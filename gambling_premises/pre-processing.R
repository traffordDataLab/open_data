## Gambling premises ##

# Source: Gambling Commission
# Publisher URL: https://www.gamblingcommission.gov.uk/public-register/premises/download
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(httr)


# Download the data ---------------------------
tmp <- tempfile(fileext = ".csv")
GET(url = "https://www.gamblingcommission.gov.uk/downloads/premises-licence-register.csv",
    write_disk(tmp))

# load data ---------------------------
raw <- read_csv(tmp)

area_lookup <- data_frame(
  area_code = paste0("E080000" , seq(1:10)),
  area_name = c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale",
                "Salford", "Stockport", "Tameside", "Trafford", "Wigan")
)

postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/gm_postcodes.csv")

# tidy data ---------------------------
df <- raw %>%
  mutate(City = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(City), perl = TRUE),
         address = str_c(`Address Line 1`, `Address Line 2`, City, sep = ", "),
         area_name = str_extract(`Local Authority`, "Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan")) %>% 
  filter(!is.na(area_name)) %>%
  select(name = `Account Name`, activity = `Premises Activity`, address, postcode = Postcode, area_name) %>% 
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

# Remove downloaded data
unlink(tmp)
