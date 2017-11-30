## Claimant count ##

# Load packages ---------------------------
library(tidyverse)

# Query nomis API ---------------------------
# Geography: 2015 electoral wards
# Temporal coverage: January 2015 - latest month
# Measure(s): count and claimants as proportion of residents aged 16-64

ward_lookup <- read_csv("https://ons.maps.arcgis.com/sharing/rest/content/items/6417806dc4564ba5afcf15c3a5670ca6/data") %>% 
  setNames(tolower(names(.))) %>% 
  filter(lad15nm %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(wd15cd, wd15nm, lad15cd, lad15nm)

read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=1673527867...1673527876,1673527878,1673527877,1673527879...1673527899,1673527901,1673527900,1673527902...1673527950,1673527953,1673527951,1673527952,1673527954...1673527997,1673527999,1673527998,1673528000,1673528002,1673528003,1673528001,1673528004...1673528050,1673528052,1673528051,1673528053...1673528081&date=latestMINUS33-latest&gender=0&age=0&measure=1,2&measures=20100&select=date_name,geography_name,geography_code,gender_name,age_name,measure_name,measures_name,obs_value,obs_status_name") %>% 
  select(date = DATE_NAME,
         wd15cd = GEOGRAPHY_CODE, 
         measure = MEASURE_NAME, 
         value = OBS_VALUE) %>%
  mutate(date = as.Date(paste('01', date), format = '%d %B %Y')) %>%        
  spread(measure, value) %>%
  rename(count = `Claimant count`, rate = `Claimants as a proportion of residents aged 16-64`) %>%
  left_join(., ward_lookup, by = "wd15cd") %>%
  select(date, count, rate, wd15cd, wd15nm, lad15cd, lad15nm) %>%
  write_csv("claimant_count_wards.csv")
  
# Query nomis API ---------------------------
# Geography: Local Authority District (as of April 2015)
# Temporal coverage: January 2015 - latest month
# Measure(s): count and claimants as proportion of residents aged 16-64

la_lookup <- read_csv("https://opendata.arcgis.com/datasets/b7f31a1598714a7ba8610867481f77f3_0.csv") %>% 
  setNames(tolower(names(.))) %>% 
  filter(lad15nm %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  select(lad15cd, lad15nm, cauth15cd, cauth15nm)
  
read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=1879048217...1879048226&date=latestMINUS33-latest&gender=0&age=0&measure=1,2&measures=20100&select=date_name,geography_name,geography_code,gender_name,age_name,measure_name,measures_name,obs_value,obs_status_name")  %>%
  select(date = DATE_NAME,
         lad15cd = GEOGRAPHY_CODE, 
         measure = MEASURE_NAME, 
         value = OBS_VALUE) %>% 
  mutate(date = as.Date(paste('01', date), format = '%d %B %Y')) %>%        
  spread(measure, value) %>% 
  rename(count = `Claimant count`, rate = `Claimants as a proportion of residents aged 16-64`) %>%
  left_join(., la_lookup, by = "lad15cd") %>%
  select(date, count, rate, lad15cd, lad15nm, cauth15cd, cauth15nm) %>%
  write_csv("claimant_count_local_authorities.csv")
  
# Query nomis API ---------------------------
# Geography: Greater Manchester Combined Authority
# Temporal coverage: January 2015 - latest month
# Measure(s): count and claimants as proportion of residents aged 16-64
  
read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=1853882369&date=latestMINUS33-latest&gender=0&age=0&measure=1,2&measures=20100&select=date_name,geography_name,geography_code,gender_name,age_name,measure_name,measures_name,obs_value,obs_status_name") %>% 
  select(date = DATE_NAME,
         cauth15cd = GEOGRAPHY_CODE,
         measure = MEASURE_NAME, 
         value = OBS_VALUE) %>%
  mutate(date = as.Date(paste('01', date), format = '%d %B %Y'),
         cauth15nm = "Greater Manchester") %>%        
  spread(measure, value) %>%
  rename(count = `Claimant count`, rate = `Claimants as a proportion of residents aged 16-64`) %>%
  select(date, count, rate, cauth15cd, cauth15nm) %>%
  write_csv("claimant_count_combined_authority.csv")
  
