# Script rapide pour afficher toutes les circonscriptions
# (à exécuter directement dans la console)

library(sf)
library(ggplot2)

# Charger les circonscriptions électorales alignées
load("data/spatial_canada_2022_electoral_ridings_aligned.rda")
# Maintenant vous avez l'objet "spatial_canada_2022_electoral_ridings_aligned" dans votre environnement

# Pour les provinces, utilisez l'une de ces méthodes :

# OPTION 1 : Si vous avez le fichier .rda des provinces comme dans votre script original
load("data/spatial_canada_provinces_simple.rda")
provinces_shp <- provinces_simple  # Utiliser directement l'objet chargé

# OPTION 2 : Si vous devez utiliser le shapefile, corrigez le chemin
# provinces_shp <- sf::st_read("/chemin/correct/vers/provinces/lpr_000b21a_f.shp", quiet = TRUE)

# Maintenant vous pouvez transformer
common_crs <- st_crs(spatial_canada_2022_electoral_ridings_aligned)
provinces_shp <- st_transform(provinces_shp, common_crs)

# Simplifier les provinces pour la performance
provinces_simple <- st_simplify(provinces_shp, preserveTopology = TRUE, dTolerance = 100)

# Vérifier combien de circonscriptions sont valides
valid_count <- sum(!st_is_empty(spatial_canada_2022_electoral_ridings_aligned$geometry))
cat("Nombre de circonscriptions avec géométrie valide:", valid_count, "/", 
    nrow(spatial_canada_2022_electoral_ridings_aligned), "\n")


# Créer un thème personnalisé inspiré de la carte partagée
theme_dark_map <- function() {
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "#1a1a1a", color = NA),
    panel.background = element_rect(fill = "#1a1a1a", color = NA),
    plot.title = element_text(color = "white", size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(color = "#cccccc", size = 12, hjust = 0.5),
    plot.caption = element_text(color = "#999999", size = 8),
    panel.grid = element_blank(),
    axis.text = element_text(color = "#999999"),
    axis.title = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(color = "white"),
    legend.title = element_text(color = "white")
  )
}

# Créer la carte avec l'esthétique demandée
map_stylized <- ggplot() +
  # Provinces en gris clair
  geom_sf(data = provinces_simple, fill = "#666666", color = "#333333", size = 0.2) +
  # Circonscriptions en blanc
  geom_sf(data = spatial_canada_2022_electoral_ridings_aligned, fill = NA, color = "#1a1a1a", size = 0.2) +
  # Appliquer le thème sombre
  theme_dark_map() +
  labs(
    title = "CIRCONSCRIPTIONS ÉLECTORALES DU CANADA",
    subtitle = paste0(valid_count, " circonscriptions"),
    caption = "Source: Données électorales 2022"
  )

# Afficher la carte
print(map_stylized)


# Sauvegarder la carte si souhaité
ggsave("data-raw/data/toutes_circonscriptions_alignees.png", map_all, width = 12, height = 10, dpi = 300)

# Script simple pour visualiser les circonscriptions électorales
# --------------------------------------------------------------

# Script pour visualiser toutes les circonscriptions individuelles
library(sf)
library(ggplot2)

# Charger les données
load("data/spatial_canada_2022_electoral_ridings_aligned.rda")

# Créer une carte montrant uniquement les contours des circonscriptions
ggplot() +
  # Tracer seulement les contours des circonscriptions avec une couleur noire
  geom_sf(data = spatial_canada_2022_electoral_ridings_aligned, 
          fill = NA,           # Pas de remplissage
          color = "black",     # Contours noirs
          size = 0.2) +        # Lignes fines
  # Titre
  labs(title = "Circonscriptions électorales du Canada - Contours") +
  # Thème simple
  theme_minimal() +
  # Enlever les éléments inutiles
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    legend.position = "none"
  )

# Sauvegarder la carte
ggsave("circonscriptions_contours.png", width = 12, height = 10, dpi = 300)

# Variante avec couleurs différentes pour chaque circonscription
# pour mieux distinguer les frontières entre circonscriptions adjacentes
ggplot() +
  geom_sf(data = spatial_canada_2022_electoral_ridings_aligned, 
          aes(fill = id_riding),  # Couleur selon l'ID de circonscription
          color = "black",        # Contours noirs
          size = 0.2,             # Lignes fines
          alpha = 0.6) +          # Semi-transparent
  scale_fill_viridis_d() +        # Palette de couleurs
  labs(title = "Circonscriptions électorales du Canada - Détails") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    legend.position = "none"      # Pas de légende (trop de circonscriptions)
  )

# Sauvegarder la deuxième carte
ggsave("circonscriptions_details.png", width = 12, height = 10, dpi = 300)