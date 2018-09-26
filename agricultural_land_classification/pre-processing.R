## Agricultural Land Classification ##

# Source: Natural England
# Publisher URL: https://data.gov.uk/dataset/provisional-agricultural-land-classification-alc2
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
sf <- st_read("https://opendata.arcgis.com/datasets/5934fd11ae3c44dbb270e8a547ba06c1_0.geojson")

gm <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/gm_local_authority_full_resolution.geojson")
trafford <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

# tidy data ---------------------------
gm_sf <- st_intersection(sf, gm) %>%
  select(Grade = ALC_GRADE, `Area code` = area_code, `Area name` = area_name)

trafford_sf <- st_intersection(sf, trafford) %>% 
  select(Grade = ALC_GRADE, `Area code` = area_code, `Area name` = area_name)

# style GeoJSON  ---------------------------
gm_sf <- gm_sf %>% 
  mutate(stroke = 
           case_when(
             Grade == "Grade 1" ~ "#c7e9c0",
             Grade == "Grade 2" ~ "#a1d99b",
             Grade == "Grade 3" ~ "#74c476",
             Grade == "Grade 4" ~ "#31a354",
             Grade == "Grade 5" ~ "#006d2c",
             Grade == "Non Agricultural" ~ "#ae8552",
             Grade == "Urban" ~ "#828282"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

trafford_sf <- trafford_sf %>% 
  mutate(stroke = 
           case_when(
             Grade == "Grade 1" ~ "#c7e9c0",
             Grade == "Grade 2" ~ "#a1d99b",
             Grade == "Grade 3" ~ "#74c476",
             Grade == "Grade 4" ~ "#31a354",
             Grade == "Grade 5" ~ "#006d2c",
             Grade == "Non Agricultural" ~ "#ae8552",
             Grade == "Urban" ~ "#828282"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data  ---------------------------
st_write(gm_sf, "gm_agricultural_land_classification.geojson", driver = "GeoJSON")
st_write(trafford_sf, "trafford_agricultural_land_classification.geojson", driver = "GeoJSON")
