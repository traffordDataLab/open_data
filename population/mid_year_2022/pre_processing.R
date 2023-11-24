#Mid-year estimates at Local authority level

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/estimatesofthepopulationforenglandandwales
# Licence: Open Government Licence 3.0

library(httr) ; library(readxl) ; library(tidyverse)

tmp <- tempfile(fileext = ".xlsx")


GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/estimatesofthepopulationforenglandandwales/mid20222023localauthorityboundaires/mye22tablesew2023geogs.xlsx",
    write_disk(tmp))

mid2022P <- read_xlsx(tmp, sheet = 7, skip = 7) %>%
  filter(Code %in% c("E08000009")) %>%
  mutate(sex = "Persons")

mid2022F <- read_xlsx(tmp, sheet = 8, skip = 7) %>%
  filter(Code %in% c("E08000009")) %>%
  mutate(sex = "Females")

mid2022M <- read_xlsx(tmp, sheet = 9, skip = 7) %>%
  filter(Code %in% c("E08000009")) %>%
  mutate(sex = "Males")

df <- bind_rows(mid2022P, mid2022F, mid2022M) %>%
  mutate(geography = "Local authority",
         period = "2022-06-30") %>%
  mutate(aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90+`))) %>% 
  select(period, area_code = Code, area_name = Name, geography, sex, all_ages = `All ages`, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), -Geography) 
  
write_csv(df, "mid-year_2022_population_estimates_local_authority.csv")
