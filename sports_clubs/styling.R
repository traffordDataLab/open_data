## Add styling to GeoJSON features ##

# load packages ---------------------------
library(tidyverse) ; library(sf) ; library(geojsonio)

# read data ---------------------------
geojson <- st_read("sports_clubs.geojson") %>% 
  rename(Name = name, Category = category, Address = address, Postcode = postcode)

# apply styles ---------------------------
geojson_styles <- geojson_style(geojson,
                                color = "#fc6721",
                                size = "medium") %>%   
  rename(`marker-color` = marker.color,
         `marker-size` = marker.size)

# write data ---------------------------
st_write(geojson_styles, "sports_clubs_styled.geojson")
