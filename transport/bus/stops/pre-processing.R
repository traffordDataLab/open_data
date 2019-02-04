## Bus stops in Trafford ##

# Source: NaPTAN, Department for Transport
# Publisher URL: http://naptan.app.dft.gov.uk/datarequest/help
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
# source: "http://naptan.app.dft.gov.uk/DataRequest/Naptan.ashx?format=csv&LA=180"
unzip("NaPTAN180csv.zip", exdir = ".")
file.remove("NaPTAN180csv.zip")

bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

# tidy data ---------------------------
sf <- read_csv("Stops.csv") %>% 
  select(atco_code = ATCOCode, 
         common_name = CommonName, 
         street = Street, 
         BusStopType, Status, Longitude, Latitude) %>% 
  filter(!is.na(BusStopType) & Status == "act") %>% 
  select(-BusStopType, -Status) %>% 
  mutate(street = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(street), perl=TRUE)) %>% 
  st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>% 
  st_intersection(., bdy) %>% 
  select(1:5, lon, lat)

# write data
st_write(sf, "trafford_bus_stops.geojson")
sf %>% 
  st_set_geometry(value = NULL) %>% 
  write_csv("trafford_bus_stops.csv")

# style data
sf %>% 
  rename(`ATCO code` = atco_code,
         `Common name` = common_name,
         Street = street,
         `Area code` = area_code, 
         `Area name` = area_name) %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium") %>% 
  st_write("trafford_bus_stops_styled.geojson")
