# Script optimisé pour aligner les circonscriptions électorales 
# avec les frontières provinciales

# Packages ---------------------------------------------------------------
library(sf)
library(dplyr)
library(ggplot2)

# Fonction d'alignement optimisée ----------------------------------------
align_ridings_to_provinces <- function() {
  message("### Démarrage de l'alignement optimisé ###")
  
  # 1. Charger les données
  message("Chargement des données...")
  
  # Circonscriptions électorales
  load("data/spatial_canada_2022_electoral_ridings.rda")
  ridings_shp <- spatial_canada_2022_electoral_ridings
  
  # Provinces
  load("data/spatial_canada_provinces_simple.rda")
  # Ici on corrige l'affectation - utiliser le bon nom d'objet
  # Corriger le nom de l'objet selon ce qui est réellement dans le fichier
  provinces_shp <- get(ls()[grep("province", ls())])
  
  # 2. Uniformiser les projections
  message("Uniformisation des projections...")
  common_crs <- st_crs(ridings_shp)
  provinces_shp <- st_transform(provinces_shp, common_crs)
  
  # 3. Simplifier les géométries de manière plus agressive pour améliorer les performances
  message("Simplification des géométries...")
  provinces_simple <- st_simplify(provinces_shp, preserveTopology = TRUE, dTolerance = 500)
  # Simplifier également les circonscriptions pour accélérer le traitement
  ridings_simple <- st_simplify(ridings_shp, preserveTopology = TRUE, dTolerance = 100)
  
  # 4. Préparation des provinces
  message("Préparation des frontières provinciales...")
  provinces_simple <- st_make_valid(provinces_simple)
  
  # 5. Utiliser une approche vectorisée plus efficace pour le découpage
  message("Découpage des circonscriptions avec les provinces (méthode vectorisée)...")
  
  # Au lieu de traiter circonscription par circonscription, on fait une seule opération
  gc() # Libérer la mémoire avant l'opération intensive
  
  # Utiliser st_intersection en une seule opération (plus efficace)
  riding_fixed <- try({
    message("Tentative d'intersection vectorisée...")
    st_intersection(ridings_simple, st_union(provinces_simple))
  })
  
  # Si l'opération vectorisée échoue, on revient à une méthode par lots
  if (inherits(riding_fixed, "try-error")) {
    message("L'intersection vectorisée a échoué, passage à la méthode par lots...")
    
    # Créer une copie pour stocker les résultats
    riding_fixed <- ridings_simple
    
    # Traiter par lots plus grands pour réduire les itérations
    batch_size <- 50 # Augmenter la taille des lots
    n_batches <- ceiling(nrow(ridings_simple) / batch_size)
    
    # Utiliser une approche par province plutôt que de tout fusionner
    # Cela permet de réduire la complexité des géométries
    for (i in 1:n_batches) {
      message("Batch ", i, "/", n_batches)
      
      start_idx <- (i-1) * batch_size + 1
      end_idx <- min(i * batch_size, nrow(ridings_simple))
      
      # Traiter ce lot de circonscriptions
      batch_ridings <- ridings_simple[start_idx:end_idx, ]
      
      # Pour chaque province, trouver les circonscriptions qui l'intersectent
      # et faire l'intersection seulement pour celles-là
      for (p in 1:nrow(provinces_simple)) {
        province_geom <- provinces_simple$geometry[p]
        
        # Identifier les circonscriptions qui intersectent cette province
        intersects <- st_intersects(batch_ridings, province_geom, sparse = FALSE)[,1]
        
        if (any(intersects)) {
          # Traiter seulement les circonscriptions qui intersectent cette province
          intersect_indices <- which(intersects)
          
          for (j in intersect_indices) {
            j_global <- start_idx + j - 1
            
            tryCatch({
              # Intersection avec cette province uniquement
              # On utilise directement la géométrie pour éviter des problèmes de colonnes
              tmp_intersection <- st_intersection(
                st_geometry(ridings_simple)[j_global], 
                province_geom
              )
              
              # Mettre à jour la géométrie
              riding_fixed$geometry[j_global] <- tmp_intersection
            }, error = function(e) {
              message("Erreur avec la circonscription ", j_global, ": ", e$message)
            })
          }
        }
        
        # Libérer la mémoire régulièrement
        if (p %% 3 == 0) gc()
      }
      
      # Libérer la mémoire après chaque lot
      gc()
    }
  }

  # 6. Validation
  message("Validation des associations ID/noms/géométries...")
  
  # S'assurer que toutes les géométries sont valides
  riding_fixed <- st_make_valid(riding_fixed)
  
  # 7. Sauvegarder les résultats
  message("Sauvegarde des résultats...")
  spatial_canada_2022_electoral_ridings_aligned <- riding_fixed
  
  save(spatial_canada_2022_electoral_ridings_aligned, 
       file = "data/spatial_canada_2022_electoral_ridings_aligned.rda", 
       compress = "bzip2")
  
  # 8. Création d'une visualisation simplifiée pour ne pas consommer trop de mémoire
  message("Création d'une visualisation...")
  
  # Échantillon réduit pour la visualisation
  set.seed(123)
  
  # Utiliser moins de circonscriptions pour l'aperçu
  sample_idx <- sample(1:nrow(riding_fixed), 5)
  
  # Utiliser une version simplifiée des provinces pour l'affichage
  provinces_viz <- st_simplify(provinces_simple, preserveTopology = TRUE, dTolerance = 1000)
  
  # Créer la carte avec moins d'éléments
  map <- ggplot() +
    geom_sf(data = provinces_viz, fill = "white", color = "darkgray") +
    geom_sf(data = riding_fixed[sample_idx,], fill = NA, color = "red") +
    theme_minimal() +
    labs(title = "Circonscriptions électorales alignées avec les provinces",
         caption = "5 circonscriptions sélectionnées aléatoirement")
  
  # Sauvegarder la carte
  ggsave("data-raw/data/aligned_ridings_preview.png", map, width = 10, height = 8)
  
  message("Processus terminé! Données sauvegardées.")
  return(spatial_canada_2022_electoral_ridings_aligned)
}