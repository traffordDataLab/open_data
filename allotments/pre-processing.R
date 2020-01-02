# Allotments #

# Source: Trafford Council and OpenStreetMap
# Publisher URL: https://www.trafford.gov.uk/residents/leisure-and-lifestyle/parks-and-open-spaces/allotments
# Licence: OGL 3.0 ; © OpenStreetMap contributors (ODbL)

# load libraries ---------------------------
library(tidyverse) ; library(rvest) ; library(osmdata) ; library(sf)

# scrape data ---------------------------
html <- read_html("https://www.trafford.gov.uk/residents/leisure-and-lifestyle/parks-and-open-spaces/allotments/allotments-in-trafford.aspx")
df <- tibble(name = html_text(html_nodes(html, "#main-article .sys_t0"))) %>% 
  mutate(name = str_replace_all(name, "allotments|Allotments|Allotment|Allotment Site", ""),
         name = str_replace(name, "Chadwick Road", "Chadwick Park"),
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

# write data ---------------------------
st_write(sf, "trafford_allotments.geojson")

sf %>% 
  mutate(lon = map_dbl(geometry, ~st_centroid(.x)[[1]]),
         lat = map_dbl(geometry, ~st_centroid(.x)[[2]])) %>% 
  st_set_geometry(value = NULL) %>%
  write_csv("trafford_allotments.csv")
