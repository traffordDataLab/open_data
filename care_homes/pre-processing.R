## Care homes ##

# Source: Care Quality Commission
# Publisher URL: http://www.cqc.org.uk/about-us/transparency/using-cqc-data
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load postcode data
postcodes <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/postcodes/trafford_postcodes.csv") %>%
  select(postcode, lon, lat)

# load and tidy data ---------------------------
df <- read_csv("https://www.cqc.org.uk/sites/default/files/2022-06/15_June_2022_CQC_directory.csv", skip = 4) %>% 
  filter(str_detect(`Service types`, "Nursing homes|Residential homes") & 
         `Local authority` == "Trafford") %>%
  select(name = Name, cqc_id = `CQC Location ID (for office use only)`, type = `Service types`, 
         address = Address, postcode = Postcode, telephone = `Phone number`, website = `Service's website (if available)`, 
         provider = `Provider name`, inspection_date = `Date of latest check`, `cqc_webpage` = `Location URL`,
         area_name = `Local authority`) %>% 
  mutate(inspection_date = as.POSIXct(inspection_date, format = "%d/%b/%Y - %H:%M", tz = Sys.timezone()),
         inspection_date = as.Date(inspection_date),
         area_code = "E0800009") %>% 
  arrange(name) %>% 
  left_join(., postcodes, by = "postcode")

# create spatial object  ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("lon", "lat")) %>%
  st_set_crs(4326) 

# write data  ---------------------------
write_csv(df, "trafford_care_homes.csv")
st_write(sf, "trafford_care_homes.geojson")
