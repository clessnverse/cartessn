#' Create thematic maps from Canadian electoral ridings data
#'
#' @description
#' This function creates customized thematic maps from Canadian electoral riding data.
#' It supports various visualization styles and can display data values on the map.
#'
#' @param spatial_data An sf object (spatial dataframe) containing electoral ridings
#' @param value_column Character string naming the column containing values to be displayed (optional)
#' @param title Character string for the map title
#' @param subtitle Character string for the map subtitle (optional)
#' @param caption Character string for the map caption/source (optional)
#' @param fill_color Character vector of colors for the map fill gradient
#'        Default is c("#f7fbff", "#9ecae1", "#4292c6", "#084594")
#' @param border_color Character string for the border color. Default is "#1a1a1a"
#' @param border_size Numeric value for the border width. Default is 0.2
#' @param background Character string for map background ("light" or "dark"). Default is "light"
#' @param legend_title Character string for the legend title (optional)
#' @param discrete_values Logical indicating if values should be treated as discrete categories.
#'        Default is FALSE (continuous values)
#'
#' @return A ggplot2 object representing the thematic map
#'
#' @examples
#' \dontrun{
#' # Load electoral ridings data
#' map_data <- cartessn::spatial_canada_2022_electoral_ridings_aligned
#' 
#' # Basic map with no data values
#' create_map(map_data, title = "Canadian Electoral Ridings")
#' 
#' # Map with hypothetical election data
#' map_data$vote_share <- runif(nrow(map_data), 0.25, 0.75)
#' create_map(map_data, 
#'            value_column = "vote_share", 
#'            title = "Hypothetical Vote Share",
#'            subtitle = "Simulated Data",
#'            caption = "Source: Simulated data",
#'            legend_title = "Vote Share",
#'            background = "dark")
#' }
#'
#' @importFrom ggplot2 ggplot geom_sf scale_fill_gradientn theme_minimal theme labs element_rect element_text element_blank
#' @importFrom sf st_transform
#'
#' @export
create_map <- function(
  spatial_data,
  value_column = NULL,
  title = "Electoral Ridings Map",
  subtitle = NULL,
  caption = NULL,
  fill_color = c("#f7fbff", "#9ecae1", "#4292c6", "#084594"),
  border_color = "#1a1a1a",
  border_size = 0.2,
  background = "light",
  legend_title = NULL,
  discrete_values = FALSE
) {
  # Ensure input is an sf object
  if (!(inherits(spatial_data, "sf") && inherits(spatial_data, "data.frame"))) {
    stop("spatial_data must have class sf and data.frame")
  }
  
  # Transform to standard CRS if needed
  spatial_data <- sf::st_transform(spatial_data, crs = 4326)
  
  # Set up theme based on background choice
  if (background == "dark") {
    map_theme <- theme_minimal() +
      theme(
        plot.background = element_rect(fill = "#1a1a1a", color = NA),
        panel.background = element_rect(fill = "#1a1a1a", color = NA),
        plot.title = element_text(color = "white", size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(color = "#cccccc", size = 12, hjust = 0.5),
        plot.caption = element_text(color = "#999999", size = 8),
        panel.grid = element_blank(),
        axis.text = element_text(color = "#999999"),
        axis.title = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(color = "white"),
        legend.title = element_text(color = "white")
      )
    # If using dark background, adjust border color if it's the default
    if (border_color == "#1a1a1a") {
      border_color <- "#555555"
    }
  } else {
    map_theme <- theme_minimal() +
      theme(
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5),
        panel.grid = element_blank(),
        axis.title = element_blank(),
        legend.position = "bottom"
      )
  }
  
  # Initialize the basic map
  map <- ggplot()
  
  # Add the geometry layer with conditional fill
  if (!is.null(value_column) && value_column %in% names(spatial_data)) {
    # When displaying values
    if (discrete_values) {
      # For categorical/discrete data
      map <- map + 
        geom_sf(
          data = spatial_data, 
          aes(fill = !!sym(value_column)), 
          color = border_color, 
          size = border_size
        ) +
        scale_fill_manual(values = fill_color)
    } else {
      # For continuous data
      map <- map + 
        geom_sf(
          data = spatial_data, 
          aes(fill = !!sym(value_column)), 
          color = border_color, 
          size = border_size
        ) +
        scale_fill_gradientn(colors = fill_color)
    }
  } else {
    # When no values are displayed
    map <- map + 
      geom_sf(
        data = spatial_data, 
        fill = fill_color[length(fill_color)], 
        color = border_color, 
        size = border_size
      )
  }
  
  # Add theme and labels
  map <- map + 
    map_theme +
    labs(
      title = title,
      subtitle = subtitle,
      caption = caption,
      fill = legend_title
    )
  
  return(map)
}

