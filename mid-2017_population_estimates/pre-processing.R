# Mid-2017 population estimates
# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(readxl)

# load and tidy data ---------------------------

# 1. Local Authority district: 2017
la_pop <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=1946157089&date=latest&gender=0...2&c_age=200,101...191&measures=20100&select=date_name,geography_name,geography_code,gender_name,c_age_name,obs_value") %>% 
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         gender = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE) %>% 
  filter(age != "All Ages") %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         gender = fct_recode(gender, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", ""))))  %>% 
  spread(age, count) %>% 
  mutate(geography = "Local Authority",
         all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

write_csv(la_pop, "mid-2017_population_estimates_local_authority.csv")

# ---------------------------

# 2. Electoral wards: 2017
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "data/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("data/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = "data")
file.remove("data/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

ward_persons <- read_excel("data/SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", sheet = 4, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(-`Local Authority`) %>% 
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, all_ages = `All Ages`, `90` = `90+`) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "Electoral ward",
         gender = "Persons",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

ward_males <- read_excel("data/SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", sheet = 5, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(-`Local Authority`) %>% 
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, all_ages = `All Ages`, `90` = `90+`) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "Electoral ward",
         gender = "Males",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

ward_females <- read_excel("data/SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", sheet = 6, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(-`Local Authority`) %>% 
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, all_ages = `All Ages`, `90` = `90+`) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "Electoral ward",
         gender = "Females",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

ward_pop <- bind_rows(ward_persons, ward_males, ward_females) 
write_csv(ward_pop, "mid-2017_population_estimates_ward.csv")
rm(ward_persons, ward_males, ward_females)

# ---------------------------

# 3. Middle-layer Super Output Areas: 2017
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates/mid2017/sape20dt3mid2017msoasyoaestimatesformatted.zip"
download.file(url, dest = "data/sape20dt3mid2017msoasyoaestimatesformatted.zip")
unzip("data/sape20dt3mid2017msoasyoaestimatesformatted.zip", exdir = "data")
file.remove("data/sape20dt3mid2017msoasyoaestimatesformatted.zip")

msoa_persons <- read_excel("data/SAPE20DT3-mid-2017-msoa-syoa-estimates-formatted.xls", sheet = 4, skip = 4) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "MSOA",
         gender = "Persons",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

msoa_males <- read_excel("data/SAPE20DT3-mid-2017-msoa-syoa-estimates-formatted.xls", sheet = 5, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "MSOA",
         gender = "Males",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

msoa_females <- read_excel("data/SAPE20DT3-mid-2017-msoa-syoa-estimates-formatted.xls", sheet = 6, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "MSOA",
         gender = "Females",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

msoa_pop <- bind_rows(msoa_persons, msoa_males, msoa_females) 
write_csv(msoa_pop, "mid-2017_population_estimates_msoa.csv")
rm(msoa_persons, msoa_males, msoa_females) 

# ---------------------------

# 4. Lower-layer Super Output Areas: 2017
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates/mid2017/sape20dt2mid2017lsoasyoaestimatesunformatted.zip"
download.file(url, dest = "data/sape20dt2mid2017lsoasyoaestimatesunformatted.zip")
unzip("data/sape20dt2mid2017lsoasyoaestimatesunformatted.zip", exdir = "data")
file.remove("data/sape20dt2mid2017lsoasyoaestimatesunformatted.zip")

lsoa_persons <- read_excel("data/SAPE20DT2-mid-2017-lsoa-syoa-estimates-unformatted.xls", sheet = 4, skip = 3) %>% 
  rename(area_code = `Area Codes`, 
         area_name = `Area Names`,
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "LSOA",
         gender = "Persons",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

lsoa_males <- read_excel("data/SAPE20DT2-mid-2017-lsoa-syoa-estimates-unformatted.xls", sheet = 5, skip = 3) %>% 
  rename(area_code = `Area Codes`, 
         area_name = `Area Names`,
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "LSOA",
         gender = "Males",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

lsoa_females <- read_excel("data/SAPE20DT2-mid-2017-lsoa-syoa-estimates-unformatted.xls", sheet = 6, skip = 3) %>% 
  rename(area_code = `Area Codes`, 
         area_name = `Area Names`,
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         geography = "LSOA",
         gender = "Females",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

lsoa_pop <- bind_rows(lsoa_persons, lsoa_males, lsoa_females) 
write_csv(lsoa_pop, "mid-2017_population_estimates_lsoa.csv")
rm(lsoa_persons, lsoa_males, lsoa_females) 

# ---------------------------

# 5. Output Areas: 2017
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/censusoutputareaestimatesinthenorthwestregionofengland/mid2017/sape20dt10bmid2017coaunformattedsyoaestimatesnorthwest.zip"
download.file(url, dest = "data/sape20dt10bmid2017coaunformattedsyoaestimatesnorthwest.zip")
unzip("data/sape20dt10bmid2017coaunformattedsyoaestimatesnorthwest.zip", exdir = "data")
file.remove("data/sape20dt10bmid2017coaunformattedsyoaestimatesnorthwest.zip")

lsoas <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/lookups/statistical_lookup.csv") %>% 
  filter(lad11nm == "Trafford") %>% 
  select(lsoa11cd) %>% 
  unique() %>% 
  pull()

oa_persons <- read_excel("data/SAPE20DT10b-mid-2017-coa-unformatted-syoa-estimates-north-west.xlsx", sheet = 4, skip = 3) %>% 
  filter(LSOA11CD %in% lsoas) %>% 
  rename(area_code = OA11CD, 
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  select(-LSOA11CD) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         area_name = paste0("Trafford - ", area_code), 
         geography = "OA",
         gender = "Persons",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

oa_males <- read_excel("data/SAPE20DT10b-mid-2017-coa-unformatted-syoa-estimates-north-west.xlsx", sheet = 5, skip = 3) %>% 
  filter(LSOA11CD %in% lsoas) %>% 
  rename(area_code = OA11CD, 
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  select(-LSOA11CD) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         area_name = paste0("Trafford - ", area_code), 
         geography = "OA",
         gender = "Males",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

oa_females <- read_excel("data/SAPE20DT10b-mid-2017-coa-unformatted-syoa-estimates-north-west.xlsx", sheet = 6, skip = 3) %>% 
  filter(LSOA11CD %in% lsoas) %>% 
  rename(area_code = OA11CD, 
         all_ages = `All Ages`,
         `90` = `90+`) %>% 
  select(-LSOA11CD) %>% 
  mutate(date = as.Date("2017-06-30", format = '%Y-%m-%d'),
         area_name = paste0("Trafford - ", area_code), 
         geography = "OA",
         gender = "Females",
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(date, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

oa_pop <- bind_rows(oa_persons, oa_males, oa_females)
write_csv(oa_pop, "mid-2017_population_estimates_oa.csv")
rm(oa_persons, oa_males, oa_females)

# merge data ---------------------------
df <- bind_rows(la_pop, ward_pop, msoa_pop, lsoa_pop, oa_pop)

# write data ---------------------------
write_csv(df, "mid-2017_population_estimates_all_geographies.csv")
