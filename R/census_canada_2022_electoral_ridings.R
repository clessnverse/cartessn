#' Données de recensement structurées – Circonscriptions électorales fédérales (Canada, 2022)
#'
#' Données sociodémographiques issues du recensement canadien de 2021, structurées par circonscription électorale fédérale
#' selon le redécoupage de 2022. Chaque ligne correspond à une catégorie d'une variable dans une circonscription donnée.
#'
#' @format Un data.frame avec 9 261 lignes et 5 colonnes :
#' \describe{
#'   \item{id_riding}{Identifiant numérique de la circonscription électorale fédérale}
#'   \item{variable}{Nom de la variable sociodémographique (ex: `ses_age`, `ses_gender`, `ses_income`)}
#'   \item{category}{Catégorie de la variable (ex: `18_24`, `female`, `30000_to_50000`)}
#'   \item{count}{Nombre de personnes dans cette catégorie}
#'   \item{prop}{Proportion de la population de la circonscription dans cette catégorie (entre 0 et 1)}
#' }
#'
#' @source Statistique Canada
"census_canada_2022_electoral_ridings"
