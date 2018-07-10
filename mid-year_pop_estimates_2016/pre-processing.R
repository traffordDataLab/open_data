# Mid-Year Population Estimates
# Source: ONS
# Licence: Open Government Licence

# Load libraries ---------------------------
library(tidyverse) ; library(readxl)

# Ward Mid-2016 Population Estimates ---------------------------
# Source: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2016sape19dt8/sape19dt8mid2016ward2016syoaestimatesunformatted.zip"
download.file(url, dest = "sape19dt8mid2016ward2016syoaestimatesunformatted.zip")
unzip("sape19dt8mid2016ward2016syoaestimatesunformatted.zip")
file.remove("sape19dt8mid2016ward2016syoaestimatesunformatted.zip")
df <- read_xls("SAPE19DT8-mid-2016-ward-2016-syoa-estimates-unformatted.xls", sheet = 2, skip = 3)

df %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', `Local Authority`)) %>% 
  rename(wd16cd = `Ward Code 1`, wd16nm = `Ward Name 1`, lad16nm = `Local Authority`, total_pop = `All Ages`) %>% 
  write_csv("mid-2016_population_estimates_ward.csv")

# Lower Super Output Area Mid-2016 Population Estimates ---------------------------
# Source: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates

df %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', `Name`)) %>% 
  mutate(lad16nm = str_extract(Name, "Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan")) %>% 
  select(lsoa11cd = Code, lsoa11nm = Name, lad16nm, total_pop = `All Ages`, everything()) %>% 
  write_csv("mid-2016_population_estimates_lsoa.csv")