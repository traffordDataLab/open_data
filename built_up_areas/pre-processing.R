## Built Up Areas 2011 ##

# Source: Office for National Statistics / Ordnance Survey
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons::built-up-areas-december-2024-boundaries-ew-bgg-v2/about
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------

areas <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/main_ONS_BUA_2024_EW_V2/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson")


gm <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/gm_local_authority_full_resolution.geojson") %>% 
  select(-lat, -lon)

# intersect data ---------------------------
gm_areas <- st_intersection(areas, gm) 

# check results ---------------------------
plot(st_geometry(gm))
plot(st_geometry(gm_areas), col = NA, add = T)

# write data  ---------------------------
st_write(gm_areas, "gm_built_up_areas.geojson", driver = "GeoJSON")

filter(gm_areas, area_name == "Trafford") %>% 
         st_write("trafford_built_up_areas.geojson", driver = "GeoJSON")
