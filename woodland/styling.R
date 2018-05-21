## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio) ; library(leaflet)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/open_data/buildings/trafford_woodland.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson, var = 'ID',
                                stroke = "#659D32",
                                stroke_width = 0.3,
                                stroke_opacity = 1) %>% 
  rename(`stroke-width` = stroke.width,
         `stroke-opacity` = stroke.opacity)

# check results ---------------------------
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  setView(-2.35533522781156, 53.419025498197, zoom = 12) %>% 
  addPolygons(data = geojson_styles, 
              color = ~stroke, 
              weight = ~`stroke-width`, 
              opacity = ~`stroke-opacity`)

# write data ---------------------------
st_write(geojson_styles, "trafford_woodland_styled.geojson")
