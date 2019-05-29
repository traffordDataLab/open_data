# Green Flag Awards #

# Source: Ministry of Housing, Communities & Local Government / Keep Britain Tidy
# Publisher URL: http://www.greenflagaward.org.uk
# Licence: Open Government Licence v3.0

library(tidyverse) ; library(httr) ; library(jsonlite) ; library(purrr) ; library(sf)

bdy <- st_read("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_December_2018_Boundaries_UK_BGC/MapServer/0/query?where=lad18nm%20IN%20(%27Bolton%27,%27Bury%27,%27Manchester%27,%27Oldham%27,%27Rochdale%27,%27Salford%27,%27Stockport%27,%27Tameside%27,%27Trafford%27,%27Wigan%27)&outFields=lad18cd,lad18nm&outSR=4326&f=geojson") %>% 
  select(area_code = lad18cd, area_name = lad18nm)

r <- POST("http://www.greenflagaward.org.uk/umbraco/surface/parks/getparks/")
sf <- content(r, as = "text", encoding = "UTF-8") %>% 
  fromJSON(flatten = TRUE) %>% 
  purrr::pluck("Parks") %>% 
  as_tibble() %>% 
  filter(WonGreenFlagAward == TRUE) %>% 
  mutate(name = str_trim(Title),
         website = str_c("http://www.greenflagaward.org.uk/park-summary/?park=", ID),
         lon = as.numeric(as.character(Longitude)),
         lat = as.numeric(as.character(Latitude))) %>% 
  select(name, website, lon, lat) %>% 
  arrange(name) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>% 
  st_join(bdy, join = st_within) %>% 
  filter(!is.na(area_code)) %>% 
  select(name, website, area_code, area_name) 

st_write(sf, "green_flags.geojson")

sf %>% 
  cbind(st_coordinates(.)) %>%
  rename(lon = X, lat = Y) %>% 
  st_set_geometry(NULL) %>% 
  write_csv("green_flags.csv")
