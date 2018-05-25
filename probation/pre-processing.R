## Probation offices ##

# Source: Cheshire and Greater Manchester CRC
# Publisher URL: http://www.cgmcrc.co.uk/contact-us/our-offices/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
raw <- read_csv("probation_offices.csv")

# load area lookup ---------------------------
area_lookup <- read_csv("https://www.traffordDataLab.io/spatial_data/lookups/administrative_lookup.csv") %>% 
  select(area_code = lad17cd, area_name = lad17nm) %>% 
  unique()

# tidy data ---------------------------
df <- raw %>% 
  left_join(., area_lookup, by = "area_name")

# match with ONS postcodes ---------------------------
postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/GM_postcodes_2018-02.csv")
df_postcodes <- left_join(df, postcodes, by = "postcode")

# convert to spatial object ---------------------------
sf <- df_postcodes %>%  
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326)

# write data   ---------------------------
write_csv(df_postcodes, "GM_probation_offices.csv")
st_write(sf, "GM_probation_offices.geojson")
