# UK armed forces veterans data, England and Wales: Census 2021
# 2022-11-10 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/articles/demographyandmigrationdatacontent/2022-11-02

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
library(tidyverse); library(httr); library(readxl); library(janitor)


# Setup objects required by this script ---------------------------

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")


# Previously served in the UK armed forces (person) ---------------------------

# LA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/20221110/TS071_uk_armed_forces/UR-ltla%2Buk_armed_forces.xlsx", write_disk(tmp))

df_veterans_person_la <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         indicator = `UK armed forces veteran indicator (5 categories) Label`,
         value = Count
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_veterans_person_la, "2021_armed_forces_veterans_person_la_gm.csv")

unlink(tmp)

# MSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/20221110/TS071_uk_armed_forces/UR-msoa%2Buk_armed_forces.xlsx", write_disk(tmp))

df_veterans_person_msoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas Label`,
         indicator = `UK armed forces veteran indicator (5 categories) Label`,
         value = Count) %>%
  filter(grepl('Trafford', area_name)) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Middle-layer Super Output Area",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_veterans_person_msoa, "2021_armed_forces_veterans_person_msoa_trafford.csv")

unlink(tmp)


# Previously served in the UK armed forces (households) ---------------------------

# LA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/20221110/TS072_hh_veterans_5a/HH-ltla%2Bhh_veterans_5a.xlsx", write_disk(tmp))

df_veterans_household_la <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         indicator = `Number of people in household who previously served in UK armed forces (5 categories) Label`,
         value = Count
  ) %>%
  filter(area_code %in% area_codes_gm,
         indicator != "Does not apply") %>% # checked the data and all of these are zero
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_veterans_household_la, "2021_armed_forces_veterans_household_la_gm.csv")

unlink(tmp)

# MSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/20221110/TS072_hh_veterans_5a/HH-msoa%2Bhh_veterans_5a.xlsx", write_disk(tmp))

df_veterans_household_msoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas Label`,
         indicator = `Number of people in household who previously served in UK armed forces (5 categories) Label`,
         value = Count) %>%
  filter(grepl('Trafford', area_name),
         indicator != "Does not apply") %>% # checked the data and all of these are zero
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Middle-layer Super Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_veterans_household_msoa, "2021_armed_forces_veterans_household_msoa_trafford.csv")

unlink(tmp)
