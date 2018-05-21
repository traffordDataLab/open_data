## Woodland ##

# Source: Ordnance Survey (OS OpenMap – Local)
# Publisher URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-map-local.html
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
woodland <- st_read("SJ_Woodland.shp") %>% 
  st_transform(4326)

trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)

# intersect data ---------------------------
trafford_woodland <- st_intersection(woodland, trafford)

# check results ---------------------------
plot(st_geometry(trafford))
plot(st_geometry(trafford_woodland), col = "#659D32", add = T)

# write data  ---------------------------
st_write(trafford_woodland, "trafford_woodland.geojson", driver = "GeoJSON")
