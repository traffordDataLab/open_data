## Fast food outlets ##
# Source: Food Standards Agency
# Publisher URL: http://ratings.food.gov.uk/open-data/en-GB
# Licence: Open Government Licence

# load the necessary R packages -------------------------------------------
library(tidyverse) ; library(httr) ; library(jsonlite) ; library(sf)

# request a list of local authorities -------------------------------------------
la <- GET(url = "http://api.ratings.food.gov.uk/Authorities/basic", 
                   add_headers("x-api-version" = "2")) %>% 
  content(as = "text", encoding = "UTF-8") %>% 
  fromJSON(flatten = TRUE) %>% 
  pluck("authorities") %>% 
  as_tibble()

# subset local authorities in Greater Manchester -------------------------------------------
gm <- filter(la, Name %in% c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale", "Salford", 
                             "Stockport", "Tameside", "Trafford", "Wigan"))

# request a list of establishments for each local authority -------------------------------------------
progress <- progress_estimated(length(gm$LocalAuthorityId))
response <- map_df(gm$LocalAuthorityId, ~{
  
  progress$tick()$print()
  
  fetch <- GET(url = "http://api.ratings.food.gov.uk/Establishments", 
                  query = list(
                    localAuthorityId = .x,
                    pageNumber = 1,
                    pageSize = 5000),
                  add_headers("x-api-version" = "2"))
  
  content(fetch, as = "text", encoding = "UTF-8") %>% 
    fromJSON(flatten = TRUE) %>% 
    pluck("establishments") %>% 
    as_tibble()
  
}, .id = "localAuthorityId")

# tidy the parsed data frame -------------------------------------------
df <- response %>% 
  mutate_all(funs(replace(., . == '', NA))) %>% # replace missing values with NA
  select(name = BusinessName,
         type = BusinessType,
         address1 = AddressLine1,
         address2 = AddressLine2,
         address3 = AddressLine3,
         address4 = AddressLine4,
         postcode = PostCode,
         area_name = LocalAuthorityName,
         long = geocode.longitude,
         lat = geocode.latitude) %>% 
  unite(address, address1, address2, address3, address4, remove = TRUE, sep = ", ") %>% 
  mutate(address = str_replace_all(address, "NA,", ""),
         address = str_replace_all(address, ", NA", ""),
         long = as.numeric(long),
         lat = as.numeric(lat))

# subset fast food outlets -------------------------------------------
sub_df <- filter(df, type ==  "Takeaway/sandwich shop") %>% 
  select(-type)

# convert to a spatial object ---------------------------
sf <- sub_df %>% 
  filter(!is.na(long)) %>% # remove fast food outlets without coordinates
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326)

# write tabular data ---------------------------
sf %>%
  cbind(., st_coordinates(.)) %>%
  rename(long = X, lat = Y) %>% 
  st_set_geometry(NULL) %>% 
  write_csv("gm_fast_food_outlets.csv")

filter(sf, area_name == "Trafford") %>% 
  cbind(., st_coordinates(.)) %>%
  rename(long = X, lat = Y) %>% 
  st_set_geometry(NULL) %>% 
  write_csv("trafford_fast_food_outlets.csv")

# write geospatial data ---------------------------
st_write(sf, "gm_fast_food_outlets.geojson")

filter(sf, area_name == "Trafford") %>% 
  st_write("trafford_fast_food_outlets.geojson")

# style geospatial data ---------------------------
filter(sf, area_name == "Trafford") %>% 
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium") %>% 
  st_write("trafford_fast_food_outlets_styled.geojson")
