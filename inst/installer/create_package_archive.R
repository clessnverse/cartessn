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

# Obtenir le répertoire du script
script_dir <- dirname(parent.frame(2)$ofile)
if (script_dir == ".") {
  script_dir <- getwd()
}

# Remonter au répertoire du package (si le script est dans inst/installer)
package_dir <- dirname(dirname(script_dir))
if (basename(dirname(script_dir)) != "inst") {
  package_dir <- script_dir
}

# Vérifier que nous sommes dans le répertoire d'un package R
if (!file.exists(file.path(package_dir, "DESCRIPTION"))) {
  stop("Impossible de trouver le fichier DESCRIPTION. Assurez-vous d'être dans le répertoire du package.")
}

# Définir le répertoire de sortie pour l'archive
output_dir <- file.path(package_dir, "dist")
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Créer l'archive du package
message("Création de l'archive du package...")
pkg_file <- pkgbuild::build(package_dir, dest_path = output_dir)

# Vérifier que l'archive a été créée
if (file.exists(pkg_file)) {
  message("Archive créée avec succès: ", pkg_file)
  message("\nPour installer le package à partir de cette archive, utilisez:")
  message("install.packages('", pkg_file, "', repos = NULL, type = 'source')")
  
  # Créer un script d'installation
  install_script <- file.path(output_dir, "install_local.R")
  cat(paste0("# Script d'installation pour cartessn\n",
            "install.packages('", pkg_file, "', repos = NULL, type = 'source')\n"),
      file = install_script)
  
  message("\nUn script d'installation a été créé: ", install_script)
} else {
  message("Échec de la création de l'archive.")
}