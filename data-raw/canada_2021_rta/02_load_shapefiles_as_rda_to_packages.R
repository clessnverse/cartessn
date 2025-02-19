shapefile_path <- "data-raw/data/canada_2021_rta/files/lfsa000a21a_e/lfsa000a21a_e.shp"

spatial_canada_2021_rta <- sf::st_read(shapefile_path)

save(spatial_canada_2021_rta, file = "data/spatial_canada_2021_rta.rda", compress = "bzip2")
