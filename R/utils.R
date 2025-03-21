#' Compute Spatial Intersections and Coverage Proportions  
#'  
#' This function computes the intersection between two spatial objects and calculates the area covered  
#' by each unit of `spatial_target` within each unit of `spatial_ref`.  
#'  
#' @param spatial_ref An `sf` object representing the reference spatial units that will be intersected.  
#' @param id_ref A string specifying the column name in `spatial_ref` that contains unique identifiers.  
#' @param spatial_target An `sf` object representing the target spatial units used to intersect `spatial_ref`.  
#' @param id_target A string specifying the column name in `spatial_target` that contains unique identifiers.  
#' @param dTolerance A numeric value specisi j'utfying the simplification tolerance for spatial geometries before computing intersections. Default is `50`.  
#'  
#' @return A tibble containing the intersections with the following columns:  
#' - `{id_ref}`: The unique identifier of the reference spatial unit.  
#' - `{id_target}`: The unique identifier of the intersecting target spatial unit.  
#' - `area_covered_by_target_m2`: The intersection area in square meters.  
#' - `prop_of_ref_area_covered_by_target`: The proportion of the reference unit covered by the target unit.  
#'  
#' @import dplyr sf
#' 
#' @details  
#' - The function simplifies the geometries before computing intersections to improve performance.  
#' - It issues warnings if no intersections are found or if some reference units are missing in the final result.  
#' - The user can adjust `dTolerance` to control the level of simplification.  
#'  
#' @examples  
#' \dontrun{  
#'  
#' # Example spatial objects (must be valid sf objects)  
#' result <- intersect_spatial_objects(spatial_ref, "region_id", spatial_target, "district_id")  
#' }  
#'  
#' @export 
intersect_spatial_objects <- function(spatial_ref, id_ref, spatial_target, id_target, dTolerance = 50) {
  message("🔹 Simplifying spatial objects...")
  spatial_ref_simplified <- sf::st_simplify(spatial_ref, dTolerance = dTolerance) |> 
    dplyr::select(!!sym(id_ref), geometry)
  spatial_target_simplified <- sf::st_simplify(spatial_target, dTolerance = dTolerance) |> 
    dplyr::select(!!sym(id_target), geometry)
  
  message("🔹 Computing intersections and transforming to tibble...")
  tibble_intersections <- dplyr::as_tibble(sf::st_intersection(spatial_ref_simplified, spatial_target_simplified))
  
  # Vérification si l'intersection a bien fonctionné
  if (nrow(tibble_intersections) == 0) {
    warning("⚠️ No intersections found! Check your input geometries.")
    return(tibble_intersections)
  }
  
  tibble_intersections$area <- sf::st_area(tibble_intersections$geometry)
  tibble_intersections$area_numeric <- as.numeric(tibble_intersections$area)
  
  empty_intersections <- nrow(tibble_intersections |> dplyr::filter(area_numeric == 0))
  message("   🔸 Empty intersections (adjust dTolerance if too high): ", empty_intersections)
  
  df_by_ref <- tibble_intersections |> 
    dplyr::filter(area_numeric > 0) |> 
    dplyr::group_by(!!sym(id_ref)) |> 
    dplyr::mutate(
      total_covered_area = sum(area_numeric),
      prop_of_ref_area_covered_by_target = area_numeric / total_covered_area
    ) |> 
    dplyr::rename(
      area_covered_by_target_m2 = area_numeric
    ) |> 
    dplyr::select(-total_covered_area, -area) |> 
    dplyr::ungroup()
  
  # Vérification que toutes les unités de ref sont présentes dans le résultat
  missing_refs <- setdiff(spatial_ref[[id_ref]], df_by_ref[[id_ref]])
  if (length(missing_refs) > 0) {
    warning("⚠️ Some reference units are missing in the final result: ", length(missing_refs), 
            " (", round(length(missing_refs) / nrow(spatial_ref) * 100, 2), "%)")
  } else {
    message("✅ All reference units are present in the final result.")
  }
  
  return(df_by_ref)
}

