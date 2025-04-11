# Installation locale du package cartessn
# Script résolvant les problèmes de connectivité à GitHub

# Configuration initiale - utilisation du chemin de librairie par défaut
# Augmenter le timeout et ajuster les paramètres réseau
options(timeout = 600)  # 10 minutes
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Installation des dépendances essentielles de manière robuste
needed_packages <- c("devtools", "remotes", "sf", "dplyr", "ggplot2", "patchwork", "rlang")
for (pkg in needed_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    tryCatch({
      install.packages(pkg)
    }, error = function(e) {
      message("Échec d'installation de ", pkg, ": ", e$message)
    })
  }
}

# Charger les librairies si disponibles
for (pkg in c("devtools", "remotes")) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    library(pkg, character.only = TRUE)
  } else {
    message("ATTENTION: Package ", pkg, " non disponible. L'installation pourrait échouer.")
  }
}

# Informations sur l'environnement
message("Informations système:")
message("- R version: ", R.version.string)
message("- Plateforme: ", Sys.info()["sysname"], " ", Sys.info()["release"])
message("- Répertoire de travail: ", getwd())

# SOLUTION ALTERNATIVE: Installation directe depuis le dépôt local
message("\nUTILISATION DU DÉPÔT LOCAL...")

# 1. Installation directe du dépôt local (option la plus fiable)
tryCatch({
  message("Installation du dépôt local...")
  # Utiliser pkgbuild directement si disponible
  if (requireNamespace("pkgbuild", quietly = TRUE)) {
    pkgbuild::build(".", dest_path = tempdir())
    pkg_path <- list.files(tempdir(), pattern = "\\.tar\\.gz$", full.names = TRUE)[1]
    if (!is.na(pkg_path)) {
      install.packages(pkg_path, repos = NULL, type = "source")
      message("Installation réussie depuis le fichier compilé localement!")
      quit(save = "no", status = 0)
    }
  }
  
  # Utiliser devtools comme alternative
  if (file.exists("NAMESPACE") && file.exists("DESCRIPTION")) {
    devtools::install(".", 
                     dependencies = TRUE, 
                     upgrade = "never",
                     force = TRUE, 
                     build = TRUE,
                     build_vignettes = FALSE)
  } else {
    message("Package incomplet - NAMESPACE ou DESCRIPTION manquant")
    return(FALSE)
  }
  message("Installation locale réussie!")
  quit(save = "no", status = 0)
}, error = function(e) {
  message("Erreur lors de l'installation locale: ", e$message)
})

# 2. Utilisation de load_all comme alternative si l'installation échoue
message("\nSOLUTION DE SECOURS - CHARGEMENT TEMPORAIRE:")
message("L'installation a échoué. Vous pouvez utiliser le package en le chargeant directement:")
message("library(devtools)")
message("devtools::load_all(\".\")")
message("\nLa commande ci-dessus chargera temporairement le package sans l'installer.")

# 3. Tentative GitHub uniquement si demandée explicitement
message("\nSi vous souhaitez essayer l'installation GitHub avec un token:")
message("remotes::install_github('clessnverse/cartessn', auth_token = 'VOTRE_TOKEN_GITHUB')")

# Enregistrer le diagnostic dans un fichier
cat(paste("Tentative d'installation:", Sys.time(), "- R", R.version.string, "\n"), 
    file = "install_log.txt", append = TRUE)