## Bus stops in Trafford ##

# Source: Transport for Greater Manchester
# Publisher URL: https://www.data.gov.uk/dataset/05252e3a-acdf-428b-9314-80ac7b17ab76/gm-bus-stopping-points
# Licence: Open Government Licence 3.0

# Data: 2022-11-11
# Last Updated: 2023-09-27


# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
raw <- read_csv("https://odata.tfgm.com/opendata/downloads/TfGMStoppingPoints.csv")

bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2021/trafford_local_authority_full_resolution.geojson")

# tidy data ---------------------------
sf <- raw %>% 
  select(atco_code = AtcoCode, 
         common_name = CommonName, 
         street = Street, 
         BusStopType, Status, Longitude, Latitude) %>% 
  filter(!is.na(BusStopType) & Status == "act") %>% 
  select(-BusStopType, -Status) %>% 
  mutate(street = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(street), perl=TRUE)) %>% 
  st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>% 
  st_intersection(., bdy) %>% 
  select(1:5, lon, lat)

# write data
st_write(sf, "trafford_bus_stops.geojson")
sf %>% 
  st_set_geometry(value = NULL) %>% 
  write_csv("trafford_bus_stops.csv")

# style data
sf %>% 
  rename(`ATCO code` = atco_code,
         `Common name` = common_name,
         Street = street,
         `Area code` = area_code, 
         `Area name` = area_name) %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium") %>% 
  st_write("trafford_bus_stops_styled.geojson")
