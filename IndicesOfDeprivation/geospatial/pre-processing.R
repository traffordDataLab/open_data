# LSOA boundaries #

# Source: Open Geography Portal, ONS
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Please note: LSOAs have been reaggragated to 2019 local authority district boundaries

library(tidyverse) ; library(sf) ; library(janitor)

# Retrieve generalised 2011 LSOA boundaries in England
lsoa <- st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_2.geojson") %>% 
  filter(str_detect(lsoa11cd, "^E"))

# Create LSOA > LA lookup from 2019 English Indices of Deprivation 
lookup <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833982/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators.csv") %>% 
  clean_names() %>% 
  select(lsoa11cd = 1, lad19cd = 3, lad19nm = 4) %>% 
  distinct(lsoa11cd, .keep_all = TRUE)

# Join data
sf <- left_join(lsoa, lookup, by = "lsoa11cd") %>% 
  select(lsoa11cd, lsoa11nm, lad19cd, lad19nm)

# Write results
st_write(sf, "lsoa.geojson")

