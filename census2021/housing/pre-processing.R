# Housing from Census 2021 data
# ONS QUALITY NOTICE: We have made changes to housing definitions since the 2011 Census. Take care if you compare Census 2021 results for this topic with those from the 2011 Census.

# 2023-01-05 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/housingcensus2021inenglandandwales

# NOTE: Data can be downloaded locally via the URL above or via NOMIS API as shown in code below

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


# TS044 - Accommodation type (households) ---------------------------

# LA (GM)
df_la_accommodation_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2062_1.data.csv?date=latest&geography=645922841...645922850&c2021_acctype_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         accommodation_type = C2021_ACCTYPE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_la_gm.csv")


# MSOA (Trafford)
df_msoa_accommodation_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2062_1.data.csv?date=latest&geography=637535406...637535433&c2021_acctype_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         accommodation_type = C2021_ACCTYPE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_accommodation_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2062_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_acctype_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         accommodation_type = C2021_ACCTYPE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_lsoa_trafford.csv")


# OA (Trafford)
df_oa_accommodation_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2062_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_acctype_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         accommodation_type = C2021_ACCTYPE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_oa_trafford.csv")


# Ward (Trafford)
df_ward_accommodation_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2062_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_acctype_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         accommodation_type = C2021_ACCTYPE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Households in England and Wales by accommodation type",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, accommodation_type, measure, unit, value) %>%
  write_csv("2021_accommodation_type_ward_trafford.csv")


# TS054 - Household Tenure (households) ---------------------------

# LA (GM)
df_la_household_tenure <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2072_1.data.csv?date=latest&geography=645922841...645922850&c2021_tenure_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_tenure = C2021_TENURE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_tenure <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2072_1.data.csv?date=latest&geography=637535406...637535433&c2021_tenure_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_tenure = C2021_TENURE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_tenure <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2072_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_tenure_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_tenure = C2021_TENURE_9_NAME,
         value = OBS_VALUE
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
df_oa_household_tenure <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2072_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_tenure_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_tenure = C2021_TENURE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_oa_trafford.csv")


# Ward (Trafford)
df_ward_household_tenure <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2072_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_tenure_9=1...8&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_tenure = C2021_TENURE_9_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Classification of households by tenure. There is evidence of people incorrectly identifying their type of landlord as ”Council or local authority” or “Housing association”. You should add these two categories together when analysing data that uses this variable",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_tenure, measure, unit, value) %>%
  write_csv("2021_household_tenure_ward_trafford.csv")


# TS045 - Car or van availability (households) ---------------------------

# LA (GM)
df_la_car_van_availability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2063_1.data.csv?date=latest&geography=645922841...645922850&c2021_cars_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         availability_category = C2021_CARS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_la_gm.csv")


# MSOA (Trafford)
df_msoa_car_van_availability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2063_1.data.csv?date=latest&geography=637535406...637535433&c2021_cars_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         availability_category = C2021_CARS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_car_van_availability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2063_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_cars_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         availability_category = C2021_CARS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_lsoa_trafford.csv")


# OA (Trafford)
df_oa_car_van_availability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2063_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_cars_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         availability_category = C2021_CARS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_oa_trafford.csv")


# Ward (Trafford)
df_ward_car_van_availability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2063_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_cars_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         availability_category = C2021_CARS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "The number of cars or vans owned or available for use by household members (excludes motorbikes, trikes, quad bikes, mobility scooters, vehicles with a SORN, vehicles owned or used only by a visitor, vehicles that are kept at another address or not easily accessed)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, availability_category, measure, unit, value) %>%
  write_csv("2021_car_van_availability_ward_trafford.csv")


# TS046 - Central Heating (households) ---------------------------

# LA (GM)
df_la_central_heating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2064_1.data.csv?date=latest&geography=645922841...645922850&c2021_heating_13=1...12&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         central_heating_type = C2021_HEATING_13_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_la_gm.csv")


# MSOA (Trafford)
df_msoa_central_heating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2064_1.data.csv?date=latest&geography=637535406...637535433&c2021_heating_13=1...12&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         central_heating_type = C2021_HEATING_13_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_central_heating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2064_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_heating_13=1...12&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         central_heating_type = C2021_HEATING_13_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_lsoa_trafford.csv")


# OA (Trafford)
df_oa_central_heating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2064_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_heating_13=1...12&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         central_heating_type = C2021_HEATING_13_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_oa_trafford.csv")


