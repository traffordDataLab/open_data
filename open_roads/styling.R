## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/open_data/open_roads/trafford_roadLink.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson, var = 'identifier',
                           stroke = "#D6437A",
                           stroke_width = 1,
                           stroke_opacity = 1) %>% 
  rename(`stroke-width` = stroke.width,
         `stroke-opacity` = stroke.opacity)

# write data ---------------------------
st_write(geojson_styles, "trafford_roadLink_styled.geojson")
