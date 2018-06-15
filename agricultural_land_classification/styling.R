## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/open_data/agricultural_land_classification/trafford_agricultural_land_classification.geojson")

# apply styles ---------------------------
geojson_styles <- geojson %>% 
  mutate(stroke = 
           case_when(
             ALC_GRADE == "Grade 1" ~ "#c7e9c0",
             ALC_GRADE == "Grade 2" ~ "#a1d99b",
             ALC_GRADE == "Grade 3" ~ "#74c476",
             ALC_GRADE == "Grade 4" ~ "#31a354",
             ALC_GRADE == "Grade 5" ~ "#006d2c",
             ALC_GRADE == "Non Agricultural" ~ "#ae8552",
             ALC_GRADE == "Urban" ~ "#828282"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson_styles, "trafford_agricultural_land_classification_styled.geojson")
