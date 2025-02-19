## This script extracts the zip files containing the shapefiles from each RTA and saves them in the data-raw/data folder
## The shapefiles from each rta can be accessed here: https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lfsa000a21a_e.zip

### zip file url
file_url <- "https://www12.statcan.gc.ca/census-recensement/2021/geo/sip-pis/boundary-limites/files-fichiers/lfsa000a21a_e.zip"

### folder and file paths
destination_folder <- "data-raw/data/canada_2021_rta"
destination_file <- paste0(destination_folder, "/files.zip")

### If the destination folder does not exist, create.
if (!dir.exists(destination_folder)) {
  dir.create(destination_folder, recursive = TRUE)
}

### download zip file
download.file(file_url, destfile = destination_file)

### extract zip file
dossier_sortie <- file.path(destination_folder, tools::file_path_sans_ext(basename(destination_file)))
dir.create(dossier_sortie, showWarnings = FALSE)
unzip(destination_file, exdir = dossier_sortie)
unlink(destination_file)
