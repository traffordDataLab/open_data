# Labour Market and Travel to Work from Census 2021 data
# ONS QUALITY NOTICE: As Census 2021 was during a unique period of rapid change, take care when using this data for planning purposes.

# 2022-12-14 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/labourmarketandtraveltoworkcensus2021inenglandandwales

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


# TS058 - Distance travelled to work (persons) ---------------------------

# LA (GM)
df_la_distance_travelled_to_work <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2075_1.data.csv?date=latest&geography=645922841...645922850&c2021_ttwdist_11=1...10&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         distance_travelled_category = C2021_TTWDIST_11_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_la_gm.csv")


# MSOA (Trafford)
df_msoa_distance_travelled_to_work <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2075_1.data.csv?date=latest&geography=637535406...637535433&c2021_ttwdist_11=1...10&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         distance_travelled_category = C2021_TTWDIST_11_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_distance_travelled_to_work <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2075_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_ttwdist_11=1...10&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         distance_travelled_category = C2021_TTWDIST_11_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_lsoa_trafford.csv")


# OA (Trafford)
df_oa_distance_travelled_to_work <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2075_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_ttwdist_11=1...10&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         distance_travelled_category = C2021_TTWDIST_11_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_oa_trafford.csv")


# Ward (Trafford)
df_ward_distance_travelled_to_work <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2075_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_ttwdist_11=1...10&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         distance_travelled_category = C2021_TTWDIST_11_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_ward_trafford.csv")


# TS059 - Hours worked (persons) ---------------------------

# LA (GM)
df_la_hours_worked <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2076_1.data.csv?date=latest&geography=645922841...645922850&c2021_hours_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         hours_worked_category = C2021_HOURS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_la_gm.csv")


# MSOA (Trafford)
df_msoa_hours_worked <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2076_1.data.csv?date=latest&geography=637535406...637535433&c2021_hours_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         hours_worked_category = C2021_HOURS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_hours_worked <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2076_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_hours_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         hours_worked_category = C2021_HOURS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_lsoa_trafford.csv")


# OA (Trafford)
df_oa_hours_worked <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2076_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_hours_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         hours_worked_category = C2021_HOURS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_oa_trafford.csv")


# Ward (Trafford)
df_ward_hours_worked <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2076_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_hours_5=1...4&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         hours_worked_category = C2021_HOURS_5_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_ward_trafford.csv")


# TS066 - Economic activity (persons) ---------------------------

# LA (GM)
df_la_economic_activity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2083_1.data.csv?date=latest&geography=645922841...645922850&c2021_eastat_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         economic_activity_status = C2021_EASTAT_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_la_gm.csv")


# MSOA (Trafford)
df_msoa_economic_activity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2083_1.data.csv?date=latest&geography=637535406...637535433&c2021_eastat_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         economic_activity_status = C2021_EASTAT_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_economic_activity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2083_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_eastat_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         economic_activity_status = C2021_EASTAT_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_lsoa_trafford.csv")


# OA (Trafford)
df_oa_economic_activity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2083_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_eastat_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         economic_activity_status = C2021_EASTAT_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_oa_trafford.csv")


# Ward (Trafford)
df_ward_economic_activity <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2083_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_eastat_20=1...19&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         economic_activity_status = C2021_EASTAT_20_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_ward_trafford.csv")

 
# TS060 - Industry (persons) ---------------------------

# LA (GM)
df_la_industry <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2077_1.data.csv?date=latest&geography=645922841...645922850&c2021_ind_88=1...87&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         industry = C2021_IND_88_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Industry worked in by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         industry = str_replace_all(industry, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, industry, measure, unit, value) %>%
  write_csv("2021_industry_la_gm.csv")


# MSOA (Trafford)
df_msoa_industry <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2077_1.data.csv?date=latest&geography=637535406...637535433&c2021_ind_88=1...87&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         industry = C2021_IND_88_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Industry worked in by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         industry = str_replace_all(industry, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, industry, measure, unit, value) %>%
  write_csv("2021_industry_msoa_trafford.csv")


# Ward (Trafford)
df_ward_industry <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2077_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_ind_88=1...87&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         industry = C2021_IND_88_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Industry worked in by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         industry = str_replace_all(industry, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, industry, measure, unit, value) %>%
  write_csv("2021_industry_ward_trafford.csv")


# TS062 - National Statistics Socio-economic Classification (NS-SEC) (persons) ---------------------------

# LA (GM)
df_la_nssec <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2079_1.data.csv?date=latest&geography=645922841...645922850&c2021_nssec_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         socio_economic_classification = C2021_NSSEC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "National Statistics Socio-economic Classification (NS-SEC) of usual residents, (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, socio_economic_classification, measure, unit, value) %>%
  write_csv("2021_socio-economic_classification_la_gm.csv")


