## Schools and colleges ##
# Source: Department for Education
# Publisher URL: http://www.education.gov.uk/edubase
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
df <- read_csv("results.csv") 

# tidy data ---------------------------
df %>%
  # remove Children's Centres
  filter(`EstablishmentTypeGroup (name)` != "Children's Centres") %>% 
  # choose and rename variables
  select(name = EstablishmentName,
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
         Easting, Northing) %>% 
  # replace "Not applicable" with NA in Resource Provision field 
  mutate(resource_provision = replace(resource_provision, resource_provision == "Not applicable", NA),
         # change Sponsoring Trust to proper case
         sponsoring_trust = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(sponsoring_trust), perl=TRUE))
  
# reproject data ------------------------------------
sf <- df %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326) %>% 
  mutate(lng = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]]))

# write data ---------------------------
write_csv(sf %>% st_set_geometry(value = NULL), "trafford_schools_and_colleges.csv")

# style geospatial data ---------------------------
sf_styled_geojson <- sf %>% 
  select(Name = name,
         Type = type,
         Gender = gender,
         `Lowest age of admission` = lowest_admission_age,
         `Highest age of admission` = highest_admission_age,
         Capacity = capacity,
         `Resource provision`  = resource_provision,
         Religion = religion,
         `Trust type` = trust_type,
         `Sponsoring Trust` = sponsoring_trust,
         Website = website,
         Postcode = postcode) %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

# write geospatial data ---------------------------
st_write(sf_styled_geojson, "trafford_schools_and_colleges.geojson")
