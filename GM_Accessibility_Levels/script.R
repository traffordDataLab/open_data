## Greater Manchester Accessibility Levels ##

# Source: Transport for Greater Manchester
# Publisher URL: https://data.gov.uk/dataset/d9dfbf0a-3cd7-4b12-a39f-0ec717423ee4/gm-accessibility-levels-gmal
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
url <- "http://odata.tfgm.com/opendata/downloads/GMAL/GMAL_TfGMOpenData.zip"
download.file(url, dest = "GMAL_TfGMOpenData.zip")
unzip("GMAL_TfGMOpenData.zip")
file.remove("GMAL_TfGMOpenData.zip")

sf <- st_read("SHP-format/GMAL_grid_open.shp") %>% st_transform(crs = 4326)
bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

# tidy data ---------------------------
gm_sf <- sf  %>% 
  select(`GMAL level` = GMALLevel, `GMAL score` = GMALScore)

trafford_sf <- st_intersection(sf, bdy) %>% 
  select(`GMAL level` = GMALLevel, `GMAL score` = GMALScore)

# style GeoJSON ---------------------------
gm_sf <- gm_sf %>% 
  mutate(stroke = 
           case_when(
             `GMAL level` == 1 ~ "#020060",
             `GMAL level` == 2 ~ "#3175FF",
             `GMAL level` == 3 ~ "#50C4FF",
             `GMAL level` == 4 ~ "#8FFF90",
             `GMAL level` == 5 ~ "#FED861",
             `GMAL level` == 6 ~ "#FF8001",
             `GMAL level` == 7 ~ "#D63027",
             `GMAL level` == 8 ~ "#500001"),
         `stroke-width` = 0,
         fill = stroke,
         `fill-opacity` = 0.8)

trafford_sf <- trafford_sf %>% 
  mutate(stroke = 
           case_when(
             `GMAL level` == 1 ~ "#020060",
             `GMAL level` == 2 ~ "#3175FF",
             `GMAL level` == 3 ~ "#50C4FF",
             `GMAL level` == 4 ~ "#8FFF90",
             `GMAL level` == 5 ~ "#FED861",
             `GMAL level` == 6 ~ "#FF8001",
             `GMAL level` == 7 ~ "#D63027",
             `GMAL level` == 8 ~ "#500001"),
         `stroke-width` = 0,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(gm_sf, "gm_GMAL.geojson")
st_write(trafford_sf, "trafford_GMAL.geojson")
