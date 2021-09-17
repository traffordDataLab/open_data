# Temporary script for obtaining the mid-year population estimates at just Local Authority level for Trafford
# The LA data is usually updated before the small areas, therefore use this if we need the LA updates ASAP.
# The main script for obtaining data for all geographic levels is updated when all the data are released
# Dataset: https://www.nomisweb.co.uk/query/construct/summary.asp?mode=construct&version=0&dataset=2002
# License: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/


#### Load libraries
library(tidyverse) ; library(lubridate)


#### Retrieve & tidy data
la <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=1820327969&date=latest&gender=0...2&c_age=101...191&measures=20100&select=date_name,geography_name,geography_code,gender_name,c_age_name,measures_name,obs_value,obs_status_name") %>% 
  mutate(geography = "Local authority") %>%
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         gender = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE,
         geography) %>% 
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         gender = fct_recode(gender, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", ""))))  %>% 
  spread(age, count) %>% 
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(period, area_code, area_name, geography, gender, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything()) 


#### Write data
write_csv(la, "mid-year_population_estimates_local_authority.csv")
