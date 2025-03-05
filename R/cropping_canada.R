#' City and region mapping for 2025 Canadian electoral ridings
#'
#' A list containing mapping information for cities and regions in Canada,
#' including their electoral riding IDs and geographic coordinates.
#'
#' @format A named list where each element represents a city/region with:
#' \describe{
#'   \item{ridings}{Character vector of electoral riding IDs}
#'   \item{coordinates}{Named numeric vector with xmin, xmax, ymin, ymax boundaries}
#' }
#'
#' @examples
#' cartessn::city_mapping_canada_2025$quebec_city$ridings
#' cartessn::city_mapping_canada_2025$quebec_city$coordinates
#'
#' @export
city_mapping_canada_2025 <- list(
  "quebec_city" = list(
    "ridings" = c(
      "24016",
      "24042",
      "24043",
      "24059"
    ),
    "coordinates" = c("xmin" = -71.6, "xmax" = -71.1, "ymin" = 46.7, "ymax" = 47)
  )
)


#' Crop an sf object to a specified city/region
#'
#' @description
#' This function extracts electoral ridings for a specified city or region
#' from a spatial dataframe. It filters the ridings based on IDs and crops
#' the result to the geographic extent of the city.
#'
#' @param spatial_dataframe An sf object (spatial dataframe) containing electoral ridings
#' @param city Character string specifying which city/region to extract. Must be one of
#'             the names defined in the city_mapping_object
#' @param electoral_riding_column Character string naming the column containing riding IDs.
#'                               Default is "id_riding"
#' @param city_mapping_object A list defining cities/regions, their ridings and coordinates
#'                           with the same structure as the city_mapping_canada_2025 object.
#'                           Default is the city_mapping_canada_2025 object
#'
#' @return An sf object (spatial dataframe) containing only the selected city's ridings
#'
#' @examples
#' map_can <- cartessn::spatial_canada_2022_electoral_ridings
#' map_qc_city <- crop_map(map_can, "quebec_city")
#'
#' @importFrom dplyr filter
#' @importFrom sf st_transform st_bbox st_crop
#' @importFrom rlang sym
#'
#' @export
crop_map <- function(
  spatial_dataframe,
  city,
  electoral_riding_column = "id_riding",
  city_mapping_object = city_mapping_canada_2025
){
  if (!(inherits(spatial_dataframe, "sf") && inherits(spatial_dataframe, "data.frame"))) {
    stop("spatial_dataframe must have class sf and data.frame")
  }
  if (!(city %in% names(city_mapping_object))) {
    stop("city must be one of the following: ", 
         paste0(names(city_mapping_object), collapse = ", "))
  }
  if (!is.list(city_mapping_object)) {
    stop("city_mapping_object must be a list")
  }
  for (i in names(city_mapping_object)) {
    if (!is.list(city_mapping_object[[i]]) || 
        !all(c("ridings", "coordinates") %in% names(city_mapping_object[[i]]))) {
      stop(paste0("city_mapping_object[[", i, "]] must be a list with 'ridings' and 'coordinates' as names. You can copy the structure of cartessn::city_mapping_canada_2025[[", i, "]]."))
    }
    if (!is.character(city_mapping_object[[i]]$ridings)) {
      stop(paste0("city_mapping_object[[", i, "]]$ridings must be a character vector. You can copy the structure of cartessn::city_mapping_canada_2025[[", i, "]]$ridings."))
    }
    if (!is.numeric(city_mapping_object[[i]]$coordinates)) {
      stop(paste0("city_mapping_object[[", i, "]]$coordinates must be a numeric vector. You can copy the structure of cartessn::city_mapping_canada_2025[[", i, "]]$coordinates."))
    }
    if (!all(names(city_mapping_object[[i]]$coordinates) %in% c("xmin", "xmax", "ymin", "ymax"))) {
      stop(paste0("city_mapping_object[[", i, "]]$coordinates must have names 'xmin', 'xmax', 'ymin', 'ymax'. You can copy the structure of cartessn::city_mapping_canada_2025[[", i, "]]$coordinates."))
    }
  }
  spatial_dataframe_filtered <- spatial_dataframe |> 
    dplyr::filter(
      !!rlang::sym(electoral_riding_column) %in% city_mapping_object[[city]]$ridings
    )
  ### transform into the appropriate coordinate system
  spatial_dataframe_filtered <- sf::st_transform(spatial_dataframe_filtered, crs = 4326)
  # Définir la zone de découpage (crop) avec les latitudes et longitudes de la ville
  crop_factor <- sf::st_bbox(
    c(xmin = unname(city_mapping_object[[city]]$coordinates["xmin"]), 
      xmax = unname(city_mapping_object[[city]]$coordinates["xmax"]), 
      ymin = unname(city_mapping_object[[city]]$coordinates["ymin"]),
      ymax = unname(city_mapping_object[[city]]$coordinates["ymax"])
    ),
    crs = sf::st_crs(spatial_dataframe_filtered)
  )
  # Découper la carte
  spatial_dataframe_cropped <- suppressWarnings(sf::st_crop(spatial_dataframe_filtered, crop_factor))
  return(spatial_dataframe_cropped)
}