### Ce script sert à aller extraire les données de
#### recensement par RTA sur Stat Can

url <- "https://www12.statcan.gc.ca/census-recensement/2021/dp-pd/prof/details/download-telecharger/comp/GetFile.cfm?Lang=E&FILETYPE=CSV&GEONO=013"
destination_folder <- "data-raw/data/census_canada_2022_rta"
destination_file <- paste0(destination_folder, "/census_data.zip")

if (!dir.exists(destination_folder)) {
  dir.create(destination_folder, recursive = TRUE)
}

download.file(url, destfile = destination_file)
unzip(destination_file, exdir = destination_folder)
unlink(destination_file)
