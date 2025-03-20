# Script ultra-minimal pour aligner les circonscriptions électorales
# avec les frontières provinciales uniquement
# Packages ---------------------------------------------------------------

# Vérifier et installer les packages requis
required_packages <- c("sf", "dplyr", "ggplot2", "parallel", "pbapply", "future", "future.apply")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installation du package ", pkg, "...")
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}

# Activer la parallélisation avec future
future::plan(future::multisession, workers = future::availableCores() - 1)

# Fonction d'alignement très basique -------------------------------------
align_ridings_to_provinces <- function() {
  message("### Démarrage de l'alignement simplifié ###")
  
  # Vérification des chemins d'accès
  data_dir <- "data"
  data_raw_dir <- "data-raw/data"
  
  # Créer les répertoires s'ils n'existent pas
  if (!dir.exists(data_dir)) {
    message("Création du répertoire 'data'...")
    dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  if (!dir.exists(data_raw_dir)) {
    message("Création du répertoire 'data-raw/data'...")
    dir.create(data_raw_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  # 1. Charger les données
  message("Chargement des données...")
  
  # Vérifier l'existence des fichiers
  riding_file <- file.path(data_dir, "spatial_canada_2022_electoral_ridings.rda")
  province_file <- file.path(data_dir, "spatial_canada_provinces_simple.rda")
  
  if (!file.exists(riding_file)) {
    stop("Fichier non trouvé: ", riding_file, 
         ". Veuillez vérifier le chemin d'accès et que le fichier existe.")
  }
  
  if (!file.exists(province_file)) {
    stop("Fichier non trouvé: ", province_file, 
         ". Veuillez vérifier le chemin d'accès et que le fichier existe.")
  }
  
  # Circonscriptions électorales
  load(riding_file)
  if (!exists("spatial_canada_2022_electoral_ridings")) {
    stop("L'objet 'spatial_canada_2022_electoral_ridings' n'a pas été chargé.")
  }
  ridings_shp <- spatial_canada_2022_electoral_ridings
  
  # Provinces
  load(province_file)
  if (!exists("provinces_simple")) {
    stop("L'objet 'provinces_simple' n'a pas été chargé.")
  }
  provinces_shp <- provinces_simple
  
  # Vérifier que les objets sont bien des objets sf
  if (!inherits(ridings_shp, "sf")) {
    stop("ridings_shp n'est pas un objet sf valide.")
  }
  
  if (!inherits(provinces_shp, "sf")) {
    stop("provinces_shp n'est pas un objet sf valide.")
  }
  
  # 2. Uniformiser les projections
  message("Uniformisation des projections...")
  common_crs <- st_crs(ridings_shp)
  provinces_shp <- st_transform(provinces_shp, common_crs)
  
  # 3. Simplifier les géométries pour améliorer les performances
  message("Simplification des géométries...")
  provinces_simple <- st_simplify(provinces_shp, preserveTopology = TRUE, dTolerance = 100)
  provinces_simple <- st_make_valid(provinces_simple)
  
  # 4. Configuration de la parallélisation
  message("Configuration de la parallélisation...")
  num_cores <- future::availableCores() - 1
  message("Utilisation de ", num_cores, " cœurs pour le traitement parallèle")
  
  # 5. Diviser les données en lots pour parallélisation
  message("Préparation des lots pour parallélisation...")
  
  # Déterminer la taille des lots basée sur le nombre de cœurs
  batch_size <- ceiling(nrow(ridings_shp) / num_cores)
  batch_indices <- split(1:nrow(ridings_shp), ceiling(seq_along(1:nrow(ridings_shp)) / batch_size))
  
  # Fonction de traitement des lots (à exécuter en parallèle)
  process_batch <- function(indices) {
    library(sf)
    library(dplyr)
    
    batch_results <- NULL
    missing_count <- 0
    
    for (j in indices) {
      tryCatch({
        # Obtenir la circonscription
        temp_riding <- ridings_shp[j,]
        riding_has_intersection <- FALSE
        
        # Pour chaque province, calculer l'intersection
        for (p in 1:nrow(provinces_simple)) {
          province <- provinces_simple[p,]
          
          # Vérifier si l'intersection existe (plus robuste)
          intersects <- suppressWarnings(st_intersects(temp_riding, province, sparse = FALSE))
          if (length(intersects) > 0 && intersects[1,1]) {
            # Calculer l'intersection
            intersection_result <- suppressWarnings(st_intersection(temp_riding, province))
            
            # Si l'intersection produit un résultat valide
            if (!is.null(intersection_result) && nrow(intersection_result) > 0) {
              # Vérifier que la géométrie est valide
              if (any(!st_is_valid(intersection_result))) {
                intersection_result <- st_make_valid(intersection_result)
              }
              
              # Obtenir les informations de la province (toutes les colonnes)
              for (col_name in names(province)) {
                if (col_name != "geometry") {
                  intersection_result[[paste0("province_", col_name)]] <- province[[col_name]]
                }
              }
              
              # Marquer cette circonscription comme ayant une intersection
              riding_has_intersection <- TRUE
              
              # Ajouter à nos résultats de lot
              if (is.null(batch_results)) {
                batch_results <- intersection_result
              } else {
                # Combiner les dataframes
                batch_results <- rbind(batch_results, intersection_result)
              }
            }
          }
        }
        
        # Si la circonscription n'a pas d'intersection valide avec une province
        # On la conserve telle quelle
        if (!riding_has_intersection) {
          missing_count <- missing_count + 1
          
          # On ajoute quand même cette circonscription au résultat
          if (is.null(batch_results)) {
            batch_results <- temp_riding
          } else {
            # Combiner les dataframes
            batch_results <- rbind(batch_results, temp_riding)
          }
        }
        
      }, error = function(e) {
        # En cas d'erreur, on ajoute quand même la circonscription originale
        if (is.null(batch_results)) {
          batch_results <<- ridings_shp[j,]
        } else {
          # Combiner les dataframes
          batch_results <<- rbind(batch_results, ridings_shp[j,])
        }
      })
    }
    
    return(list(results = batch_results, missing = missing_count))
  }
  
  # 6. Exécution parallèle
  message("Traitement parallèle des circonscriptions...")
  
  # Utiliser future_lapply pour le traitement parallèle
  batch_results <- future.apply::future_lapply(
    batch_indices,
    process_batch,
    future.seed = TRUE  # Pour la reproductibilité
  )
  
  # 7. Combiner les résultats de tous les processus
  message("Combinaison des résultats...")
  result_ridings <- NULL
  missing_count <- 0
  
  for (batch in batch_results) {
    batch_data <- batch$results
    missing_count <- missing_count + batch$missing
    
    if (!is.null(batch_data) && nrow(batch_data) > 0) {
      if (is.null(result_ridings)) {
        result_ridings <- batch_data
      } else {
        # Uniformiser les colonnes avant de combiner
        all_cols <- union(names(result_ridings), names(batch_data))
        
        # Ajouter les colonnes manquantes à chaque dataframe
        for (col in all_cols) {
          if (!col %in% names(result_ridings)) {
            result_ridings[[col]] <- NA
          }
          if (!col %in% names(batch_data)) {
            batch_data[[col]] <- NA
          }
        }
        
        # Maintenant combiner
        result_ridings <- rbind(result_ridings[, all_cols], 
                               batch_data[, all_cols])
      }
    }
  }
  
  message("Circonscriptions sans intersection valide: ", missing_count)
  
  # Vérifier que tous les ridings originaux sont bien représentés
  original_ids <- unique(ridings_shp$id_riding)
  result_ids <- unique(result_ridings$id_riding)
  missing_ids <- setdiff(original_ids, result_ids)
  
  if (length(missing_ids) > 0) {
    warning("Certaines circonscriptions originales manquent dans le résultat: ", 
            paste(missing_ids, collapse=", "))
    
    # Ajouter les circonscriptions manquantes
    for (id in missing_ids) {
      missing_riding <- ridings_shp[ridings_shp$id_riding == id, ]
      result_ridings <- rbind(result_ridings, missing_riding)
    }
    
    message("Les circonscriptions manquantes ont été ajoutées.")
  }
  
  # 8. Sauvegarder les résultats
  message("Sauvegarde des résultats...")
  spatial_canada_2022_electoral_ridings_aligned <- result_ridings
  output_file <- file.path(data_dir, "spatial_canada_2022_electoral_ridings_aligned.rda")
  
  # Créer une sauvegarde si le fichier existe déjà
  if (file.exists(output_file)) {
    backup_file <- paste0(output_file, ".backup-", format(Sys.time(), "%Y%m%d%H%M%S"))
    file.copy(output_file, backup_file)
    message("Sauvegarde du fichier existant créée: ", backup_file)
  }
  
  # Sauvegarder les résultats
  save(spatial_canada_2022_electoral_ridings_aligned,
       file = output_file,
       compress = "bzip2")
  
  # 9. Créer une visualisation
  message("Création d'une visualisation...")
  # Échantillon pour la visualisation
  if (nrow(result_ridings) > 0) {
    set.seed(123)
    sample_size <- min(10, nrow(result_ridings))
    sample_idx <- sample(1:nrow(result_ridings), sample_size)
    
    # Créer la carte
    map <- ggplot() +
      geom_sf(data = provinces_simple, fill = "white", color = "darkgray") +
      geom_sf(data = result_ridings[sample_idx,], fill = NA, color = "red") +
      theme_minimal() +
      labs(title = "Circonscriptions électorales alignées avec les provinces",
           caption = paste(sample_size, "circonscriptions sélectionnées aléatoirement"))
    
    # Sauvegarder la carte
    viz_file <- file.path(data_raw_dir, "aligned_ridings_preview.png")
    ggsave(viz_file, map, width = 10, height = 8)
    message("Visualisation sauvegardée: ", viz_file)
  } else {
    warning("Impossible de créer une visualisation: aucun résultat généré.")
  }
  
  # Afficher des statistiques
  message("Nombre total de circonscriptions originales: ", length(original_ids))
  message("Nombre total d'enregistrements dans le résultat: ", nrow(result_ridings))
  message("Nombre total de circonscriptions uniques dans le résultat: ", length(unique(result_ridings$id_riding)))
  
  message("Processus terminé! Données sauvegardées dans: ", output_file)
  return(spatial_canada_2022_electoral_ridings_aligned)
}

# Exécuter la fonction automatiquement
align_ridings_to_provinces()