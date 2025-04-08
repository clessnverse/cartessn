# Installation locale du package cartessn
# Script amélioré pour résoudre les problèmes de téléchargement

# Configuration initiale
lib_path <- "~/R/library"
dir.create(lib_path, showWarnings = FALSE, recursive = TRUE)

# Ajustement des options de téléchargement
options(timeout = 600)  # Augmenter le timeout à 10 minutes

# Installation des dépendances essentielles
needed_packages <- c("devtools", "remotes", "sf", "dplyr", "ggplot2", "patchwork", "rlang")
for (pkg in needed_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org", lib = lib_path)
  }
}

# Charger les librairies nécessaires
library(devtools, lib.loc = lib_path)
library(remotes, lib.loc = lib_path)

# Désactiver les avertissements comme erreurs pour éviter les interruptions
options(warn = 1)  # Afficher les avertissements sans arrêter
options(verbose = TRUE)

# Définir clairement le chemin complet du répertoire actuel
current_dir <- getwd()
message("Installation depuis le répertoire: ", current_dir)

# Installation prioritaire depuis le répertoire local
tryCatch({
  message("Installation depuis le répertoire local...")
  devtools::install(".", lib = lib_path, dependencies = TRUE, upgrade = "never", force = TRUE, quiet = FALSE)
  message("Installation locale réussie!")
  quit(save = "no", status = 0)  # Sortir si l'installation locale réussit
}, error = function(e) {
  message("Erreur lors de l'installation locale: ", e$message)
  message("Tentative d'installation depuis GitHub...")
})

# Tentatives d'installation depuis GitHub avec différentes méthodes
# Méthode 1: Installation standard
tryCatch({
  message("Tentative 1: Installation GitHub standard...")
  remotes::install_github("clessnverse/cartessn", 
                         dependencies = TRUE,
                         force = TRUE)
}, error = function(e) {
  message("Échec de la tentative 1: ", e$message)
})

# Méthode 2: Avec libcurl 
tryCatch({
  message("Tentative 2: Installation avec libcurl...")
  options(download.file.method = "libcurl")
  remotes::install_github("clessnverse/cartessn", 
                         dependencies = TRUE,
                         force = TRUE)
}, error = function(e) {
  message("Échec de la tentative 2: ", e$message)
})

# Méthode 3: Avec wget
tryCatch({
  message("Tentative 3: Installation avec wget...")
  options(download.file.method = "wget")
  remotes::install_github("clessnverse/cartessn", 
                         dependencies = TRUE,
                         force = TRUE)
}, error = function(e) {
  message("Échec de la tentative 3: ", e$message)
})

# Vérification finale
if (requireNamespace("cartessn", quietly = TRUE)) {
  message("Installation réussie! Le package cartessn est maintenant disponible.")
} else {
  message("ÉCHEC: Le package n'a pas pu être installé. Vérifiez votre connexion internet et les permissions GitHub.")
  message("Vous pouvez toujours utiliser le package localement avec:")
  message("devtools::load_all(\".\")")
}

# Enregistrer les informations d'installation dans un log
cat(paste("Tentative d'installation:", Sys.time(), "\n"), 
    file = "install_log.txt", append = TRUE)