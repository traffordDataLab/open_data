# Mid-Year Population Estimates (2016)
# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(readxl)

# load and tidy data ---------------------------

# 1. Local Authority district: 2017
la_pop <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=1946157089&date=2016&gender=0...2&c_age=200,101...191&measures=20100&select=date_name,geography_name,geography_code,gender_name,c_age_name,measures_name,obs_value,obs_status_name") %>% 
  select(year = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         gender = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE) %>% 
  mutate(year = as.character(year),
         age = str_replace_all(age, "Age.", ""),
         age = str_trim(age),
         age = fct_recode(age, "90" = "90+")) %>% 
  spread(age, count) %>% 
  mutate(geography = "Local Authority") %>% 
  select(year, area_code, area_name, geography, gender, All, everything())

# ---------------------------

# 2. Electoral wards: 2016
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2016sape19dt8/sape19dt8mid2016ward2016syoaestimatesunformatted.zip"
download.file(url, dest = "data/sape19dt8mid2016ward2016syoaestimatesunformatted.zip")
unzip("data/sape19dt8mid2016ward2016syoaestimatesunformatted.zip", exdir = "data")
file.remove("data/sape19dt8mid2016ward2016syoaestimatesunformatted.zip")

ward_pop_total <- read_excel("data/SAPE19DT8-mid-2016-ward-2016-syoa-estimates-unformatted.xls", sheet = 2, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(-`Local Authority`) %>% 
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, All = `All Ages`, `90` = `90+`) %>% 
  mutate(year = "2016", gender = "Total") %>% 
  select(year, area_code, area_name, gender, everything())

ward_pop_male <- read_excel("data/SAPE19DT8-mid-2016-ward-2016-syoa-estimates-unformatted.xls", sheet = 3, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(-`Local Authority`) %>% 
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, All = `All Ages`, `90` = `90+`) %>% 
  mutate(year = "2016", gender = "Male") %>% 
  select(year, area_code, area_name, gender, everything())

ward_pop_female <- read_excel("data/SAPE19DT8-mid-2016-ward-2016-syoa-estimates-unformatted.xls", sheet = 4, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(-`Local Authority`) %>% 
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, All = `All Ages`, `90` = `90+`) %>% 
  mutate(year = "2016", gender = "Female") %>% 
  select(year, area_code, area_name, gender, everything())

ward_pop <- bind_rows(ward_pop_total, ward_pop_male, ward_pop_female) %>% 
  mutate(geography = "Ward") %>% 
  select(year, area_code, area_name, geography, everything())

rm(ward_pop_total, ward_pop_male, ward_pop_female)

# ---------------------------

# 3. Middle-layer Super Output Areas: 2016
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates/mid2016sape19dt3/sape19dt3mid2016msoasyoaestimatesformatted.zip"
download.file(url, dest = "data/sape19dt3mid2016msoasyoaestimatesformatted.zip")
unzip("data/sape19dt3mid2016msoasyoaestimatesformatted.zip", exdir = "data")
file.remove("data/sape19dt3mid2016msoasyoaestimatesformatted.zip")

