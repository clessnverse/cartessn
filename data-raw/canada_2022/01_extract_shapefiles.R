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



### If folder `data/canada_2022` does not exist, create.