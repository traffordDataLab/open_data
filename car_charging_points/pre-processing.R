## Car charging points ##

# Source: Ordnance Survey (OS OpenMap – Local)
# Publisher URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-map-local.html
# Licence: Open Government Licence

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
sd <- st_read("OS OpenMap Local (ESRI Shape File) SD/data/SD_CarChargingPoint.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
se <- st_read("OS OpenMap Local (ESRI Shape File) SE/data/SE_CarChargingPoint.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
sj <- st_read("OS OpenMap Local (ESRI Shape File) SJ/data/SJ_CarChargingPoint.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
sk <- st_read("OS OpenMap Local (ESRI Shape File) SK/data/SK_CarChargingPoint.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)
points <- rbind(sd, se, sj, sk)

gm <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/gm_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)
trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)

# intersect data ---------------------------
sf_gm <- st_intersection(points, gm)
sf_trafford <- st_intersection(points, trafford)

# check results  ---------------------------
plot(st_geometry(gm))
plot(st_geometry(sf_gm), add = T)

# write geospatial data ---------------------------
st_write(sf_gm, "gm_car_charging_points.geojson", driver = "GeoJSON")
st_write(sf_trafford, "trafford_car_charging_points.geojson", driver = "GeoJSON")

# write tabular data ---------------------------
coords <- st_coordinates(sf_gm)
df_gm <- sf_gm %>%
  st_set_geometry(value = NULL) 
df_gm$long <- coords[,1]
df_gm$lat <- coords[,2]
write_csv(df_gm, "gm_car_charging_points.csv")

coords <- st_coordinates(sf_trafford)
df_trafford <- sf_trafford %>%
  st_set_geometry(value = NULL)
df_trafford$long <- coords[,1]
df_trafford$lat <- coords[,2]
write_csv(df_trafford, "trafford_car_charging_points.csv")

