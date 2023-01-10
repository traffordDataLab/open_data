# Housing from Census 2021 data
# ONS QUALITY NOTICE: We have made changes to housing definitions since the 2011 Census. Take care if you compare Census 2021 results for this topic with those from the 2011 Census.

# 2023-01-05 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/housingcensus2021inenglandandwales

# AREA CODES OF INTEREST
# Regions
# E92000001: England
# E12000002: North West
# E11000001: Greater Manchester

# Greater Manchester Authorities
# E08000001: Bolton
# E08000002: Bury
# E08000003: Manchester
# E08000004: Oldham
# E08000005: Rochdale
# E08000006: Salford
# E08000007: Stockport
# E08000008: Tameside
# E08000009: Trafford
# E08000010: Wigan

# Trafford's Children's Services Statistical Neighbours
# E10000015: Hertfordshire
# E09000006: Bromley
# E08000029: Solihull
# E08000007: Stockport
# E06000036: Bracknell Forest
# E06000056: Central Bedfordshire
# E06000014: York
# E06000049: Cheshire East
# E10000014: Hampshire
# E06000060: Buckinghamshire

# Trafford's CIPFA Nearest Neighbours (2019)
# E06000007: Warrington
# E06000030: Swindon
# E08000029: Solihull
# E06000042: Milton Keynes
# E06000025: South Gloucestershire
# E06000034: Thurrock
# E08000007: Stockport
# E06000014: York
# E06000055: Bedford
# E06000050: Cheshire West and Chester
# E06000031: Peterborough
# E06000005: Darlington
# E06000015: Derby
# E08000002: Bury
# E06000020: Telford and Wrekin


# Load the required libraries ---------------------------
library(tidyverse);


# Setup objects required by this script ---------------------------

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")


## NOTE: Data downloaded locally via the form on the ONS website. Can also be downloaded via API from NOMIS


# Accommodation type ---------------------------

# LA (GM)
df_la_accommodation_type <- read_csv("accommodation_type_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         accommodation_type = `Accommodation type (8 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_la_gm.csv")