#' Map Forward Sortation Areas (FSAs) to Electoral Ridings
#'
#' This function creates a mapping between Forward Sortation Areas (FSAs, the first 3 characters
#' of a Canadian postal code) and electoral ridings. It handles topological issues and ensures
#' that the output is valid for map visualizations and other analyses.
#'
#' @param sf_rta An `sf` object containing FSA (RTA in French) geometries. Should have a column
#'        named 'rta' containing the FSA codes.
#' @param sf_ridings An `sf` object containing electoral riding geometries. Should have a column
#'        named 'id_riding' containing the riding identifiers.
#' @param min_intersection_pct Minimum percentage of FSA area that must be covered by a riding
#'        to be considered for mapping. Lower values may include more mappings but with lower confidence.
#'        Default is 10 (10%).
#' @param simplify_geometries Logical indicating whether to simplify geometries before intersection
#'        for better performance. Default is TRUE.
#' @param tolerance Simplification tolerance when simplify_geometries is TRUE. Default is 50.
#' @param force_all_fsa_match Logical indicating if FSAs with no major riding intersection should be
#'        assigned to the largest intersection regardless of size. Default is FALSE.
#'
#' @return A list containing three dataframes:
#' \describe{
#'   \item{fsa_riding_intersections}{A complete dataframe of all FSA-Riding intersections with areas and percentages}
#'   \item{fsa_to_riding_mapping}{A simplified mapping with each FSA mapped to its most overlapping riding}
#'   \item{summary}{A summary of match statistics}
#' }
#'
#' @details
#' - This function addresses common topological issues with spatial data
#' - It calculates the intersection between FSAs and electoral ridings
#' - For each FSA, it identifies the riding with the largest intersection
#' - The return value includes both detailed intersections and a simplified mapping
#'
#' @import dplyr sf
#'
#' @examples
#' \dontrun{
#' # Load spatial data
#' sf_rta <- cartessn::spatial_canada_2021_rta
#' sf_ridings <- cartessn::spatial_canada_2022_electoral_ridings_aligned
#'
#' # Create the mapping
#' mapping <- map_fsa_to_ridings(sf_rta, sf_ridings)
#'
#' # Access the simplified mapping
#' fsa_riding_map <- mapping$fsa_to_riding_mapping
#'
#' # Join with survey data
#' survey_data$id_riding <- fsa_riding_map$id_riding[match(survey_data$postal_code_prefix, fsa_riding_map$rta)]
#' }
#'
#' @export
map_fsa_to_ridings <- function(sf_rta, sf_ridings, min_intersection_pct = 10, 
                              simplify_geometries = TRUE, tolerance = 50,
                              force_all_fsa_match = FALSE) {
  
  # Input validation
  if (!inherits(sf_rta, "sf") || !inherits(sf_ridings, "sf")) {
    stop("Both sf_rta and sf_ridings must be sf objects")
  }
  
  if (!"rta" %in% names(sf_rta)) {
    stop("sf_rta must have a column named 'rta'")
  }
  
  if (!"id_riding" %in% names(sf_ridings)) {
    stop("sf_ridings must have a column named 'id_riding'")
  }
  
  message("🔹 Preparing spatial data...")
  
  # Make copies to avoid modifying the original data
  sf_rta_valid <- sf_rta
  sf_ridings_valid <- sf_ridings
  
  # Ensure both datasets use the same CRS
  if (sf::st_crs(sf_rta_valid) != sf::st_crs(sf_ridings_valid)) {
    message("   - Transforming coordinate reference systems to match...")
    sf_ridings_valid <- sf::st_transform(sf_ridings_valid, sf::st_crs(sf_rta_valid))
  }
  
  # Fix topology issues
  message("   - Fixing topology issues...")
  sf_rta_valid <- sf::st_make_valid(sf_rta_valid)
  sf_ridings_valid <- sf::st_make_valid(sf_ridings_valid)
  
  # Apply a very small buffer to fix noding errors
  message("   - Applying buffer to resolve noding issues...")
  sf_rta_buffered <- sf::st_buffer(sf_rta_valid, 0)
  sf_ridings_buffered <- sf::st_buffer(sf_ridings_valid, 0)
  
  # Try to compute intersections
  message("🔹 Computing intersections...")
  
  intersections <- tryCatch({
    if (simplify_geometries) {
      # Use the utility function with simplification
      intersect_spatial_objects(
        spatial_ref = sf_rta_buffered,
        id_ref = "rta",
        spatial_target = sf_ridings_buffered,
        id_target = "id_riding",
        dTolerance = tolerance
      )
    } else {
      # Direct approach with no simplification
      message("   - Using direct intersection (no simplification)...")
      
      # Prepare simplified datasets for intersection
      sf_rta_simple <- sf_rta_buffered %>%
        dplyr::select(rta)
      
      sf_ridings_simple <- sf_ridings_buffered %>% 
        dplyr::select(id_riding)
      
      # Calculate intersection
      intersection_sf <- sf::st_intersection(sf_rta_simple, sf_ridings_simple)
      
      # Calculate intersection areas
      intersection_sf$area_intersection <- sf::st_area(intersection_sf)
      
      # Calculate total FSA areas
      sf_rta_with_area <- sf_rta_simple %>%
        dplyr::mutate(total_area_rta = sf::st_area(.))
      
      # Join total areas and calculate proportions
      intersections_df <- intersection_sf %>%
        sf::st_join(sf_rta_with_area %>% dplyr::select(rta, total_area_rta), by = "rta") %>%
        sf::st_drop_geometry() %>%
        dplyr::mutate(
          prop_of_ref_area_covered_by_target = as.numeric(area_intersection / total_area_rta),
          area_covered_by_target_m2 = as.numeric(area_intersection)
        ) %>%
        dplyr::select(
          rta,
          id_riding,
          area_covered_by_target_m2,
          prop_of_ref_area_covered_by_target
        )
      
      intersections_df
    }
  }, error = function(e) {
    message("   - Error in intersection calculation: ", e$message)
    message("   - Attempting alternative method...")
    
    # Alternative approach if the first one fails
    sf_rta_simple <- sf_rta_buffered %>%
      dplyr::select(rta) %>%
      sf::st_transform(sf::st_crs(sf_ridings_buffered))
    
    sf_ridings_simple <- sf_ridings_buffered %>% 
      dplyr::select(id_riding)
    
    # Try with simpler operation
    intersection_sf <- sf::st_intersection(sf_rta_simple, sf_ridings_simple)
    
    # Calculate areas
    intersection_sf$area_intersection <- sf::st_area(intersection_sf)
    
    # Calculate total FSA areas
    sf_rta_with_area <- sf_rta_simple %>%
      dplyr::mutate(total_area_rta = sf::st_area(.))
    
    # Join and calculate proportions
    intersections_df <- intersection_sf %>%
      sf::st_join(sf_rta_with_area %>% dplyr::select(rta, total_area_rta), by = "rta") %>%
      sf::st_drop_geometry() %>%
      dplyr::mutate(
        prop_of_ref_area_covered_by_target = as.numeric(area_intersection / total_area_rta),
        area_covered_by_target_m2 = as.numeric(area_intersection)
      ) %>%
      dplyr::select(
        rta,
        id_riding,
        area_covered_by_target_m2,
        prop_of_ref_area_covered_by_target
      )
    
    intersections_df
  })
  
  # If we still don't have intersections, return an error
  if (nrow(intersections) == 0) {
    stop("Failed to compute intersections between FSAs and electoral ridings")
  }
  
  # Format intersections for user readability
  message("🔹 Creating FSA-riding membership table...")
  fsa_riding_intersections <- intersections %>%
    dplyr::mutate(percentage_overlap = prop_of_ref_area_covered_by_target * 100) %>%
    dplyr::select(
      rta,
      id_riding,
      area_intersection_m2 = area_covered_by_target_m2,
      percentage_overlap
    ) %>%
    dplyr::arrange(rta, dplyr::desc(percentage_overlap))
  
  # Create a mapping with each FSA assigned to its most overlapping riding
  message("🔹 Creating FSA-to-riding mapping...")
  
  # Filter by minimum percentage if not forcing all matches
  filtered_intersections <- if (!force_all_fsa_match) {
    fsa_riding_intersections %>%
      dplyr::filter(percentage_overlap >= min_intersection_pct)
  } else {
    fsa_riding_intersections
  }
  
  # For each FSA, select the riding with the largest intersection
  fsa_to_riding <- filtered_intersections %>%
    dplyr::group_by(rta) %>%
    dplyr::slice_max(order_by = percentage_overlap, n = 1) %>%
    dplyr::ungroup() %>%
    dplyr::select(rta, id_riding, percentage_overlap)
  
  # Generate summary statistics
  total_fsas <- length(unique(sf_rta_buffered$rta))
  matched_fsas <- length(unique(fsa_to_riding$rta))
  match_rate <- matched_fsas / total_fsas * 100
  
  message("✅ Mapping complete!")
  message(sprintf("   - Matched %d out of %d FSAs (%.2f%%)", 
                 matched_fsas, total_fsas, match_rate))
  
  # Create summary
  summary_df <- data.frame(
    total_fsas = total_fsas,
    matched_fsas = matched_fsas,
    match_rate_pct = match_rate,
    min_intersection_pct_used = min_intersection_pct,
    forced_all_matches = force_all_fsa_match
  )
  
  # Return results as a list
  return(list(
    fsa_riding_intersections = fsa_riding_intersections,
    fsa_to_riding_mapping = fsa_to_riding,
    summary = summary_df
  ))
}