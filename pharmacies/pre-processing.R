## Pharmacies in Trafford ##
# Source: Trafford Council
# Publisher URL: http://www.trafford.gov.uk/about-your-council/children-families-and-wellbeing/children-families-and-wellbeing.aspx
# Licence: Open Government Licence

# Notes: addresses that could not be geocoded at the "Address and postcode" level were manually geocoded

# load libraries
library(tidyverse) ; library(ggmap) ; library(sf)

# load data ---------------------------
df <- read_csv("pharmacy_providers_2017-19.csv")

# geocode data using Google Maps API ---------------------------
df <- mutate(df, location = paste(provider, address, postcode, "United Kingdom", sep = ", "))
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

# export for manual geocoding
write_csv(df_geocoded, "manual_geocoding.csv")

# write data  ---------------------------
df_final <- read_csv("manual_geocoding.csv")

write_csv(df_final, "trafford_pharmacies.csv")

df_final %>%  
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_write("trafford_pharmacies.geojson")







