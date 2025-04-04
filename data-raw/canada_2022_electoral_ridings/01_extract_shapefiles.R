## This script downloads and extracts the shapefiles for the 2023 Canadian federal electoral districts
## The shapefiles can be accessed here: https://ftp.cartes.canada.ca/pub/elections_elections/Electoral-districts_Circonscription-electorale/Elections_Canada_2021/FED_CA_2021_FR.gdb.zip

# Packages ---------------------------------------------------------------
library(utils)

# Download and extract shapefile -----------------------------------------

# URL for the FED_CA_2021_FR.gdb.zip file
zip_url <- "https://ftp.maps.canada.ca/pub/elections_elections/Electoral-districts_Circonscription-electorale/federal_electoral_districts_boundaries_2023/CF_CA_2023_FR-SHP.zip"

# Define destination paths
destination_folder <- "data-raw/data/canada_2022_electoral_ridings/"
zip_destination <- file.path(destination_folder, "CF_CA_2023_FR-SHP.zip")
shp_folder_path <- "data-raw/CF_CA_2023_FR-SHP"

# Create destination directory if it doesn't exist
if (!dir.exists(destination_folder)) {
  dir.create(destination_folder, recursive = TRUE)
}

if (!dir.exists(shp_folder_path)) {
  dir.create(shp_folder_path, recursive = TRUE)
}

# Download the zip file
download.file(zip_url, destfile = zip_destination)

# Extract the zip file
unzip(zip_destination, exdir = destination_folder)

message("Downloaded and extracted shapefiles to: ", destination_folder)

# Note: After extraction, the shapefile path that will be used in subsequent scripts is:
# shp_folder_path <- "data-raw/CF_CA_2023_FR-SHP"
# shapefile_path <- file.path(shp_folder_path, "CF_CA_2023_FR.shp")
