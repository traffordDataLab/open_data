## Bus stops in Trafford ##

# Source: NaPTAN, Department for Transport
# Publisher URL: http://naptan.app.dft.gov.uk/datarequest/help
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load and tidy data ---------------------------
# source: "http://naptan.app.dft.gov.uk/DataRequest/Naptan.ashx?format=csv&LA=180"
unzip("data/NaPTAN180csv.zip", exdir = "data")
file.remove("data/NaPTAN180csv.zip")

bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

sf <- read_csv("data/Stops.csv") %>% 
  select(atco_code = ATCOCode, 
         common_name = CommonName, 
         street = Street, 
         BusStopType, Status, Longitude, Latitude) %>% 
  filter(!is.na(BusStopType) & Status == "act") %>% 
  select(-BusStopType, -Status) %>% 
  st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>% 
  st_intersection(., bdy) %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

# write data
st_write(sf, "trafford_bus_stops.geojson")
