## Care homes ##
# Source: Care Quality Commission
# Publisher URL: http://www.cqc.org.uk/about-us/transparency/using-cqc-data
# Licence: Open Government Licence

# load packages ---------------------------
library(sf) ; library(tidyverse) ; library(ggmap) ; library(sf)

# load data ---------------------------
cqc <- read_csv("http://www.cqc.org.uk/sites/default/files/21_March_2018_CQC_directory.csv", skip = 4, col_names = TRUE) %>% 
  setNames(tolower(names(.)))

# filter data ---------------------------
df <- filter(cqc, `service types` %in% c("Nursing homes", "Residential homes") & 
               `local authority` == "Trafford") %>%
  select(name, type = `service types`, address, postcode, area_name = `local authority`)

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

# write data  ---------------------------
write_csv(df_geocoded, "trafford_care_homes.csv")
df_geocoded %>%  
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_write("trafford_care_homes.geojson")



