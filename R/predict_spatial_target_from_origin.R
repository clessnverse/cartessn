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


#' Simuler des répondants selon les distributions du recensement et la géographie intersectionnelle
#'
#' Cette fonction génère des données simulées ou des prédictions uniques par unité spatiale d'origine (`origin_col`),
#' selon le nombre de cibles (`target_col`) qui lui sont associées. Elle retourne un objet contenant les cas,
#' les prédictions uniques (si une seule cible), et les jeux de données simulés (si plusieurs).
#'
#' @param census_origin Données de recensement agrégées par unité spatiale d'origine, au format long
#' (`variable`, `category`, `count`, `prop`).
#' @param census_target Données de recensement agrégées par unité spatiale cible, au même format que `census_origin`.
#' @param spatial_intersection Table des intersections spatiales produite par
#' `cartessn::intersect_spatial_objects()`.
#' @param origin_col Nom de la colonne identifiant l’unité spatiale d’origine (ex. `"rta"`).
#' @param target_col Nom de la colonne identifiant l’unité spatiale cible (ex. `"id_riding"`).
#' @param n_sim Nombre de répondants à simuler par unité spatiale d'origine.
#' @param origins (Optionnel) Vecteur de noms/id des unités spatiales d'origine à traiter. Si `NULL`, toutes sont utilisées.
#'
#' @return Une liste contenant :
#' \describe{
#'   \item{cases}{Vecteur nommé identifiant les cas : 1 (une seule cible), 2 (plusieurs).}
#'   \item{unique_predictions}{Liste nommée de vecteurs de probabilité (valeur 1) pour les cas à une seule cible.}
#'   \item{simulated_datasets}{Liste nommée de jeux de données simulés pour les cas à plusieurs cibles.}
#' }
#'
#' @importFrom dplyr group_by summarise mutate filter pull
#' @importFrom tibble deframe
#' @export
prepare_simulations <- function(
  census_origin, census_target,
  spatial_intersection,
  origin_col, target_col,
  n_sim = 500,
  origins = NULL
) {
  message("Simuler ", n_sim, " répondants par `", origin_col, "`...")
  rta_cases <- spatial_intersection |>
    dplyr::group_by(.data[[origin_col]]) |>
    dplyr::summarise(case = dplyr::n(), .groups = "drop") |>
    dplyr::mutate(case = ifelse(case > 1, 2, 1)) |>
    tibble::deframe()

  if (!is.null(origins)) {
    rta_cases <- rta_cases[names(rta_cases) %in% origins]
  }

  unique_predictions <- list()
  simulated_datasets <- list()

  total <- length(rta_cases)

  for (i in seq_along(rta_cases)) {
    origin_id <- names(rta_cases)[i]
    case_i <- rta_cases[[i]]

    if (case_i == 1) {
      target_id <- spatial_intersection |>
        dplyr::filter(.data[[origin_col]] == origin_id) |>
        dplyr::pull(.data[[target_col]]) |>
        unique()
      unique_predictions[[origin_id]] <- setNames(1, target_id)
    } else {
      simulated_data <- suppressMessages(
        cartessn::simulate_respondents_from_census_unit(
          origin_unit_id = origin_id,
          n = n_sim,
          spatial_intersection = spatial_intersection,
          origin_id_col = origin_col,
          target_id_col = target_col,
          census_origin = census_origin,
          census_target = census_target
        )
      )
      simulated_datasets[[origin_id]] <- simulated_data
    }

    pct <- floor(i / total * 100)
    cat(sprintf("\r         Progression: %3d%% — %s", pct, origin_id))
    flush.console()
  }

  cat("\n")

  list(
    cases = rta_cases,
    unique_predictions = unique_predictions,
    simulated_datasets = simulated_datasets
  )
}


