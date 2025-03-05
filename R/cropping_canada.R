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
  "quebec_city" = quebec_city,
  "montreal" = montreal,
  "kitchener_waterloo" = kitchener_waterloo,
  "london" = london,
  "toronto" = toronto,
  "ottawa_gatineau" = ottawa_gatineau,
  "vancouver" = vancouver,
  "winnipeg" = winnipeg
)
# Définir city_mapping_canada_2025 (que vous avez déjà)
city_mapping_canada_2025 <- list(
  "quebec_city" = list(
    "ridings" = c(
      "24016", # Charlesbourg—Haute-Saint-Charles
      "24042", # Louis-Hébert
      "24059", # Québec Centre
      "24043"  # Louis-Saint-Laurent—Akiawenhrahk
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
      "24021", # Dorval—Lachine
      "24025", # Hochelaga
      "24026", # Honoré-Mercier
      "24030", # La Pointe-de-l'Île
      "24033", # Lac-Saint-Louis
      "24034", # LaSalle—Verdun
      "24036", # Laurier—Sainte-Marie
      "24037", # Laval—Les Îles
      "24040", # Longueuil—Charles-LeMoyne
      "24041", # Longueuil—Saint-Hubert
      "24044", # Marc-Aurèle-Fortin
      "24046", # Mirabel
      "24047", # Mount Royal
      "24048", # Montarville
      "24052", # Notre-Dame-de-Grâce—Westmount
      "24053", # Outremont
      "24054", # Papineau
      "24055", # Pierre-Boucher—Les Patriotes—Verchères
      "24056", # Pierrefonds—Dollard
      "24063", # Rivière-des-Mille-Îles
      "24064", # Rivière-du-Nord
      "24065", # Rosemont—La Petite-Patrie
      "24068", # Saint-Laurent
      "24069", # Saint-Léonard—Saint-Michel
      "24074", # Thérèse-De Blainville
      "24076", # Vaudreuil
      "24077", # Ville-Marie—Le Sud-Ouest—Île-des-Soeurs
      "24073", # Terrebonne
      "24060", # Repentigny
      "24031", # La prairie
      "24078"  # Vimy
    ),
    "coordinates" = c("xmin" = -74.05, "xmax" = -73.45, "ymin" = 45.40, "ymax" = 45.70)
  ),
  "kitchener_waterloo" = list(
   "ridings" = c(
    "35048", # Kitchener Centre
    "35049", # Kitchener—Conestoga
    "35050", # Kitchener South—Hespeler
    "35114", # Waterloo
    "35019", # Cambridge
    "35115", # Wellington—Halton Hills North
    "35033", # Guelph
    "35084", # Oxford
    "35086", # Perth—Wellington
    "35015", # Brantford—Brant South—Six Nations
    "35061", # Milton East—Halton Hills South
    "35018", # Burlington North—Milton West
    "35032", # Flamborough—Glanbrook—Brant North
    "35039"  # Hamilton West—Ancaster—Dundas
   ),
   "coordinates" = c("xmin" = -80.8, "xmax" = -80.2, "ymin" = 43.3, "ymax" = 43.7)
 ),
 "london" = list(
    "ridings" = c(
      "35053", # London Centre
      "35054", # London—Fanshawe
      "35055", # London West
      "35027", # Elgin—St. Thomas—London South
      "35060"  # Middlesex—London
    ),
    "coordinates" = c("xmin" = -81.46, "xmax" = -81.07, "ymin" = 42.8, "ymax" = 43.1)
  ),
  "toronto" = list(
  "ridings" = c(
    # Circonscriptions déjà incluses
    "35105", # Taiaiako'n—Parkdale—High Park
    "35108", # Toronto Centre
    "35109", # Toronto—Danforth
    "35110", # Toronto—St. Paul's
    "35111", # University—Rosedale
    "35112", # Vaughan—Thornhill
    "35113", # Vaughan—Woodbridge
    "35117", # Willowdale
    "35120", # York Centre
    "35122", # York South—Weston—Etobicoke
    "35022", # Davenport
    "35023", # Don Valley North
    "35024", # Don Valley South
    "35026", # Eglinton—Lawrence
    "35029", # Etobicoke Centre
    "35030", # Etobicoke—Lakeshore
    "35031", # Etobicoke North
    "35041", # Humber River—Black Creek
    "35047", # King—Vaughan
    "35057", # Markham—Stouffville
    "35058", # Markham—Thornhill
    "35059", # Markham—Unionville
    "35062", # Mississauga Centre
    "35063", # Mississauga East—Cooksville
    "35064", # Mississauga—Erin Mills
    "35065", # Mississauga—Lakeshore
    "35066", # Mississauga—Malton
    "35067", # Mississauga—Streetsville
    "35076", # Oakville East
    "35077", # Oakville West
    "35090", # Richmond Hill South
    "35093", # Scarborough—Agincourt
    "35094", # Scarborough Centre—Don Valley East
    "35095", # Scarborough—Guildwood—Rouge Park
    "35096", # Scarborough North
    "35097", # Scarborough Southwest
    "35098", # Scarborough—Woburn
    "35101", # Spadina—Harbourfront
    
    # Circonscriptions supplémentaires potentielles
    "35001", # Ajax
    "35003", # Aurora—Oak Ridges—Richmond Hill
    "35007", # Beaches—East York
    "35008", # Bowmanville—Oshawa North
    "35009", # Brampton Centre
    "35010", # Brampton—Chinguacousy Park
    "35011", # Brampton East
    "35012", # Brampton North—Caledon
    "35013", # Brampton South
    "35014", # Brampton West
    "35017", # Burlington
    "35018", # Burlington North—Milton West
    "35069", # Newmarket—Aurora
    "35070", # New Tecumseth—Gwillimbury
    "35079", # Oshawa
    "35088", # Pickering—Brooklin
    "35116", # Whitby
    "35121"  # York—Durham
  ),
  "coordinates" = c("xmin" = -79.67, "xmax" = -79.1, "ymin" = 43.55, "ymax" = 43.9)
),
"ottawa_gatineau" = list(
  "ridings" = c(
    # Ottawa (Ontario)
    "35020", # Carleton
    "35043", # Kanata
    "35068", # Nepean
    "35078", # Orléans
    "35080", # Ottawa Centre
    "35081", # Ottawa South
    "35082", # Ottawa—Vanier—Gloucester
    "35083", # Ottawa West—Nepean
    "35089", # Prescott—Russell—Cumberland
    
    # Gatineau (Québec)
    "24024", # Gatineau
    "24027", # Hull—Aylmer
    "24057", # Pontiac—Kitigan Zibi
    "24005"  # Argenteuil—La Petite-Nation
  ),
  "coordinates" = c("xmin" = -76.0, "xmax" = -75.5, "ymin" = 45.2, "ymax" = 45.5)
),
"vancouver" = list(
  "ridings" = c(
    "59001", # Abbotsford—South Langley
    "59002", # Burnaby Central
    "59003", # Burnaby North—Seymour
    "59004", # Capilano—North Vancouver
    "59006", # Chilliwack—Hope
    "59007", # Cloverdale—Langley City
    "59009", # Coquitlam—Port Coquitlam
    "59012", # Delta
    "59013", # Esquimalt—Saanich—Sooke
    "59014", # Fleetwood—Port Kells
    "59015", # Howe Sound—West Vancouver
    "59019", # Langley Township
    "59020", # Mission—Matsqui—Abbotsford
    "59021", # Nanaimo—Ladysmith
    "59022", # New Westminster—Burnaby—Maillardville
    "59025", # Pitt Meadows—Maple Ridge
    "59026", # Port Moody—Coquitlam
    "59028", # Richmond Centre—Marpole
    "59029", # Richmond East—Steveston
    "59030", # Saanich—Gulf Islands
    "59033", # South Surrey—White Rock
    "59034", # Surrey Centre
    "59035", # Surrey Newton
    "59036", # Vancouver Arbutus
    "59037", # Vancouver Centre
    "59038", # Vancouver East
    "59039", # Vancouver Fraserview—South Burnaby
    "59040", # Vancouver Kingsway
    "59041", # Vancouver West Broadway
    "59043"  # Victoria
  ),
  "coordinates" = c("xmin" = -123.5, "xmax" = -122.1, "ymin" = 48.8, "ymax" = 49.6)
),
"winnipeg" = list(
  "ridings" = c(
    "46001", # Brandon—Souris
    "46002", # Churchill—Keewatinook Aski
    "46003", # Elmwood—Transcona
    "46004", # Kildonan—St. Paul
    "46005", # Portage—Lisgar
    "46006", # Provencher
    "46007", # Riding Mountain
    "46008", # St. Boniface—St. Vital
    "46009", # Selkirk—Interlake—Eastman
    "46010", # Winnipeg Centre
    "46011", # Winnipeg North
    "46012", # Winnipeg South
    "46013", # Winnipeg South Centre
    "46014"  # Winnipeg West
  ),
  "coordinates" = c("xmin" = -97.5, "xmax" = -96.5, "ymin" = 49.6, "ymax" = 50.2)
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

