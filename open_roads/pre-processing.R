## OS Open Roads ##

# Source: Ordnance Survey
# Publisher URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-roads.html
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(sf) ; library(tidyverse) ; library(rmapshaper)

# load geospatial data ---------------------------

# Trafford local authority boundary
trafford <- st_read("https://opendata.arcgis.com/datasets/ae90afc385c04d869bc8cf8890bd1bcd_1.geojson") %>% 
  filter(lad17nm == "Trafford") %>% 
  select(area_code = lad17cd, area_name = lad17nm)
trafford <- st_transform(trafford, 4326)

# OS Open Road
unzip("oproad_essh_gb.zip")
file.remove("oproad_essh_gb.zip")

roadLink <- st_read("data/SJ_RoadLink.shp")
roadLink <- st_transform(roadLink, 4326)

roadNode <- st_read("data/SJ_RoadNode.shp")
roadNode <- st_transform(roadNode, 4326)

motorwayJunction <- st_read("data/SJ_MotorwayJunction.shp")
motorwayJunction <- st_transform(motorwayJunction, 4326)

# intersect data ---------------------------
trafford_roadLink <- st_intersection(roadLink, trafford) 
plot(st_geometry(trafford_roadLink))

trafford_roadNode <- st_intersection(roadNode, trafford) 
plot(st_geometry(trafford_roadNode))

trafford_motorwayJunction <- st_intersection(motorwayJunction, trafford) 
plot(st_geometry(trafford_motorwayJunction))

# write data  ---------------------------
st_write(trafford_roadLink, "trafford_roadLink.geojson", driver = "GeoJSON")
st_write(trafford_roadNode, "trafford_roadNode.geojson", driver = "GeoJSON")
st_write(trafford_motorwayJunction, "trafford_motorwayJunction.geojson", driver = "GeoJSON")

# simplify data  ---------------------------
trafford_roadLink_simplified <- ms_simplify(trafford_roadLink, keep = 0.01, keep_shapes = T) # keep 1% of the points
st_write(trafford_roadLink_simplified, "trafford_roadLink_simplified.geojson")