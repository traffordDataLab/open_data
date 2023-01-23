# Health, disability and unpaid care from Census 2021 data
# 2023-01-19 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/healthdisabilityandunpaidcarecensus2021inenglandandwales

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


# General health ---------------------------

# LA (GM)
df_la_general_health <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2055_1.data.csv?date=latest&geography=645922841...645922850&c2021_health_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         general_health = C2021_HEALTH_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by their own assessment of the general state of their health from very good to very bad. This assessment is not based on a person's health over any specified period of time.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, general_health, measure, unit, value) %>%
  write_csv("2021_general_health_la_gm.csv")


# MSOA (Trafford)
df_msoa_general_health <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2055_1.data.csv?date=latest&geography=637535406...637535433&c2021_health_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         general_health = C2021_HEALTH_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by their own assessment of the general state of their health from very good to very bad. This assessment is not based on a person's health over any specified period of time.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, general_health, measure, unit, value) %>%
  write_csv("2021_general_health_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_general_health <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2055_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_health_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         general_health = C2021_HEALTH_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by their own assessment of the general state of their health from very good to very bad. This assessment is not based on a person's health over any specified period of time.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, general_health, measure, unit, value) %>%
  write_csv("2021_general_health_lsoa_trafford.csv")


# OA (Trafford)
df_oa_general_health <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2055_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_health_6=1...5&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         general_health = C2021_HEALTH_6_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by their own assessment of the general state of their health from very good to very bad. This assessment is not based on a person's health over any specified period of time.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, general_health, measure, unit, value) %>%
  write_csv("2021_general_health_oa_trafford.csv")


# General health (Age Standardised Proportions) ---------------------------

# LA (GM)
df_la_general_health_asp <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2092_1.data.csv?date=latest&geography=645922841...645922850&c2021_health_5=0...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         general_health = C2021_HEALTH_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Percentage",
         indicator = "Estimates that classify usual residents by their own assessment of the general state of their health from very good to very bad. This assessment is not based on a person's health over any specified period of time. Age-standardisation allows for comparisons between populations that may contain proportions of different ages, represented as a percentage.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, general_health, measure, unit, value) %>%
  write_csv("2021_general_health_age_standardised_la_gm.csv")


# Disability ---------------------------

# LA (GM)
df_la_disability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2056_1.data.csv?date=latest&geography=645922841...645922850&c2021_disability_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disability_category = C2021_DISABILITY_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by long-term health problems or disabilities. Residents who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses are considered disabled.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, disability_category, measure, unit, value) %>%
  write_csv("2021_disability_la_gm.csv")


# MSOA (Trafford)
df_msoa_disability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2056_1.data.csv?date=latest&geography=637535406...637535433&c2021_disability_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disability_category = C2021_DISABILITY_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by long-term health problems or disabilities. Residents who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses are considered disabled.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, disability_category, measure, unit, value) %>%
  write_csv("2021_disability_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_disability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2056_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_disability_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disability_category = C2021_DISABILITY_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by long-term health problems or disabilities. Residents who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses are considered disabled.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, disability_category, measure, unit, value) %>%
  write_csv("2021_disability_lsoa_trafford.csv")


# OA (Trafford)
df_oa_disability <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2056_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_disability_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disability_category = C2021_DISABILITY_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by long-term health problems or disabilities. Residents who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses are considered disabled.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, disability_category, measure, unit, value) %>%
  write_csv("2021_disability_oa_trafford.csv")


# Disability (Age Standardised Proportions) ---------------------------

# LA (GM)
df_la_disability_asp <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2093_1.data.csv?date=latest&geography=645922841...645922850&c2021_disability_3=0...2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disability_category = C2021_DISABILITY_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Percentage",
         indicator = "Estimates that classify usual residents by long-term health problems or disabilities. Residents who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses are considered disabled. Age-standardisation allows for comparisons between populations that may contain proportions of different ages, represented as a percentage.",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, disability_category, measure, unit, value) %>%
  write_csv("2021_disability_age_standardised_la_gm.csv")


