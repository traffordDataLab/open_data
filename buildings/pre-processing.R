## Buildings ##

# Source: Ordnance Survey Open Map - Local
# URL: https://www.ordnancesurvey.co.uk/business-government/products/open-map-local
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
buildings <- st_read("OS OpenMap Local (ESRI Shape File) SJ/data/SJ_Building.shp") %>% 
  st_transform(27700)

# UK Local Authority Districts
# Source: ONS Open Geography Portal
# URL: https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2019-boundaries-uk-bfc
trafford <- st_read("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_December_2019_Boundaries_UK_BFC/MapServer/0/query?where=lad19cd%20%3D%20'E08000009'&outFields=lad19cd,lad19nm&outSR=27700&f=geojson") %>% 
  rename(area_code = lad19cd, area_name = lad19nm)

# intersect data ---------------------------
trafford_buildings <- st_intersection(buildings, trafford)

# check data  ---------------------------
plot(st_geometry(trafford), col = "#f0f0f0")
plot(st_geometry(trafford_buildings), add = T)

# write data  ---------------------------
trafford_buildings %>% 
  st_transform(4326) %>% 
  st_write("trafford_buildings.geojson", driver = "GeoJSON")
