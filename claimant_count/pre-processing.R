## Claimant count ##

# Load packages ---------------------------
library(tidyverse)

# Query nomis API ---------------------------
results <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=1249902593...1249937345&date=latest&gender=0&age=0&measure=1&measures=20100&select=date_name,geography_name,geography_code,gender_name,age_name,measure_name,measures_name,obs_value,obs_status_name") 

# Tidy data ---------------------------
df <- results %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', GEOGRAPHY_NAME) &
           MEASURE_NAME == "Claimant count") %>% 
  mutate(date = as.Date(paste('01', DATE_NAME), format = '%d %B %Y')) %>% 
  select(date,
         lsoa11cd = GEOGRAPHY_CODE, 
         lsoa11nm = GEOGRAPHY_NAME, 
         measure = MEASURE_NAME, 
         value = OBS_VALUE)

# Write data ---------------------------
write_csv(df, "claimant_count.csv")


