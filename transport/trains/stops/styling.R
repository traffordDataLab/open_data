## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("trafford_train_stops.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson,
                                color = "#fc6721",
                                size = "medium") %>%   
  rename(`marker-color` = marker.color,
         `marker-size` = marker.size)

# write data ---------------------------
st_write(geojson_styles, "trafford_train_stops_styled.geojson")
