# cartessn

## Outils de Cartographie Électorale Canadienne

Ce package fournit des outils pour manipuler et visualiser les données cartographiques des circonscriptions électorales canadiennes. Il inclut des fonctions pour extraire, recadrer et représenter visuellement les données électorales, ainsi que des ensembles de données spatiales pour les circonscriptions électorales fédérales de 2013 et 2022.

## Installation

### Installation depuis CRAN (à venir)

```r
install.packages("cartessn")
```

### Installation depuis GitHub

```r
# Option 1: Installation standard
remotes::install_github("clessnverse/cartessn")

# Option 2: Si l'option 1 échoue, essayez avec un autre download.file.method
options(download.file.method = "libcurl")
remotes::install_github("clessnverse/cartessn")

# Option 3: Installation locale si vous avez déjà cloné le dépôt
# Dans le répertoire du package
devtools::install(".")
```

### Dépendances

Le package nécessite les librairies suivantes:
- sf
- dplyr
- ggplot2
- patchwork
- rlang

## Utilisation

### Chargement du package

```r
library(cartessn)
```

### Données incluses

- `spatial_canada_2013_electoral_ridings`: Données spatiales des circonscriptions électorales fédérales de 2013
- `spatial_canada_2022_electoral_ridings`: Données spatiales des circonscriptions électorales fédérales de 2022
- `spatial_canada_2021_rta`: Données spatiales des régions de tri d'acheminement (RTA/FSA) de 2021
- `names_canada_2013_electoral_ridings`: Noms des circonscriptions électorales fédérales de 2013
- `names_canada_2022_electoral_ridings`: Noms des circonscriptions électorales fédérales de 2022

### Fonctions principales

- `create_map()`: Création de cartes électorales
- `crop_map()`: Recadrage de cartes pour se concentrer sur des régions spécifiques
- `create_multi_panel_map()`: Création de cartes à plusieurs panneaux
- `predict_spatial_target()`: Prédiction de valeurs cibles à partir de données spatiales d'origine

## Exemples

```r
# Chargement du package
library(cartessn)

# Création d'une carte de base avec les circonscriptions électorales de 2022
map <- create_map(spatial_data = spatial_canada_2022_electoral_ridings)

# Affichage de la carte
map

# Recadrage de la carte pour se concentrer sur une province spécifique (Québec)
quebec_map <- crop_map(map, province = "QC")
quebec_map
```

## Résolution de problèmes d'installation

Si vous rencontrez des problèmes lors de l'installation depuis GitHub, essayez:

1. **Mise à jour de R et des packages**:
   ```r
   update.packages(ask = FALSE)
   ```

2. **Installation de la version de développement de devtools/remotes**:
   ```r
   install.packages("devtools")
   ```

3. **Installation locale** (si vous avez cloné le dépôt):
   ```r
   devtools::install("chemin/vers/cartessn", dependencies = TRUE)
   ```

4. **Chargement temporaire** (sans installation):
   ```r
   devtools::load_all("chemin/vers/cartessn")
   ```

## Contribution

Les contributions sont les bienvenues! N'hésitez pas à ouvrir une issue ou à proposer une pull request sur [GitHub](https://github.com/clessnverse/cartessn).

## Licence

Ce package est distribué sous licence MIT.