shapefile_path <- "data-raw/data/canada_2013_electoral_ridings/files/lfed000a16a_e.shp"

spatial_canada_2013_electoral_ridings <- sf::st_read(shapefile_path)

save(spatial_canada_2013_electoral_ridings, file = "data/spatial_canada_2013_electoral_ridings.rda", compress = "bzip2")
