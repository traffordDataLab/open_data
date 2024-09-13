#Mid-year estimates at Local authority level

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/estimatesofthepopulationforenglandandwales
# Licence: Open Government Licence 3.0

library(tidyverse)

#Local authority

# Local authority
la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=1778385132&date=latest&gender=0...2&c_age=101...191&measures=20100") %>% 
  mutate(geography = "Local authority") %>% 
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sex = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE,
         geography) %>% 
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         sex = factor(fct_recode(sex, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"), levels = c("Persons", "Females", "Males")),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", ""))))  %>% 
  spread(age, count) %>% 
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), `90+` = `90`)

write_csv(la, "mid-year_2023_population_estimates_local_authority.csv")
