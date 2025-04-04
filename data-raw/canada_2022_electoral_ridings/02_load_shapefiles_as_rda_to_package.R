## This script loads the 2023 Canadian federal electoral districts shapefile
## and saves it as an R data object for the package.
# Packages ---------------------------------------------------------------
library(dplyr)
library(sf)
shp_folder_path <- "data-raw/data/canada_2022_electoral_ridings/"
shapefile_path <- file.path(shp_folder_path, "CF_CA_2023_FR.shp")
spatial_canada_2022_electoral_ridings <- sf::st_read(shapefile_path) |>
  # Convert to proper projection if needed
  # sf::st_transform(4326) |> # Uncomment if you need to transform the CRS
  # Select and rename columns to match the expected structure
  dplyr::select(
    id_riding = NUM_CF,      # NUM_CF est la colonne d'ID de circonscription
    name_riding_fr = CF_NOMFR, # CF_NOMFR est la colonne du nom français
    name_riding_en = CF_NOMAN, # CF_NOMAN est la colonne du nom anglais
    geometry
  ) |>
  # Ajouter le code de province basé sur le préfixe de id_riding
  mutate(
    id_province = case_when(
      substr(id_riding, 1, 2) == "10" ~ "NL", # Newfoundland and Labrador
      substr(id_riding, 1, 2) == "11" ~ "PE", # Prince Edward Island
      substr(id_riding, 1, 2) == "12" ~ "NS", # Nova Scotia
      substr(id_riding, 1, 2) == "13" ~ "NB", # New Brunswick
      substr(id_riding, 1, 2) == "24" ~ "QC", # Quebec
      substr(id_riding, 1, 2) == "35" ~ "ON", # Ontario
      substr(id_riding, 1, 2) == "46" ~ "MB", # Manitoba
      substr(id_riding, 1, 2) == "47" ~ "SK", # Saskatchewan
      substr(id_riding, 1, 2) == "48" ~ "AB", # Alberta
      substr(id_riding, 1, 2) == "59" ~ "BC", # British Columbia
      substr(id_riding, 1, 2) == "60" ~ "YT", # Yukon
      substr(id_riding, 1, 2) == "61" ~ "NT", # Northwest Territories
      substr(id_riding, 1, 2) == "62" ~ "NU", # Nunavut
      TRUE ~ "Unknown"
    )
  )
# Note: The new shapefile might have different column names than what was used before.
# If the column selections above don't match, you'll need to adjust them based on the
# actual column names in the shapefile.
# Save the processed data ------------------------------------------------
save(spatial_canada_2022_electoral_ridings,
     file = "data/spatial_canada_2022_electoral_ridings.rda",
     compress = "bzip2")
