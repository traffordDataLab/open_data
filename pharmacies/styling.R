## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/open_data/pharmacies/trafford_pharmacies.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson,
                                color = "#fc6721",
                                size = "medium") %>%   
  rename(`marker-color` = marker.color,
         `marker-size` = marker.size)

# write data ---------------------------
st_write(geojson_styles, "trafford_pharmacies_styled.geojson")
