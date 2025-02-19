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
