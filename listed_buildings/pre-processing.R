## Listed buildings ##

# Source: Historic England (English Heritage)
# Publisher URL: https://services.historicengland.org.uk/NMRDataDownload/default.aspx
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
sites <- st_read("ListedBuildings_09March2018.shp") %>% 
  st_as_sf(crs = 27700, coords = c("Easting", "Northing")) %>% 
  st_transform(4326)

trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326)

# intersect data ---------------------------
trafford_sites <- st_intersection(sites, trafford)

# tidy data ---------------------------
library(stringr)
trafford_sites <- trafford_sites %>% 
  mutate(Name = str_to_title(Name))

# check data  ---------------------------
library(leaflet)
leaflet(data = trafford_sites) %>% 
  setView(-2.35533522781156, 53.419025498197, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = trafford, fillColor = "#757575", weight = 1.5, dashArray = "3", color = "#212121", fillOpacity = 0.3) %>%
  addMarkers(label = ~as.character(Name), options = markerOptions(riseOnHover = TRUE, opacity = 0.75)) %>% 
  addControl("<strong>Listed Buildings in Trafford</strong><br /><em>Source: Historic England (English Heritage)</em>",
             position = 'topright')

# write data ---------------------------
st_write(trafford_sites, "trafford_listed_buildings.geojson", driver = "GeoJSON")
trafford_sites %>% 
  st_set_geometry(NULL) %>%
  write_csv("trafford_listed_buildings.csv")


