# Script d'installation du package cartessn depuis GitHub
# Avec diagnostics et solutions alternatives

# Vérifier les prérequis
cat("Vérification des prérequis...\n")
r_version <- paste0(R.version$major, ".", R.version$minor)
cat("Version de R:", r_version, "\n")

# Installer remotes si nécessaire
if (!requireNamespace("remotes", quietly = TRUE)) {
  cat("Installation du package 'remotes'...\n")
  install.packages("remotes")
}

# Liste des méthodes de téléchargement disponibles
dl_methods <- c("auto", "internal", "libcurl", "wget", "curl")
avail_methods <- c()

# Vérifier quelles méthodes sont disponibles sur ce système
for (method in dl_methods) {
  tryCatch({
    options(download.file.method = method)
    temp_file <- tempfile()
    download.file("https://cloud.r-project.org", temp_file, quiet = TRUE)
    if (file.exists(temp_file)) {
      avail_methods <- c(avail_methods, method)
      unlink(temp_file)
    }
  }, error = function(e) {
    cat("Méthode", method, "non disponible\n")
  })
}

cat("Méthodes de téléchargement disponibles:", paste(avail_methods, collapse=", "), "\n")

# Fonction pour tester l'installation avec une méthode spécifique
try_install <- function(method = NULL) {
  if (!is.null(method)) {
    cat("\nEssai avec la méthode:", method, "\n")
    options(download.file.method = method)
  } else {
    cat("\nEssai avec la méthode par défaut\n")
  }
  
  # S'assurer que devtools est disponible
  if (!requireNamespace("devtools", quietly = TRUE)) {
    cat("Installation du package 'devtools'...\n")
    install.packages("devtools")
  }
  
  tryCatch({
    # Essayer avec remotes d'abord
    remotes::install_github("clessnverse/cartessn", 
                           dependencies = TRUE,
                           force = TRUE,
                           upgrade = "never",
                           quiet = FALSE)
    return(TRUE)
  }, error = function(e) {
    cat("Échec avec remotes:", conditionMessage(e), "\n")
    
    # Si remotes échoue, essayer avec devtools
    tryCatch({
      cat("Tentative avec devtools...\n")
      devtools::install_github("clessnverse/cartessn",
                               dependencies = TRUE,
                               force = TRUE,
                               upgrade = "never")
      return(TRUE)
    }, error = function(e2) {
      cat("Échec avec devtools:", conditionMessage(e2), "\n")
      return(FALSE)
    })
  })
}

# Essai 1: Méthode par défaut
cat("\nTentative d'installation depuis GitHub...\n")
success <- try_install()

# Si l'installation a échoué, essayer d'autres méthodes
if (!success) {
  for (method in avail_methods) {
    success <- try_install(method)
    if (success) break
  }
}

# Vérification finale
if (requireNamespace("cartessn", quietly = TRUE)) {
  cat("\nInstallation réussie! Vous pouvez maintenant utiliser le package.\n")
  cat("Pour charger le package: library(cartessn)\n")
} else {
  cat("\nÉchec de l'installation depuis GitHub.\n")
  cat("Conseils de dépannage:\n")
  cat("1. Vérifiez votre connexion Internet\n")
  cat("2. Vérifiez les permissions de votre compte GitHub\n")
  cat("3. Essayez d'installer depuis une archive locale:\n")
  cat("   - Téléchargez l'archive du package depuis la page releases\n")
  cat("   - Exécutez: install.packages('chemin/vers/archive.tar.gz', repos = NULL, type = 'source')\n")
  cat("4. Clonez le dépôt et installez localement:\n")
  cat("   - git clone https://github.com/clessnverse/cartessn.git\n")
  cat("   - Dans R: devtools::install('chemin/vers/cartessn')\n")
}