## Process and style the RAW csv and map data into cleaned and styled GeoJSON

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load the raw data ---------------------------
df_csv_source <- read_csv("mental_health_services_RAW.csv")
sf_geojson_source <- st_read("mental_health_services_RAW.geojson")

# create a copy of the csv data without the id field which isn't required for the final output csv ---------------------------
df_csv_output <- select(df_csv_source, -featureNum)

# create the cleaned output csv ---------------------------
write_csv(df_csv_output, "trafford_mental_health_services.csv")

# create a new variable for the organisations' websites which is an HTML link ---------------------------
df_csv_join <- rename(df_csv_source, website_text = website) %>%
  mutate(website = paste0("<a href='", website_text, "' target='_blank'>View website</a>")) %>%
  # remove the simple text website variable
  select(-website_text) 

# join data from csv to geojson ---------------------------
sf_joined_geojson <- left_join(sf_geojson_source, df_csv_join, by = "featureNum") %>%
  # remove the unwanted variables
  select(-featureNum, -featureAlias)

# save the un-styled version of the geojson
st_write(sf_joined_geojson, "trafford_mental_health_services.geojson")

# create a new spatial features object, copying the joined geojson and capitalising all the variables that the user will see in Explore ---------------------------
sf_styled_geojson <- sf_joined_geojson %>%
  rename(Name = name, Description = description, Address = address, Postcode = postcode, Telephone = telephone, Website = website)

# add the geojson styling ---------------------------
sf_styled_geojson <- geojson_style(sf_styled_geojson,
                        color = "#fc6721",
                        size = "medium") %>%   
                        rename(`marker-color` = marker.color,
                        `marker-size` = marker.size)

# save the styled version of the geojson
st_write(sf_styled_geojson, "trafford_mental_health_services_styled.geojson")
