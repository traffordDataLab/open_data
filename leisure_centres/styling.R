## Add styling to GeoJSON features ##

# load packages ---------------------------
library(tidyverse) ; library(sf)

# read data ---------------------------
geojson <- st_read("trafford_leisure_centres.geojson") %>%
  # capitalise the first letter of the variable names to make the presentation nicer
  rename(Name = name, Address = address, Postcode = postcode, Telephone = telephone, `Opening hours` = opening_hours, Facilities = facilities)

# apply styles ---------------------------
#   - different colour depending if the shape is a car park or a leisure centre, based on the name
geojson_styles <- geojson %>% 
  mutate(stroke = 
          if_else(grepl("\\b.*?Parking", Name), "#e5c494", "#fc6721"),
          `stroke-width` = 3,
          `stroke-opacity` = 1,
          fill = stroke,
          `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson_styles, "trafford_leisure_centres_styled.geojson")
