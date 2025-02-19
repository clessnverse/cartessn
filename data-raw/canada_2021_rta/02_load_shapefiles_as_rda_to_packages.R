shapefile_path <- "data-raw/data/canada_2021_rta/files/lfsa000a21a_e/lfsa000a21a_e.shp"

spatial_canada_2021_rta <- sf::st_read(shapefile_path) |> 
  dplyr::mutate(
    id_province = dplyr::case_when(
        PRUID == "10" ~ "NL",
        PRUID == "11" ~ "PE",
        PRUID == "12" ~ "NS",
        PRUID == "13" ~ "NB",
        PRUID == "24" ~ "QC",
        PRUID == "35" ~ "ON",
        PRUID == "46" ~ "MB",
        PRUID == "47" ~ "SK",
        PRUID == "48" ~ "AB",
        PRUID == "59" ~ "BC",
        PRUID == "60" ~ "YT",
        PRUID == "61" ~ "NT",
        PRUID == "62" ~ "NU",
        TRUE ~ NA_character_  # Pour éviter NA implicites si un code inconnu apparaît
      )
  ) |> 
  dplyr::select(-DGUID, -PRUID, -PRNAME, -LANDAREA) |> 
  dplyr::rename(
    rta = CFSAUID
  )

save(spatial_canada_2021_rta, file = "data/spatial_canada_2021_rta.rda", compress = "bzip2")