#' Prédire une unité spatiale cible à partir d'unité d'origine et de variables SES
#'
#' Cette fonction entraîne un modèle multinomial pour chaque unité d'origine à partir de données simulées
#' (ou applique une correspondance unique si l'unité n'est liée qu'à une seule cible).
#' Elle retourne soit une matrice de probabilités, soit un vecteur des classes les plus probables.
#'
#' @param survey_data Données du sondage. Doit contenir uniquement `origin_col` et les variables listées dans `ses_vars`.
#' @param origin_col Nom de la colonne dans `survey_data` identifiant l’unité spatiale d’origine (ex: `"rta"`).
#' @param target_col Nom de l’unité spatiale à prédire (ex: `"id_riding"`).
#' @param ses_vars Vecteur de noms de variables SES présentes dans `survey_data` et dans les colonnes `variable` des recensements.
#' @param census_origin Données de recensement par unité d'origine. Format long avec colonnes `variable`, `category`, `count`, `prop`.
#' @param census_target Données de recensement par unité cible. Même format que `census_origin`.
#' @param spatial_origin Objet `sf` représentant les unités spatiales d’origine (ex: RTAs).
#' @param spatial_target Objet `sf` représentant les unités spatiales cibles (ex: circonscriptions).
#' @param return_type Type de sortie : `"probabilities"` (matrice avec une colonne par cible) ou `"class"` (vecteur des classes les plus probables).
#' @param n_sim Nombre de répondants à simuler par unité d'origine.
#'
#' @details
#' Cette fonction effectue plusieurs validations :
#' \itemize{
#'   \item `survey_data` ne doit contenir que `origin_col` et les variables spécifiées dans `ses_vars`.
#'   \item Les recensements doivent être au format long avec les colonnes : `variable`, `category`, `count`, `prop`.
#'   \item Toutes les SES doivent apparaître dans les colonnes `variable` des deux recensements.
#'   \item Toutes les catégories présentes dans `survey_data` doivent être présentes dans les recensements.
#'   \item Le nombre d'unités spatiales dans les objets `sf` doit correspondre à celui dans les recensements.
#' }
#'
#' @return
#' Un `data.frame` avec une ligne par répondant :
#' \itemize{
#'   \item Si `return_type = "probabilities"` : une matrice de probabilités (1 ligne x N cibles).
#'   \item Si `return_type = "class"` : un vecteur de classes (`target_col`) avec la classe la plus probable.
#' }
#'
#' @importFrom dplyr filter mutate select pull where group_by summarise n across
#' @importFrom tidyr replace_na
#' @importFrom nnet multinom
#' @importFrom stats predict setNames
#' @importFrom tibble deframe
#' @export
predict_spatial_target <- function(
  survey_data,
  origin_col = "rta",
  target_col = "id_riding",
  ses_vars,
  census_origin,
  census_target,
  spatial_origin,
  spatial_target,
  return_type = c("probabilities", "class"),
  n_sim = 500
) {
  message("Validation des arguments de la fonction...")
  return_type <- match.arg(return_type)

  # Vérifications
  expected_vars <- c(origin_col, ses_vars)
  extra_vars <- setdiff(names(survey_data), expected_vars)
  if (length(extra_vars) > 0) {
    stop(
      "`survey_data` ne devrait contenir que la colonne d'origine (`", origin_col, "`) et les variables SES dans `ses_vars`.\n",
      "Variables supplémentaires détectées :\n  → ",
      paste(extra_vars, collapse = "\n  → ")
    )
  }

  missing_ses <- setdiff(ses_vars, names(survey_data))
  if (length(missing_ses) > 0) {
    stop(
      "Certaines variables dans `ses_vars` ne sont pas présentes dans `survey_data` : ",
      paste(missing_ses, collapse = ", ")
    )
  }

  required_cols <- c("variable", "category", "count", "prop")
  check_census_format <- function(census_df, name) {
    missing_cols <- setdiff(required_cols, names(census_df))
    if (length(missing_cols) > 0) {
      stop(
        "Le jeu de données `", name, "` n'est pas dans le bon format.\n",
        "Colonnes manquantes : ", paste(missing_cols, collapse = ", "), "\n",
        "Référez-vous au format de `cartessn::census_canada_2022_electoral_ridings`."
      )
    }
  }

  check_census_format(census_origin, "census_origin")
  check_census_format(census_target, "census_target")

  missing_origin <- setdiff(ses_vars, unique(census_origin$variable))
  missing_target <- setdiff(ses_vars, unique(census_target$variable))
  if (length(missing_origin) > 0 || length(missing_target) > 0) {
    stop(
      "Certaines variables SES dans `ses_vars` sont absentes dans la colonne `variable` des recensements :\n",
      if (length(missing_origin) > 0)
        paste0("- Dans `census_origin` : ", paste(missing_origin, collapse = ", "), "\n"),
      if (length(missing_target) > 0)
        paste0("- Dans `census_target` : ", paste(missing_target, collapse = ", "))
    )
  }

  # Vérifie les catégories SES entre survey_data et census
  missing_entries <- list()
  for (var in ses_vars) {
    survey_categories <- unique(survey_data[[var]]) |> na.omit()
    origin_categories <- census_origin |> dplyr::filter(variable == var) |> dplyr::pull(category) |> unique()
    target_categories <- census_target |> dplyr::filter(variable == var) |> dplyr::pull(category) |> unique()
    missing_in_origin <- setdiff(survey_categories, origin_categories)
    missing_in_target <- setdiff(survey_categories, target_categories)

    if (length(missing_in_origin) > 0) {
      missing_entries <- c(missing_entries, lapply(missing_in_origin, \(cat) c("census_origin", var, cat)))
    }
    if (length(missing_in_target) > 0) {
      missing_entries <- c(missing_entries, lapply(missing_in_target, \(cat) c("census_target", var, cat)))
    }
  }

  if (length(missing_entries) > 0) {
    missing_msg <- vapply(missing_entries, paste, character(1), collapse = " → ")
    stop(
      "Certaines catégories observées dans `survey_data` sont absentes du recensement :\n",
      paste(missing_msg, collapse = "\n")
    )
  }

  message("Calculer les intersections géographiques entre `", origin_col, "` et `", target_col, "`...")
  spatial_intersection <- suppressWarnings(
    cartessn::intersect_spatial_objects(
      spatial_ref = spatial_origin,
      id_ref = origin_col,
      spatial_target = spatial_target,
      id_target = target_col
    )
  )

  sim_result <- prepare_simulations(
    census_origin = census_origin,
    census_target = census_target,
    spatial_intersection = spatial_intersection,
    origin_col = origin_col,
    target_col = target_col,
    n_sim = n_sim,
    origins = unique(survey_data[[origin_col]])
  )

  cases <- sim_result$cases
  unique_predictions <- sim_result$unique_predictions
  simulated_datasets <- sim_result$simulated_datasets
  list_predictions <- vector("list", nrow(survey_data))

  message("Entrainement et prédiction des modèles sur chaque rangée de `survey_data`...")
  total <- nrow(survey_data)

  for (i in seq_len(total)) {
    origin_id <- survey_data[[origin_col]][i]
    case_i <- tryCatch(cases[[origin_id]], error = function(e) NA)

    if (is.na(case_i)) {
      preds <- stats::setNames(rep(0, length(unique(spatial_target[[target_col]]))),
                               sort(unique(spatial_target[[target_col]])))
    } else if (case_i == 1) {
      preds <- unique_predictions[[origin_id]]
    } else {
      non_empty_vars <- survey_data[i, ses_vars] |>
        dplyr::select(dplyr::where(~ !is.na(.))) |>
        names()
    
      model <- suppressMessages(
        nnet::multinom(
          formula = paste0(target_col, " ~ ", paste0(non_empty_vars, collapse = " + ")),
          data = simulated_datasets[[origin_id]],
          trace = FALSE
        )
      )
    
      preds <- stats::predict(model, newdata = survey_data[i, ], type = "prob")
    
      if (length(model$lev) == 2) {
        preds <- stats::setNames(
          c(1 - preds, preds),
          model$lev
        )
      }
    }

    list_predictions[[i]] <- round(preds, 2)
    pct <- floor(i / total * 100)
    cat(sprintf("\r         Progression: %3d%%", pct))
    flush.console()
  }

  df_predictions <- dplyr::bind_rows(list_predictions) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), ~ tidyr::replace_na(.x, 0)))

  if (return_type == "class") {
    return(df_predictions %>%
      dplyr::mutate(.prediction = ifelse(rowSums(df_predictions) == 0, NA, names(.)[max.col(.)])) |>
      dplyr::pull(.prediction))
  }

  return(df_predictions)
}





