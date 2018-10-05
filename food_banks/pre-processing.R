## Food banks in GM ##

# Source: GM Poverty Action
# Publisher URL: http://www.gmpovertyaction.org/maps/
# Licence: https://twitter.com/GMPovertyAction/status/931462172206620672

# Notes: the coordinates were scraped from the GMPA Food Bank Map on Google Maps because coordinates were not provided in the KML file
# https://www.google.com/maps/d/viewer?mid=1d57arj_ukZpZudaEHERZV72QKxc&usp

# load libraries
library(tidyverse) ; library(sf)

# load data ---------------------------
df <- read_csv("scraped_data.csv")

bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/gm_local_authority_full_resolution.geojson")

# tidy data ---------------------------
sf <- df %>%  
  filter(!is.na(lon)) %>%
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_intersection(., bdy)

# style GeoJSON  ---------------------------
sf <- sf %>% 
  select(Name = name,
         `Referral method` = referral_method, 
         `Opening times` = opening_times, 
         Address = address,
         Postcode = post_code,
         Contact = contact,
         Website = website,
         `Area name` = area_name,
         `Area code` = area_code) %>%
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

# write data  ---------------------------
write_csv(st_set_geometry(sf, value = NULL), "gm_food_banks.csv")
write_csv(filter(st_set_geometry(sf, value = NULL), `Area name` == "Trafford"), "trafford_food_banks.csv")
st_write(sf, "gm_food_banks.geojson")
st_write(filter(sf, `Area name` == "Trafford"), "trafford_food_banks.geojson")
