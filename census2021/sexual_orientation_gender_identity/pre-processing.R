# Sexual orientation and gender identity from Census 2021 data
# 2023-01-13 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/sexualorientationandgenderidentitycensus2021inenglandandwales

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


# Objects containing LA codes above ---------------------------

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")


## NOTE: Data can be downloaded locally via the URL at the top of the script or via NOMIS API as shown in code below


# Gender identity ---------------------------

# LA (GM)
df_la_gender_identity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2061_1.data.csv?date=latest&geography=645922841...645922850&c2021_genderid_7=1...6&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         gender_identity = C2021_GENDERID_7_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Gender identity of usual residents (voluntary question only asked of people aged 16 years and over)",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, gender_identity, measure, unit, value) %>%
  write_csv("2021_gender_identity_la_gm.csv")


# MSOA (Trafford)
df_msoa_gender_identity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2061_1.data.csv?date=latest&geography=637535406...637535433&c2021_genderid_7=1...6&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         gender_identity = C2021_GENDERID_7_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Gender identity of usual residents (voluntary question only asked of people aged 16 years and over)",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, gender_identity, measure, unit, value) %>%
  write_csv("2021_gender_identity_msoa_trafford.csv")


# Gender identity - Detailed ---------------------------

# LA (GM)
df_la_gender_identity_detailed <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2087_1.data.csv?date=latest&geography=645922841...645922850&c2021_genderid_8=1...7&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         gender_identity = C2021_GENDERID_8_NAME,
         value = OBS_VALUE
  ) %>%
  filter(gender_identity != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Gender identity of usual residents (voluntary question only asked of people aged 16 years and over)",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, gender_identity, measure, unit, value) %>%
  write_csv("2021_gender_identity_detailed_la_gm.csv")


# Sexual orientation ---------------------------

# LA (GM)
df_la_sexual_orientation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2060_1.data.csv?date=latest&geography=645922841...645922850&c2021_sexor_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sexual_orientation = C2021_SEXOR_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Sexual orientation of usual residents (voluntary question only asked of people aged 16 years and over)",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, sexual_orientation, measure, unit, value) %>%
  write_csv("2021_sexual_orientation_la_gm.csv")


# MSOA (Trafford)
df_msoa_sexual_orientation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2060_1.data.csv?date=latest&geography=637535406...637535433&c2021_sexor_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sexual_orientation = C2021_SEXOR_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Sexual orientation of usual residents (voluntary question only asked of people aged 16 years and over)",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, sexual_orientation, measure, unit, value) %>%
  write_csv("2021_sexual_orientation_msoa_trafford.csv")


# Sexual orientation - detailed ---------------------------

# LA (GM)
df_la_sexual_orientation_detailed <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2086_1.data.csv?date=latest&geography=645922841...645922850&c2021_sexor_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sexual_orientation = C2021_SEXOR_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Sexual orientation of usual residents (voluntary question only asked of people aged 16 years and over)",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, sexual_orientation, measure, unit, value) %>%
  write_csv("2021_sexual_orientation_detailed_la_gm.csv")

