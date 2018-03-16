## Agricultural Land Classification ##

# Source: Natural England
# Publisher URL: https://data.gov.uk/dataset/provisional-agricultural-land-classification-alc2
# Licence: Open Government Licence 3.0

# load libraries---------------------------
library(tidyverse) ; library(sf)

# load data ---------------------------
alc <- st_read("https://opendata.arcgis.com/datasets/5934fd11ae3c44dbb270e8a547ba06c1_0.geojson")

trafford <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/local_authority/2016/trafford_local_authority_full_resolution.geojson") %>% 
  st_set_crs(4326) %>% 
  select(-lat, -lon)

# intersect data ---------------------------
trafford_alc <- st_intersection(alc, trafford)

# check data  ---------------------------
library(leaflet)
pal <- colorFactor(c("#39E2FE", "#C3FBFE", "#D8F0ED", "#FEF8A4", "#B28764", "#FEC454", "#FF6347"), 
                   domain = c("Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5",
                              "Non Agricultural", "Urban"),
                   ordered = TRUE)

leaflet(data = trafford_alc) %>% 
  setView(-2.35533522781156, 53.419025498197, zoom = 12) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolygons(data = trafford, fillColor = "transparent", weight = 1.5, dashArray = "3", color = "#212121", fillOpacity = 0.3) %>%
  addPolygons(fillColor = ~pal(ALC_GRADE), weight = 0.5, opacity = 1, color = "white", fillOpacity = 0.7, label = ~ALC_GRADE,
              labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "15px", direction = "auto")) %>% 
  addLegend(position = 'bottomleft',
            colors = c("#39E2FE", "#D8F0ED", "#B3FE99", "#FEF8A4", "#B28764", "#FEC454", "#FF6347"),
            labels = c("Excellent", "Very Good", "Good to Moderate", "Poor", "Very Poor",
                       "Non Agricultural", "Urban"),
            opacity = 1) %>% 
  addControl("<strong>Agricultural Land Classification in Trafford</strong><br /><em>Source: Natural England</em>",
             position = 'topright')

# write data  ---------------------------
st_write(trafford_alc, "trafford_agricultural_land_classification.geojson", driver = "GeoJSON")
