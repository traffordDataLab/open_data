## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/open_data/general_practices/GM_general_practices.geojson")

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson,
                                color = "#fc6721",
                                size = "medium") %>%   
  rename(`marker-color` = marker.color,
         `marker-size` = marker.size)

# write data ---------------------------
st_write(geojson_styles, "GM_general_practices_styled.geojson")
