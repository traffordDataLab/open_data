## Children's Centres ##

# Source: Department for Education
# Publisher URL: https://get-information-schools.service.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# read data ---------------------------
df <- read_csv("results.csv") %>% 
  filter(`LA (name)` == "Trafford",
         `TypeOfEstablishment (name)` == "Children's centre") %>% 
  select(name = EstablishmentName,
         UPRN,
         postcode = Postcode, 
         Easting, Northing)

# tidy data ------------------------------------
sf <- df %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]]))

# write data ---------------------------
st_write(sf, "trafford_childrens_centres.geojson")
write_csv(sf %>% st_set_geometry(value = NULL), "trafford_childrens_centres.csv")

# style data ---------------------------
sf %>% 
  select(Name = name,
         UPRN,
         Postcode = postcode) %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium") %>% 
  st_write("trafford_childrens_centres_styled.geojson")
