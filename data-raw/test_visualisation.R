# Test script for FSA to riding mapping and visualization
library(sf)
library(dplyr)
library(ggplot2)
library(cartessn)

# Example: Map FSAs to electoral ridings ----------------------------------------

# Load spatial data
sf_rta <- cartessn::spatial_canada_2021_rta
sf_ridings <- cartessn::spatial_canada_2022_electoral_ridings_aligned

# Create the mapping
mapping <- cartessn::map_fsa_to_ridings(sf_rta, sf_ridings)

# Examine the results
print(head(mapping$fsa_riding_intersections))
print(head(mapping$fsa_to_riding_mapping))
print(mapping$summary)

# Simulate some data by riding for visualization --------------------------------
set.seed(123)

# Create a simulated dataset with values by riding
sf_ridings_with_data <- sf_ridings %>%
  mutate(
    simulated_value = runif(n(), 0, 100),
    category = sample(c("Category A", "Category B", "Category C"), n(), replace = TRUE)
  )

# Test the map visualization functions -----------------------------------------

# Create a basic map of all ridings
basic_map <- cartessn::create_map(
  sf_ridings_with_data,
  value_column = "simulated_value",
  title = "Simulated Values by Electoral Riding",
  subtitle = "Random data for demonstration",
  caption = "Source: Simulated data",
  legend_title = "Value"
)

# Save the map
ggsave("data-raw/data/basic_map_example.png", basic_map, width = 10, height = 8)

# Create a multi-panel map for specific regions
multi_panel_map <- cartessn::create_multi_panel_map(
  sf_ridings_with_data,
  regions = c("quebec_city", "montreal", "toronto"),
  value_column = "simulated_value",
  title = "Simulated Values by Region",
  background = "dark"
)

# Save the multi-panel map
ggsave("data-raw/data/multi_panel_map_example.png", multi_panel_map, width = 15, height = 10)

# Example: Working with FSA data and mapping to ridings ------------------------

# Simulate some data at the FSA level (e.g., survey responses by postal code)
# In a real scenario, this would be actual survey or administrative data
set.seed(456)

# Get a sample of FSAs
sample_fsas <- sample(sf_rta$rta, 100)

# Create simulated data
simulated_fsa_data <- data.frame(
  rta = sample_fsas,
  response_count = sample(10:500, length(sample_fsas), replace = TRUE),
  avg_rating = rnorm(length(sample_fsas), mean = 7, sd = 1.5)
)

# Join with the FSA-riding mapping to get riding IDs
fsa_data_with_ridings <- simulated_fsa_data %>%
  left_join(mapping$fsa_to_riding_mapping, by = "rta")

# Summarize data by riding
riding_summary <- fsa_data_with_ridings %>%
  group_by(id_riding) %>%
  summarize(
    total_responses = sum(response_count),
    avg_rating = weighted.mean(avg_rating, response_count, na.rm = TRUE),
    .groups = "drop"
  )

# Join the summary with spatial data for mapping
sf_ridings_for_visualization <- sf_ridings %>%
  left_join(riding_summary, by = "id_riding")

# Create a map of the aggregated data
aggregated_map <- cartessn::create_map(
  sf_ridings_for_visualization,
  value_column = "avg_rating",
  title = "Average Rating by Electoral Riding",
  subtitle = "Aggregated from simulated FSA-level data",
  caption = "Source: Simulated FSA data mapped to ridings",
  legend_title = "Avg. Rating",
  fill_color = c("#f7fbff", "#deebf7", "#c6dbef", "#9ecae1", "#6baed6", "#4292c6", "#2171b5", "#084594")
)

# Save the map
ggsave("data-raw/data/aggregated_data_map.png", aggregated_map, width = 10, height = 8)

# Demonstration of working with real survey data -------------------------------
# Uncomment and adapt this section if you have actual survey data

# # Example with real survey data (adapt column names as needed)
# survey_data <- readRDS("path/to/survey_data.rds")
# 
# # Extract FSA (first 3 characters of postal code)
# survey_data$rta <- substr(survey_data$postal_code, 1, 3)
# 
# # Assign riding IDs
# survey_data <- survey_data %>%
#   left_join(mapping$fsa_to_riding_mapping, by = "rta")
# 
# # Check match rate
# match_count <- sum(!is.na(survey_data$id_riding))
# total_count <- nrow(survey_data)
# match_rate <- match_count / total_count * 100
# 
# print(paste0("Successfully matched ", match_count, " out of ", total_count, 
#              " respondents (", round(match_rate, 2), "%)"))
# 
# # Aggregate data by riding for analysis or visualization
# riding_data <- survey_data %>%
#   group_by(id_riding) %>%
#   summarize(
#     respondent_count = n(),
#     # Add additional summary statistics based on your survey columns
#     # For example:
#     avg_age = mean(age, na.rm = TRUE),
#     pct_female = mean(gender == "Female", na.rm = TRUE) * 100,
#     # ...
#     .groups = "drop"
#   )
# 
# # Join with spatial data and create maps
# # ...

# Save mapping results for later use ------------------------------------------
# Uncomment if you want to save the mapping for future use

# saveRDS(mapping$fsa_riding_intersections, "path/to/save/fsa_riding_intersections.rds")
# saveRDS(mapping$fsa_to_riding_mapping, "path/to/save/fsa_to_riding_mapping.rds")

# Original visualizations (kept for reference) --------------------------------

# Script rapide pour afficher toutes les circonscriptions
# Charger les circonscriptions électorales alignées
load("data/spatial_canada_2022_electoral_ridings_aligned.rda")

# Pour les provinces, utilisez l'une de ces méthodes :
# OPTION 1 : Si vous avez le fichier .rda des provinces comme dans votre script original
load("data/spatial_canada_provinces_simple.rda")
provinces_shp <- provinces_simple  # Utiliser directement l'objet chargé

# Maintenant vous pouvez transformer
common_crs <- st_crs(spatial_canada_2022_electoral_ridings_aligned)
provinces_shp <- st_transform(provinces_shp, common_crs)

# Simplifier les provinces pour la performance
provinces_simple <- st_simplify(provinces_shp, preserveTopology = TRUE, dTolerance = 100)

# Vérifier combien de circonscriptions sont valides
valid_count <- sum(!st_is_empty(spatial_canada_2022_electoral_ridings_aligned$geometry))
cat("Nombre de circonscriptions avec géométrie valide:", valid_count, "/", 
    nrow(spatial_canada_2022_electoral_ridings_aligned), "\n")

# Créer un thème personnalisé inspiré de la carte partagée
theme_dark_map <- function() {
  theme_minimal() +
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
}

# Créer la carte avec l'esthétique demandée
map_stylized <- ggplot() +
  # Provinces en gris clair
  geom_sf(data = provinces_simple, fill = "#666666", color = "#333333", size = 0.2) +
  # Circonscriptions en blanc
  geom_sf(data = spatial_canada_2022_electoral_ridings_aligned, fill = NA, color = "#1a1a1a", size = 0.2) +
  # Appliquer le thème sombre
  theme_dark_map() +
  labs(
    title = "CIRCONSCRIPTIONS ÉLECTORALES DU CANADA",
    subtitle = paste0(valid_count, " circonscriptions"),
    caption = "Source: Données électorales 2022"
  )

# Sauvegarder la carte si souhaité
ggsave("data-raw/data/toutes_circonscriptions_alignees.png", map_stylized, width = 12, height = 10, dpi = 300)