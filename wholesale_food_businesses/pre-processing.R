# Wholesale food businesses #

# Source: Food Standards Agency
# URL: https://www.food.gov.uk/business-guidance/approved-food-establishments
# Licence: Open Government Licence (v3) 

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# load postcode data
postcodes <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/postcodes/trafford_postcodes.csv") %>%
  select(-area_code, -area_name, -locality)

# load and tidy data ---------------------------
df <- read_csv("https://fsadata.github.io/approved-food-establishments/data/approved-food-establishments-as-at-1-january-2018.csv") %>% 
  filter(CompetentAuthority == "Trafford") %>% 
  mutate(address = str_replace_all(paste(Address1, Address2, Address3, sep = ", "), c("NA|NA, |, NA"), "")) %>% 
  select(name = TradingName, activity = AllActivities, address, postcode = Postcode)

# manual fill missing data
df <- df %>% 
  # https://www.yell.com/biz/j-priestner-partnership-lymm-1259009
  mutate(address = case_when(name == "J. Priestner Partnership" ~ "Midlands Farm Moss Lane, Warburton, Lymm", TRUE ~ address),
         postcode = case_when(name == "J. Priestner Partnership" ~ "WA13 9TX", TRUE ~ postcode)
  )

# join coordinates from postcode data
df <- left_join(df, postcodes, by = "postcode")

# create spatial object  ---------------------------
sf <- df %>% 
  st_as_sf(coords = c("lon", "lat")) %>%
  st_set_crs(4326) 

# write data  ---------------------------
write_csv(df, "trafford_wholesale_food_businesses.csv")
st_write(sf, "trafford_wholesale_food_businesses.geojson")
