## Built Up Areas 2011 ##

# Source: Office for National Statistics / Ordnance Survey
# Publisher URL: http://geoportal.statistics.gov.uk/datasets/f6684981be23404e83321077306fa837_0
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
areas <- st_read("https://opendata.arcgis.com/datasets/f6684981be23404e83321077306fa837_0.geojson")

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
