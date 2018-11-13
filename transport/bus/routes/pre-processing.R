## Bus routes in Trafford ##

# Source: Transport for Greater Manchester
# Publisher URL: https://data.gov.uk/dataset/136be10f-1667-474f-b52c-92bb24486739/gm-bus-routes-1-25-000-scale-map-data
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(sf) ; library(tidyverse)

# load geospatial data ---------------------------
lad <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

url <- "http://odata.tfgm.com/opendata/downloads/BusRouteMaps/BusRouteMapData.zip"
download.file(url, dest = "data/BusRouteMapData.zip")
unzip("data/BusRouteMapData.zip", exdir = "data")
file.remove("data/BusRouteMapData.zip")

# tidy and write geospatial data   ---------------------------
st_read("data/KML-format/OpenData_BusRoutes.KML") %>% 
  st_transform(crs = 4326) %>% 
  st_intersection(., lad) %>% 
  select(ServiceID = Name) %>% 
  mutate(stroke = "#fc6721",
         `stroke-width` = 0.3,
         `stroke-opacity` = 1) %>% 
  st_write("trafford_bus_routes.geojson")