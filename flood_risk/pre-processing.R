## Risk of Flooding from Rivers and Sea ##

# Source: Environment Agency
# Publisher URL: https://data.gov.uk/dataset/risk-of-flooding-from-rivers-and-sea1
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
flood <- st_read("flood_risk_radius.geojson") # processed in QGIS beforehand

trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)

# intersect data ---------------------------
trafford_flood <- st_intersection(flood, trafford)

# write data  ---------------------------
st_write(trafford_flood, "trafford_flood_risk.geojson", driver = "GeoJSON")
