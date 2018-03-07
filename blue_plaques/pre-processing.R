## Blue plaques ##

# Source: Open Plaques
# Publisher URL: http://openplaques.org/
# Licence: Public Domain Dedication and License 1.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
plaques <- read_csv("https://s3.eu-west-2.amazonaws.com/openplaques/open-plaques-United-Kingdom-2017-11-08.csv") %>% 
  filter(!is.na(latitude)) %>% 
  st_as_sf(crs = 4326, coords = c("longitude", "latitude"))

trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  select(area_code, area_name)

# intersect data ---------------------------
trafford_plaques <- st_intersection(plaques, trafford)

# tidy data ---------------------------
trafford_plaques <- trafford_plaques %>% 
  select(id, title, inscription, erected, number_of_subjects,
         lead_subject_name, lead_subject_born_in, lead_subject_died_in, lead_subject_type,
         lead_subject_wikipedia, main_photo, address, area_name, area_code)

# check data  ---------------------------
library(leaflet)
popup = paste0("<a href='",  trafford_plaques$main_photo, "' target='_blank'><img style = 'width: 150px;' src = ", trafford_plaques$main_photo, ">",
                       "</a><br/><small>", trafford_plaques$title, "</small>")


leaflet(data = trafford_plaques) %>% 
  setView(-2.35533522781156, 53.419025498197, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = trafford, fillColor = "#757575", weight = 1.5, dashArray = "3", color = "#212121", fillOpacity = 0.3) %>%
  addMarkers(label = ~as.character(title), popup = popup, options = markerOptions(riseOnHover = TRUE, opacity = 0.75)) %>% 
  addControl("<strong>Blue Plaques in Trafford</strong><br /><em>Source: Open Plaques</em>",
             position = 'topright')

# write data ---------------------------
st_write(trafford_plaques, "blue_plaques_trafford.geojson", driver = "GeoJSON")
trafford_plaques %>%
  cbind(., st_coordinates(.)) %>%
  rename(long = X, lat = Y) %>% 
  st_set_geometry(NULL) %>%
  write_csv("blue_plaques_trafford.csv")

