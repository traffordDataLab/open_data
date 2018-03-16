## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/spatial_data/watercourses/trafford_watercourses.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson, var = 'identifier',
                           stroke = "#40a4df",
                           stroke_width = 3,
                           stroke_opacity = 1,
                           fill = "#40a4df",
                           fill_opacity = 0.8) %>% 
  rename(`stroke-width` = stroke.width,
         `stroke-opacity` = stroke.opacity,
         `fill-opacity` = fill.opacity)

# write data ---------------------------
st_write(geojson_styles, "trafford_watercourses_styled.geojson")
