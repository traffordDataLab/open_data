## GP Practices ##
# Source: Care Quality Commission
# Publisher URL: http://www.cqc.org.uk/about-us/transparency/using-cqc-data
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(sf)

# load data ---------------------------
raw <- read_csv("http://www.cqc.org.uk/sites/default/files/14_May_2018_CQC_directory.csv", skip = 4, col_names = TRUE)

# load area lookup ---------------------------
area_lookup <- read_csv("https://www.traffordDataLab.io/spatial_data/lookups/administrative_lookup.csv") %>% 
  select(area_code = lad17cd, area_name = lad17nm) %>% 
  unique()

# tidy data ---------------------------
df <- raw %>% 
  setNames(tolower(names(.))) %>% 
  filter(`service types` == "Doctors/GPs" | `service types` == "Doctors/GPs|Doctors/GPs") %>% 
  select(name, alias = `also known as`, cqc_id = `cqc provider id (for office use only)`, tel = `phone number`,
         address, postcode, area_name = `local authority`) %>% 
  filter(area_name %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) %>% 
  left_join(., area_lookup, by = "area_name")

# match with ONS postcodes ---------------------------
postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/GM_postcodes_2018-02.csv")
df_postcodes <- left_join(df, postcodes, by = "postcode")

# convert to spatial object ---------------------------
sf <- df_postcodes %>%  
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326)

# write data   ---------------------------
write_csv(df_postcodes, "GM_general_practices.csv")
st_write(sf, "GM_general_practices.geojson")

write_csv(filter(df_postcodes, area_name == "Trafford"), "trafford_general_practices.csv")
st_write(filter(sf, area_name == "Trafford"), "trafford_general_practices.geojson")
