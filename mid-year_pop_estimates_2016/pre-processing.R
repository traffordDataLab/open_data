# Ward Level Mid-Year Population Estimates (2016)
# Source : https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental

# Load libraries ---------------------------
library(readxl) ; library(tidyverse)

# Load data ---------------------------
df_raw <- read_xls("SAPE19DT8-mid-2016-ward-2016-syoa-estimates-unformatted.xls", sheet = 2, skip = 3)

# Tidy data ---------------------------
df_tidy <- df_raw %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', `Local Authority`)) %>% 
  rename(wd16cd = `Ward Code 1`, wd16nm = `Ward Name 1`, lad16nm = `Local Authority`, total_pop = `All Ages`)

# Write data ---------------------------
write_csv(df_tidy, "ONS_mid-year_population_estimates_2016.csv")
