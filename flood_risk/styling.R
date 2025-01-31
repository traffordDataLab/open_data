## Styling flood risk features ##

# load packages ---------------------------
library(tidyverse); library(sf)

# read un-styled, cleaned data ---------------------------
trafford_flood_risk <- read_sf("trafford_flood_risk.geojson")

# apply styles ---------------------------
trafford_flood_risk_styled <- trafford_flood_risk %>% 
    mutate(stroke = case_when(
                        flood_risk == "Very low" ~ "#C4E1FF",
                        flood_risk == "Low" ~ "#A2CFFF",
                        flood_risk == "Medium" ~ "#6699CD",
                        flood_risk == "High" ~ "#3D4489",
                        TRUE ~ "#ff0000"), # To visually indicate that something has gone wrong),
           `stroke-width` = 3,
           `stroke-opacity` = 1,
           fill = stroke,
           `fill-opacity` = 0.8)

# delete the old and then create the new data ---------------------------
file.remove("trafford_flood_risk_styled.geojson")
write_sf(trafford_flood_risk_styled, "trafford_flood_risk_styled.geojson")
