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
  ),
  
  "montreal" = list(
    "ridings" = c(
      "24003", # Ahuntsic-Cartierville
      "24014", # Dorval—Lachine—LaSalle
      "24028", # Hochelaga
      "24029", # Honoré-Mercier
      "24033", # La Pointe-de-l'Île
      "24039", # LaSalle—Émard—Verdun
      "24051", # Mont-Royal
      "24054", # Notre-Dame-de-Grâce—Westmount
      "24055", # Outremont
      "24058", # Papineau
      "24067", # Rosemont—La Petite-Patrie
      "24070", # Saint-Laurent
      "24071", # Saint-Léonard—Saint-Michel
      "24077"  # Ville-Marie—Le Sud-Ouest—Île-des-Sœurs
    ),
    "coordinates" = c("xmin" = -73.99, "xmax" = -73.47, "ymin" = 45.41, "ymax" = 45.71)
  ),
  
  "toronto" = list(
    "ridings" = c(
      "35020", # Davenport
      "35024", # Don Valley East
      "35025", # Don Valley North
      "35026", # Don Valley West
      "35028", # Eglinton—Lawrence
      "35029", # Etobicoke Centre
      "35030", # Etobicoke—Lakeshore
      "35031", # Etobicoke North
      "35103", # Scarborough—Agincourt
      "35104", # Scarborough Centre
      "35105", # Scarborough—Guildwood
      "35106", # Scarborough North
      "35107", # Scarborough—Rouge Park
      "35108", # Scarborough Southwest
      "35109", # Spadina—Fort York
      "35110", # Toronto Centre
      "35113", # Toronto—Danforth
      "35114", # Toronto—St. Paul's
      "35121", # University—Rosedale
      "35124", # Willowdale
      "35125", # York Centre
      "35126", # York South—Weston
      "35127"  # Humber River—Black Creek
    ),
    "coordinates" = c("xmin" = -79.65, "xmax" = -79.12, "ymin" = 43.58, "ymax" = 43.83)
  ),
  
  "vancouver" = list(
    "ridings" = c(
      "59001", # Vancouver Centre
      "59002", # Vancouver East
      "59003", # Vancouver Granville
      "59004", # Vancouver Kingsway
      "59005", # Vancouver Quadra
      "59006", # Vancouver South
      "59033"  # Burnaby North—Seymour
    ),
    "coordinates" = c("xmin" = -123.27, "xmax" = -122.97, "ymin" = 49.2, "ymax" = 49.32)
  ),
  
  "calgary" = list(
    "ridings" = c(
      "48001", # Calgary Centre
      "48002", # Calgary Confederation
      "48003", # Calgary Forest Lawn
      "48004", # Calgary Heritage
      "48005", # Calgary Midnapore
      "48006", # Calgary Nose Hill
      "48007", # Calgary Rocky Ridge
      "48008", # Calgary Shepard
      "48009", # Calgary Signal Hill
      "48010"  # Calgary Skyview
    ),
    "coordinates" = c("xmin" = -114.3, "xmax" = -113.8, "ymin" = 50.85, "ymax" = 51.2)
  ),
  
  "edmonton" = list(
    "ridings" = c(
      "48015", # Edmonton Centre
      "48016", # Edmonton Griesbach
      "48017", # Edmonton Manning
      "48018", # Edmonton Mill Woods
      "48019", # Edmonton Riverbend
      "48020", # Edmonton Strathcona
      "48021", # Edmonton West
      "48022"  # Edmonton—Wetaskiwin
    ),
    "coordinates" = c("xmin" = -113.7, "xmax" = -113.2, "ymin" = 53.4, "ymax" = 53.7)
  ),
  
  "ottawa" = list(
    "ridings" = c(
      "35077", # Ottawa Centre
      "35078", # Ottawa South
      "35079", # Ottawa—Vanier
      "35080", # Ottawa West—Nepean
      "35052", # Kanata—Carleton
      "35089", # Orléans
      "35043", # Carleton
      "35053"  # Nepean
    ),
    "coordinates" = c("xmin" = -75.95, "xmax" = -75.55, "ymin" = 45.25, "ymax" = 45.5)
  ),
  
  "winnipeg" = list(
    "ridings" = c(
      "46001", # Winnipeg Centre
      "46002", # Winnipeg North
      "46003", # Winnipeg South
      "46004", # Winnipeg South Centre
      "46006", # Saint Boniface—Saint Vital
      "46007", # Elmwood—Transcona
      "46008", # Kildonan—St. Paul
      "46009"  # Charleswood—St. James—Assiniboia—Headingley
    ),
    "coordinates" = c("xmin" = -97.32, "xmax" = -96.95, "ymin" = 49.77, "ymax" = 50.05)
  ),
  
  "halifax" = list(
    "ridings" = c(
      "12001", # Halifax
      "12002", # Halifax West
      "12003", # Dartmouth—Cole Harbour
      "12004"  # Sackville—Preston—Chezzetcook
    ),
    "coordinates" = c("xmin" = -63.7, "xmax" = -63.4, "ymin" = 44.6, "ymax" = 44.75)
  ),
  
  "hamilton" = list(
    "ridings" = c(
      "35036", # Hamilton Centre
      "35037", # Hamilton East—Stoney Creek
      "35038", # Hamilton Mountain
      "35039", # Hamilton West—Ancaster—Dundas
      "35019"  # Burlington
    ),
    "coordinates" = c("xmin" = -80.05, "xmax" = -79.7, "ymin" = 43.18, "ymax" = 43.33)
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
  if (!is.list(city_mapping_object)) {
    stop("city_mapping_object must be a list. You can copy the structure of cartessn::city_mapping_canada_2025.")
  }
  if (!(city %in% names(city_mapping_object))) {
    stop("city must be one of the following: ", 
         paste0(names(city_mapping_object), collapse = ", "))
  }
  for (i in names(city_mapping_object)) {
    if (!is.list(city_mapping_object[[i]]) || 
        !all(c("ridings", "coordinates") %in% names(city_mapping_object[[i]]))) {
      stop(paste0("city_mapping_object[['", i, "']] must be a list with 'ridings' and 'coordinates' as names. You can copy the structure of cartessn::city_mapping_canada_2025."))
    }
    if (!is.character(city_mapping_object[[i]]$ridings)) {
      stop(paste0("city_mapping_object[['", i, "']]$ridings must be a character vector. You can copy the structure of cartessn::city_mapping_canada_2025."))
    }
    if (!is.numeric(city_mapping_object[[i]]$coordinates)) {
      stop(paste0("city_mapping_object[['", i, "']]$coordinates must be a numeric vector. You can copy the structure of cartessn::city_mapping_canada_2025."))
    }
    if (!all(names(city_mapping_object[[i]]$coordinates) %in% c("xmin", "xmax", "ymin", "ymax"))) {
      stop(paste0("city_mapping_object[['", i, "']]$coordinates must have names 'xmin', 'xmax', 'ymin', 'ymax'. You can copy the structure of cartessn::city_mapping_canada_2025."))
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