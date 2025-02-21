## Styling watercourses features ##

# Load packages ---------------------------
library(tidyverse); library(sf)


# Remove the previous files ---------------------------
file.remove(c("trafford_watercourses_styled.geojson",
              "trafford_buffer_watercourses_styled.geojson",
              "gm_watercourses_styled.geojson"))


# Function to apply styles ---------------------------
style_watercourses <- function(unstyled_data_filename) {
    read_sf(unstyled_data_filename) %>%
    mutate(stroke = "#40a4df",
           `stroke-width` = 3,
           `stroke-opacity` = 1,
           fill = stroke,
           `fill-opacity` = 0.8)
}


# Create the new styled data ---------------------------
write_sf(style_watercourses("trafford_watercourses.geojson"), "trafford_watercourses_styled.geojson", driver = "GeoJSON")
write_sf(style_watercourses("trafford_buffer_watercourses.geojson"), "trafford_buffer_watercourses_styled.geojson", driver = "GeoJSON")
write_sf(style_watercourses("gm_watercourses.geojson"), "gm_watercourses_styled.geojson", driver = "GeoJSON")