# Ward (Trafford)
df_ward_central_heating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2064_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_heating_13=1...12&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         central_heating_type = C2021_HEATING_13_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "The type of central heating present in occupied household spaces",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, central_heating_type, measure, unit, value) %>%
  write_csv("2021_central_heating_ward_trafford.csv")


# TS047 - Communal Establishment Residents by sex and age (persons)  ---------------------------

# LA (GM)
df_la_communal_estab_residents_by_sex_and_age <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2065_1.data.csv?date=latest&geography=645922841...645922850&c2021_age_sex_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         resident_category = C2021_AGE_SEX_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Communal establishment residents by age and sex",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, resident_category, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_sex_age_la_gm.csv")


# MSOA (Trafford)
df_msoa_communal_estab_residents_by_sex_and_age <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2065_1.data.csv?date=latest&geography=637535406...637535433&c2021_age_sex_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         resident_category = C2021_AGE_SEX_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Communal establishment residents by age and sex",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, resident_category, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_sex_age_msoa_trafford.csv")


# Ward (Trafford)
df_ward_communal_estab_residents_by_sex_and_age <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2065_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_age_sex_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         resident_category = C2021_AGE_SEX_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Communal establishment residents by age and sex",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, resident_category, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_sex_age_ward_trafford.csv")


# TS048 - Communal Establishment Residents by establishment type (persons)  ---------------------------

# LA (GM)
df_la_communal_estab_residents_by_establishment_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2066_1.data.csv?date=latest&geography=645922841...645922850&c2021_comest_26=1...26&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         establishment_type = C2021_COMEST_26_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Communal establishment residents by establishment management and type",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, establishment_type, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_establishment_type_la_gm.csv")


# MSOA (Trafford)
df_msoa_communal_estab_residents_by_establishment_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2066_1.data.csv?date=latest&geography=637535406...637535433&c2021_comest_26=1...26&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         establishment_type = C2021_COMEST_26_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Communal establishment residents by establishment management and type",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, establishment_type, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_establishment_type_msoa_trafford.csv")


# Ward (Trafford)
df_ward_communal_estab_residents_by_establishment_type <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2066_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_comest_26=1...26&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         establishment_type = C2021_COMEST_26_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Communal establishment residents by establishment management and type",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, establishment_type, measure, unit, value) %>%
  write_csv("2021_communal_establishment_residents_establishment_type_ward_trafford.csv")


# TS050 - Household number of bedrooms (households)  ---------------------------

# LA (GM)
df_la_household_number_of_bedrooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2068_1.data.csv?date=latest&geography=645922841...645922850&c2021_bedrooms_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_bedrooms = C2021_BEDROOMS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_number_of_bedrooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2068_1.data.csv?date=latest&geography=637535406...637535433&c2021_bedrooms_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_bedrooms = C2021_BEDROOMS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_number_of_bedrooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2068_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_bedrooms_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_bedrooms = C2021_BEDROOMS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_number_of_bedrooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2068_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_bedrooms_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_bedrooms = C2021_BEDROOMS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_oa_trafford.csv")


# Ward (Trafford)
df_ward_household_number_of_bedrooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2068_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_bedrooms_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_bedrooms = C2021_BEDROOMS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Number of bedrooms in household spaces with at least one usual resident",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_bedrooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_bedrooms_ward_trafford.csv")


# TS051 Household number of rooms (households) ---------------------------

# LA (GM)
df_la_household_number_of_rooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2069_1.data.csv?date=latest&geography=645922841...645922850&c2021_rooms_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_rooms = C2021_ROOMS_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_number_of_rooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2069_1.data.csv?date=latest&geography=637535406...637535433&c2021_rooms_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_rooms = C2021_ROOMS_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_number_of_rooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2069_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_rooms_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_rooms = C2021_ROOMS_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_number_of_rooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2069_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_rooms_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_rooms = C2021_ROOMS_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_oa_trafford.csv")


# Ward (Trafford)
df_ward_household_number_of_rooms <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2069_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_rooms_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         household_rooms = C2021_ROOMS_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Number of rooms in household spaces with at least one usual resident (Valuation Office Agency definition)",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_rooms, measure, unit, value) %>%
  write_csv("2021_household_number_of_rooms_ward_trafford.csv")


# TS052 - Household bedroom occupancy rating (households) ---------------------------

