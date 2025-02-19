## This script extracts the zip files containing the shapefiles for each electoral riding from the 2013 redistribution and saves them in the data-raw/data folder
## https://www12.statcan.gc.ca/census-recensement/alternative_alternatif.cfm?archived=1&l=eng&dispext=zip&teng=gfed000a11a_e.zip&k=%20%20%20%2013195&loc=http://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/gfed000a11a_e.zip

### zip file url
file_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lfed000a16a_e.zip"

### folder and file paths
destination_folder <- "data-raw/data/canada_2013_electoral_ridings"
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
