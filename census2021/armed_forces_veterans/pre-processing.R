# UK armed forces veterans data, England and Wales: Census 2021
# 2022-11-10 James Austin.
# 2023-01-31 Updated to use NOMIS API and added ward data
# Source: Office for National Statistics via NOMIS and https://www.ons.gov.uk/peoplepopulationandcommunity/armedforcescommunity/bulletins/ukarmedforcesveteransenglandandwales/census2021

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


# TS071 - Previously served in the UK armed forces (persons) ---------------------------

# LA
df_veterans_person_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2088_1.data.csv?date=latest&geography=645922841...645922850&c2021_ukforcevet_6=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         veteran_status = C2021_UKFORCEVET_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         unit = "Persons",
         indicator = "Identifies all usual residents aged 16 and over who have previously served in the UK armed forces. This includes those who have served for at least one day in armed forces, either regular or reserves, or Merchant Mariners who have seen duty on legally defined military operations.") %>%
  select(area_code, area_name, geography, period, indicator, veteran_status, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_person_la_gm.csv")


# MSOA
df_veterans_person_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2088_1.data.csv?date=latest&geography=637535406...637535433&c2021_ukforcevet_6=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         veteran_status = C2021_UKFORCEVET_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         unit = "Persons",
         indicator = "Identifies all usual residents aged 16 and over who have previously served in the UK armed forces. This includes those who have served for at least one day in armed forces, either regular or reserves, or Merchant Mariners who have seen duty on legally defined military operations.") %>%
  select(area_code, area_name, geography, period, indicator, veteran_status, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_person_msoa_trafford.csv")


# Ward
df_veterans_person_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2088_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_ukforcevet_6=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         veteran_status = C2021_UKFORCEVET_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         measure = "Count",
         unit = "Persons",
         indicator = "Identifies all usual residents aged 16 and over who have previously served in the UK armed forces. This includes those who have served for at least one day in armed forces, either regular or reserves, or Merchant Mariners who have seen duty on legally defined military operations.") %>%
  select(area_code, area_name, geography, period, indicator, veteran_status, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_person_ward_trafford.csv")


# TS072 - Number of people in household who have previously served in UK armed forces (households) ---------------------------

# LA
df_veterans_household_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2089_1.data.csv?date=latest&geography=645922841...645922850&c2021_hhveteran_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_veterans = C2021_HHVETERAN_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         unit = "Households",
         indicator = "Number of people in the household who have previously served in the UK armed forces. This includes those who have served for at least one day in armed forces, either regular, reserves or Merchant Mariners who have seen duty on legally defined military operations.") %>%
  select(area_code, area_name, geography, period, indicator, household_veterans, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_household_la_gm.csv")


# MSOA
df_veterans_household_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2089_1.data.csv?date=latest&geography=637535406...637535433&c2021_hhveteran_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_veterans = C2021_HHVETERAN_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         unit = "Households",
         indicator = "Number of people in the household who have previously served in the UK armed forces. This includes those who have served for at least one day in armed forces, either regular, reserves or Merchant Mariners who have seen duty on legally defined military operations.") %>%
  select(area_code, area_name, geography, period, indicator, household_veterans, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_household_msoa_trafford.csv")


# Ward
df_veterans_household_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2089_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_hhveteran_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_veterans = C2021_HHVETERAN_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         measure = "Count",
         unit = "Households",
         indicator = "Number of people in the household who have previously served in the UK armed forces. This includes those who have served for at least one day in armed forces, either regular, reserves or Merchant Mariners who have seen duty on legally defined military operations.") %>%
  select(area_code, area_name, geography, period, indicator, household_veterans, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_household_ward_trafford.csv")


# TS073 - Population who have previously served in UK armed forces in communal establishments and in households (persons) ---------------------------

# LA
df_veterans_residence_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2090_1.data.csv?date=latest&geography=645922841...645922850&c2021_restype_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         residence_type = C2021_RESTYPE_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         unit = "Persons",
         indicator = "Usual residents in England and Wales who have previously served in the UK armed forces by whether they reside in communal establishments and in households.") %>%
  select(area_code, area_name, geography, period, indicator, residence_type, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_residence_la_gm.csv")


# MSOA
df_veterans_residence_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2090_1.data.csv?date=latest&geography=637535406...637535433&c2021_restype_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         residence_type = C2021_RESTYPE_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         unit = "Persons",
         indicator = "Usual residents in England and Wales who have previously served in the UK armed forces by whether they reside in communal establishments and in households.") %>%
  select(area_code, area_name, geography, period, indicator, residence_type, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_residence_msoa_trafford.csv")


# Ward
df_veterans_residence_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2090_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_restype_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         residence_type = C2021_RESTYPE_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         measure = "Count",
         unit = "Persons",
         indicator = "Usual residents in England and Wales who have previously served in the UK armed forces by whether they reside in communal establishments and in households.") %>%
  select(area_code, area_name, geography, period, indicator, residence_type, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_residence_ward_trafford.csv")


# TS074 - Household Reference Person indicator of previous service in UK armed forces (households) ---------------------------

# LA
df_veterans_household_ref_person_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2091_1.data.csv?date=latest&geography=645922841...645922850&c2021_hh_hrp_veteran_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         reference_person_veteran_status = C2021_HH_HRP_VETERAN_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         unit = "Households",
         indicator = "Classifying households in England and Wales by whether or not the Household Reference Person has previously served in the UK armed forces.") %>%
  select(area_code, area_name, geography, period, indicator, reference_person_veteran_status, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_household_reference_indicator_la_gm.csv")


# MSOA
df_veterans_household_ref_person_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2091_1.data.csv?date=latest&geography=637535406...637535433&c2021_hh_hrp_veteran_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         reference_person_veteran_status = C2021_HH_HRP_VETERAN_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         unit = "Households",
         indicator = "Classifying households in England and Wales by whether or not the Household Reference Person has previously served in the UK armed forces.") %>%
  select(area_code, area_name, geography, period, indicator, reference_person_veteran_status, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_household_reference_indicator_msoa_trafford.csv")


# Ward
df_veterans_household_ref_person_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2091_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_hh_hrp_veteran_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         reference_person_veteran_status = C2021_HH_HRP_VETERAN_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         measure = "Count",
         unit = "Households",
         indicator = "Classifying households in England and Wales by whether or not the Household Reference Person has previously served in the UK armed forces.") %>%
  select(area_code, area_name, geography, period, indicator, reference_person_veteran_status, measure, unit, value) %>%
  write_csv("2021_armed_forces_veterans_household_reference_indicator_ward_trafford.csv")
