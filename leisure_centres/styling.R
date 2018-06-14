## Add styling to GeoJSON features ##

# load packages ---------------------------
library(tidyverse) ; library(sf)

# read data ---------------------------
geojson <- st_read("trafford_leisure_centres.geojson")

# apply styles ---------------------------
#   - different colour depending if the shape is a car park or a leisure centre, based on the name
geojson_styles <- geojson %>% 
  mutate(stroke = 
          if_else(grepl("\\b.*?Parking", name), "#e5c494", "#fc6721"),
          `stroke-width` = 3,
          `stroke-opacity` = 1,
          fill = stroke,
          `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson_styles, "trafford_leisure_centres_styled.geojson")
