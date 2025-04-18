% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map_visualization.R
\name{create_map}
\alias{create_map}
\title{Create thematic maps from Canadian electoral ridings data}
\usage{
create_map(
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
)
}
\arguments{
\item{spatial_data}{An sf object (spatial dataframe) containing electoral ridings}

\item{value_column}{Character string naming the column containing values to be displayed (optional)}

\item{title}{Character string for the map title}

\item{subtitle}{Character string for the map subtitle (optional)}

\item{caption}{Character string for the map caption/source (optional)}

\item{fill_color}{Character vector of colors for the map fill gradient
Default is c("#f7fbff", "#9ecae1", "#4292c6", "#084594")}

\item{border_color}{Character string for the border color. Default is "#1a1a1a"}

\item{border_size}{Numeric value for the border width. Default is 0.2}

\item{background}{Character string for map background ("light" or "dark"). Default is "light"}

\item{legend_title}{Character string for the legend title (optional)}

\item{discrete_values}{Logical indicating if values should be treated as discrete categories.
Default is FALSE (continuous values)}
}
\value{
A ggplot2 object representing the thematic map
}
\description{
This function creates customized thematic maps from Canadian electoral riding data.
It supports various visualization styles and can display data values on the map.
}
\examples{
\dontrun{
# Load electoral ridings data
map_data <- cartessn::spatial_canada_2022_electoral_ridings_aligned

# Basic map with no data values
create_map(map_data, title = "Canadian Electoral Ridings")

# Map with hypothetical election data
map_data$vote_share <- runif(nrow(map_data), 0.25, 0.75)
create_map(map_data, 
           value_column = "vote_share", 
           title = "Hypothetical Vote Share",
           subtitle = "Simulated Data",
           caption = "Source: Simulated data",
           legend_title = "Vote Share",
           background = "dark")
}

}
