## This script will only load the names of the electoral ridings as a dataframe accesible via the package.

# Packages ---------------------------------------------------------------
library(dplyr)

names_canada_2013_electoral_ridings <- as.data.frame(sf::st_read("data-raw/data/canada_2013_electoral_ridings/files/lfed000a16a_e.shp")) |> 
  mutate(
    id_province = case_when(
      substr(FEDUID, 1, 2) == "10" ~ "NL",
      substr(FEDUID, 1, 2) == "11" ~ "PE",
      substr(FEDUID, 1, 2) == "12" ~ "NS",
      substr(FEDUID, 1, 2) == "13" ~ "NB",
      substr(FEDUID, 1, 2) == "24" ~ "QC",
      substr(FEDUID, 1, 2) == "35" ~ "ON",
      substr(FEDUID, 1, 2) == "46" ~ "MB",
      substr(FEDUID, 1, 2) == "47" ~ "SK",
      substr(FEDUID, 1, 2) == "48" ~ "AB",
      substr(FEDUID, 1, 2) == "59" ~ "BC",
      substr(FEDUID, 1, 2) == "60" ~ "YT",
      substr(FEDUID, 1, 2) == "61" ~ "NT",
      substr(FEDUID, 1, 2) == "62" ~ "NU",
      TRUE ~ NA_character_  # Pour éviter NA implicites si un code inconnu apparaît
    )
  ) |> 
  select(
    id_riding = `FEDUID`,
    name_riding_en = `FEDENAME`,
    name_riding_fr = `FEDFNAME`,
    id_province,
    -geometry
  ) |> 
  distinct(id_riding, .keep_all = TRUE)

save(names_canada_2013_electoral_ridings, file = "data/names_canada_2013_electoral_ridings.rda", compress = "bzip2")
