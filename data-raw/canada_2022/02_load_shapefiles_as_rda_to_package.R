## This script loads the shapefiles from each province and merges them together.
## To obtain access to the data folder containing the downloaded shapefiles, contact Hubert Cadieux

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
  dplyr::bind_rows()

#### Il semble avoir des doublons, mais après vérifications
#### c'est simplement pour gérer les circonscriptions où le territoire est séparé par de l'eau ou wtv.
#### Exemple: 24020 et 24023 (Côte-Nord et Gaspésie)


### AJOUTER LES TERRITOIRES