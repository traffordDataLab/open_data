## Rail stops in Trafford ##

# Source: Transport for Greater Manchester
# Publisher URL: https://data.gov.uk/dataset/8faea7ee-eb7d-43dd-b1d4-f01aac4c44d3/metrolink-stops-and-rail-stations
# Licence: Open Government Licence 3.0

# Data: 2022-11-11
# Last Updated: 2023-09-27

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
raw <- read_csv("http://odata.tfgm.com/opendata/downloads/TfGMMetroRailStops.csv")

# manipulate data ---------------------------
df <- raw %>%
  filter(NETTYP == "R") %>%
  select(name = RSTNAM, easting = GMGRFE, northing = GMGRFN) %>% 
  mutate(name = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(name), perl=TRUE))

# convert to geospatial data ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("easting", "northing")) %>% 
  st_set_crs(27700) %>% 
  st_transform(4326)

# load boundary layer ---------------------------
bdy <- st_read("https://www.trafforddatalab.io/spatial_data/ward/2023/trafford_ward_full_resolution.geojson") %>% 
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
write_csv(df_trafford, "trafford_train_stops.csv")
st_write(sf_trafford, "trafford_train_stops.geojson")
