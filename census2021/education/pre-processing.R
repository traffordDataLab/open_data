# Education data from Census 2021
# 2023-01-16 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/educationcensus2021inenglandandwales

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


# Highest level of qualification ---------------------------

# LA (GM)
df_la_highest_qualification <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2084_1.data.csv?date=latest&geography=645922841...645922850&c2021_hiqual_8=1...7&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         highest_qualification = C2021_HIQUAL_8_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Highest level of qualification held by usual residents aged 16 years and over. This is derived from the question asking people to indicate all qualifications held, or their nearest equivalent. This may include foreign qualifications where they were matched to the closest UK equivalent",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, highest_qualification, measure, unit, value) %>%
  write_csv("2021_highest_level_qualification_la_gm.csv")


# MSOA (Trafford)
df_msoa_highest_qualification <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2084_1.data.csv?date=latest&geography=637535406...637535433&c2021_hiqual_8=1...7&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         highest_qualification = C2021_HIQUAL_8_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Highest level of qualification held by usual residents aged 16 years and over. This is derived from the question asking people to indicate all qualifications held, or their nearest equivalent. This may include foreign qualifications where they were matched to the closest UK equivalent",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, highest_qualification, measure, unit, value) %>%
  write_csv("2021_highest_level_qualification_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_highest_qualification <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2084_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_hiqual_8=1...7&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         highest_qualification = C2021_HIQUAL_8_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Highest level of qualification held by usual residents aged 16 years and over. This is derived from the question asking people to indicate all qualifications held, or their nearest equivalent. This may include foreign qualifications where they were matched to the closest UK equivalent",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, highest_qualification, measure, unit, value) %>%
  write_csv("2021_highest_level_qualification_lsoa_trafford.csv")


# OA (Trafford)
df_oa_highest_qualification <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2084_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_hiqual_8=1...7&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         highest_qualification = C2021_HIQUAL_8_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Highest level of qualification held by usual residents aged 16 years and over. This is derived from the question asking people to indicate all qualifications held, or their nearest equivalent. This may include foreign qualifications where they were matched to the closest UK equivalent",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, highest_qualification, measure, unit, value) %>%
  write_csv("2021_highest_level_qualification_oa_trafford.csv")


# Schoolchildren and full-time students ---------------------------

# LA (GM)
df_la_student <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2085_1.data.csv?date=latest&geography=645922841...645922850&c2021_student_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         student_status = C2021_STUDENT_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Whether a person aged 5 years and over was in full-time education on Census Day, 21 March 2021. This includes schoolchildren and adults in full-time education. Schoolchildren and students in full-time education studying away from home are treated as usually resident at their term-time address",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, student_status, measure, unit, value) %>%
  write_csv("2021_schoolchildren_and_full-time_students_la_gm.csv")


# MSOA (Trafford)
df_msoa_student <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2085_1.data.csv?date=latest&geography=637535406...637535433&c2021_student_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         student_status = C2021_STUDENT_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Whether a person aged 5 years and over was in full-time education on Census Day, 21 March 2021. This includes schoolchildren and adults in full-time education. Schoolchildren and students in full-time education studying away from home are treated as usually resident at their term-time address",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, student_status, measure, unit, value) %>%
  write_csv("2021_schoolchildren_and_full-time_students_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_student <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2085_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_student_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         student_status = C2021_STUDENT_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Whether a person aged 5 years and over was in full-time education on Census Day, 21 March 2021. This includes schoolchildren and adults in full-time education. Schoolchildren and students in full-time education studying away from home are treated as usually resident at their term-time address",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, student_status, measure, unit, value) %>%
  write_csv("2021_schoolchildren_and_full-time_students_lsoa_trafford.csv")


# OA (Trafford)
df_oa_student <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2085_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_student_3=1,2&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         student_status = C2021_STUDENT_3_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Whether a person aged 5 years and over was in full-time education on Census Day, 21 March 2021. This includes schoolchildren and adults in full-time education. Schoolchildren and students in full-time education studying away from home are treated as usually resident at their term-time address",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, student_status, measure, unit, value) %>%
  write_csv("2021_schoolchildren_and_full-time_students_oa_trafford.csv")

