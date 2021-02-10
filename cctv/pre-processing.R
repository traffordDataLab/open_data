## This dataset was created by the Trafford Data Lab using our Plotter app.
## Purpose of this script is simply to prepare the raw file and create cleaned CSV and GeoJSON outputs from it.
## Help with the regular expressions and using them within stringr::str_extract came from:
## https://stackoverflow.com/questions/46787725/stringr-str-extract-capture-group-capturing-everything

# Load the libraries we need to use
library(tidyverse) ; library(sf)

# Load the raw GeoJSON data created by Plotter into a Simple Features data frame
geojson_df <- sf::st_read("CCTV_cameras_trafford_RAW.geojson")

# Create a new variables for the camera id number and location by extracting the information from the featureAlias variable.
# We need to use regular expressions to match specific parts of the strings contained in featureAlias.
# For the camera id, it is contained within the string: "Cam xxxx - " where xxxx is a number comprised of 1 - 4 digits.
# As we only want the number and not the other part of the string we need to use lookbehind and lookahead.
# The regular expression "(?<=Cam\\s)\\d{1,4}(?=\\s-)" is saying:
#   - Return 1 to 4 digits that have the string "Cam " before them and the string " -" after them.
# For the location, we want everything after "Cam xxxx - ", so we only need lookbehind "(?<=Cam\\s\\d{1,4}\\s-\\s).+"
# It's pretty much the same pattern, with the ".+" returning everything after the match.
# The final 2 variables are to assist with matching these data to others based on LA code or name, or if this dataset was added to a larger CCTV dataset for GM etc.
geojson_df <- geojson_df %>%
  dplyr::mutate(camera_id = stringr::str_extract(featureAlias, "(?<=Cam\\s)\\d{1,4}(?=\\s-)"),
                location = stringr::str_extract(featureAlias, "(?<=Cam\\s\\d{1,4}\\s-\\s).+"),
                area_name = "Trafford",
                area_code = "E0800009")
  
# Remove the featureNum and featureAlias variables as we don't need them
geojson_df <- geojson_df %>%
  dplyr::select(-featureNum, -featureAlias)

# extract the coordinates as separate lon and lat variables to use for the CSV output
coords <- sf::st_coordinates(geojson_df) %>%
  tibble::as_tibble() %>%
  dplyr::select(X, Y) %>%
  dplyr::rename(lon = X, lat = Y)

# create a new standard data frame for the CSV output by binding the coordinates to the Simple Features data frame and removing the geometry
csv_df <- sf::st_set_geometry(geojson_df, NULL) %>%
  dplyr::bind_cols(coords)

# Create the new geojson (spatial) and csv (non-spatial) outputs
sf::st_write(geojson_df, "trafford_cctv_cameras.geojson")
readr::write_csv(csv_df, "trafford_cctv_cameras.csv")
