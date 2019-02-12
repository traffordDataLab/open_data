# Green spaces #

# Source: OS Open Greenspace, Ordnance Survey
# Publisher URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html
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
gm <- st_read("https://www.trafforddatalab.io/spatial_data/local_authority/2016/gm_local_authority_full_resolution.geojson") %>% 
  select(-lon, -lat)

# intersect data ---------------------------
sites_gm <- st_intersection(sites, gm)  %>% 
  mutate(site_type = fct_recode(site_type,
                    "Sports" = "Bowling Green",
                    "Sports" = "Other Sports Facility",
                    "Sports" = "Tennis Court",
                    "Religious Ground and Cemetries" = "Religious Grounds",
                    "Religious Ground and Cemetries" = "Cemetery")) %>% 
  select(`Site type` = site_type, 
         `Site name` = site_name,
         `Area code` = area_code, 
         `Area name` = area_name)

access_gm <- st_intersection(access, gm)  %>% 
  select(`Access type` = access_type,
         `Area code` = area_code, 
         `Area name` = area_name)

# write data ---------------------------
st_write(sites_gm, "gm_greenspace_sites.geojson", driver = "GeoJSON")
st_write(filter(sites_gm, `Area name` == "Trafford"), "trafford_greenspace_sites.geojson", driver = "GeoJSON")

st_write(access_gm, "gm_greenspace_access_points.geojson", driver = "GeoJSON")
st_write(filter(access_gm, `Area name` == "Trafford"), "trafford_greenspace_access_points.geojson", driver = "GeoJSON")


# style data ---------------------------
filter(sites_gm, `Area name` == "Trafford") %>% 
  mutate(stroke = 
           case_when(
             `Site type` == "Allotments Or Community Growing Spaces" ~ "#66c2a5",
             `Site type` == "Golf Course" ~ "#fc8d62",
             `Site type` == "Play Space" ~ "#8da0cb",
             `Site type` == "Playing Field" ~ "#e78ac3",
             `Site type` == "Public Park Or Garden" ~ "#a6d854",
             `Site type` == "Religious Ground and Cemeteries" ~ "#ffd92f",
             `Site type` == "Sports" ~ "#e5c494"),
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8) %>% 
  st_write("trafford_greenspace_sites_styled.geojson")