#' Create multi-panel maps displaying different regions
#'
#' @description
#' This function creates a multi-panel map displaying different regions or cities
#' from Canadian electoral riding data.
#'
#' @param spatial_data An sf object (spatial dataframe) containing electoral ridings
#' @param regions Character vector of region/city names to display
#' @param value_column Character string naming the column containing values to be displayed (optional)
#' @param electoral_riding_column Character string naming the column containing riding IDs.
#'                               Default is "id_riding"
#' @param title Character string for the overall map title
#' @param fill_color Character vector of colors for the map fill gradient
#' @param background Character string for map background ("light" or "dark"). Default is "light"
#' @param ncol Number of columns for the multi-panel layout. Default is 2
#' @param city_mapping_object A list defining cities/regions, their ridings and coordinates.
#'                           Default is the city_mapping_canada_2025 object
#'
#' @return A ggplot2 object representing the multi-panel map
#'
#' @examples
#' \dontrun{
#' # Load electoral ridings data
#' map_data <- cartessn::spatial_canada_2022_electoral_ridings_aligned
#' 
#' # Create multi-panel map for Quebec City and Montreal
#' create_multi_panel_map(
#'   map_data,
#'   regions = c("quebec_city", "montreal"),
#'   title = "Quebec Urban Centers",
#'   background = "dark"
#' )
#' }
#'
#' @importFrom ggplot2 ggplot geom_sf theme facet_wrap
#' @importFrom patchwork wrap_plots
#'
#' @export
create_multi_panel_map <- function(
  spatial_data,
  regions,
  value_column = NULL,
  electoral_riding_column = "id_riding",
  title = "Regional Electoral Maps",
  fill_color = c("#f7fbff", "#9ecae1", "#4292c6", "#084594"),
  background = "light",
  ncol = 2,
  city_mapping_object = city_mapping_canada_2025
) {
  # Validate input
  if (!(inherits(spatial_data, "sf") && inherits(spatial_data, "data.frame"))) {
    stop("spatial_data must have class sf and data.frame")
  }
  
  if (!all(regions %in% names(city_mapping_object))) {
    invalid_regions <- regions[!regions %in% names(city_mapping_object)]
    stop("Invalid region names: ", paste(invalid_regions, collapse = ", "), 
         ". Available regions are: ", paste(names(city_mapping_object), collapse = ", "))
  }
  
  # Create list to store individual maps
  map_list <- list()
  
  # Create a map for each region
  for (i in seq_along(regions)) {
    region <- regions[i]
    
    # Crop the data to the current region
    region_data <- crop_map(
      spatial_data, 
      region, 
      electoral_riding_column = electoral_riding_column,
      city_mapping_object = city_mapping_object
    )
    
    # Create the map
    region_map <- create_map(
      region_data,
      value_column = value_column,
      title = region,
      fill_color = fill_color,
      background = background,
      # Simplify the theme for multi-panel
      subtitle = NULL,
      caption = NULL
    )
    
    # Store in list
    map_list[[i]] <- region_map
  }
  
  # Combine all maps
  combined_map <- patchwork::wrap_plots(map_list, ncol = ncol)
  
  # Add title if needed
  if (!is.null(title)) {
    combined_map <- combined_map + patchwork::plot_annotation(
      title = title,
      theme = if (background == "dark") {
        theme(
          plot.background = element_rect(fill = "#1a1a1a", color = NA),
          plot.title = element_text(color = "white", size = 18, face = "bold", hjust = 0.5)
        )
      } else {
        theme(
          plot.title = element_text(size = 18, face = "bold", hjust = 0.5)
        )
      }
    )
  }
  
  return(combined_map)
}