# Provision of unpaid care ---------------------------

# LA (GM)
df_la_unpaid_care <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2057_1.data.csv?date=latest&geography=645922841...645922850&c2021_carer_7=1...6&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         unpaid_care = C2021_CARER_7_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by the number of hours of unpaid care they provide",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, unpaid_care, measure, unit, value) %>%
  write_csv("2021_unpaid_care_la_gm.csv")


# Provision of unpaid care (Age Standardised Proportions) ---------------------------

# LA (GM)
df_la_unpaid_care_asp <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2094_1.data.csv?date=latest&geography=645922841...645922850&c2021_carer_4=0...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         unpaid_care = C2021_CARER_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Percentage",
         indicator = "Estimates that classify usual residents by the number of hours of unpaid care they provide. Age-standardisation allows for comparisons between populations that may contain proportions of different ages, represented as a percentage.",
         unit = "Persons",
         unpaid_care = str_replace_all(unpaid_care, 'carea', 'care a')) %>%
  select(area_code, area_name, geography, period, indicator, unpaid_care, measure, unit, value) %>%
  write_csv("2021_unpaid_care_age_standardised_la_gm.csv")


# MSOA (Trafford)
df_msoa_unpaid_care <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2057_1.data.csv?date=latest&geography=637535406...637535433&c2021_carer_7=1...6&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         unpaid_care = C2021_CARER_7_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by the number of hours of unpaid care they provide",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, unpaid_care, measure, unit, value) %>%
  write_csv("2021_unpaid_care_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_unpaid_care <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2057_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_carer_7=1...6&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         unpaid_care = C2021_CARER_7_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by the number of hours of unpaid care they provide",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, unpaid_care, measure, unit, value) %>%
  write_csv("2021_unpaid_care_lsoa_trafford.csv")


# OA (Trafford)
df_oa_unpaid_care <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2057_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_carer_7=1...6&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         unpaid_care = C2021_CARER_7_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Estimates that classify usual residents by the number of hours of unpaid care they provide",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, unpaid_care, measure, unit, value) %>%
  write_csv("2021_unpaid_care_oa_trafford.csv")


# Number of disabled people in the household ---------------------------

# LA (GM)
df_la_household_disabled_members <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2058_1.data.csv?date=latest&geography=645922841...645922850&c2021_hhdisabled_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disabled_household_members = C2021_HHDISABLED_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "The number of people in a household who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses and are considered disabled. This definition of a disabled person meets the harmonised standard for measuring disability and is in line with the Equality Act (2010).",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, disabled_household_members, measure, unit, value) %>%
  write_csv("2021_disabled_people_in_household_la_gm.csv")


# MSOA (Trafford)
df_msoa_household_disabled_members <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2058_1.data.csv?date=latest&geography=637535406...637535433&c2021_hhdisabled_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disabled_household_members = C2021_HHDISABLED_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "The number of people in a household who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses and are considered disabled. This definition of a disabled person meets the harmonised standard for measuring disability and is in line with the Equality Act (2010).",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, disabled_household_members, measure, unit, value) %>%
  write_csv("2021_disabled_people_in_household_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_household_disabled_members <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2058_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_hhdisabled_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disabled_household_members = C2021_HHDISABLED_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "The number of people in a household who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses and are considered disabled. This definition of a disabled person meets the harmonised standard for measuring disability and is in line with the Equality Act (2010).",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, disabled_household_members, measure, unit, value) %>%
  write_csv("2021_disabled_people_in_household_lsoa_trafford.csv")


# OA (Trafford)
df_oa_household_disabled_members <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2058_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_hhdisabled_4=1...3&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         disabled_household_members = C2021_HHDISABLED_4_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "The number of people in a household who assessed their day-to-day activities as limited by long-term physical or mental health conditions or illnesses and are considered disabled. This definition of a disabled person meets the harmonised standard for measuring disability and is in line with the Equality Act (2010).",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, disabled_household_members, measure, unit, value) %>%
  write_csv("2021_disabled_people_in_household_oa_trafford.csv")

