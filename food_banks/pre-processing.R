## Food banks in GM ##
# Source: GM Poverty Action
# Publisher URL: http://www.gmpovertyaction.org/maps/
# Licence: https://twitter.com/GMPovertyAction/status/931462172206620672

# Notes: 
# The coordinates were scraped from the GMPA Food Bank Map on Google Maps

# load libraries
library(tidyverse) ; library(sf) ; library(leaflet)

# load data ---------------------------
df <- read_csv("scraped_data.csv", col_names = TRUE)

# convert to geospatial data ---------------------------
sf <- df %>%  
  filter(!is.na(lon)) %>%
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326)

# read ward layer ---------------------------
wards <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/lookups/administrative_lookup.geojson") %>% 
  st_transform(crs = 4326) %>% 
  select(wd17cd, wd17nm, lad17cd, lad17nm)

# join ward attributes ---------------------------
sf <- st_join(sf, wards, join = st_within, left = FALSE) 

# check results
leaflet(sf) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addMarkers(label = ~as.character(address))

# write geospatial data  ---------------------------
st_write(sf, "GM_food_banks.geojson")

# write tabular data  ---------------------------
sf %>%
  cbind(., st_coordinates(.)) %>%
  rename(long = X, lat = Y) %>% 
  st_set_geometry(NULL) %>%
  write_csv("GM_food_banks.csv")
