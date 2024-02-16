## Risk of Flooding from Rivers and Sea ##

# Source: Environment Agency
# Publisher URL: https://www.data.gov.uk/dataset/bad20199-6d39-4aad-8564-26a46778fd94/risk-of-flooding-from-rivers-and-sea
# Licence: Open Government Licence 3.0
# Attribution: (C) Environment Agency Copyright and/or Database Rights 2023. All rights reserved.
# Last Updated: 2024-02-09
# NOTE 1: "This year we are pausing the updates to this dataset after December 2023. This is in advance of publishing the first outputs from our new National Flood Risk Assessment. These outputs will be published by the end of 2024 and will include a new version of this dataset."
# NOTE 2: The initial dataset is downloaded from https://environment.data.gov.uk/explore/8d57464f-d465-11e4-8790-f0def148f590 by creating a bounding polygon around Trafford. This file is large ~14MB.

# Load libraries ---------------------------
library(tidyverse) ; library(sf)


# Set sf geometry calculation method ---------------------------
# Refer to the following for further information: https://github.com/r-spatial/sf/issues/1771
is_sf_using_s2 <- sf_use_s2() # Store whether sf is using S2 or R2 geometry calculations
sf_use_s2(FALSE)              # Set sf to use R2 calculations as we get errors using S2


# Load raw data and Trafford's boundary ---------------------------
flood_risk_raw <- st_read("Risk_of_Flooding_from_Rivers_and_Sea.json") %>% # Downloaded file mentioned in NOTE 2
    st_make_valid() # The geometry returned in the data downloaded above needs correcting as there are overlapping vertices/self-intersections etc.

# Load boundary of Trafford ---------------------------
trafford <- st_read("https://www.trafforddatalab.io/spatial_data/local_authority/2021/trafford_local_authority_full_resolution.geojson") %>% 
    st_set_crs(4326) %>% 
    select(-lat, -lon)

# Intersect data, leaving just flood risk data within Trafford's boundary and tidy up variables ---------------------------
trafford_flood_risk <- st_intersection(flood_risk_raw, trafford) %>%
    rename(flood_risk = prob_4band,
           suitable_scale = suitability) %>%
    mutate(publication_date = as.character(as.POSIXct(pub_date, tz="UTC"))) %>%
    filter(st_geometry_type(geometry) != "POINT") %>% # Remove any point data as this will show up as a marker pin on the map which will be confusing. There seem to be 6 within the dataset.
    select(flood_risk, suitable_scale, publication_date, RoFRS_id = id)


# write data  ---------------------------
st_write(trafford_flood_risk, "trafford_flood_risk.geojson", driver = "GeoJSON")

sf_use_s2(is_sf_using_s2) # Reset whether sf is using S2 or R2 geometry calculations
