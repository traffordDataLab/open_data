# Green spaces #

# Source: OS Open Greenspace, Ordnance Survey
# Publisher URL: https://osdatahub.os.uk/downloads/open/OpenGreenspace
# Licence: Open Government Licence (OGL)

# load necessary packages ---------------------------
library(sf) ; library(tidyverse)

# load geospatial data ---------------------------

# OS Open Greenspace: sites
sites <- read_sf("OS Open Greenspace (ESRI Shape File) GB/data/GB_GreenspaceSite.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_zm() %>% 
  mutate(site_type = factor(`function`),
         site_name = factor(distName1)) %>% 
  select(id, site_type, site_name)

# OS Open Greenspace: access points
access <- read_sf("OS Open Greenspace (ESRI Shape File) GB/data/GB_AccessPoint.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_zm() %>% 
  select(id, access_type = accessType)

# Greater Manchester local authority boundaries
gm <- st_read("https://www.trafforddatalab.io/spatial_data/local_authority/2021/gm_local_authority_full_resolution.geojson") %>% 
  select(-lon, -lat)

# intersect data ---------------------------
sites_gm <- st_intersection(sites, gm)  %>%
  select(site_type, site_name, area_code, area_name)

access_gm <- st_intersection(access, gm)  %>% 
  select(access_type, area_code, area_name)

# write data ---------------------------
st_write(sites_gm, "gm_greenspace_sites.geojson", driver = "GeoJSON")
st_write(filter(sites_gm, area_name == "Trafford"), "trafford_greenspace_sites.geojson", driver = "GeoJSON")

st_write(access_gm, "gm_greenspace_access_points.geojson", driver = "GeoJSON")
st_write(filter(access_gm, area_name == "Trafford"), "trafford_greenspace_access_points.geojson", driver = "GeoJSON")

# style data ---------------------------
# NOTE: original palette choice was "# set2" from https://vega.github.io/vega/docs/schemes/#categorical
# New palette is created by Paul Tol (https://personal.sron.nl/~pault/) and obtained via: https://davidmathlogic.com/colorblind/#%23332288-%23117733-%2344AA99-%2388CCEE-%23DDCC77-%23CC6677-%23AA4499-%23882255-%233dd707-%23ca825f
filter(sites_gm, area_name == "Trafford") %>% 
  select(`Site type` = site_type, 
         `Site name` = site_name,
         `Area code` = area_code, 
         `Area name` = area_name) %>% 
  mutate(stroke = 
           case_when(
             `Site type` == "Allotments Or Community Growing Spaces" ~ "#44AA99",
             `Site type` == "Bowling Green" ~ "#3DD707",
             `Site type` == "Cemetery" ~ "#332288",
             `Site type` == "Golf Course" ~ "#CA825F",
             `Site type` == "Other Sports Facility" ~ "#DDCC77",
             `Site type` == "Play Space" ~ "#88CCEE",
             `Site type` == "Playing Field" ~ "#AA4499",
             `Site type` == "Public Park Or Garden" ~ "#117733",
             `Site type` == "Religious Grounds" ~ "#882255",
             `Site type` == "Tennis Court" ~ "#CC6677"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8) %>% 
  st_write("trafford_greenspace_sites_styled.geojson")
