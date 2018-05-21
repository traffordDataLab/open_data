## Fire stations ##

# Source: Ordnance Survey (OS OpenMap – Local)
# Publisher URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-map-local.html
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
sd <- st_read("OS OpenMap Local (ESRI Shape File) SD/data/SD_ImportantBuilding.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
se <- st_read("OS OpenMap Local (ESRI Shape File) SE/data/SE_ImportantBuilding.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
sj <- st_read("OS OpenMap Local (ESRI Shape File) SJ/data/SJ_ImportantBuilding.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
sk <- st_read("OS OpenMap Local (ESRI Shape File) SK/data/SK_ImportantBuilding.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
polygons <- rbind(sd, se, sj, sk)

gm <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/gm_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)
trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)

# filter data ---------------------------
sites <- filter(polygons, CLASSIFICA == "Fire Station")

# intersect data ---------------------------
sf_gm <- st_intersection(sites, gm)
sf_trafford <- st_intersection(sites, trafford)

# check results  ---------------------------
plot(st_geometry(gm))
plot(st_geometry(sf_gm), add = T)

# write geospatial data ---------------------------
st_write(sf_gm, "gm_fire_stations.geojson", driver = "GeoJSON")
st_write(sf_trafford, "trafford_fire_stations.geojson", driver = "GeoJSON")

