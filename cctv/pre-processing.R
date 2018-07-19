## Tidy up data created from a GeoJSON to CSV conversion performed by http://www.convertcsv.com/geojson-to-csv.htm
## Produces cleaned CSV and GeoJSON outputs and a styled GeoJSON output for use in the Lab's Explore application

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load the raw data ---------------------------
df_csv_raw <- read_csv("CCTV_cameras_trafford_raw.csv")
sf_geojson_raw <- st_read("CCTV_cameras_trafford_RAW.geojson")

# select the required columns in the required order from the raw CSV data ---------------------------
df_csv_clean <- select(df_csv_raw, cameraId, cameraLocation, longitude, latitude) %>%
  rename(camera_id = cameraId, location = cameraLocation)

# clean the raw geojson ---------------------------
sf_geojson_clean <- select(sf_geojson_raw, -featureNum, -featureAlias) %>%
  rename(camera_id = cameraId, location = cameraLocation)

# create the cleaned outputs ---------------------------
write_csv(df_csv_clean, "CCTV_cameras_trafford.csv")
st_write(sf_geojson_clean, "CCTV_cameras_trafford.geojson")

# create a new spatial features object from the cleaned geojson, capitalising all the variables that the user will see in Explore ---------------------------
sf_styled_geojson <- geojson_style(sf_geojson_clean,
                                   color = "#fc6721",
                                   size = "medium") %>%   
  rename(`marker-color` = marker.color,
         `marker-size` = marker.size,
         `Camera ID` = camera_id,
         Location = location)

# save the styled version of the geojson
st_write(sf_styled_geojson, "CCTV_cameras_trafford_styled.geojson")
