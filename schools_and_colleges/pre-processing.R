## Schools and colleges ##

# Source: Department for Education
# Publisher URL: https://get-information-schools.service.gov.uk/
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
# NOTE: you will need to download results.csv from the Get Information Schools Service
# 1. Search by Local Authority
# 2. Enter "Trafford", tick "Include open schools only" and choose "Search"
# 3. Choose link "Download these search results"
# 4. Choose "Full set of data", tick "Include additional data: links" and choose "Select and continue"
# 5. Choose "Data in CSV format" and choose "Select and continue"
# 6. Download the file, unzip and place in the same folder as this script
df_raw <- read_csv("results.csv") 

# tidy data ---------------------------
df <- df_raw %>%
  # remove Children's Centres
  filter(`EstablishmentTypeGroup (name)` != "Children's Centres") %>% 
  
  # change Sponsoring Trust to proper case
  mutate(`Trusts (name)` = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(`Trusts (name)`), perl=TRUE)) %>%
  
  # choose and rename variables
  select(name = EstablishmentName,
         local_authority_code = `LA (code)`,
         establishment_number = EstablishmentNumber,
         unique_reference_number = URN,
         type = `EstablishmentTypeGroup (name)`,
         gender = `Gender (name)`,
         lowest_admission_age = StatutoryLowAge,
         highest_admission_age = StatutoryHighAge,
         capacity = SchoolCapacity,
         resource_provision = `TypeOfResourcedProvision (name)`,
         religion = `ReligiousCharacter (name)`,
         trust_type = `TrustSchoolFlag (name)`,
         sponsoring_trust = `Trusts (name)`,
         website = SchoolWebsite,
         postcode = Postcode,
         Easting, Northing)
  
# reproject data ------------------------------------
sf <- df %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326) %>% 
  # extract coordinates
  mutate(lng = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]]))

# write geospatial data ---------------------------
st_write(sf, "trafford_schools_and_colleges.geojson")

# write data ---------------------------
write_csv(sf %>% st_set_geometry(value = NULL), "trafford_schools_and_colleges.csv")
