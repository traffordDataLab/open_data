## Children's Centres ##

# Source: Department for Education
# Publisher URL: https://get-information-schools.service.gov.uk/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
# NOTE: you will need to download results.csv from the Get Information Schools Service
# 1. Search by Local Authority
# 2. Enter "Trafford", tick "Include open schools only" and choose "Search"
# 3. Expand "Children's Centres" and tick just "Children's Centre"
# 4. Choose link "Download these search results"
# 5. Choose "Full set of data", tick "Include additional data: links" and choose "Select and continue"
# 6. Choose "Data in CSV format" and choose "Select and continue"
# 7. Download the file, unzip and place in the same folder as this script
df <- read_csv("results.csv") %>% 
  # tidy the data and the variable names
  mutate(address = str_replace_all(paste(Street, Locality, Town, sep = ", "), "NA, ", "")) %>%
  select(name = EstablishmentName,
         address,
         postcode = Postcode,
         telephone = TelephoneNum,
         unique_reference_number = URN,
         Easting, Northing)

# convert to a spatial features object and in the process convert the eastings and northings to lon lat ------------------------------------
sf <- df %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]]),
         unique_reference_number = as.integer(unique_reference_number)) # want to ensure that the output is an integer and doesn't get ".0" appended

# write data ---------------------------
write_csv(sf %>% st_set_geometry(value = NULL), "trafford_childrens_centres.csv") # write the CSV without the geometry field

sf %>%
  select(-lon, -lat) %>%  # remove the lon and lat from the properties as they are present in the geometry field
    st_write("trafford_childrens_centres.geojson")  # write out the spatial data file