msoa_pop_total <- read_excel("data/SAPE19DT3-mid-2016-msoa-syoa-estimates_formatted.xls", sheet = 4, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         All = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(year = "2016", gender = "Total") %>% 
  select(year, area_code, area_name, gender, everything())

msoa_pop_male <- read_excel("data/SAPE19DT3-mid-2016-msoa-syoa-estimates_formatted.xls", sheet = 5, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         All = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(year = "2016", gender = "Male") %>% 
  select(year, area_code, area_name, gender, everything())

msoa_pop_female <- read_excel("data/SAPE19DT3-mid-2016-msoa-syoa-estimates_formatted.xls", sheet = 6, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         All = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(year = "2016", gender = "Female") %>% 
  select(year, area_code, area_name, gender, everything())

msoa_pop <- bind_rows(msoa_pop_total, msoa_pop_male, msoa_pop_female) %>% 
  mutate(geography = "MSOA") %>% 
  select(year, area_code, area_name, geography, everything())

rm(msoa_pop_total, msoa_pop_male, msoa_pop_female)

# ---------------------------

# 4. Lower-layer Super Output Areas: 2016
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates/mid2016sape19dt1/sape19dt1mid2016lsoasyoaestimates.zip"
download.file(url, dest = "data/sape19dt1mid2016lsoasyoaestimates.zip")
unzip("data/sape19dt1mid2016lsoasyoaestimates.zip", exdir = "data")
file.remove("data/sape19dt1mid2016lsoasyoaestimates.zip")

lsoa_pop_total <- read_excel("data/SAPE19DT1-mid-2016-lsoa-syoa-estimates.xls", sheet = 4, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         All = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(year = "2016", gender = "Total") %>% 
  select(year, area_code, area_name, gender, everything())

lsoa_pop_male <- read_excel("data/SAPE19DT1-mid-2016-lsoa-syoa-estimates.xls", sheet = 5, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         All = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(year = "2016", gender = "Male") %>% 
  select(year, area_code, area_name, gender, everything())

lsoa_pop_female <- read_excel("data/SAPE19DT1-mid-2016-lsoa-syoa-estimates.xls", sheet = 6, skip = 3) %>% 
  select(-`Area Names`) %>%  
  rename(area_code = `Area Codes`, 
         area_name = 2,
         All = `All Ages`,
         `90` = `90+`) %>% 
  filter(grepl("Trafford", area_name)) %>% 
  mutate(year = "2016", gender = "Female") %>% 
  select(year, area_code, area_name, gender, everything())

lsoa_pop <- bind_rows(lsoa_pop_total, lsoa_pop_male, lsoa_pop_female) %>% 
  mutate(geography = "LSOA") %>% 
  select(year, area_code, area_name, geography, everything())

rm(lsoa_pop_total, lsoa_pop_male, lsoa_pop_female)

# ---------------------------

# 5. Output Areas: 2016
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/censusoutputareaestimatesinthenorthwestregionofengland/mid2016sape19dt10b/sape19dt10bmid2016coaunformattedsyoaestimatesnorthwest.zip"
download.file(url, dest = "data/sape19dt10bmid2016coaunformattedsyoaestimatesnorthwest.zip")
unzip("data/sape19dt10bmid2016coaunformattedsyoaestimatesnorthwest.zip", exdir = "data")
file.remove("data/sape19dt10bmid2016coaunformattedsyoaestimatesnorthwest.zip")

lsoas <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/lookups/statistical_lookup.csv") %>% 
  filter(lad11nm == "Trafford") %>% 
  select(lsoa11cd) %>% 
  unique() %>% 
  pull()

oa_pop_total <- read_excel("data/SAPE19DT10b-mid-2016-coa-unformatted-syoa-estimates-north-west.xls", sheet = 4, skip = 3) %>% 
  filter(LSOA11CD %in% lsoas) %>% 
  rename(area_code = OA11CD, 
         All = `All Ages`,
         `90` = `90+`) %>% 
  select(-LSOA11CD) %>% 
  mutate(year = "2016", area_name = paste0("Trafford - ", area_code), gender = "Total") %>% 
  select(year, area_code, area_name, gender, everything())

oa_pop_male <- read_excel("data/SAPE19DT10b-mid-2016-coa-unformatted-syoa-estimates-north-west.xls", sheet = 5, skip = 3) %>% 
  filter(LSOA11CD %in% lsoas) %>% 
  rename(area_code = OA11CD, 
         All = `All Ages`,
         `90` = `90+`) %>% 
  select(-LSOA11CD) %>% 
  mutate(year = "2016", area_name = paste0("Trafford - ", area_code), gender = "Male") %>% 
  select(year, area_code, area_name, gender, everything())

oa_pop_female <- read_excel("data/SAPE19DT10b-mid-2016-coa-unformatted-syoa-estimates-north-west.xls", sheet = 6, skip = 3) %>% 
  filter(LSOA11CD %in% lsoas) %>% 
  rename(area_code = OA11CD, 
         All = `All Ages`,
         `90` = `90+`) %>% 
  select(-LSOA11CD) %>% 
  mutate(year = "2016", area_name = paste0("Trafford - ", area_code), gender = "Female") %>% 
  select(year, area_code, area_name, gender, everything())

oa_pop <- bind_rows(oa_pop_total, oa_pop_male, oa_pop_female) %>% 
  mutate(geography = "OA") %>% 
  select(year, area_code, area_name, geography, everything())

rm(oa_pop_total, oa_pop_male, oa_pop_female)

# merge data ---------------------------
df <- bind_rows(la_pop, ward_pop, msoa_pop, lsoa_pop, oa_pop)

# write data ---------------------------
write_csv(df, "mid-2016_population_estimates.csv")
