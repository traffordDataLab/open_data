## Bus stops in Trafford ##

# Source: Transport for Greater Manchester
# Publisher URL: https://data.gov.uk/dataset/05252e3a-acdf-428b-9314-80ac7b17ab76/gm-bus-stopping-points
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
raw <- read_csv("http://odata.tfgm.com/opendata/downloads/TfGMStoppingPoints.csv")

# manipulate data ---------------------------
df <- raw %>% 
  select(atco_code = AtcoCode, stop_type = StopType, street = Street, Longitude, Latitude) %>% 
  mutate(street = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(street), perl=TRUE))

# convert to geospatial data ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("Longitude", "Latitude")) %>% 
  st_set_crs(4326)

# load boundary layer ---------------------------
bdy <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/ward/2017/trafford_ward_full_resolution.geojson") %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  select(area_code, area_name)

# run spatial join ---------------------------
sf_trafford <- st_join(sf, bdy, join = st_within, left = FALSE)

# check results ---------------------------
plot(st_geometry(bdy))
plot(st_geometry(sf_trafford), col = "blue", add = TRUE)

# extract the coordinates ---------------------------
coords <- st_coordinates(sf_trafford)

# add coordinates to dataframe ---------------------------
df_trafford <- sf_trafford %>%
  st_set_geometry(value = NULL)
df_trafford$long <- coords[,1]
df_trafford$lat <- coords[,2]

# write data   ---------------------------
write_csv(df_trafford, "trafford_bus_stops.csv")
st_write(sf_trafford, "trafford_bus_stops.geojson")
