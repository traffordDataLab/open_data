## Buildings ##

# Source: Ordnance Survey Open Map - Local
# Publisher URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-map-local.html
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
bldgs <- st_read("SJ_Building.shp") %>% st_transform(27700)
trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  select(-lon, -lat) %>% 
  st_set_crs(4326) %>% 
  st_transform(27700)

# intersect data ---------------------------
trafford_bldgs <- st_intersection(bldgs, trafford)

# check data  ---------------------------
plot(st_geometry(trafford), col = "#f0f0f0")
plot(st_geometry(trafford_bldgs), add = T)

# write data  ---------------------------
trafford_bldgs %>% 
  st_transform(4326) %>% 
  st_write("trafford_buildings.geojson", driver = "GeoJSON")
