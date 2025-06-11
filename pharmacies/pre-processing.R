## Pharmacies in Trafford and Greater Manchester ##

# Source: NHS Business Services Authority (NHSBSA) Master Data Replacement (MDR)
# Publisher URL: https://opendata.nhsbsa.net/dataset/consolidated-pharmaceutical-list
#   - Consolidated Pharmaceutical List - 2024-25 Quarter 4

# Licence: Open Government Licence

# Load required packages ---------------------------
library(tidyverse) ; library(sf)


# Load raw data and clean ---------------------------
df_raw <- read_csv("https://opendata.nhsbsa.net/dataset/240d142d-df82-4e97-b051-12371519e4e1/resource/545609ba-8f93-4adf-8f5a-7a34a1a31881/download/consol_pharmacy_list_202425q4.csv")

df <- df_raw %>%
    filter(HEALTH_AND_WELLBEING_BOARD %in% c("BOLTON","BURY","MANCHESTER","OLDHAM","ROCHDALE","SALFORD","STOCKPORT","TAMESIDE","TRAFFORD","WIGAN")) %>%
    mutate(address = str_to_title(str_replace_all(paste0(ADDRESS_FIELD_1, ", ", ADDRESS_FIELD_2, ", ", ADDRESS_FIELD_3, ", ", ADDRESS_FIELD_4), ", NA", "")),
           HEALTH_AND_WELLBEING_BOARD = str_to_title(HEALTH_AND_WELLBEING_BOARD),
           PHARMACY_TRADING_NAME = str_to_title(PHARMACY_TRADING_NAME),
           ORGANISATION_NAME = str_to_title(ORGANISATION_NAME)) %>%
    arrange(HEALTH_AND_WELLBEING_BOARD, PHARMACY_TRADING_NAME) %>%
    select(pharmacy_name = PHARMACY_TRADING_NAME,
           address,
           postcode = POST_CODE,
           opening_hours_monday = PHARMACY_OPENING_HOURS_MONDAY,
           opening_hours_tuesday = PHARMACY_OPENING_HOURS_TUESDAY,
           opening_hours_wednesday = PHARMACY_OPENING_HOURS_WEDNESDAY,
           opening_hours_thursday = PHARMACY_OPENING_HOURS_THURSDAY,
           opening_hours_friday = PHARMACY_OPENING_HOURS_FRIDAY,
           opening_hours_saturday = PHARMACY_OPENING_HOURS_SATURDAY,
           opening_hours_sunday = PHARMACY_OPENING_HOURS_SUNDAY,
           organisation_data_service_code = `PHARMACY_ODS_CODE_(F-CODE)`,
           health_and_wellbeing_board = HEALTH_AND_WELLBEING_BOARD)


# Match pharmacy data with ONS postcodes to obtain spatial coordinates, ward and la information ---------------------------
postcodes <- read_csv("https://www.trafforddatalab.io/spatial_data/postcodes/gm_postcodes.csv") %>%
    select(postcode, ward_code, ward_name, la_code, la_name, lon, lat)

df_with_coords <- left_join(df, postcodes, by = "postcode")


# Convert to spatial object ---------------------------
sf <- df_with_coords %>%  
  filter(!is.na(lat)) %>%
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326)


# Write data   ---------------------------
file.remove(c("gm_pharmacies.geojson",
              "trafford_pharmacies.geojson"))

# NOTE: There are a few pharmacies where the value of health_and_wellbeing_board differs from la_name, therefore I'm using the former as the filter.
write_sf(sf, "gm_pharmacies.geojson", driver = "GeoJSON")
write_sf(sf %>% filter(health_and_wellbeing_board == "Trafford"), "trafford_pharmacies.geojson", driver = "GeoJSON")

write_csv(st_set_geometry(sf, value = NULL), "gm_pharmacies.csv")
write_csv(st_set_geometry(sf, value = NULL) %>% filter(health_and_wellbeing_board == "Trafford"), "trafford_pharmacies.csv")
