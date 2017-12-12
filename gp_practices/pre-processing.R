## GP Practices ##
# Source: Care Quality Commission
# Publisher URL: http://www.cqc.org.uk/about-us/transparency/using-cqc-data
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(tmaptools) ; library(sf)

# load data ---------------------------
df <- read_csv("http://www.cqc.org.uk/sites/default/files/06_December_2017_CQC_directory.csv", skip = 4, col_names = TRUE) %>% 
  # set variable names to lower case
  setNames(tolower(names(.)))

# tidy data ---------------------------
df <- df %>% 
  # filter by GP
  filter(`service types` == "Doctors/GPs" | `service types` == "Doctors/GPs|Doctors/GPs") %>% 
  # select and rename variables
  select(name, address, postcode, lad16nm = `local authority`) %>% 
  # filter by GM local authority
  filter(lad16nm %in% c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")) 
  
# geocode data (OSM Nominatim API) ---------------------------
df$location <- paste(gsub(",.*$", "", df$address), df$postcode, sep = ", ")
geocodes <- geocode_OSM(df$location, as.data.frame = TRUE) %>% 
  distinct(query, .keep_all = TRUE) %>% 
  select(query, lat, lon)
df_matches <- left_join(df, geocodes, by = c("location" = "query"))
df1 <- na.omit(df_matches) %>% 
  mutate(precision = "Address and postcode") %>% 
  select(-location)

# geocode unmatched rows with postcodes only
df_ungeocoded <- filter(df_matches, is.na(lon)) %>% select(-lat, -lon)
geocodes <- geocode_OSM(df_ungeocoded$postcode, as.data.frame = TRUE) %>% 
  distinct(query, .keep_all = TRUE) %>% 
  select(query, lat, lon)
df_matches <- left_join(df_ungeocoded, as.data.frame(geocodes), by = c("postcode" = "query"))
df2 <- na.omit(df_matches)  %>% 
  mutate(precision = "Postcode") %>% 
  select(-location)

# row bind geocoded results
df_geocoded <- rbind(df1, df2)
round(nrow(df_geocoded) / nrow(df) * 100, 1) # geocode hit rate

# convert to spatial object ---------------------------
df_sf <- df_geocoded %>%  
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326)
plot(st_geometry(df_sf))

# load boundary layer ---------------------------
bdy <- st_read("https://github.com/traffordDataLab/boundaries/raw/master/GMCA.geojson") %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  select(-everything())

# plot data  ---------------------------
plot(st_geometry(bdy))
plot(st_geometry(df_sf), col = "red", add = TRUE)

# clip data within boundary ---------------------------
df_sf_clipped <- st_join(df_sf, bdy, join = st_within, left = FALSE)
plot(st_geometry(bdy))
plot(st_geometry(df_sf_clipped), col = "blue", add = TRUE)

# write data   ---------------------------
write_csv(filter(df_geocoded, name %in% pull(df_sf_clipped, name)), "gp_practices.csv")
st_write(df_sf_clipped, "gp_practices.geojson")
