## Styling flood risk features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read un-styled, cleaned data ---------------------------
geojson <- st_read("trafford_flood_risk.geojson")

# apply styles ---------------------------
geojson_styles <- geojson %>% 
  mutate(stroke = 
           case_when(
             flood_risk == "Very Low" ~ "#bdd7e7",
             flood_risk == "Low" ~ "#6baed6",
             flood_risk == "Medium" ~ "#2171b5",
             flood_risk == "High" ~ "#3E4388"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson_styles, "trafford_flood_risk_styled.geojson")
