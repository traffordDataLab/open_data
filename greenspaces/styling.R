## Styling features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read data ---------------------------
geojson <- st_read("http://trafforddatalab.io/spatial_data/greenspaces/trafford_greenspace_sites.geojson")

# apply styles ---------------------------
geojson_styles <- geojson %>% 
  mutate(stroke = 
           case_when(
             site_type == "Allotments Or Community Growing Spaces" ~ "#66c2a5",
             site_type == "Golf Course" ~ "#fc8d62",
             site_type == "Play Space" ~ "#8da0cb",
             site_type == "Playing Field" ~ "#e78ac3",
             site_type == "Public Park Or Garden" ~ "#a6d854",
             site_type == "Religious Ground and Cemeteries" ~ "#ffd92f",
             site_type == "Sports" ~ "#e5c494"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(geojson_styles, "trafford_greenspace_sites_styled.geojson")
