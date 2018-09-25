## Gambling premises ##

# Source: Gambling Commission
# Publisher URL: https://secure.gamblingcommission.gov.uk/PublicRegister
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse); library(sf)

# load data ---------------------------
raw <- read_csv("Premises-licence-database-extract.csv")

area_lookup <- data_frame(
  area_code = paste0("E080000" , seq(1:10)),
  area_name = c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale",
                "Salford", "Stockport", "Tameside", "Trafford", "Wigan")
)

postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/GM_postcodes_2018-08.csv")

# tidy data ---------------------------
df <- raw %>%
  mutate(premises_City = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(premises_City), perl = TRUE),
         address = str_c(premises_Address1, premises_Address2, premises_City, sep = ", "),
         area_name = str_extract(Local_Authority_Name, "Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan")) %>% 
  filter(!is.na(area_name)) %>%
  select(name = Account_Name, activity = Activity, address, postcode = premises_Postcode, area_name) %>% 
  left_join(., area_lookup, by = "area_name") %>% 
  left_join(., postcodes, by = "postcode")

# style GeoJSON ---------------------------
sf <- df %>% 
  filter(!is.na(lat)) %>%
  st_as_sf(coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  rename(Name = name,
         Activity = activity,
         Address = address,
         Postcode = postcode,
         `Area name` = area_name,
         `Area code` = area_code)

# write data ---------------------------
write_csv(df, "gm_gambling_premises.csv")
write_csv(filter(df, area_name == "Trafford"), "trafford_gambling_premises.csv")

st_write(sf, "gm_gambling_premises.geojson")
st_write(filter(sf, `Area name` == "Trafford"), "trafford_gambling_premises.geojson")


