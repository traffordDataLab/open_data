## Food banks in GM ##
# Source: GM Poverty Action
# Publisher URL: http://www.gmpovertyaction.org/maps/
# Licence: https://twitter.com/GMPovertyAction/status/931462172206620672

# Notes: 
# The KML file was converted into a CSV using QGIS
# Sites that were geocoded by postcode only, wrongly geocoded or retrieved nil results using the Google Maps API were manually geocoded

# load libraries
library(tidyverse) ; library(ggmap) ; library(sf)

# load data ---------------------------
df <- read_csv("GM Poverty Action Emergency Food Providers map January 2017.csv", col_names = TRUE)

# geocode data using Google Maps API ---------------------------
df <- mutate(df, location = paste(name, address, postcode, "United Kingdom", sep = ", "))
geocodes <- geocode(df$location)
df_matches <- cbind(df, geocodes)
df1 <- na.omit(df_matches) %>% 
  mutate(precision = "Address and postcode") %>% 
  select(-location)

# geocode unmatched rows with address and postcodes ---------------------------
df_ungeocoded <- filter(df_matches, is.na(lon)) %>% 
  mutate(location = paste(address, postcode, "United Kingdom", sep = ", ")) %>% 
  select(-lat, -lon)
geocodes <- geocode(df_ungeocoded$location)
df_matches <- cbind(df_ungeocoded, geocodes)
df2 <- na.omit(df_matches)  %>% 
  mutate(precision = "Address and postcode") %>% 
  select(-location)

# geocode unmatched rows with postcodes only ---------------------------
df_ungeocoded <- filter(df_matches, is.na(lon)) %>% 
  mutate(location = paste(postcode, "United Kingdom", sep = ", ")) %>% 
  select(-lat, -lon)
geocodes <- geocode(df_ungeocoded$location)
df_matches <- cbind(df_ungeocoded, geocodes)
df3 <- na.omit(df_matches)  %>% 
  mutate(precision = "Postcode") %>% 
  select(-location)

# row bind geocoded results ---------------------------
df_ungeocoded <- filter(df_matches, is.na(lon)) %>% 
  mutate(precision = "Manually geocoded") %>% 
  select(-location)
df_geocoded <- rbind(df1, df2, df3, df_ungeocoded)

# geocode hit rate ---------------------------
filter(df_geocoded, precision != "Manually geocoded") %>% 
  summarise(hit_rate = round(nrow(.) / nrow(df) * 100, 1))

# manual geocoding ---------------------------

# write geospatial data ---------------------------
sf_geocoded <- df_geocoded %>%  
  filter(!is.na(lon)) %>%
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326)

wards <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/lookups/administrative_lookup.geojson") %>% 
  st_transform(crs = 4326) %>% 
  select(wd17cd, wd17nm, lad17cd, lad17nm)

sf_geocoded <- st_join(sf_geocoded, wards, join = st_within, left = FALSE)

st_write(sf_geocoded, "GM_food_banks.geojson")

# write data  ---------------------------
sf_geocoded %>%
  st_set_geometry(value = NULL) %>% 
  write_csv("GM_food_banks.csv")