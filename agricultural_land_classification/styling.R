## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/spatial_data/agricultural_land_classification/trafford_agricultural_land_classification.geojson")

# apply styles ---------------------------
geojson <- geojson %>% 
  mutate(stroke = 
           case_when(
             ALC_GRADE == "Grade 1" ~ "#4C948E",
             ALC_GRADE == "Grade 2" ~ "#8BCAC5",
             ALC_GRADE == "Grade 3" ~ "#D8F0ED",
             ALC_GRADE == "Grade 4" ~ "#4C948E",
             ALC_GRADE == "Grade 5" ~ "#E4CA93",
             ALC_GRADE == "Non Agricultural" ~ "#AE8552",
             ALC_GRADE == "Urban" ~ "#828282"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson, "trafford_agricultural_land_classification_styled.geojson")
