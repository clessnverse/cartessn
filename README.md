# cartessn - Package pour la cartographie électorale canadienne

Package R pour la cartographie électorale canadienne développé par le [CLESSN](https://www.clessn.com/) (Chaire de leadership en enseignement des sciences sociales numériques).

## Structure du package

Le package `cartessn` est organisé comme suit :

### Données spatiales
- `spatial_canada_2013_electoral_ridings`: Circonscriptions électorales canadiennes de 2013
- `spatial_canada_2022_electoral_ridings`: Circonscriptions électorales canadiennes de 2022
- `spatial_canada_2022_electoral_ridings_aligned`: Circonscriptions électorales de 2022 alignées avec les frontières provinciales
- `spatial_canada_2021_rta`: Régions de tri d'acheminement (RTA) canadiennes de 2021
- `spatial_canada_provinces_simple`: Frontières provinciales simplifiées

### Données nominatives
- `names_canada_2013_electoral_ridings`: Noms des circonscriptions électorales de 2013
- `names_canada_2022_electoral_ridings`: Noms des circonscriptions électorales de 2022

### Fonctions de cartographie
- `crop_map()`: Extrait et recadre une carte pour une région/ville spécifique
- `create_map()`: Crée une carte thématique personnalisable à partir des données électorales
- `create_multi_panel_map()`: Crée des cartes multi-panneaux pour comparer plusieurs régions

### Fonctions d'analyse spatiale
- `intersect_spatial_objects()`: Calcule l'intersection entre deux objets spatiaux et les proportions de couverture

## Installation

```r
# Installer depuis GitHub
devtools::install_github("clessn/cartessn")
```

## Exemples d'utilisation

### Afficher une carte des circonscriptions électorales d'une ville

```r
library(cartessn)
library(ggplot2)

# Charger les données des circonscriptions
data_ridings <- cartessn::spatial_canada_2022_electoral_ridings_aligned

# Extraire la carte de Québec
quebec_map <- crop_map(data_ridings, "quebec_city")

# Créer une carte simple
create_map(quebec_map, 
           title = "Circonscriptions électorales de Québec",
           background = "dark")
```

### Créer une carte thématique avec des données

```r
# Ajouter des données fictives pour la démonstration
data_ridings$value <- runif(nrow(data_ridings), 0, 100)

# Créer une carte thématique pour Montréal
montreal_map <- crop_map(data_ridings, "montreal")

create_map(montreal_map,
           value_column = "value",
           title = "Exemple de carte thématique",
           subtitle = "Région de Montréal",
           caption = "Source: Données fictives",
           legend_title = "Valeur",
           fill_color = c("#ffffcc", "#a1dab4", "#41b6c4", "#225ea8"),
           background = "light")
```

### Comparer plusieurs régions

```r
# Créer une carte multi-panneaux pour comparer plusieurs villes
create_multi_panel_map(
  data_ridings,
  regions = c("quebec_city", "montreal", "toronto", "vancouver"),
  value_column = "value",
  title = "Comparaison des grandes villes canadiennes",
  background = "dark",
  ncol = 2
)
```

## Organisation du code

### Dossier `R/`
Contient les fonctions exportées du package :
- `cropping_canada.R` : Définition des régions et fonction `crop_map()`
- `utils.R` : Utilitaires comme `intersect_spatial_objects()`
- `map_visualization.R` : Fonctions de visualisation comme `create_map()` et `create_multi_panel_map()`
- Autres fichiers pour l'accès aux données spatiales et nominatives

### Dossier `data-raw/`
Le dossier `data-raw` contient les scripts qui permettent de préparer les données utilisées dans ce package comme les shapefiles. Les sous-dossiers à la racine du dossier `data-raw` font référence aux éditions de découpages des circonscriptions. Par exemple, le sous-dossier `data-raw/canada_2022_electoral_ridings` contient les scripts qui préparent les données du redécoupage électoral fédéral de 2022.

Les données intermédiaires qui ne sont pas nécessaires à l'utilisation du package sont stockées dans le dossier `data` à l'intérieur de `data-raw`. Ce dossier est exclu du package par le fichier `.gitignore` et peut être entièrement généré grâce aux scripts dans `data-raw`.

Le fichier `align_electoral_ridings.R` contient le code permettant d'aligner les circonscriptions électorales avec les frontières provinciales.

### Dossier `data/`
Contient les fichiers de données inclus dans le package (fichiers .rda).
