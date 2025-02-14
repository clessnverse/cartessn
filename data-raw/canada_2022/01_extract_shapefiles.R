## This script extracts the zip files containing the shapefiles from each province and saves them in the data folder
## The shapefiles from each province can be accessed here: https://redecoupage-redistribution-2022.ca/com/index_e.aspx

# Packages ---------------------------------------------------------------
library(rvest)

# Scrape provinces ids in the website ------------------------------------

### load page
page <- read_html("https://redecoupage-redistribution-2022.ca/com/index_e.aspx")

### extract all urls
all_urls <- page |> 
  html_nodes("a") |> 
  html_attr("href") |> 
  unique()

### filter to only keep urls that are links to provinces pages
provinces_urls <- all_urls[grepl("^/com/[a-z]{2,3}/index_e\\.aspx$", all_urls)]

### extract the provinces ids from these urls
provinces <- sub("^/com/([a-z]{2,3})/.*", "\\1", provinces_urls)

# Extract zip files containing shapefiles ------------------------------------------------------

## example url: https://redecoupage-redistribution-2022.ca/com/nl/NLpropo.zip

destination_folder <- "data-raw/data/canada_2022/shapefiles/"

## Only try to extract provinces that are not yet extracted
provinces_extracted <- gsub("\\.zip", "", list.files(destination_folder))
provinces_not_extacted <- provinces[!(provinces %in% provinces_extracted)]

for (i in provinces_not_extacted){
  zip_urls <- paste0(
    "https://redecoupage-redistribution-2022.ca/com/",
    i,
    "/",
    toupper(substr(i, 1, 2)),
    c("final.zip", ".zip")
  )
  ### If folder `data/canada_2022/zip_containing_shp` does not exist, create.
  if (!dir.exists(destination_folder)) {
    dir.create(destination_folder, recursive = TRUE)
  }
  ### download zip file
  tryCatch(
    expr = download.file(zip_urls[1], destfile = paste0(destination_folder, i, ".zip")),
    error = function(e) download.file(zip_urls[2], destfile = paste0(destination_folder, i, ".zip"))
  )
  message("-------------------\n", i, "\n-------------------")
  Sys.sleep(1)
}

# Extract zip files as normal folders ------------------------------------

zip_files <- list.files(destination_folder, pattern = "\\.zip$", full.names = TRUE)

# Extraire chaque ZIP dans un dossier du même nom (sans .zip)
lapply(zip_files, function(zip) {
  dossier_sortie <- file.path(destination_folder, tools::file_path_sans_ext(basename(zip)))
  dir.create(dossier_sortie, showWarnings = FALSE)
  unzip(zip, exdir = dossier_sortie)
  unlink(zip)
})
