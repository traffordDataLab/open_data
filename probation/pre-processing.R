## Probation offices ##

# Source: Cheshire and Greater Manchester CRC
# Publisher URL: http://www.cgmcrc.co.uk/contact-us/our-offices/
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
raw <- read_csv("probation_offices.csv")

area_lookup <- read_csv("https://www.traffordDataLab.io/spatial_data/lookups/administrative_lookup.csv") %>% 
  select(area_code = lad17cd, area_name = lad17nm) %>% 
  unique()

postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/GM_postcodes_2018-02.csv")

# tidy data ---------------------------
df <- raw %>% 
  left_join(., area_lookup, by = "area_name") %>% 
  left_join(df, postcodes, by = "postcode")

# style GeoJSON   ---------------------------
sf <- df %>%  
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326)  %>% 
  select(Name = name,
       Type = type,
       Address = address,
       Postcode = postcode,
       Telephone = telephone,
       `Area name` = area_name,
       `Area code` = area_code) %>%
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

# write data   ---------------------------
write_csv(df, "gm_probation_offices.csv")
st_write(sf, "gm_probation_offices.geojson")
