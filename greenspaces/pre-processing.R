## OS Green Space ##

# load necessary packages ---------------------------
library(sf) ; library(tidyverse)

# load geospatial data ---------------------------

# Greater Manchester local authority boundaries
gm <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/gm_local_authority_full_resolution.geojson") %>% 
  select(-lon, -lat)
st_crs(gm)

# OS Green Spaces: sites
sites <- read_sf("data/GB_GreenspaceSite.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_zm() %>% 
  mutate(site_type = factor(function.),
         site_name = factor(distName1)) %>% 
  select(id, site_type, site_name)
st_crs(sites)

# OS Green Spaces: access points
access <- read_sf("data/GB_AccessPoint.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_zm() %>% 
  select(id, access_type = accessType)
st_crs(access)

# intersect data ---------------------------
sites_gm <- st_intersection(sites, gm)  %>% 
  mutate(site_type = fct_recode(site_type,
                    "Sports" = "Bowling Green",
                    "Sports" = "Other Sports Facility",
                    "Sports" = "Tennis Court",
                    "Religious Ground and Cemetries" = "Religious Grounds",
                    "Religious Ground and Cemetries" = "Cemetery")) %>% 
  select(area_code, area_name, id, site_type, site_name)

access_gm <- st_intersection(access, gm)  %>% 
  select(area_code, area_name, id, access_type)

# check results ---------------------------
library(leaflet)
site_pal <- colorFactor(c("#a6cee3", "#1f78b4", "#b2df8a", "#33a02c", "#fb9a99", "#e31a1c", "#fdbf6f"), 
                   domain = c("Public Park Or Garden", "Play Space", "Playing Field", "Sports", "Golf Course",
                              "Allotments Or Community Growing Spaces", "Religious Ground and Cemetries"),
                   ordered = TRUE)

leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = filter(sites_gm, area_name == "Trafford"), 
              fillColor = ~site_pal(site_type), fillOpacity = 0.7,
              weight = 0.5, opacity = 1, color = "white", label = ~site_type,
              highlight = highlightOptions(weight = 2, color = "#FFFF00", fillOpacity = 0.7, bringToFront = FALSE),
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")) %>% 
  addCircleMarkers(data = filter(access_gm, area_name == "Trafford"), 
                 radius = 3, 
                 color = "black", fillOpacity = 0.8,
                 stroke = FALSE,
                 label = ~access_type)

# write data ---------------------------
st_write(sites_gm, "gm_greenspace_sites.geojson", driver = "GeoJSON")
st_write(filter(sites_gm, area_name == "Trafford"), "trafford_greenspace_sites.geojson", driver = "GeoJSON")

st_write(access_gm, "gm_greenspace_access_points.geojson", driver = "GeoJSON")
st_write(filter(access_gm, area_name == "Trafford"), "trafford_greenspace_access_points.geojson", driver = "GeoJSON")
