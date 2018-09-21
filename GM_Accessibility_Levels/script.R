## Greater Manchester Accessibility Levels ##

# Source: Active Places Power
# Publisher URL: https://www.activeplacespower.com/OpenData/download
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# download and unzip data ---------------------------
url <- "http://odata.tfgm.com/opendata/downloads/GMAL/GMAL_TfGMOpenData.zip"
download.file(url, dest = "GMAL_TfGMOpenData.zip")
unzip("GMAL_TfGMOpenData.zip")
file.remove("GMAL_TfGMOpenData.zip")

bdy <- st_read("https://www.traffordDataLab.io/spatial_data/local_authority/2016/trafford_local_authority_full_resolution.geojson")

# read data ---------------------------
gmal <- st_read("SHP-format/GMAL_grid_open.shp") %>% 
  st_transform(crs = 4326)

# clip data ---------------------------
sf <- st_intersection(gmal, bdy)%>% 
  select(GridID, GMALLevel, GMALScore)

# apply styles ---------------------------
sf <- sf %>% 
  mutate(stroke = 
           case_when(
             GMALLevel == 1 ~ "#020060",
             GMALLevel == 2 ~ "#3175FF",
             GMALLevel == 3 ~ "#50C4FF",
             GMALLevel == 4 ~ "#8FFF90",
             GMALLevel == 5 ~ "#FED861",
             GMALLevel == 6 ~ "#FF8001",
             GMALLevel == 7 ~ "#D63027",
             GMALLevel == 8 ~ "#500001"),
         `stroke-width` = 0,
         fill = stroke,
         `fill-opacity` = 0.8)

# write data ---------------------------
st_write(sf, "GMAL_trafford.geojson")
