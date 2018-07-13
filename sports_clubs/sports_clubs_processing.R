## R Script to join variables in CSV to properties of features within GeoJSON based on a shared variable ##
## The source file indicated in this script is a bespoke file and not present in the repo as the file created within this script supercedes it ##
## Therefore this is not reproducible code out-of-the-box ##

# load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(stringr)

# load data ---------------------------
df_csv_source <- read_csv("sports_clubs_RAW.csv")
sf_geojson_source <- st_read("sports_clubs_RAW.geojson")

# clean CSV data ---------------------------
df_csv_source <- mutate(df_csv_source, address = paste0(street, ', ', town),
                        address = str_replace_all(address, 'NA, ', '')) %>%
  select(1:3, 7, 6)

# create the output CSV file
df_csv_output <- select(df_csv_source, -featureNum)
write_csv(df_csv_output, "sports_clubs.csv")

# join data from CSV to GeoJSON ---------------------------
sf_joined_geojson <- left_join(sf_geojson_source, df_csv_source, by = "featureNum")

# remove unwanted variables from the GeoJSON ---------------------------
sf_geojson_output <- select(sf_joined_geojson, -featureNum, -featureAlias)

# create the new GeoJSON output ---------------------------
st_write(sf_geojson_output, "sports_clubs.geojson", driver = "GeoJSON")
