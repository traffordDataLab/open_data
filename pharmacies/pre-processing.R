## Pharmacies in Trafford ##

# Source: Trafford Council
# Publisher URL: http://www.trafford.gov.uk/about-your-council/children-families-and-wellbeing/children-families-and-wellbeing.aspx
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(sf)

# load data ---------------------------
df <- read_csv("trafford_pharmacies.csv")

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
write_csv(st_set_geometry(sf, value = NULL), "trafford_pharmacies.csv")
st_write(sf, "trafford_pharmacies.geojson")





