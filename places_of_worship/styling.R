## Post processing script to transform and style the Ordnance Survey data into a more presentable format
## This file uses the manually cleaned versions of the files created using the pre-processing script

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load data and select ---------------------------
sf_geojson_source <- st_read("trafford_places_of_worship.geojson")
  
# select only the variables we are interested in and rename them ---------------------------
sf_geojson <- select(sf_geojson_source, DISTNAME, area_code, area_name) %>%
  rename(Name = DISTNAME, `Area Code` = area_code, `Area Name` = area_name)

# add styling properties ---------------------------
sf_geojson_styles <- sf_geojson %>% 
  mutate(stroke = "#fc6721",
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(sf_geojson_styles, "trafford_places_of_worship_styled.geojson")
