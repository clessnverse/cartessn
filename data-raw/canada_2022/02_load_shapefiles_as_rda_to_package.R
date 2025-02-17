## This script loads the shapefiles from each province and merges them together.
## To obtain access to the data folder containing the downloaded shapefiles, contact Hubert Cadieux

# Packages ---------------------------------------------------------------
library(dplyr)

# List files to merge together -------------------------------------------------------------
files <- list.files(
  "data-raw/data/canada_2022/shapefiles/",
  pattern = ".shp$",
  full.names = TRUE,
  recursive = TRUE
)

# Merge files together -------------------------------------------------------------

df_shapefiles_together <- lapply(
  files,
  FUN = function(x){
    df <- sf::st_read(x)
    print(x)
    return(df)
  }
) |> 
  dplyr::bind_rows() |> 
  select(
    id_riding = FED_NUM,
    name_riding_en = ED_NAMEE,
    name_riding_fr = ED_NAMEF,
    id_province = PROV_CODE,
    geometry
  )

#### Il semble avoir des doublons, mais après vérifications
#### c'est simplement pour gérer les circonscriptions où le territoire est séparé par de l'eau ou wtv.
#### Exemple: 24020 et 24023 (Côte-Nord et Gaspésie)

### AJOUTER LES TERRITOIRES
#### J'ai manuellement downloadé et unzippé les fichiers dans "data-raw/data/canada_2013".
#### Ce dossier contient les shapefiles des circonscriptions du redécoupage de 2013,
#### et il contient donc les circonscriptions des territoires (qui n'ont pas changé en 2022).

df_territories_shapefiles <- sf::st_read("data-raw/data/canada_2013/decoupage_2013.shp") |> 
  ## filter for territories only
  filter(
    `CÉFIDU` %in% c(
      60001,
      61001,
      62001
      )
  ) |> 
  mutate(
    id_province = case_when(
      `CÉFIDU` == 60001 ~ "YT",
      `CÉFIDU` == 61001 ~ "NT",
      `CÉFIDU` == 62001 ~ "NU"
    )
  ) |> 
  select(
    id_riding = `CÉFIDU`,
    name_riding_en = `CÉFANOM`,
    name_riding_fr = `CÉFFNOM`,
    id_province,
    geometry
  )
  

spatial_canada_2022_electoral_ridings <- rbind(df_shapefiles_together, df_territories_shapefiles)

save(spatial_canada_2022_electoral_ridings, file = "data/spatial_canada_2022_electoral_ridings.rda", compress = "bzip2")
