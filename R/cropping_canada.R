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
      "24016", # Charlesbourg—Haute-Saint-Charles
      "24043", # Louis-Hébert
      "24059", # Québec-Centre
      "24044", # Louis-Saint-Laurent—Akiawenhrahk
      "24008", # Beauport—Limoilou
      "24051", # Montmorency—Charlevoix
      "24058", # Portneuf—Jacques-Cartier
      "24010", # Bellechasse—Les Etchemins—Lévis
      "24040"  # Lévis—Lotbinière
    ),
    "coordinates" = c("xmin" = -71.6, "xmax" = -71.1, "ymin" = 46.7, "ymax" = 47)
  ),
  "montreal" = list(
    "ridings" = c(
      "24003", # Ahuntsic-Cartierville
      "24004", # Alfred-Pellan
      "24013", # Bourassa
      "24015", # Brossard—Saint-Lambert
      "24017", # Châteauguay—Les Jardins-de-Napierville
      "24022", # Dorval—Lachine—LaSalle
      "24026", # Hochelaga—Rosemont-Est
      "24027", # Honoré-Mercier
      "24031", # La Pointe-de-l'Île
      "24034", # Lac-Saint-Louis
      "24035", # LaSalle—Émard—Verdun
      "24037", # Laurier—Sainte-Marie
      "24038", # Laval—Les Îles
      "24041", # Longueuil—Charles-LeMoyne
      "24042", # Longueuil—Saint-Hubert
      "24045", # Marc-Aurèle-Fortin
      "24047", # Mirabel
      "24048", # Mont-Royal
      "24052", # Notre-Dame-de-Grâce—Westmount
      "24053", # Outremont
      "24054", # Papineau
      "24055", # Pierre-Boucher—Les Patriotes—Verchères
      "24056", # Pierrefonds—Dollard
      "24060", # Repentigny
      "24063", # Rivière-des-Mille-Îles
      "24065", # Rosemont—La Petite-Patrie
      "24068", # Saint-Laurent
      "24069", # Saint-Léonard—Saint-Michel
      "24073", # Terrebonne
      "24074", # Thérèse-De Blainville
      "24076", # Vaudreuil
      "24077", # Ville-Marie—Le Sud-Ouest—Île-des-Soeurs
      "24078", # Vimy
      "24032", # La Prairie—Atateken
      "24049"  # Mont-Saint-Bruno—L'Acadie
    ),
    "coordinates" = c("xmin" = -74.03, "xmax" = -73.47, "ymin" = 45.38, "ymax" = 45.72)
  ),
  "toronto" = list(
    "ridings" = c(
      "35105", # Taiaiako'n—Parkdale—High Park
      "35109", # Toronto-Centre
      "35110", # Toronto—Danforth
      "35111", # Toronto—St. Paul's
      "35112", # University—Rosedale
      "35117", # Willowdale
      "35120", # York-Centre
      "35122", # York-Sud—Weston—Etobicoke
      "35022", # Davenport
      "35023", # Don Valley-Nord
      "35024", # Don Valley-Ouest
      "35026", # Eglinton—Lawrence
      "35029", # Etobicoke-Centre
      "35030", # Etobicoke—Lakeshore
      "35031", # Etobicoke-Nord
      "35041", # Humber River—Black Creek
      "35047", # King—Vaughan
      "35056", # Markham—Stouffville
      "35057", # Markham—Thornhill
      "35058", # Markham—Unionville
      "35061", # Mississauga-Centre
      "35062", # Mississauga-Est—Cooksville
      "35063", # Mississauga—Erin Mills
      "35064", # Mississauga—Lakeshore
      "35065", # Mississauga—Malton
      "35066", # Mississauga—Streetsville
      "35075", # Oakville-Est
      "35076", # Oakville-Ouest
      "35089", # Richmond Hill-Sud
      "35092", # Scarborough—Agincourt
      "35093", # Scarborough-Centre—Don Valley-Est
      "35094", # Scarborough—Guildwood—Rouge Park
      "35095", # Scarborough-Nord
      "35096", # Scarborough-Sud-Ouest
      "35097", # Scarborough—Woburn
      "35100", # Spadina—Harbourfront
      "35106", # Thornhill
      "35113", # Vaughan—Woodbridge
      "35001", # Ajax
      "35003", # Aurora—Oak Ridges—Richmond Hill
      "35007", # Beaches—East York
      "35008", # Bowmanville—Oshawa-Nord
      "35009", # Brampton-Centre
      "35010", # Brampton—Chinguacousy Park
      "35011", # Brampton-Est
      "35012", # Brampton-Nord—Caledon
      "35013", # Brampton-Sud
      "35014", # Brampton-Ouest
      "35017", # Burlington
      "35018", # Burlington-Nord—Milton-Ouest
      "35068", # Newmarket—Aurora
      "35069", # New Tecumseth—Gwillimbury
      "35087", # Pickering—Brooklin
      "35116", # Whitby
      "35121", # York—Durham
      "35025"  # Dufferin—Caledon
    ),
    "coordinates" = c("xmin" = -79.67, "xmax" = -79.1, "ymin" = 43.55, "ymax" = 43.9)
  ),
  "ottawa_gatineau" = list(
    "ridings" = c(
      "35020", # Carleton
      "35043", # Kanata
      "35067", # Nepean
      "35077", # Orléans
      "35079", # Ottawa-Centre
      "35080", # Ottawa-Sud
      "35081", # Ottawa—Vanier—Gloucester
      "35082", # Ottawa-Ouest—Nepean
      "35088", # Prescott—Russell—Cumberland
      "24025", # Gatineau
      "24028", # Hull—Aylmer
      "24057", # Pontiac—Kitigan Zibi
      "24005"  # Argenteuil—La Petite-Nation
    ),
    "coordinates" = c("xmin" = -76.0, "xmax" = -75.5, "ymin" = 45.2, "ymax" = 45.5)
  ),
  "vancouver" = list(
    "ridings" = c(
      "59001", # Abbotsford—Langley-Sud
      "59002", # Burnaby Central
      "59003", # Burnaby-Nord—Seymour
      "59006", # Cloverdale—Langley City
      "59008", # Coquitlam—Port Coquitlam
      "59011", # Delta
      "59013", # Fleetwood—Port Kells
      "59017", # Langley Township—Fraser Heights
      "59018", # Mission—Matsqui—Abbotsford
      "59019", # Nanaimo—Ladysmith
      "59020", # New Westminster—Burnaby—Maillardville
      "59022", # North Vancouver—Capilano
      "59024", # Pitt Meadows—Maple Ridge
      "59025", # Port Moody—Coquitlam
      "59027", # Richmond-Centre—Marpole
      "59028", # Richmond-Est—Steveston
      "59032", # Surrey-Sud—White Rock
      "59033", # Surrey-Centre
      "59034", # Surrey Newton
      "59035", # Vancouver-Centre
      "59036", # Vancouver-Est
      "59037", # Vancouver Fraserview—Burnaby-Sud
      "59038", # Vancouver Granville
      "59039", # Vancouver Kingsway
      "59040", # Vancouver Quadra
      "59042", # Victoria
      "59043"  # West Vancouver—Sunshine Coast—Sea to Sky Country
    ),
    "coordinates" = c("xmin" = -123.41, "xmax" = -122.84, "ymin" = 49.11, "ymax" = 49.45)
  ),
  "winnipeg" = list(
    "ridings" = c(
      "46003", # Elmwood—Transcona
      "46004", # Kildonan—St. Paul
      "46008", # Saint-Boniface—Saint-Vital
      "46010", # Winnipeg-Centre
      "46011", # Winnipeg-Nord
      "46012", # Winnipeg-Sud
      "46013", # Winnipeg-Centre-Sud
      "46014", # Winnipeg-Ouest
      "46001", # Brandon—Souris
      "46002", # Churchill—Keewatinook Aski
      "46005", # Portage—Lisgar
      "46006", # Provencher
      "46007", # Mont-Riding
      "46009"  # Selkirk—Interlake—Eastman
    ),
    "coordinates" = c("xmin" = -123.28, "xmax" = -122.72, "ymin" = 49.08, "ymax" = 49.44)
  ),
  "kitchener_waterloo" = list(
    "ridings" = c(
      "35048", # Kitchener-Centre
      "35049", # Kitchener—Conestoga
      "35050", # Kitchener-Sud—Hespeler
      "35114", # Waterloo
      "35019", # Cambridge
      "35115", # Wellington—Halton Hills-Nord
      "35033", # Guelph
      "35083", # Oxford
      "35085", # Perth—Wellington
      "35015", # Brantford—Brant-Sud—Six Nations
      "35060", # Milton-Est—Halton Hills-Sud
      "35018", # Burlington-Nord—Milton-Ouest
      "35032", # Flamborough—Glanbrook—Brant-Nord
      "35039"  # Hamilton-Ouest—Ancaster—Dundas
    ),
    "coordinates" = c("xmin" = -80.8, "xmax" = -80.2, "ymin" = 43.3, "ymax" = 43.7)
  ),
  "london" = list(
    "ridings" = c(
      "35053", # London-Centre
      "35054", # London—Fanshawe
      "35055", # London-Ouest
      "35027", # Elgin—St. Thomas—London-Sud
      "35059"  # Middlesex—London
    ),
    "coordinates" = c("xmin" = -81.46, "xmax" = -81.07, "ymin" = 42.8, "ymax" = 43.1)
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
#' map_can <- cartessn::spatial_canada_2022_electoral_ridings_aligned
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
  # Transform into the appropriate coordinate system
  spatial_dataframe_filtered <- sf::st_transform(spatial_dataframe_filtered, crs = 4326)
  # Define the crop area with the city's latitudes and longitudes
  crop_factor <- sf::st_bbox(
    c(xmin = unname(city_mapping_object[[city]]$coordinates["xmin"]), 
      xmax = unname(city_mapping_object[[city]]$coordinates["xmax"]), 
      ymin = unname(city_mapping_object[[city]]$coordinates["ymin"]),
      ymax = unname(city_mapping_object[[city]]$coordinates["ymax"])
    ),
    crs = sf::st_crs(spatial_dataframe_filtered)
  )
  # Crop the map
  spatial_dataframe_cropped <- suppressWarnings(sf::st_crop(spatial_dataframe_filtered, crop_factor))
  return(spatial_dataframe_cropped)
}