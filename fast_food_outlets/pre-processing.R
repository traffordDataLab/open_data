## Fast food outlets ##
# Source: Food Standards Agency (FSA) Food Hygiene Rating Scheme (FHRS)
# Publisher URL: http://ratings.food.gov.uk/open-data/en-GB
# Licence: Open Government Licence

# The inclusion and exclusion criteria for matching are derived from the Public Health England's density of fast food outlets map (2018)
# https://www.gov.uk/government/publications/fast-food-outlets-density-by-local-authority-in-england
# Note that the '8 major chains' were not stated in the PHE methodology.

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

# 1: filter by type
takeaway <- filter(df, type ==  "Takeaway/sandwich shop")    

# 2: filter by search terms
keywords <- c("burger", "chicken", "chip", "fish bar", "pizza", "kebab", "india", "china", "chinese")
terms <- filter(df, type %in% c("Mobile caterer", 
                                 "Other catering premises",
                                 "Restaurant/Cafe/Canteen"),
                 str_detect(name, regex(paste(keywords, collapse = ".|"), ignore_case = T)))

# 3: filter by fast food chains
keywords <- c("McDonald", "KFC", "Subway", "Burger King", "Domino", "Pret a Manger", "Wimpy", "Chicken Cottage")
chains <- filter(df, type %in% c("Other catering premises", 
                               "Restaurant/Cafe/Canteen",
                               "Retailers - other",
                               "Retailers - supermarkets/hypermarkets",
                               "School/college/university"),
                 str_detect(name, regex(paste(keywords, collapse = ".|"), ignore_case = T)))            

sub_df <- bind_rows(takeaway, terms, chains)     

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
            
            
            
            
