## Script to tidy up data created from a GeoJSON to CSV conversion performed by http://www.convertcsv.com/geojson-to-csv.htm

# Load in the required packages
library(tidyverse)

# Read the raw 
cctv_raw <- read_csv("CCTV_cameras_trafford_raw.csv")

# Select the required columns in the required order from the raw data
cctv_clean <- select(cctv_raw, featureNum, featureAlias, cameraId, cameraLocation, latitude, longitude)

# Create the final CSV output
write_csv(cctv_clean, "CCTV_cameras_trafford.csv")