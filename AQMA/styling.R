## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio) ; library(RColorBrewer) ; library(leaflet)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/spatial_data/AQMA/trafford_aqma.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson, var = 'AQMA_Ref',
                           stroke = "#727C81",
                           stroke_width = 3,
                           stroke_opacity = 1,
                           fill = "#727C81",
                           fill_opacity = 0.8) %>% 
  rename(`stroke-width` = stroke.width,
         `stroke-opacity` = stroke.opacity,
         `fill-opacity` = fill.opacity)

# check results ---------------------------
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  setView(-2.35533522781156, 53.419025498197, zoom = 12) %>% 
  addPolygons(data = geojson_styles, 
              color = ~stroke, 
              weight = ~`stroke-width`, 
              opacity = ~`stroke-opacity`,
              fillColor = ~fill,
              fillOpacity = ~`fill-opacity`)

# write data ---------------------------
st_write(geojson_styles, "trafford_aqma_styled.geojson")
