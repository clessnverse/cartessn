#' Simuler des répondants à partir de données de recensement spatiales
#'
#' Cette fonction génère un ensemble de répondants simulés à partir des distributions
#' sociodémographiques disponibles pour une unité spatiale d'origine (`origin_unit_id`)
#' en combinant les données de recensement de cette unité et des unités cibles qu'elle recouvre,
#' pondérées selon la superficie partagée.
#'
#' @param origin_unit_id Identifiant d'une unité spatiale d'origine (ex. : "G2L" pour une RTA).
#' @param n Nombre de répondants à simuler (par défaut : 500).
#' @param spatial_intersection Data frame indiquant la proportion de chaque unité cible couverte
#'   par chaque unité d'origine. Doit contenir les colonnes `origin_id_col`, `target_id_col`,
#'   et `prop_of_ref_area_covered_by_target`.
#' @param origin_id_col Nom de la colonne contenant l'identifiant de l'unité spatiale d'origine (ex. : `"rta"`).
#' @param target_id_col Nom de la colonne contenant l'identifiant de l'unité spatiale cible (ex. : `"id_riding"`).
#' @param census_origin Données de recensement associées aux unités d'origine. Doit contenir les colonnes :
#'   `variable`, `category`, `prop`, ainsi qu’une colonne correspondant à `origin_id_col`.
#' @param census_target Données de recensement associées aux unités cibles. Doit contenir les colonnes :
#'   `variable`, `category`, `prop`, ainsi qu’une colonne correspondant à `target_id_col`.
#'
#' @return Un `tibble` contenant `n` répondants simulés avec :
#' - un identifiant unique (`id`),
#' - l’unité spatiale d’origine (`origin_id_col`),
#' - l’unité spatiale cible assignée (`target_id_col`),
#' - et les variables sociodémographiques simulées selon les distributions croisées.
#'
#' @examples
#' \dontrun{
#' simulate_respondents_from_census_unit(
#'   origin_unit_id = "G2L",
#'   n = 500,
#'   spatial_intersection = df_intersections,
#'   origin_id_col = "rta",
#'   target_id_col = "id_riding",
#'   census_origin = df_census_rta,
#'   census_target = df_census_ridings
#' )
#' }
#'
#' @export
simulate_respondents_from_census_unit <- function(
  origin_unit_id,                    # ID d'une unité spatiale d'origine (ex: "G2L")
  n = 500,                           # Nombre de répondants à simuler
  spatial_intersection,             # Table avec les recouvrements spatiaux (ex: df_intersections)
  origin_id_col = "origin",         # Nom de la colonne d'identifiant de l'unité d'origine
  target_id_col = "target",         # Nom de la colonne d'identifiant de l'unité cible
  census_origin,                    # Recensement par unité d'origine
  census_target                     # Recensement par unité cible
) {
  # --- Vérifications ---
  required_cols <- c("variable", "category", "prop")
  if (!all(required_cols %in% names(census_origin)))
    stop("`census_origin` doit contenir les colonnes : variable, category, prop")
  if (!all(required_cols %in% names(census_target)))
    stop("`census_target` doit contenir les colonnes : variable, category, prop")
  if (!all(c(origin_id_col, target_id_col, "prop_of_ref_area_covered_by_target") %in% names(spatial_intersection)))
    stop("`spatial_intersection` doit contenir les colonnes : origin_id_col, target_id_col, prop_of_ref_area_covered_by_target")

  message("Étape 1 — Pondération des " , target_id_col, " selon la couverture spatiale...")

  target_weights <- spatial_intersection %>%
    filter(.data[[origin_id_col]] == origin_unit_id) %>%
    select(!!sym(target_id_col), prop_of_ref_area_covered_by_target) %>%
    tibble::deframe()

  if (length(target_weights) == 0)
    stop("Aucune unité cible trouvée pour l'unité d'origine spécifiée.")

  message("Étape 2 — Attribution des ", target_id_col, " aux répondants simulés...")

  assigned_targets <- sample(
    names(target_weights),
    size = n,
    replace = TRUE,
    prob = target_weights
  )

  message("Étape 3 — Fusion des distributions du recensement entre les ", origin_id_col, " et les ", target_id_col, "...")

  census_origin_sub <- census_origin %>%
    filter(.data[[origin_id_col]] == origin_unit_id)

  census_target_sub <- census_target %>%
    filter(.data[[target_id_col]] %in% names(target_weights))

  census_combined <- full_join(
    census_origin_sub %>%
      select(variable, category, prop_origin = prop),
    census_target_sub %>%
      select(!!sym(target_id_col), variable, category, prop_target = prop),
    by = c("variable", "category")
  ) %>%
    mutate(
      weight_target = target_weights[as.character(.data[[target_id_col]])],
      prop_adj = (1 - weight_target) * prop_origin + weight_target * prop_target
    )

  message("Étape 4 — Simulation des caractéristiques sociodémographiques des répondants simulés...")

  respondents <- tibble(
    id = 1:n,
    !!origin_id_col := origin_unit_id,
    !!target_id_col := assigned_targets
  )

  ses_vars <- unique(census_combined$variable)

  for (var in ses_vars) {
    dist_var <- census_combined %>%
      filter(variable == var) %>%
      select(!!sym(target_id_col), category, prop = prop_adj)

    respondents[[var]] <- purrr::map_chr(respondents[[target_id_col]], function(target_val) {
      dist_r <- dist_var %>% filter(.data[[target_id_col]] == target_val)
      sample(dist_r$category, size = 1, prob = dist_r$prop)
    })
  }

  message("✓ Simulation terminée.")

  return(respondents)
}
