## This script loads the shapefiles from each province and merges them together.
## To obtain access to the data folder containing the downloaded shapefiles, contact Hubert Cadieux

# Packages ---------------------------------------------------------------
library(dplyr)

# List files to merge together -------------------------------------------------------------
files <- list.files(
  "data-raw/data/canada_2022_electoral_ridings/shapefiles/",
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
#### Puisque les territoires n'ont pas été affectés par le redécoupage, le site web où
#### je suis allé chercher les shapefiles des nouvelles circonscriptions n'a pas inclus les territoires.
#### Il faut donc aller les chercher du redécoupage précédent, celui de 2013.
#### On peut aller extraire les shapefiles de 2013 dans le script `data-raw/canada_2013_electoral_ridings/01_extract_shapefiles.R`

df_territories_shapefiles <- sf::st_read("data-raw/data/canada_2013_electoral_ridings/files/lfed000a16a_e.shp") |> 
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
    geometry
  )

spatial_canada_2022_electoral_ridings <- rbind(df_shapefiles_together, df_territories_shapefiles)

save(spatial_canada_2022_electoral_ridings, file = "data/spatial_canada_2022_electoral_ridings.rda", compress = "bzip2")
