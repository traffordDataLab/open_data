## Styling flood risk features ##

# Load packages ---------------------------
library(tidyverse); library(sf)


# Remove the previous files ---------------------------
file.remove(c("trafford_flood_risk_styled.geojson",
              "trafford_flood_risk_0_2m_depth_styled.geojson",
              "trafford_flood_risk_0_3m_depth_styled.geojson",
              "trafford_flood_risk_0_6m_depth_styled.geojson",
              "trafford_flood_risk_0_9m_depth_styled.geojson",
              "trafford_flood_risk_1_2m_depth_styled.geojson"))


# Function to apply styles ---------------------------
style_flood_risk <- function(unstyled_data_filename) {
    read_sf(unstyled_data_filename) %>%
    mutate(stroke = case_when(
                        flood_risk == "Very low" ~ "#C4E1FF",
                        flood_risk == "Low" ~ "#A2CFFF",
                        flood_risk == "Medium" ~ "#6699CD",
                        flood_risk == "High" ~ "#3D4489",
                        TRUE ~ "#b1b3b4"), # Likely "Unavailable"
           `stroke-width` = 3,
           `stroke-opacity` = 1,
           fill = stroke,
           `fill-opacity` = 0.8)
}


# Create the new styled data ---------------------------
write_sf(style_flood_risk("trafford_flood_risk.geojson"), "trafford_flood_risk_styled.geojson", driver = "GeoJSON")
write_sf(style_flood_risk("trafford_flood_risk_0_2m_depth.geojson"), "trafford_flood_risk_0_2m_depth_styled.geojson", driver = "GeoJSON")
write_sf(style_flood_risk("trafford_flood_risk_0_3m_depth.geojson"), "trafford_flood_risk_0_3m_depth_styled.geojson", driver = "GeoJSON")
write_sf(style_flood_risk("trafford_flood_risk_0_6m_depth.geojson"), "trafford_flood_risk_0_6m_depth_styled.geojson", driver = "GeoJSON")
write_sf(style_flood_risk("trafford_flood_risk_0_9m_depth.geojson"), "trafford_flood_risk_0_9m_depth_styled.geojson", driver = "GeoJSON")
write_sf(style_flood_risk("trafford_flood_risk_1_2m_depth.geojson"), "trafford_flood_risk_1_2m_depth_styled.geojson", driver = "GeoJSON")
