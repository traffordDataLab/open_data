## OS Open Roads ##

# Source: Ordnance Survey
# Publisher URL: https://osdatahub.os.uk/data/downloads/open/OpenRoads
# Licence: Open Government Licence 3.0

# load necessary packages ---------------------------
library(sf) ; library(tidyverse) ; library(rmapshaper)

# load geospatial data ---------------------------

# Create a string object with the name of your local authority
id <- "Trafford"

# Retrieve the local authority boundary
# Source: ONS Open Geography Portal
la <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_DEC_2025_Boundaries_UK_BFC/FeatureServer/0/query?where=UPPER(LAD25NM)%20like%20'%25", URLencode(toupper(id), reserved = TRUE), "%25'&outFields=*&outSR=4326&f=geojson"), quiet = TRUE) %>% 
  select(area_code = LAD25CD, area_name = LAD25NM)

# OS Open Road
  
url <- "https://api.os.uk/downloads/v1/products/OpenRoads/downloads?area=GB&format=ESRI%C2%AE+Shapefile&redirect"
download.file(url = url, destfile = "oproad_essh_gb.zip", mode = "wb")
unzip("oproad_essh_gb.zip")
file.remove("oproad_essh_gb.zip")

roadLink <- st_read("data/SJ_RoadLink.shp")
roadLink <- st_transform(roadLink, 4326)

roadNode <- st_read("data/SJ_RoadNode.shp")
roadNode <- st_transform(roadNode, 4326)

motorwayJunction <- st_read("data/SJ_MotorwayJunction.shp")
motorwayJunction <- st_transform(motorwayJunction, 4326)

# intersect data ---------------------------
trafford_roadLink <- st_intersection(roadLink, la) 

ggplot(data = trafford_roadLink) + geom_sf()
  
trafford_roadNode <- st_intersection(roadNode, la)

ggplot(data = trafford_roadNode) + geom_sf()

trafford_motorwayJunction <- st_intersection(motorwayJunction, la)

ggplot(data = trafford_motorwayJunction) + geom_sf()

# write data  ---------------------------
st_write(trafford_roadLink, "trafford_roadLink.geojson", driver = "GeoJSON")
st_write(trafford_roadNode, "trafford_roadNode.geojson", driver = "GeoJSON")
st_write(trafford_motorwayJunction, "trafford_motorwayJunction.geojson", driver = "GeoJSON")

# simplify data  ---------------------------
trafford_roadLink_simplified <- ms_simplify(trafford_roadLink, keep = 0.01, keep_shapes = T) # keep 1% of the points
ggplot(data = trafford_roadLink_simplified) + geom_sf()
st_write(trafford_roadLink_simplified, "trafford_roadLink_simplified.geojson")
