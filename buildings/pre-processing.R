## Buildings ##

# Source: Ordnance Survey Open Map - Local
# URL: https://www.ordnancesurvey.co.uk/business-government/products/open-map-local
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
buildings <- st_read("OS OpenMap Local (ESRI Shape File) SJ/data/SJ_Building.shp") %>% 
  st_transform(4326)

# UK Local Authority Districts
# Source: ONS Open Geography Portal
# URL: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-may-2023-uk-bfc

trafford <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2023_UK_BFC/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=LAD23CD,LAD23NM&outSR=4326&f=json") %>% 
  rename(area_code = LAD23CD, area_name = LAD23NM)

# intersect data ---------------------------
trafford_buildings <- st_intersection(buildings, trafford)

# check data  ---------------------------
plot(st_geometry(trafford), col = "#f0f0f0")
plot(st_geometry(trafford_buildings), add = T)

# write data  ---------------------------
trafford_buildings %>% 
  st_transform(4326) %>% 
  st_write("trafford_buildings.geojson", driver = "GeoJSON")