# MSOA (Trafford)
df_msoa_accommodation_type <- read_csv("accommodation_type_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         accommodation_type = `Accommodation type (8 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_accommodation_type <- read_csv("accommodation_type_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         accommodation_type = `Accommodation type (8 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_lsoa_trafford.csv")


# OA (Trafford)
df_oa_accommodation_type <- read_csv("accommodation_type_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         accommodation_type = `Accommodation type (8 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_oa_trafford.csv")


# Household Tenure ---------------------------

# LA (GM)
df_la_household_tenure <- read_csv("household_tenure_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         household_tenure = `Tenure of household (9 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         household_tenure != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_tenure <- read_csv("household_tenure_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         household_tenure = `Tenure of household (9 categories)`,
         value = Observation
  ) %>%
  filter(household_tenure != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_tenure <- read_csv("household_tenure_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         household_tenure = `Tenure of household (9 categories)`,
         value = Observation
  ) %>%
  filter(household_tenure != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_tenure <- read_csv("household_tenure_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         household_tenure = `Tenure of household (9 categories)`,
         value = Observation
  ) %>%
  filter(household_tenure != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_oa_trafford.csv")


# Car or van availability ---------------------------

# LA (GM)
df_la_car_van_availability <- read_csv("car_van_availability_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         availability_category = `Car or van availability (5 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         availability_category != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_la_gm.csv")


# MSOA (Trafford)
df_msoa_car_van_availability <- read_csv("car_van_availability_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         availability_category = `Car or van availability (5 categories)`,
         value = Observation
  ) %>%
  filter(availability_category != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_car_van_availability <- read_csv("car_van_availability_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         availability_category = `Car or van availability (5 categories)`,
         value = Observation
  ) %>%
  filter(availability_category != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_lsoa_trafford.csv")


# OA (Trafford)
df_oa_car_van_availability <- read_csv("car_van_availability_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         availability_category = `Car or van availability (5 categories)`,
         value = Observation
  ) %>%
  filter(availability_category != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_oa_trafford.csv")


# Central Heating ---------------------------

# LA (GM)
df_la_central_heating <- read_csv("central_heating_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         central_heating_type = `Type of central heating in household (13 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         central_heating_type != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_la_gm.csv")


# MSOA (Trafford)
df_msoa_central_heating <- read_csv("central_heating_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         central_heating_type = `Type of central heating in household (13 categories)`,
         value = Observation
  ) %>%
  filter(central_heating_type != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_central_heating <- read_csv("central_heating_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         central_heating_type = `Type of central heating in household (13 categories)`,
         value = Observation
  ) %>%
  filter(central_heating_type != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_lsoa_trafford.csv")


# OA (Trafford)
df_oa_central_heating <- read_csv("central_heating_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         central_heating_type = `Type of central heating in household (13 categories)`,
         value = Observation
  ) %>%
  filter(central_heating_type != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_oa_trafford.csv")


# Communal Establishment Residents by sex and age  ---------------------------

# LA (GM)
df_la_communal_estab_residents_by_sex_and_age <- read_csv("communal_establishment_residents_sex_age_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         resident_category = `Position in communal establishment and sex and age (19 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Communal establishment residents by age and sex",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, resident_category, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_sex_age_la_gm.csv")


# MSOA (Trafford)
df_msoa_communal_estab_residents_by_sex_and_age <- read_csv("communal_establishment_residents_sex_and_age_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         resident_category = `Position in communal establishment and sex and age (19 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Communal establishment residents by age and sex",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, resident_category, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_sex_age_msoa_trafford.csv")


# Communal Establishment Residents by establishment type  ---------------------------

# LA (GM)
df_la_communal_estab_residents_by_establishment_type <- read_csv("communal_establishment_residents_type_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         establishment_type = `Communal establishment management and type (26 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Communal establishment residents by establishment management and type",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, establishment_type, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_establishment_type_la_gm.csv")


# MSOA (Trafford)
df_msoa_communal_estab_residents_by_establishment_type <- read_csv("communal_establishment_residents_type_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         establishment_type = `Communal establishment management and type (26 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Communal establishment residents by establishment management and type",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, establishment_type, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_establishment_type_msoa_trafford.csv")


# Household number of bedrooms  ---------------------------

# LA (GM)
df_la_household_number_of_bedrooms <- read_csv("household_bedrooms_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         household_bedrooms = `Number of Bedrooms (5 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         household_bedrooms != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_number_of_bedrooms <- read_csv("household_bedrooms_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         household_bedrooms = `Number of Bedrooms (5 categories)`,
         value = Observation
  ) %>%
  filter(household_bedrooms != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_number_of_bedrooms <- read_csv("household_bedrooms_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         household_bedrooms = `Number of Bedrooms (5 categories)`,
         value = Observation
  ) %>%
  filter(household_bedrooms != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_number_of_bedrooms <- read_csv("household_bedrooms_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         household_bedrooms = `Number of Bedrooms (5 categories)`,
         value = Observation
  ) %>%
  filter(household_bedrooms != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_oa_trafford.csv")


# Household number of rooms  ---------------------------

# LA (GM)
df_la_household_number_of_rooms <- read_csv("household_rooms_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         household_rooms = `Number of rooms (Valuation Office Agency) (9 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_number_of_rooms <- read_csv("household_rooms_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         household_rooms = `Number of rooms (Valuation Office Agency) (9 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_number_of_rooms <- read_csv("household_rooms_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         household_rooms = `Number of rooms (Valuation Office Agency) (9 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_number_of_rooms <- read_csv("household_rooms_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         household_rooms = `Number of rooms (Valuation Office Agency) (9 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_oa_trafford.csv")


# Household bedroom occupancy rating  ---------------------------

# LA (GM)
df_la_household_bedroom_occupancy_rating <- read_csv("bedroom_occupancy_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         bedroom_occupancy = `Occupancy rating for bedrooms (6 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         bedroom_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_bedroom_occupancy_rating <- read_csv("bedroom_occupancy_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         bedroom_occupancy = `Occupancy rating for bedrooms (6 categories)`,
         value = Observation
  ) %>%
  filter(bedroom_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_bedroom_occupancy_rating <- read_csv("bedroom_occupancy_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         bedroom_occupancy = `Occupancy rating for bedrooms (6 categories)`,
         value = Observation
  ) %>%
  filter(bedroom_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_bedroom_occupancy_rating <- read_csv("bedroom_occupancy_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         bedroom_occupancy = `Occupancy rating for bedrooms (6 categories)`,
         value = Observation
  ) %>%
  filter(bedroom_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_oa_trafford.csv")


# Household room occupancy rating  ---------------------------

# LA (GM)
df_la_household_room_occupancy_rating <- read_csv("room_occupancy_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         room_occupancy = `Occupancy rating for rooms (6 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         room_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_room_occupancy_rating <- read_csv("room_occupancy_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         room_occupancy = `Occupancy rating for rooms (6 categories)`,
         value = Observation
  ) %>%
  filter(room_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_room_occupancy_rating <- read_csv("room_occupancy_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         room_occupancy = `Occupancy rating for rooms (6 categories)`,
         value = Observation
  ) %>%
  filter(room_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_room_occupancy_rating <- read_csv("room_occupancy_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         room_occupancy = `Occupancy rating for rooms (6 categories)`,
         value = Observation
  ) %>%
  filter(room_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_oa_trafford.csv")


# Second Address Indicator ---------------------------

# LA (GM)
df_la_second_address <- read_csv("second_address_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         second_address_category = `Second address indicator (3 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_la_gm.csv")


# MSOA (Trafford)
df_msoa_second_address <- read_csv("second_address_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         second_address_category = `Second address indicator (3 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_second_address <- read_csv("second_address_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         second_address_category = `Second address indicator (3 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_lsoa_trafford.csv")


# OA (Trafford)
df_oa_second_address <- read_csv("second_address_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         second_address_category = `Second address indicator (3 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_oa_trafford.csv")


# Second Address Purpose ---------------------------

# LA (GM)
df_la_second_address_purpose <- read_csv("second_address_purpose_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         second_address_purpose = `Second address type (10 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_la_gm.csv")


# MSOA (Trafford)
df_msoa_second_address_purpose <- read_csv("second_address_purpose_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         second_address_purpose = `Second address type (10 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_second_address_purpose <- read_csv("second_address_purpose_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         second_address_purpose = `Second address type (10 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_lsoa_trafford.csv")


# OA (Trafford)
df_oa_second_address_purpose <- read_csv("second_address_purpose_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         second_address_purpose = `Second address type (10 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_oa_trafford.csv")

