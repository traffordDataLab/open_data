## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read data ---------------------------
geojson <- st_read("https://www.traffordDataLab.io/open_data/flood_risk/trafford_flood_risk.geojson")

# apply styles ---------------------------
geojson_styles <- geojson %>% 
  mutate(stroke = 
           case_when(
             PROB_4BAND == "Very Low" ~ "#eff3ff",
             PROB_4BAND == "Low" ~ "#bdd7e7",
             PROB_4BAND == "Medium" ~ "#6baed6",
             PROB_4BAND == "High" ~ "#2171b5"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson_styles, "trafford_flood_risk_styled.geojson")
