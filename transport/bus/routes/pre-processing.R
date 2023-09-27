## Bus routes in Trafford ##

# Source: Transport for Greater Manchester
# Publisher URL: https://www.data.gov.uk/dataset/136be10f-1667-474f-b52c-92bb24486739/gm-bus-routes-1-25-000-scale-map-data
# Licence: Open Government Licence 3.0

# Data: 2023-05-25
# Last Updated: 2023-09-27

# load libraries---------------------------
library(sf) ; library(tidyverse)

# load geospatial data ---------------------------
lad <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2021/trafford_local_authority_full_resolution.geojson")

url <- "https://odata.tfgm.com/opendata/downloads/BusRouteMaps/BusRouteMapData.zip"
download.file(url, dest = "BusRouteMapData.zip")
unzip("BusRouteMapData.zip", exdir = "data")
file.remove("BusRouteMapData.zip")

# tidy and write geospatial data   ---------------------------
st_read("data/KML-format/OpenData_BusRoutes.KML") %>% 
  st_transform(crs = 4326) %>% 
  st_intersection(., lad) %>% 
  select(ServiceID = Name) %>% 
  mutate(stroke = "#fc6721",
         `stroke-width` = 0.3,
         `stroke-opacity` = 1) %>% 
  st_write("trafford_bus_routes.geojson")
