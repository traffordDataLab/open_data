## Jobcentre offices ##

# Source: DWP
# Publisher URL: https://www.gov.uk/government/publications/dwp-jobcentre-register
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(readODS) ; library(sf) 

# load data ---------------------------
raw <- read_ods("dwp-jcp-office-address-register.ods", skip = 1) %>% 
  select(name = `Jobcentre Office`, address = `Office Address`, postcode = Postcode)

postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/GM_postcodes_2018-08.csv")
bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/gm_local_authority_full_resolution.geojson")

# tidy data ---------------------------
df <- raw %>% 
  left_join(., postcodes, by = "postcode") %>% 
  filter(!is.na(lon)) %>% 
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_intersection(., bdy) %>% 
  st_set_geometry(value = NULL)

# style GeoJSON  ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  select(Name = name,
         Address = address,
         Postcode = postcode,
         `Area name` = area_name,
         `Area code` = area_code) %>%
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

# write data  ---------------------------
write_csv(df, "gm_jobcentreplus.csv")
write_csv(filter(df, area_name == "Trafford"), "trafford_jobcentreplus.csv")
st_write(sf, "gm_jobcentreplus.geojson")
st_write(filter(sf, `Area name` == "Trafford"), "trafford_jobcentreplus.geojson")
