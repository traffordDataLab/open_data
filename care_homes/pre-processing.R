## Care homes ##

# Source: Care Quality Commission
# Publisher URL: http://www.cqc.org.uk/about-us/transparency/using-cqc-data
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ;  library(sf)

# load data ---------------------------
raw <- read_csv("https://www.cqc.org.uk/sites/default/files/10_April_2019_CQC_directory.csv", 
                skip = 4, col_names = TRUE) %>% setNames(tolower(names(.)))

area_lookup <- data_frame(
  area_code = paste0("E080000" , seq(1:10)),
  area_name = c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale",
                "Salford", "Stockport", "Tameside", "Trafford", "Wigan")
)

# load postcodes (don't need the area_code and area_name variables as they are present in the CQC dataset)
postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/gm_postcodes.csv") %>%
  select(-area_code, -area_name)

# tidy data ---------------------------
df <- raw %>% 
  filter(str_detect(`service types`, "Nursing homes|Residential homes") & 
           `local authority` %in% area_lookup$area_name) %>%
  select(name, type = `service types`, address, postcode, telephone = `phone number`, 
         website = `service's website (if available)`, area_name = `local authority`) %>% 
  left_join(., area_lookup, by = "area_name") %>% 
  left_join(., postcodes, by = "postcode")

# create GeoJSON  ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("lon", "lat")) %>%
  st_set_crs(4326) 

# write data  ---------------------------
write_csv(df, "gm_care_homes.csv")
write_csv(filter(df, area_name == "Trafford"), "trafford_care_homes.csv")

st_write(sf, "gm_care_homes.geojson")
st_write(filter(sf, area_name == "Trafford"), "trafford_care_homes.geojson")
