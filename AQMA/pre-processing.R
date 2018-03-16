## Air Quality Management Areas (AQMAs) ##

# Source: Department for Environment Food & Rural Affairs (Defra)
# Publisher URL: http://uk-air.defra.gov.uk/aqma/maps
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
url <- "https://uk-air.defra.gov.uk/assets/documents/uk_aqma_Jan2018_FINAL.zip"
download.file(url, dest = "uk_aqma_Jan2018_FINAL.zip")
unzip("uk_aqma_Jan2018_FINAL.zip")
file.remove("uk_aqma_Jan2018_FINAL.zip")

aqma <- st_read("uk_aqma_Jan2018_FINAL.shp") %>% 
  st_transform(4326)

trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)

# intersect data ---------------------------
trafford_aqma <- st_intersection(aqma, trafford)

# check data  ---------------------------
library(leaflet)

leaflet(data = trafford_aqma) %>% 
  setView(-2.35533522781156, 53.419025498197, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = trafford, fillColor = "transparent", weight = 1.5, dashArray = "3", color = "#212121", fillOpacity = 0.3) %>%
  addPolygons(fillColor = "green", weight = 0.5, opacity = 1, color = "white", fillOpacity = 0.7) %>% 
  addControl("<strong>Air Quality Management Areas in Trafford</strong><br /><em>Source: DEFRA</em>",
             position = 'topright')

# write data  ---------------------------
st_write(trafford_aqma, "trafford_aqma.geojson", driver = "GeoJSON")