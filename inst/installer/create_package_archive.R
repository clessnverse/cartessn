# Script pour créer une archive du package qui pourra être installée localement

# Charger les packages nécessaires
if (!requireNamespace("pkgbuild", quietly = TRUE)) {
  install.packages("pkgbuild")
}
if (!requireNamespace("utils", quietly = TRUE)) {
  install.packages("utils")
}

library(pkgbuild)
library(utils)

# Déterminer le répertoire du package
package_dir <- getwd()
if (basename(package_dir) != "cartessn") {
  if (dirname(package_dir) == "installer" && basename(dirname(dirname(package_dir))) == "cartessn") {
    package_dir <- dirname(dirname(package_dir))  # Si dans inst/installer
  } else if (basename(dirname(package_dir)) == "cartessn") {
    package_dir <- dirname(package_dir)  # Si dans un sous-répertoire
  }
}

# Vérifier que nous sommes dans le répertoire d'un package R
if (!file.exists(file.path(package_dir, "DESCRIPTION"))) {
  stop("Impossible de trouver le fichier DESCRIPTION. Exécutez ce script depuis le répertoire du package.")
}

cat("Répertoire du package:", package_dir, "\n")

# Définir le répertoire de sortie pour l'archive
output_dir <- file.path(package_dir, "dist")
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Créer l'archive du package
cat("Création de l'archive du package...\n")
pkg_file <- pkgbuild::build(package_dir, dest_path = output_dir)

# Vérifier que l'archive a été créée
if (file.exists(pkg_file)) {
  cat("Archive créée avec succès:", pkg_file, "\n")
  cat("\nPour installer le package à partir de cette archive, utilisez:\n")
  cat("install.packages('", pkg_file, "', repos = NULL, type = 'source')\n", sep="")
  
  # Créer un script d'installation
  install_script <- file.path(output_dir, "install_local.R")
  cat(paste0("# Script d'installation pour cartessn\n",
            "install.packages('", pkg_file, "', repos = NULL, type = 'source')\n"),
      file = install_script)
  
  cat("\nUn script d'installation a été créé:", install_script, "\n")
} else {
  cat("Échec de la création de l'archive.\n")
}