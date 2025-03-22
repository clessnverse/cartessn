#' Données de recensement structurées – RTA (Canada, 2021)
#'
#' Données sociodémographiques issues du recensement canadien de 2021, structurées par région de tri d'acheminement (RTA).
#' Chaque ligne correspond à une catégorie d'une variable dans une RTA donnée.
#'
#' @format Un data.frame avec 9 261 lignes et 5 colonnes :
#' \describe{
#'   \item{rta}{Identifiant de la RTA}
#'   \item{variable}{Nom de la variable sociodémographique (ex: `ses_age`, `ses_gender`, `ses_income`)}
#'   \item{category}{Catégorie de la variable (ex: `18_24`, `female`, `30000_to_50000`)}
#'   \item{count}{Nombre de personnes dans cette catégorie}
#'   \item{prop}{Proportion de la population de la RTA dans cette catégorie (entre 0 et 1)}
#' }
#'
#' @source Statistique Canada
"census_canada_2022_rta"
