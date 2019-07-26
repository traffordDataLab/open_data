## Car charging points ##

# Source: Open Charge Map
# Publisher URL: https://map.openchargemap.io
# Licence: Creative Commons Attribution-ShareAlike 4.0 International

# load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(httr) ; library(jsonlite)

# retrieve GM local authority vector boundary layer from ONS Open Geography Portal ---------------------------
bdy <- st_read("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_December_2018_Boundaries_UK_BGC/MapServer/0/query?where=lad18nm%20IN%20('Bolton','Bury','Manchester','Oldham','Rochdale','Salford','Stockport','Tameside','Trafford','Wigan')&outFields=lad18cd,lad18nm&outSR=4326&f=geojson")

# submit request to API ---------------------------
request <- GET(url = "https://api.openchargemap.io/v3/poi/?",
               query = list(
                 output = "json",
                 countrycode = "GB",
                 boundingbox = paste0("(", st_bbox(bdy)[2], ",", st_bbox(bdy)[1], "),", "(", st_bbox(bdy)[4], ",", st_bbox(bdy)[3], ")"),
                 opendata = TRUE,
                 compact = FALSE,
                 verbose = TRUE,
                 comments = FALSE,
                 camelcase = TRUE)
               )

# parse the response and convert to a data frame ---------------------------
response <- content(request, as = "text", encoding = "UTF-8") %>%
  fromJSON(flatten = TRUE) %>%
  as_tibble() %>% 
  unnest(connections) 

# convert to spatial data, clip by boundary and rename variables ---------------------------
points <- response %>% 
  st_as_sf(crs = 4326, coords = c("addressInfo.longitude", "addressInfo.latitude"))  %>% 
  st_intersection(bdy) %>% 
  mutate_if(is.character, str_trim) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>% 
  unite(address, c("addressInfo.addressLine1", "addressInfo.addressLine2", "addressInfo.town", "addressInfo.stateOrProvince"), sep = ", ") %>% 
  mutate(address = str_replace_all(address, ", NA", ""),
         address = str_replace_all(address, ", , ", ", "),
         cost = str_replace_all(usageCost, "Â", "")) %>% 
  select(name = addressInfo.title, 
         points = numberOfPoints,
         connection_type = connectionType.title,
         kW = powerKW,
         cost,
         address,
         postcode = addressInfo.postcode,
         operator = operatorInfo.title,
         website = operatorInfo.websiteURL,
         email = operatorInfo.contactEmail,
         updated = dateLastStatusUpdate,
         area_code = lad18cd, 
         area_name = lad18nm, 
         lon, lat)

# check results ---------------------------
plot(st_geometry(bdy))
plot(st_geometry(points), add = TRUE)

# export as CSV ---------------------------
write_csv(st_set_geometry(points, value = NULL), "gm_car_charging_points.csv")
write_csv(filter(st_set_geometry(points, value = NULL), area_name == "Trafford"), "trafford_car_charging_points.csv")

# export as GeoJSON ---------------------------
st_write(points, "gm_car_charging_points.geojson")
st_write(filter(points, area_name == "Trafford"), "trafford_car_charging_points.geojson")