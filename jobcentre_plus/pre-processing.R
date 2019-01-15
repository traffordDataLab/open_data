## Jobcentre offices ##

# Source: DWP
# Publisher URL: https://www.gov.uk/government/publications/dwp-jobcentre-register
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(sf) 

# load data ---------------------------
raw <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/770117/dwp-jcp-office-address-register.csv", skip = 1) %>% 
  setNames(tolower(names(.)))

postcodes <- read_csv("http://geoportal.statistics.gov.uk/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>%
  filter(oslaua %in% paste0("E0", seq(8000001, 8000010, 1))) %>% 
  select(postcode = pcds, lon = long, lat)

boundary <- st_read("https://www.trafforddatalab.io/spatial_data/local_authority/2016/gm_local_authority_full_resolution.geojson")

# tidy data ---------------------------
df <- raw %>%
  left_join(., postcodes, by = "postcode") %>%
  filter(!is.na(lon)) %>%
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>%
  st_join(boundary) %>% 
  select(name = `jobcentre office`,
         address = `office address`,
         postcode, area_name, area_code) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>%
  st_set_geometry(value = NULL)

# write data ---------------------------
write_csv(df, "gm_jobcentreplus.csv")
write_csv(filter(df, area_name == "Trafford"), "trafford_jobcentreplus.csv")

# style GeoJSON ---------------------------
sf <- raw %>%
  left_join(., postcodes, by = "postcode") %>%
  filter(!is.na(lon)) %>%
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>%
  st_join(boundary) %>% 
  select(Name = `jobcentre office`,
         Address = `office address`,
         Postcode = postcode, 
         `Area name` = area_name,
         `Area code` = area_code) %>%
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")

st_write(sf, "gm_jobcentreplus.geojson")
write_csv(filter(sf, `Area name` == "Trafford"), "trafford_jobcentreplus.geojson")
