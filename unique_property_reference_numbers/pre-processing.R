# Unique Property Reference Numbers (UPRN) in Trafford
# Source: https://osdatahub.os.uk/downloads/open/OpenUPRN
# Licence: https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/


# Load required packages ---------
library(tidyverse); library(httr); library(sf); library(lubridate)


# Download and extract the data ---------
# The data is available updated monthly, so enter the version in the format YYYYMM (you can check the version from the Source URL above)
data_version <- "202411"

# The URL shouldn't change from the API
data_url <- "https://api.os.uk/downloads/v1/products/OpenUPRN/downloads?area=GB&format=CSV&redirect"

download.file(data_url, destfile = paste0("osopenuprn_", data_version, "_csv.zip"), timeout = 5000)
unzip(paste0("osopenuprn_", data_version, "_csv.zip"), exdir = ".", files = paste0("osopenuprn_", data_version, ".csv"))

# Read in the data for the whole of GB
df_uprn_gb <- read_csv(paste0("osopenuprn_", data_version, ".csv"))
                        
# Tidy-up removing the files we no longer need
file.remove(paste0("osopenuprn_", data_version, "_csv.zip"))
file.remove(paste0("osopenuprn_", data_version, ".csv"))


# Extract just the data that lies within Trafford's boundary ---------
# Load in Trafford's boundary as a spatial object
sf_trafford <- st_read("https://www.trafforddatalab.io/council_open_data/boundaries/local_authority_district.geojson")

# Convert the UPRN dataset into a spatial file using the LATITUDE and LONGITUDE variables
sf_uprn_gb <- df_uprn_gb %>%
    # Make copies of the lat/lon coordinates to use later in the dataset as the originals will become the geometry
    mutate(lat = LATITUDE,
           lon = LONGITUDE) %>%
    st_as_sf(coords = c("LONGITUDE", "LATITUDE"),
             crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

# Perform spatial join to extract just those UPRNs within Trafford
sf_uprn_trafford <- st_join(sf_uprn_gb, sf_trafford, join = st_within, left = FALSE)


# Tidy the resultant spatial dataset for Trafford, renaming variables for clarity and adding version date ---------
sf_uprn_trafford_tidy <- sf_uprn_trafford %>%
    mutate(version_date = paste(month(ymd(paste0(substring(data_version, 1, 4), "-", substring(data_version, 5, 6), "-01")), label = TRUE, abbr = FALSE), substring(data_version, 1, 4))) %>%
    rename(uprn = UPRN,
           easting = X_COORDINATE,
           northing = Y_COORDINATE,
           latitude = lat,
           longitude = lon) %>%
    select(uprn, latitude, longitude, easting, northing, area_code, area_name, version_date, geometry)


# Create the output files ---------
# Convert to a non-spatial dataset in order to output as CSV
df_uprn_trafford <- sf_uprn_trafford_tidy %>%
    st_set_geometry(value = NULL)

write_csv(df_uprn_trafford, "trafford_unique_property_reference_numbers.csv")
st_write(sf_uprn_trafford_tidy, "trafford_unique_property_reference_numbers.geojson", driver = "GeoJSON")

