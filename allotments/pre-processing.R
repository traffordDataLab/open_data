## Allotments in Trafford ##

# Source: Trafford Council and OpenStreetMap
# Publisher URL: https://www.trafford.gov.uk/residents/leisure-and-lifestyle/parks-and-open-spaces/allotments/allotments-in-trafford.aspx
# Licence: OGL 3.0 ; © OpenStreetMap contributors (ODbL)

# load libraries ---------------------------
library(tidyverse) ; library(rvest) ; library(osmdata) ; library(sf) ; library(leaflet)

# scrape data ---------------------------
html <- read_html("https://www.trafford.gov.uk/residents/leisure-and-lifestyle/parks-and-open-spaces/allotments/allotments-in-trafford.aspx")
df <- data_frame(name = html_text(html_nodes(html, ".sys_t2643"))) %>% 
  mutate(name = str_replace_all(name, "allotments|Allotments|Allotment|Allotment Site", ""),
         name = str_replace(name, "Grove Lane", "Quarry Bank"),
         name = str_replace(name, "Lesley Road / Moss Park", "Lesley Road/Moss Park"),
         name = str_replace(name, "Moss Lane / Golf Road", "Moss Lane/Golf Road"),
         name = str_replace(name, "Trafford Drive / Beech Avenue", "Trafford Drive/Beech Avenue"),
         name = str_replace(name, "Woodstock", "Woodstock Road"),
         name = str_replace(name, "De Quincey Road", "Woodcote Road"),
         name = str_replace(name, "Tavistock", "Tavistock Road"),
         name = str_replace(name, "Seymour Grove", "Old Trafford"),
         name = str_replace(name, "Moss view", "Moss View Road"),
         name = str_replace(name, "Malborough", "Marlborough Road"),
         name = str_trim(name))

# retrieve allotments from OpenStreetMap ---------------------------
osm <- opq(bbox = c(-2.478454,53.35742,-2.253022,53.48037)) %>%
  add_osm_feature(key = "landuse", value = "allotments") %>%
  osmdata_sf()

# prepare for matching ---------------------------
osm <- osm$osm_polygons %>%
  mutate(name = str_replace(name, "Moss View Road Allotment Site", "Moss View Road"),
         name = str_replace_all(name, "allotments|Allotments|Allotment", ""),
         name = str_replace(name, "Lesley Road / Moss Park", "Lesley Road/Moss Park"),
         name = str_replace(name, "Trafford Drive/Beech Ave", "Trafford Drive/Beech Avenue"),
         name = str_replace(name, "Trafford Drive / Beech Ave", "Trafford Drive / Beech Avenue"),
         name = str_replace(name, "Wellfield", "Wellfield Lane"),
         name = str_trim(name)) %>% 
  select(name, osm_id)

# join OpenStreetMap geometries ---------------------------
sf <- df %>% 
  left_join(osm, by = "name") %>% 
  st_as_sf(crs = 4326)

# add missing geometry for Pickering Lodge Allotments ---------------------------
sf[sf$name == "Pickering Lodge",]$geometry <- st_polygon(list(rbind(
  c(-2.332236, 53.398683),
  c(-2.332225, 53.398812),
  c(-2.332088, 53.398866),
  c(-2.331825, 53.398921),
  c(-2.331650, 53.398692),
  c(-2.331539, 53.398507),
  c(-2.331444, 53.397967),
  c(-2.331584, 53.397978),
  c(-2.331791, 53.398163),
  c(-2.331925, 53.398347),
  c(-2.332113, 53.398483),
  c(-2.332236, 53.398683)
)))

# add ward and locality names ---------------------------
wards <- st_read("https://www.trafforddatalab.io/spatial_data/ward/2017/trafford_ward_full_resolution.geojson") %>% 
  select(area_code, area_name)
localities <- st_read("https://www.trafforddatalab.io/spatial_data/council_defined/trafford_localities.geojson") %>% 
  select(locality)

sf <- st_join(sf, wards, join = st_within, left = FALSE) %>% 
  st_join(localities, join = st_within, left = FALSE)

# write data ---------------------------
sf %>% 
  rename(Name = name,
         OSM_ID = osm_id,
         `Area name` = area_name,
         `Area code` = area_code,
         Locality = locality) %>%
  mutate(stroke = "#659D32",
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = "#659D32",
         `fill-opacity` = 0.8) %>% 
  st_write("trafford_allotments.geojson")

sf %>% 
  mutate(lon = map_dbl(geometry, ~st_centroid(.x)[[1]]),
         lat = map_dbl(geometry, ~st_centroid(.x)[[2]])) %>% 
  st_set_geometry(value = NULL) %>%
  write_csv("trafford_allotments.csv")
