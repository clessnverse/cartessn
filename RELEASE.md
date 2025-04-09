# Guide de préparation pour la publication du package

## Liste de vérification avant publication

Avant de publier une nouvelle version du package, vérifiez les points suivants :

### 1. Documentation

- [ ] Vérifier que la documentation de toutes les fonctions exportées est à jour
- [ ] Vérifier que le fichier README.md est à jour
- [ ] Mettre à jour le numéro de version dans le fichier DESCRIPTION

### 2. Tests

- [ ] Exécuter tous les tests unitaires
  ```r
  devtools::test()
  ```
- [ ] Vérifier que le package passe les vérifications R CMD check
  ```r
  devtools::check()
  ```

### 3. Construction du package

- [ ] Nettoyer le répertoire de travail
  ```r
  devtools::clean_vignettes()
  ```
- [ ] Reconstruire la documentation
  ```r
  devtools::document()
  ```
- [ ] Créer l'archive du package
  ```r
  devtools::build()
  ```

## Préparation d'une archive d'installation

Pour faciliter l'installation par les utilisateurs sans accès à GitHub, créez une archive :

```r
source("inst/installer/create_package_archive.R")
```

Cela créera une archive `.tar.gz` dans le répertoire `dist/`, ainsi qu'un script `install_local.R` pour installer facilement le package.

## Problèmes d'installation courants

Si les utilisateurs rencontrent des problèmes avec `remotes::install_github()` :

1. Vérifier que l'accès Internet n'est pas bloqué par un proxy ou un pare-feu
2. Essayer différentes méthodes de téléchargement :
   ```r
   options(download.file.method = "libcurl")  # ou "wget", "curl"
   ```
3. Utiliser l'installation depuis une archive locale :
   ```r
   install.packages("chemin/vers/cartessn_x.y.z.tar.gz", repos = NULL, type="source")
   ```
4. Utiliser le script d'installation fourni dans `inst/installer/install_from_github.R`