# MSOA (Trafford)
df_msoa_nssec <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2079_1.data.csv?date=latest&geography=637535406...637535433&c2021_nssec_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         socio_economic_classification = C2021_NSSEC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "National Statistics Socio-economic Classification (NS-SEC) of usual residents, (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, socio_economic_classification, measure, unit, value) %>%
  write_csv("2021_socio-economic_classification_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_nssec <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2079_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_nssec_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         socio_economic_classification = C2021_NSSEC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "National Statistics Socio-economic Classification (NS-SEC) of usual residents, (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, socio_economic_classification, measure, unit, value) %>%
  write_csv("2021_socio-economic_classification_lsoa_trafford.csv")


# OA (Trafford)
df_oa_nssec <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2079_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_nssec_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         socio_economic_classification = C2021_NSSEC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "National Statistics Socio-economic Classification (NS-SEC) of usual residents, (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, socio_economic_classification, measure, unit, value) %>%
  write_csv("2021_socio-economic_classification_oa_trafford.csv")


# Ward (Trafford)
df_ward_nssec <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2079_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_nssec_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         socio_economic_classification = C2021_NSSEC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "National Statistics Socio-economic Classification (NS-SEC) of usual residents, (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, socio_economic_classification, measure, unit, value) %>%
  write_csv("2021_socio-economic_classification_ward_trafford.csv")


# TS063 - Occupation (persons) ---------------------------

# LA (GM)
df_la_occupation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2080_1.data.csv?date=latest&geography=645922841...645922850&c2021_occ_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]\\. ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_la_gm.csv")


# MSOA (Trafford)
df_msoa_occupation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2080_1.data.csv?date=latest&geography=637535406...637535433&c2021_occ_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]\\. ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_occupation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2080_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_occ_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]\\. ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_lsoa_trafford.csv")


# OA (Trafford)
df_oa_occupation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2080_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_occ_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]\\. ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_oa_trafford.csv")


# Ward (Trafford)
df_ward_occupation <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2080_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_occ_10=1...9&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_10_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]\\. ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_ward_trafford.csv")


# TS064 - Occupation Minor Groups (detailed) (persons) ---------------------------

# LA (GM)
df_la_occupation_detailed <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2081_1.data.csv?date=latest&geography=645922841...645922850&c2021_occ_105=1...104&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_105_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_detailed_la_gm.csv")


# MSOA (Trafford)
df_msoa_occupation_detailed <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2081_1.data.csv?date=latest&geography=637535406...637535433&c2021_occ_105=1...104&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_105_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_detailed_msoa_trafford.csv")


# Ward (Trafford)
df_ward_occupation_detailed <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2081_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_occ_105=1...104&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         occupation = C2021_OCC_105_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Occupation of usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         occupation = str_replace_all(occupation, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, occupation, measure, unit, value) %>%
  write_csv("2021_occupation_detailed_ward_trafford.csv")


# TS061 - Method of travel to work (persons) ---------------------------

# LA (GM)
df_la_work_travel_mode <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2078_1.data.csv?date=latest&geography=645922841...645922850&c2021_ttwmeth_12=1...11&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         mode_of_travel = C2021_TTWMETH_12_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Method used to travel to work (2001 specification) of usual residents, (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, mode_of_travel, measure, unit, value) %>%
  write_csv("2021_method_of_travel_to_work_la_gm.csv")


# MSOA (Trafford)
df_msoa_work_travel_mode <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2078_1.data.csv?date=latest&geography=637535406...637535433&c2021_ttwmeth_12=1...11&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         mode_of_travel = C2021_TTWMETH_12_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Method used to travel to work (2001 specification) of usual residents, (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, mode_of_travel, measure, unit, value) %>%
  write_csv("2021_method_of_travel_to_work_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_work_travel_mode <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2078_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_ttwmeth_12=1...11&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         mode_of_travel = C2021_TTWMETH_12_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Method used to travel to work (2001 specification) of usual residents, (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, mode_of_travel, measure, unit, value) %>%
  write_csv("2021_method_of_travel_to_work_lsoa_trafford.csv")


# OA (Trafford)
df_oa_work_travel_mode <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2078_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_ttwmeth_12=1...11&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         mode_of_travel = C2021_TTWMETH_12_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Method used to travel to work (2001 specification) of usual residents, (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, mode_of_travel, measure, unit, value) %>%
  write_csv("2021_method_of_travel_to_work_oa_trafford.csv")


# ward (Trafford)
df_ward_work_travel_mode <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2078_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_ttwmeth_12=1...11&measures=20100") %>%
  rename(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         mode_of_travel = C2021_TTWMETH_12_NAME,
         value = OBS_VALUE
  ) %>%
  mutate(geography = "Electoral ward",
         area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets
         period = "2021-03-21",
         indicator = "Method used to travel to work (2001 specification) of usual residents, (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, mode_of_travel, measure, unit, value) %>%
  write_csv("2021_method_of_travel_to_work_ward_trafford.csv")

