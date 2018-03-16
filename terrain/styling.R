## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/open_data/terrain/trafford_terrain_lines.geojson")

# apply styles ---------------------------
geojson_styles <- geojson %>% 
  mutate(stroke = 
           case_when(
             SUB_TYPE == "master" ~ "#e0945e",
             SUB_TYPE == "meanHighWater" ~ "#179ae5",
             SUB_TYPE == "meanLowWater" ~ "#179ae5",
             SUB_TYPE == "ordinary" ~ "#e0945e"),
         `stroke-width` = 3,
         `stroke-opacity` = 1)

# write data ---------------------------
st_write(geojson_styles, "trafford_terrain_lines_styled.geojson")
