## Schools and colleges ##
# Source: Department for Education
# Publisher URL: http://www.education.gov.uk/edubase
# Licence: Open Government Licence

# load the necessary R packages ---------------------------
library(tidyverse) ; library(sf)

# load and tidy data ---------------------------
df <- read_csv("results.csv") %>% 
  filter(`EstablishmentTypeGroup (name)` != "Children's Centres") %>% 
  select(Name = EstablishmentName,
         Type = `EstablishmentTypeGroup (name)`,
         Gender = `Gender (name)`,
         `Lowest age of admission` = StatutoryLowAge,
         `Highest age of admission` = StatutoryHighAge,
         Capacity = SchoolCapacity,
         `Pupils on roll` = NumberOfPupils,
         `Percent free school meals` = PercentageFSM,
         `Resource provision`  = `TypeOfResourcedProvision (name)`,
         Religion = `ReligiousCharacter (name)`,
         `Trust type` = `TrustSchoolFlag (name)`,
        `Sponsoring Trust` = `Trusts (name)`,
         Website = SchoolWebsite,
         Postcode = Postcode,
         Easting, Northing)
df$`Sponsoring Trust` <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(df$`Sponsoring Trust`), perl=TRUE)

# reproject data ------------------------------------
sf <- df %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326) %>% 
  mutate(Longitude = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         Latitude = map_dbl(geometry, ~st_coordinates(.x)[[2]]))

# write data   ---------------------------
write_csv(sf %>% st_set_geometry(value = NULL), "trafford_schools_and_colleges.csv")
st_write(sf, "trafford_schools_and_colleges.geojson")