# LA (GM)
df_la_household_bedroom_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2070_1.data.csv?date=latest&geography=645922841...645922850&c2021_occrat_bedrooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         bedroom_occupancy = C2021_OCCRAT_BEDROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_bedroom_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2070_1.data.csv?date=latest&geography=637535406...637535433&c2021_occrat_bedrooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         bedroom_occupancy = C2021_OCCRAT_BEDROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_bedroom_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2070_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_occrat_bedrooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         bedroom_occupancy = C2021_OCCRAT_BEDROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_bedroom_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2070_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_occrat_bedrooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         bedroom_occupancy = C2021_OCCRAT_BEDROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  filter(bedroom_occupancy != "Does not apply") %>%  # These are 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_oa_trafford.csv")


# Ward (Trafford)
df_ward_household_bedroom_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2070_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_occrat_bedrooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         bedroom_occupancy = C2021_OCCRAT_BEDROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of bedrooms in the household. -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of bedrooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, bedroom_occupancy, measure, unit, value) %>%
  write_csv("2021_household_bedroom_occupancy_ward_trafford.csv")


# TS053 - Household room occupancy rating (households) ---------------------------

# LA (GM)
df_la_household_room_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2071_1.data.csv?date=latest&geography=645922841...645922850&c2021_occrat_rooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         room_occupancy = C2021_OCCRAT_ROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_room_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2071_1.data.csv?date=latest&geography=637535406...637535433&c2021_occrat_rooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         room_occupancy = C2021_OCCRAT_ROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_room_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2071_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_occrat_rooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         room_occupancy = C2021_OCCRAT_ROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_room_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2071_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_occrat_rooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         room_occupancy = C2021_OCCRAT_ROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_oa_trafford.csv")


# Ward (Trafford)
df_ward_household_room_occupancy_rating <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2071_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_occrat_rooms_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         room_occupancy = C2021_OCCRAT_ROOMS_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Occupancy rating based on the number of rooms in the household (Valuation Office Agency definition). -1 or less implies overcrowding, +1 or more implies under-occupancy and 0 suggests the household has an ideal number of rooms",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, room_occupancy, measure, unit, value) %>%
  write_csv("2021_household_room_occupancy_ward_trafford.csv")


# TS056 - Second Address Indicator (persons) ---------------------------

# LA (GM)
df_la_second_address <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2074_1.data.csv?date=latest&geography=645922841...645922850&c2021_2addr_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_category = C2021_2ADDR_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_la_gm.csv")


# MSOA (Trafford)
df_msoa_second_address <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2074_1.data.csv?date=latest&geography=637535406...637535433&c2021_2addr_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_category = C2021_2ADDR_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_second_address <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2074_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_2addr_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_category = C2021_2ADDR_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_lsoa_trafford.csv")


# OA (Trafford)
df_oa_second_address <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2074_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_2addr_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_category = C2021_2ADDR_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_oa_trafford.csv")


# Ward (Trafford)
df_ward_second_address <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2074_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_2addr_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_category = C2021_2ADDR_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Classification of usual residents by their use of a second address and whether that address is inside or outside the UK",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_category, measure, unit, value) %>%
  write_csv("2021_second_address_indicator_ward_trafford.csv")


# TS055 - Second Address Purpose (persons) ---------------------------

# LA (GM)
df_la_second_address_purpose <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2073_1.data.csv?date=latest&geography=645922841...645922850&c2021_pur2addr_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_purpose = C2021_PUR2ADDR_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_la_gm.csv")


# MSOA (Trafford)
df_msoa_second_address_purpose <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2073_1.data.csv?date=latest&geography=637535406...637535433&c2021_pur2addr_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_purpose = C2021_PUR2ADDR_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_second_address_purpose <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2073_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_pur2addr_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_purpose = C2021_PUR2ADDR_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_lsoa_trafford.csv")


# OA (Trafford)
df_oa_second_address_purpose <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2073_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_pur2addr_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_purpose = C2021_PUR2ADDR_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_oa_trafford.csv")


df_ward_second_address_purpose <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2073_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_pur2addr_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         second_address_purpose = C2021_PUR2ADDR_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Classification of usual residents with a second address by the purpose of that second address. The 'Does not apply' classification applies to people without an alternative address.",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, second_address_purpose, measure, unit, value) %>%
  write_csv("2021_second_address_purpose_ward_trafford.csv")

