## Libraries ##

# Original Source: Department for Digital, Culture, Media & Sport
# Original Publisher URL: https://www.gov.uk/government/publications/public-libraries-in-england-basic-dataset
# Dataset was then reviewed and amended where required by each of the Local Authorities in Greater Manchester
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ;  library(sf)

# load the csv data for GM -----------------
df <- read_csv("gm_libraries.csv")

# style GeoJSON  ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("lon", "lat")) %>%
  st_set_crs(4326) %>%
  rename(Name = name,
         Address = address,
         Postcode = postcode,
         Type = type,
         Email = email,
         Website = website,
         `Area name` = area_name,
         `Area code` = area_code) %>%
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

# write data  ---------------------------
write_csv(filter(df, area_name == "Trafford"), "trafford_libraries.csv")
st_write(sf, "gm_libraries.geojson")
st_write(filter(sf, `Area name` == "Trafford"), "trafford_libraries.geojson")
