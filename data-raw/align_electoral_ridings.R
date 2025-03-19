# Script ultra-minimal pour aligner les circonscriptions électorales
# avec les frontières provinciales uniquement
# Packages ---------------------------------------------------------------
library(sf)
library(dplyr)
library(ggplot2)

# Fonction d'alignement très basique -------------------------------------
align_ridings_to_provinces <- function() {
  message("### Démarrage de l'alignement simplifié ###")
  
  # 1. Charger les données
  message("Chargement des données...")
  # Circonscriptions électorales
  load("data/spatial_canada_2022_electoral_ridings.rda")
  ridings_shp <- spatial_canada_2022_electoral_ridings
  
  # Provinces - Correction: utiliser load() au lieu de st_read() pour le fichier .rda
  load("data/spatial_canada_provinces_simple.rda")
  # Assurez-vous que le nom de l'objet correspond à celui dans le fichier .rda
  # Si l'objet s'appelle autrement que "spatial_canada_provinces_simple", 
  # ajustez la ligne suivante en conséquence
  provinces_shp <- provinces_simple
  
  # 2. Uniformiser les projections
  message("Uniformisation des projections...")
  common_crs <- st_crs(ridings_shp)
  provinces_shp <- st_transform(provinces_shp, common_crs)
  
  # 3. Simplifier les géométries pour améliorer les performances
  message("Simplification des géométries...")
  provinces_simple <- st_simplify(provinces_shp, preserveTopology = TRUE, dTolerance = 100)
  
  # 4. Fusionner toutes les provinces en une seule géométrie
  message("Préparation des frontières provinciales...")
  # CORRECTION: Ajouter st_make_valid pour résoudre l'erreur de topologie
  provinces_simple <- st_make_valid(provinces_simple)
  provinces_union <- st_union(provinces_simple)
  
  # 5. Découper les circonscriptions avec les provinces
  message("Découpage des circonscriptions avec les provinces...")
  # Cette méthode alternative utilise un masque plutôt que des alignements complexes
  # Elle est beaucoup plus simple et robuste
  riding_fixed <- ridings_shp
  
  # Traiter par lots pour économiser la mémoire
  message("Traitement par lots...")
  batch_size <- 20
  n_batches <- ceiling(nrow(ridings_shp) / batch_size)
  
  for (i in 1:n_batches) {
    message("Batch ", i, "/", n_batches)
    start_idx <- (i-1) * batch_size + 1
    end_idx <- min(i * batch_size, nrow(ridings_shp))
    
    # Pour chaque circonscription dans ce lot
    for (j in start_idx:end_idx) {
      tryCatch({
        # Effectuer l'intersection de manière à préserver les attributs
        # Au lieu de modifier seulement la géométrie, on travaille avec la ligne complète
        temp_riding <- ridings_shp[j,]
        intersection_result <- st_intersection(temp_riding, provinces_union)
        
        # Si l'intersection produit un résultat valide
        if (!is.null(intersection_result) && nrow(intersection_result) > 0) {
          # Si plusieurs géométries sont créées, les fusionner
          if (nrow(intersection_result) > 1) {
            intersection_result <- intersection_result %>%
              summarise(across(where(is.character), first), 
                        across(where(is.numeric), first),
                        across(where(is.factor), first))
          }
          
          # Mettre à jour la géométrie tout en conservant les attributs originaux
          riding_fixed$geometry[j] <- intersection_result$geometry
        }
      }, error = function(e) {
        message("Erreur avec la circonscription ", j, ": ", e$message)
      })
    }
  }
  
  # 6. Sauvegarder les résultats
  message("Sauvegarde des résultats...")
  spatial_canada_2022_electoral_ridings_aligned <- riding_fixed
  save(spatial_canada_2022_electoral_ridings_aligned,
       file = "data/spatial_canada_2022_electoral_ridings_aligned.rda",
       compress = "bzip2")
  
  # 7. Créer une visualisation
  message("Création d'une visualisation...")
  # Échantillon pour la visualisation
  set.seed(123)
  sample_idx <- sample(1:nrow(riding_fixed), 10)
  
  # Créer la carte
  map <- ggplot() +
    geom_sf(data = provinces_simple, fill = "white", color = "darkgray") +
    geom_sf(data = riding_fixed[sample_idx,], fill = NA, color = "red") +
    theme_minimal() +
    labs(title = "Circonscriptions électorales alignées avec les provinces",
         caption = "10 circonscriptions sélectionnées aléatoirement")
  
  # Sauvegarder la carte
  ggsave("data-raw/data/aligned_ridings_preview.png", map, width = 10, height = 8)
  
  message("Processus terminé! Données sauvegardées.")
  return(spatial_canada_2022_electoral_ridings_aligned)
}

# Exécuter la fonction
align_ridings_to_provinces()