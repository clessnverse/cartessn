## This script will only load the names of the electoral ridings as a dataframe accesible via the package.

# Packages ---------------------------------------------------------------
library(dplyr)

# List files to merge together -------------------------------------------------------------
files <- list.files(
  "data-raw/data/canada_2022_electoral_ridings/shapefiles/",
  pattern = ".shp$",
  full.names = TRUE,
  recursive = TRUE
)


# Merge ------------------------------------------------------------------
df_shapefiles_together <- lapply(
  files,
  FUN = function(x){
    df <- as.data.frame(sf::st_read(x))
    print(x)
    return(df)
  }
) |> 
  dplyr::bind_rows() |> 
  select(
    id_riding = FED_NUM,
    name_riding_en = ED_NAMEE,
    name_riding_fr = ED_NAMEF,
    id_province = PROV_CODE
  )

df_territories_shapefiles <- as.data.frame(sf::st_read("data-raw/data/canada_2013_electoral_ridings/files/lfed000a16a_e.shp")) |> 
  ## filter for territories only
  filter(
    `FEDUID` %in% c(
      60001,
      61001,
      62001
      )
  ) |> 
  mutate(
    id_province = case_when(
      `FEDUID` == 60001 ~ "YT",
      `FEDUID` == 61001 ~ "NT",
      `FEDUID` == 62001 ~ "NU"
    )
  ) |> 
  select(
    id_riding = `FEDUID`,
    name_riding_en = `FEDENAME`,
    name_riding_fr = `FEDFNAME`,
    id_province,
    -geometry
  )

names_canada_2022_electoral_ridings <- rbind(df_shapefiles_together, df_territories_shapefiles) |> 
  ## remove duplicates of id_riding
  distinct(id_riding, .keep_all = TRUE)

save(names_canada_2022_electoral_ridings, file = "data/names_canada_2022_electoral_ridings.rda", compress = "bzip2")
