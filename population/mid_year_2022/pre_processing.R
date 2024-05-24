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

df_la <- bind_rows(mid2022P, mid2022F, mid2022M) %>%
  mutate(geography = "Local authority",
         period = "2022-06-30") %>%
  mutate(aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90+`))) %>% 
  select(period, area_code = Code, area_name = Name, geography, sex, all_ages = `All ages`, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), -Geography)

write_csv(df_la, "mid-year_2022_population_estimates_local_authority.csv")


#Wards

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates
# Licence: Open Government Licence 3.0

tmp <- tempfile(fileext = ".xlsx")

GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2021andmid2022/sapewardstablefinal.xlsx",
    write_disk(tmp))

df_ward <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  rename(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`) %>%
  pivot_longer(Total:M90, names_to = "age", values_to = "value") %>%
  mutate(period = "2022-06-30") %>%
  filter(age != "Total") %>%
  separate(age, into = c("sex", "age"), sep = 1) %>%
  mutate(sex = case_match(sex,"F"~"Females","M"~"Males")) %>%
  pivot_wider(names_from = "sex", values_from = value) %>%
  mutate(Persons = Females + Males) %>%
  pivot_longer(Females:Persons, names_to = "sex", values_to = "value") %>%
  pivot_wider(values_from = "value", names_from = "age") %>%
  select(-`LAD 2023 Code`, -`LAD 2023 Name`) %>%
  rename(`90+` = `90`) %>%
  mutate(geography = "Ward") %>%
  mutate(all_ages = rowSums(select(., `0`:`90+`)),
           aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90+`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything()) 

write_csv(df_ward, "mid-year_2022_population_estimates_ward.csv")

#MSOAs

#House of Commons Library MSOA Names
# URL: https://visual.parliament.uk/msoanames

lookup <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-Latest.csv") %>%
  filter(Laname=="Trafford") %>%
  select(area_code = msoa11cd, area_name = msoa11hclnm)

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates
# Licence: Open Government Licence 3.0

tmp <- tempfile(fileext = ".xlsx")

GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates/mid2021andmid2022/sapemsoasyoatablefinal.xlsx",
    write_disk(tmp))

df_msoa <- read_xlsx(tmp, sheet = 6, skip = 3) %>%
  filter(`LAD 2021 Code` == "E08000009") %>%
  rename(area_code = `MSOA 2021 Code`) %>%
  pivot_longer(Total:M90, names_to = "age", values_to = "value") %>%
  mutate(period = "2022-06-30") %>%
  filter(age != "Total") %>%
  separate(age, into = c("sex", "age"), sep = 1) %>%
  mutate(sex = case_match(sex,"F"~"Females","M"~"Males")) %>%
  pivot_wider(names_from = "sex", values_from = value) %>%
  mutate(Persons = Females + Males) %>%
  pivot_longer(Females:Persons, names_to = "sex", values_to = "value") %>%
  pivot_wider(values_from = "value", names_from = "age") %>%
  select(-`LAD 2021 Code`, -`LAD 2021 Name`) %>%
  rename(`90+` = `90`) %>%
  mutate(geography = "MSOA") %>%
  mutate(all_ages = rowSums(select(., `0`:`90+`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90+`))) %>%
  left_join(lookup, by = "area_code") %>%
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(),-`MSOA 2021 Name`) 

write_csv(df_msoa, "mid-year_2022_population_estimates_msoa.csv")

#LSOA

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates
# Licence: Open Government Licence 3.0

tmp <- tempfile(fileext = ".xlsx")

GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates/mid2021andmid2022/sapelsoasyoatablefinal.xlsx",
    write_disk(tmp))

df_lsoa <- read_xlsx(tmp, sheet = 6, skip = 3) %>%
  filter(`LAD 2021 Code` == "E08000009") %>%
  rename(area_code = `LSOA 2021 Code`, area_name = `LSOA 2021 Name`) %>%
  pivot_longer(Total:M90, names_to = "age", values_to = "value") %>%
  mutate(period = "2022-06-30") %>%
  filter(age != "Total") %>%
  separate(age, into = c("sex", "age"), sep = 1) %>%
  mutate(sex = case_match(sex,"F"~"Females","M"~"Males")) %>%
  pivot_wider(names_from = "sex", values_from = value) %>%
  mutate(Persons = Females + Males) %>%
  pivot_longer(Females:Persons, names_to = "sex", values_to = "value") %>%
  pivot_wider(values_from = "value", names_from = "age") %>%
  select(-`LAD 2021 Code`, -`LAD 2021 Name`) %>%
  rename(`90+` = `90`) %>%
  mutate(geography = "LSOA") %>%
  mutate(all_ages = rowSums(select(., `0`:`90+`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90+`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything()) 

write_csv(df_lsoa, "mid-year_2022_population_estimates_lsoa.csv")


#OA

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/censusoutputareapopulationestimatessupportinginformation
# Licence: Open Government Licence 3.0

tmp <- tempfile(fileext = ".xlsx")

GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/censusoutputareapopulationestimatessupportinginformation/mid2022/sapeoatablefinal2022v2.xlsx",
    write_disk(tmp))

df_oa <- read_xlsx(tmp, sheet = 5, skip = 3) %>%
  filter(`LAD 2021 Code` == "E08000009") %>%
  rename(area_code = `OA 2021 Code`) %>%
  pivot_longer(Total:M90, names_to = "age", values_to = "value") %>%
  mutate(period = "2022-06-30") %>%
  filter(age != "Total") %>%
  separate(age, into = c("sex", "age"), sep = 1) %>%
  mutate(sex = case_match(sex,"F"~"Females","M"~"Males")) %>%
  pivot_wider(names_from = "sex", values_from = value) %>%
  mutate(Persons = Females + Males) %>%
  pivot_longer(Females:Persons, names_to = "sex", values_to = "value") %>%
  pivot_wider(values_from = "value", names_from = "age") %>%
  select(-`LAD 2021 Code`, -`LAD 2021 Name`) %>%
  rename(`90+` = `90`) %>%
  mutate(geography = "OA", area_name = area_code) %>%
  mutate(all_ages = rowSums(select(., `0`:`90+`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90+`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything()) 

write_csv(df_oa, "mid-year_2022_population_estimates_oa.csv")

write_csv(bind_rows(df_la,df_ward,df_lsoa,df_msoa,df_oa), "mid-year_2022_population_estimates_all_geographies.csv")
