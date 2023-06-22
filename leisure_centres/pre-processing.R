# Leisure Centres in Trafford
# 2023-06-22

library(tidyverse) ; library(sf)

# Read in the source data
sf_centres_and_parking <-  st_read("trafford_leisure_centres_and_parking_polygons.geojson")

# Create a styled version of the centres and parking polygons for use in https://www.trafforddatalab.io/explore
sf_centres_and_parking %>%
    # replace missing values within the parking nodes with blank string
    replace_na(list(telephone = "", website = "", opening_hours = "", facilities = "")) %>%
    mutate(stroke = 
           if_else(grepl("\\b.*?Parking", name), "#e5c494", "#fc6721"),
           `stroke-width` = 3,
           `stroke-opacity` = 1,
           fill = stroke,
           `fill-opacity` = 0.8) %>%
    st_write("trafford_leisure_centres_and_parking_polygons_styled.geojson")

# Create a CSV version of the dataset
df_centres_and_parking <- sf_centres_and_parking %>%
    st_drop_geometry() %>%
    write_csv("trafford_leisure_centres_and_parking.csv")


# Now amend the CSV, dropping the car parks, ready to create a point dataset
df_centres <- df_centres_and_parking %>%
    filter(!grepl("\\b.*?Parking", name))

# Create a dataset of the centre's point locations which can be used to join with the centres CSV to create a GeoJSON point dataset
df_centres_points <- tibble(name = "Move Altrincham", lon = -2.3456813925334914, lat = 53.38834687816429) %>%
    add_row(name = "Sale Leisure Centre", lon = -2.3159524585775513, lat = 53.42488843133235) %>%
    add_row(name = "Stretford Sports Village, Chester Centre", lon = -2.292924139797425, lat = 53.458544642219614) %>%
    add_row(name = "Stretford Sports Village, Talbot Centre", lon = -2.292381866967942, lat = 53.456315024784935) %>%
    add_row(name = "Stretford Sports Village, Old Trafford Sports Barn", lon = -2.2733521875550693, lat = 53.460386751389535) %>%
    add_row(name = "Partington Sports Village", lon = -2.42818378755827, lat = 53.41360666756395) %>%
    add_row(name = "Move Urmston", lon = -2.3711497029003548, lat = 53.450327457123855) %>%
    add_row(name = "The Grammar", lon = -2.3505202740693187, lat = 53.37550898109315) %>%
    add_row(name = "BeActive Urmston", lon = -2.3427956452275187, lat = 53.45788738193787)

# Join the centres dataset to the points, save as a CSV, then transform into a spatial file
sf_centres <- df_centres %>%
    left_join(df_centres_points, by = "name") %>%
    write_csv("trafford_leisure_centres.csv") %>%
    st_as_sf(crs = 4326, coords = c("lon", "lat")) %>%
    st_write("trafford_leisure_centres.geojson")
