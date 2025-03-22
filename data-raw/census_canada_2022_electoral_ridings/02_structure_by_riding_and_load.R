library(dplyr)

df_raw <- read.csv("data-raw/data/census_canada_2022_electoral_ridings/98-401-X2021029_English_CSV_data.csv", 
                 fileEncoding = "latin1") |>
  filter(GEO_LEVEL == "Federal electoral district (2023 Representation Order)")

# Name each characteristic ID --------------------------------------------

characteristics_names <- c(
  "14" = "ses_age.18_19",
  "15" = "ses_age.20_24",
  "16" = "ses_age.25_29",
  "17" = "ses_age.30_34",
  "18" = "ses_age.35_39",
  "19" = "ses_age.40_44",
  "20" = "ses_age.45_49",
  "21" = "ses_age.50_54",
  "22" = "ses_age.55_59",
  "23" = "ses_age.60_64",
  "25" = "ses_age.65_69",
  "26" = "ses_age.70_74",
  "27" = "ses_age.75_79",
  "28" = "ses_age.80_84",
  "30" = "ses_age.85_89",
  "31" = "ses_age.90_94",
  "32" = "ses_age.95_99",
  "33" = "ses_age.100+",
  "156" = "ses_income.no_income",
  "158" = "ses_income.1_to_30000",
  "159" = "ses_income.1_to_30000",
  "160" = "ses_income.1_to_30000",
  "161" = "ses_income.30001_to_60000",
  "162" = "ses_income.30001_to_60000",
  "163" = "ses_income.30001_to_60000",
  "164" = "ses_income.60001_to_90000",
  "165" = "ses_income.60001_to_90000",
  "166" = "ses_income.60001_to_90000",
  "167" = "ses_income.90001_to_110000",
  "169" = "ses_income.110001_to_150000",
  "170" = "ses_income.more_than_150000"
)

## education
## langue
## religion
## densité de population
## owner/locataire
## ménage, enfants
## occupation
## ethnicité
## immigrant
## type de logement


# Structure data ----------------------------------------------------------

df_gender <- df_raw |>
  filter(CHARACTERISTIC_ID == 8) |>
  select(
    id_riding = ALT_GEO_CODE,
    ses_gender.male = `C2_COUNT_MEN.`,
    ses_gender.female = `C3_COUNT_WOMEN.`
  ) |> 
  tidyr::pivot_longer(
    cols = c(ses_gender.male, ses_gender.female),
    names_to = "charac",
    values_to = "count"
  ) |> 
  tidyr::separate(
    col = "charac", into = c("variable", "category"), sep = "\\."
  )

census_canada_2022_electoral_ridings <- df_raw |> 
  filter(
    CHARACTERISTIC_ID %in% names(characteristics_names)
  ) |>
  mutate(
    charac = characteristics_names[as.character(CHARACTERISTIC_ID)]
  ) |> 
  tidyr::separate(
    col = "charac", into = c("variable", "category"), sep = "\\."
  ) |> 
  select(
    id_riding = ALT_GEO_CODE,
    variable,
    category,
    count = C1_COUNT_TOTAL
  ) %>% 
  ## add the gender df
  rbind(., df_gender) |> 
  arrange(id_riding, variable, category) |>
  group_by(
    id_riding, variable, category
  ) |> 
  ## when one category is across many characteristics ids
  summarise(
    count = sum(count)
  ) |> 
  ## calculate proportion of the variable
  group_by(
    id_riding, variable
  ) |> 
  mutate(
    prop = count / sum(count)
  )
  

save(census_canada_2022_electoral_ridings, file = "data/census_canada_2022_electoral_ridings.rda", compress = "bzip2")
