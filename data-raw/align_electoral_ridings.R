# Script pour aligner les circonscriptions électorales avec les frontières provinciales simplifiées

# Chargement des packages nécessaires
library(sf)
library(dplyr)
library(ggplot2)

# Fonction d'alignement
align_ridings_to_provinces <- function() {
  message("### Démarrage de l'alignement des circonscriptions ###")
  
  # 1. Chargement des données
  message("Chargement des données...")
  
  # Circonscriptions électorales
  load("data/spatial_canada_2022_electoral_ridings.rda")
  ridings_shp <- spatial_canada_2022_electoral_ridings
  
  # Provinces simplifiées
  load("data/spatial_canada_provinces_simple.rda")
  # Récupération de l'objet des provinces (s'adapte au nom variable)
  all_objects <- ls()
  province_obj_name <- all_objects[grep("province", all_objects)]
  provinces_shp <- get(province_obj_name)
  
  # 2. Vérification et uniformisation des projections
  message("Uniformisation des projections...")
  if (st_crs(ridings_shp) != st_crs(provinces_shp)) {
    provinces_shp <- st_transform(provinces_shp, st_crs(ridings_shp))
  }
  
  # 3. Simplification adaptative des géométries
  message("Simplification des géométries...")
  # Simplification adaptative basée sur la taille des circonscriptions
  ridings_simplified <- ridings_shp %>%
    mutate(area = as.numeric(st_area(.)),
           # Calcul d'une tolérance variable selon la taille (plus petit = moins simplifié)
           tolerance = pmin(sqrt(area)/100, 200)) 
  
  # Application de la simplification avec tolérance variable
  ridings_list <- vector("list", nrow(ridings_simplified))
  for (i in 1:nrow(ridings_simplified)) {
    ridings_list[[i]] <- st_simplify(
      ridings_simplified[i,], 
      preserveTopology = TRUE, 
      dTolerance = ridings_simplified$tolerance[i]
    )
    # Affichage périodique de la progression
    if (i %% 50 == 0) message("Simplification: ", i, "/", nrow(ridings_simplified))
  }
  
  # Reconstitution du sf object
  ridings_simple <- do.call(rbind, ridings_list)
  rm(ridings_list) # Libération de mémoire
  gc()
  
  # 4. Préparation et simplification des provinces
  message("Préparation des provinces...")
  # Simplification variable selon la taille des provinces
  provinces_shp <- provinces_shp %>%
    mutate(area = as.numeric(st_area(.)),
           # Plus grandes provinces = plus simplifiées
           tolerance = pmin(sqrt(area)/200, 500))
  
  provinces_list <- vector("list", nrow(provinces_shp))
  for (i in 1:nrow(provinces_shp)) {
    provinces_list[[i]] <- st_simplify(
      provinces_shp[i,], 
      preserveTopology = TRUE, 
      dTolerance = provinces_shp$tolerance[i]
    )
  }
  
  provinces_simple <- do.call(rbind, provinces_list)
  rm(provinces_list)
  gc()
  
  # Validation des géométries
  provinces_simple <- st_make_valid(provinces_simple)
  ridings_simple <- st_make_valid(ridings_simple)
  
  # 5. Intersection par lots avec gestion d'erreurs
  message("Découpage des circonscriptions par provinces...")
  
  # Préparation du résultat
  riding_aligned <- ridings_simple
  
  # Taille de lot adaptée à la mémoire disponible
  batch_size <- 20
  n_batches <- ceiling(nrow(ridings_simple) / batch_size)
  
  for (batch in 1:n_batches) {
    message("Traitement du lot ", batch, "/", n_batches)
    
    # Indices pour ce lot
    start_idx <- (batch-1) * batch_size + 1
    end_idx <- min(batch * batch_size, nrow(ridings_simple))
    batch_indices <- start_idx:end_idx
    
    # Pour chaque circonscription dans ce lot
    for (i in batch_indices) {
      # Identifie la province qui a la plus grande intersection avec cette circonscription
      intersections <- st_intersection(st_geometry(ridings_simple[i,]), st_geometry(provinces_simple))
      
      # Si aucune intersection n'est trouvée, passer à la suivante
      if (length(intersections) == 0) {
        message("Aucune intersection trouvée pour la circonscription ", i)
        next
      }
      
      # Calculer les aires d'intersection
      intersection_areas <- st_area(intersections)
      
      # Trouver l'index de l'intersection avec la plus grande aire
      max_area_idx <- which.max(intersection_areas)
      
      # Utiliser cette intersection comme géométrie alignée
      tryCatch({
        riding_aligned$geometry[i] <- intersections[max_area_idx]
      }, error = function(e) {
        message("Erreur avec la circonscription ", i, ": ", e$message)
      })
    }
    
    # Libérer la mémoire après chaque lot
    gc()
  }
  
  # 6. Validation finale
  message("Validation des géométries finales...")
  riding_aligned <- st_make_valid(riding_aligned)
  
  # 7. Sauvegarde des résultats
  message("Sauvegarde des résultats...")
  spatial_canada_2022_electoral_ridings_aligned <- riding_aligned
  
  save(spatial_canada_2022_electoral_ridings_aligned, 
       file = "data/spatial_canada_2022_electoral_ridings_aligned.rda", 
       compress = "bzip2")
  
  # Créer une sauvegarde
  file.copy("data/spatial_canada_2022_electoral_ridings_aligned.rda", 
            paste0("data/spatial_canada_2022_electoral_ridings_aligned.rda.backup-", 
                   format(Sys.time(), "%Y%m%d%H%M%S")),
            overwrite = TRUE)
  
  # 8. Visualisation de vérification
  message("Création d'une visualisation...")
  
  # Échantillonnage pour la visualisation (plus d'échantillons mais toujours limité)
  set.seed(123)
  sample_size <- min(10, nrow(riding_aligned))
  sample_idx <- sample(1:nrow(riding_aligned), sample_size)
  
  # Visualisation
  map <- ggplot() +
    geom_sf(data = provinces_simple, fill = "white", color = "darkgray", size = 0.5) +
    geom_sf(data = riding_aligned[sample_idx,], fill = NA, color = "red", size = 0.3) +
    theme_minimal() +
    labs(title = "Circonscriptions électorales alignées avec les provinces",
         subtitle = paste(sample_size, "circonscriptions aléatoires affichées"),
         caption = format(Sys.time(), "%Y-%m-%d"))
  
  # Création du dossier si nécessaire
  if (!dir.exists("data-raw/data")) {
    dir.create("data-raw/data", recursive = TRUE)
  }
  
  # Sauvegarde de la carte
  ggsave("data-raw/data/aligned_ridings_preview.png", map, width = 10, height = 8, dpi = 100)
  
  message("Processus terminé! Données sauvegardées.")
  return(invisible(spatial_canada_2022_electoral_ridings_aligned))
}

# Exécution de la fonction (ligne à décommenter pour exécuter)
align_ridings_to_provinces()
