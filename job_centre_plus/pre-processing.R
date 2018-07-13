## Jobcentre offices ##
# Source: DWP
# Publisher URL: https://www.gov.uk/government/publications/dwp-jobcentre-register
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(readODS) ; library(sf) 

# load data ---------------------------
df <- read_ods("dwp-jcp-office-address-register.ods", skip = 1) %>% 
  select(name = `Jobcentre Office`, address = `Office Address`, postcode = Postcode)

# load local authorities ---------------------------
la <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/gm_local_authority_full_resolution.geojson") %>% 
  select(area_code, area_name)

# match with ONS postcodes ---------------------------
postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/GM_postcodes_2018-02.csv")
df_postcodes <- left_join(df, postcodes, by = "postcode")

# convert to spatial object and creat spatial join ---------------------------
sf <- df_postcodes %>%  
  filter(!is.na(lat)) %>%
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_join(la, join = st_within, left = FALSE)

# write data   ---------------------------
write_csv(st_set_geometry(sf, value = NULL), "jobcentreplus_gm.csv")
st_write(sf, "jobcentreplus_gm.geojson")

# style geospatial data ---------------------------
filter(sf, area_name == "Trafford") %>% 
  select(-area_code, -area_name) %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium") %>% 
  st_write("jobcentreplus_trafford.styled.geojson.geojson")
