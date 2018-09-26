## Air Quality Management Areas (AQMAs) ##

# Source: Department for Environment Food & Rural Affairs (Defra)
# Publisher URL: http://uk-air.defra.gov.uk/aqma/maps
# Licence: Open Government Licence 3.0

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
url <- "https://uk-air.defra.gov.uk/assets/documents/uk_aqma_July2018_Final.zip"
download.file(url, dest = "uk_aqma_July2018_Final.zip")
unzip("uk_aqma_July2018_Final.zip")
file.remove("uk_aqma_July2018_Final.zip")

sf <- st_read("uk_aqma_July2018_Final.shp") %>% st_transform(4326)
bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

# tidy data ---------------------------
gm_sf <- sf %>% 
  filter(LOCAL_AUTH == "Greater Manchester") %>% 
  mutate(area_code = "E47000001") %>% 
  select(area_code, area_name = LOCAL_AUTH, description = DESCRIPTIO)

trafford_sf <- st_intersection(gm_sf, bdy)

# style GeoJSON ---------------------------
gm_sf <- gm_sf %>% 
  mutate(stroke = "#727C81",
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = "#727C81",
         `fill-opacity` = 0.8)

trafford_sf <- trafford_sf %>% 
  mutate(stroke = "#727C81",
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = "#727C81",
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(gm_sf, "gm_aqma.geojson", driver = "GeoJSON")
st_write(trafford_sf, "trafford_aqma.geojson", driver = "GeoJSON")
