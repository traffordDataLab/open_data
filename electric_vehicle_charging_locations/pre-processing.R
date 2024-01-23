## Electric vehicle charging locations ##

# Source: Open Charge Map
# Publisher URL: https://map.openchargemap.io
# Licence: Creative Commons Attribution-ShareAlike 4.0 International

library(tidyverse) ; library(sf) ; library(httr) ; library(jsonlite) ; library(janitor)

# Create a string object with the name of your local authority
id <- "Trafford"

# Insert the key for the openchargemap API
api_key = ''

# Retrieve the local authority boundary
# Source: ONS Open Geography Portal
la <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2023_UK_BGC_V2/FeatureServer/0/query?where=LAD23NM%20%3D%20'", URLencode(toupper(id), reserved = TRUE), "'&outFields=LAD23CD,LAD23NM&outSR=4326&f=geojson"), quiet = TRUE) %>% 
  select(area_code = LAD23CD, area_name = LAD23NM) 

# Submit request to API
request <- GET(url = paste0("https://api.openchargemap.io/v3/poi/?key=", api_key),
               query = list(
                 output = "json",
                 countrycode = "GB",
                 boundingbox = paste0("(", st_bbox(la)[2], ",", st_bbox(la)[1], "),", "(", st_bbox(la)[4], ",", st_bbox(la)[3], ")"),
                 opendata = TRUE,
                 compact = FALSE,
                 verbose = TRUE,
                 comments = FALSE,
                 camelcase = TRUE)
)

# Parse the response and convert to a data frame
response <- content(request, as = "text", encoding = "UTF-8") %>%
  fromJSON(flatten = TRUE) %>%
  as_tibble(.name_repair = make_clean_names)   %>%
  select(-id) %>% 
  unnest(connections) 

# Convert to spatial data, clip by boundary and rename variables
sf <- response %>% 
  st_as_sf(crs = 4326, coords = c("address_info_longitude", "address_info_latitude"))  %>% 
  st_intersection(la) %>% 
  mutate_if(is.character, str_trim) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>% 
  unite(address, c("address_info_address_line1", "address_info_address_line2", "address_info_town", "address_info_state_or_province"), sep = ", ") %>% 
  mutate(address = str_replace_all(address, ", NA", ""),
         address = str_replace_all(address, ", , ", ", "),
         cost = str_replace_all(usage_cost, "Â", "")) %>% 
  select(name = address_info_title, 
         points = number_of_points,
         connection_type = connectionType.title,
         kW = powerKW,
         cost,
         address,
         postcode = address_info_postcode,
         operator = operator_info_title,
         website = operator_info_website_url,
         email = operator_info_contact_email,
         updated = date_last_status_update,
         lon, lat) %>%
  arrange(desc(updated))

# Write results
st_write(sf, "trafford_electric_vehicle_charging_locations.geojson")
write_csv(st_set_geometry(sf, value = NULL), "trafford_electric_vehicle_charging_locations.csv")
