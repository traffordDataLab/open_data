## This dataset was created by the Trafford Data Lab using our Plotter app.
## Purpose of this script is simply to prepare the raw file and create cleaned CSV and GeoJSON outputs from it.

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load the raw GeoJSON data and select the variables we want ---------------------------
sf <- st_read("CCTV_cameras_trafford_RAW.geojson") %>%
  select(camera_id = cameraId, location = cameraLocation) %>%
  mutate(area_name = "Trafford", area_code = "E0800009")

# extract the coordinates as separate lon and lat variables ---------------------------
coords <- st_coordinates(sf) %>%
  as_tibble() %>%
  select(X, Y) %>%
  rename(lon = X, lat = Y)

# bind the coordinates to the spatial features data frame, removing the geometry ---------------------------
df <- st_set_geometry(sf, NULL) %>%
  bind_cols(coords)

# write out the new spatial file and csv ---------------------------
st_write(sf, "trafford_cctv_cameras.geojson")
write_csv(df, "trafford_cctv_cameras.csv")
