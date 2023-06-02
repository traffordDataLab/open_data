# Population and household data from Census 2021 data
# Initially created: 2022-11-02, modified: 2023-06-02 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/bulletins/populationandhouseholdestimatesenglandandwales/census2021unroundeddata

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
library(tidyverse); library(httr); library(readxl); library(janitor)


# TS007A - Age by five-year age bands (persons) ---------------------------

# LA (GM)
df_age_5_year_bands_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2020_1.data.csv?date=latest&geography=645922841...645922850&c2021_age_19=1...18&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_AGE_19_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Local authority",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_5_year_age_bands_la_gm.csv")


# MSOA (Trafford)
df_age_5_year_bands_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2020_1.data.csv?date=latest&geography=637535406...637535433&c2021_age_19=1...18&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_AGE_19_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Middle-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_5_year_age_bands_msoa_trafford.csv")


# LSOA (Trafford)
df_age_5_year_bands_lsoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2020_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_age_19=1...18&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_AGE_19_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Lower-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_5_year_age_bands_lsoa_trafford.csv")


# OA (Trafford)
df_age_5_year_bands_oa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2020_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_age_19=1...18&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_AGE_19_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_5_year_age_bands_oa_trafford.csv")


# TS008 - Sex (persons) ---------------------------

# LA (GM)
df_pop_by_sex_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2028_1.data.csv?date=latest&geography=645922841...645922850&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Local authority",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_sex_la_gm.csv")


# MSOA (Trafford)
df_pop_by_sex_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2028_1.data.csv?date=latest&geography=637535406...637535433&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Middle-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_sex_msoa_trafford.csv")


# LSOA (Trafford)
df_pop_by_sex_lsoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2028_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Lower-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_sex_lsoa_trafford.csv")


# OA (Trafford)
df_pop_by_sex_oa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2028_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_sex_oa_trafford.csv")


# Ward (Trafford)
df_pop_by_sex_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2028_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Electoral ward",
           area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets)
           period = "2021-03-21",
           measure = "Count",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_by_sex_ward_trafford.csv")


# RM200 - Sex by single year of age (detailed) (persons) ---------------------------

# LA (GM)
df_sex_and_age_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2300_1.data.csv?date=latest&geography=645922841...645922850&c2021_age_92=1...91&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           age = C2021_AGE_92_NAME,
           sex = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Local authority",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual resident population by sex and age",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, age, sex, value) %>%
    write_csv("2021_population_by_sex_and_age_la_gm.csv")


# MSOA (Trafford)
df_sex_and_age_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2300_1.data.csv?date=latest&geography=637535406...637535433&c2021_age_92=1...91&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           age = C2021_AGE_92_NAME,
           sex = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Middle-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual resident population by sex and age",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, age, sex, value) %>%
    write_csv("2021_population_by_sex_and_age_msoa_trafford.csv")


# LSOA (Trafford)
df_sex_and_age_lsoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2300_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_age_92=1...91&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           age = C2021_AGE_92_NAME,
           sex = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Lower-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual resident population by sex and age",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, age, sex, value) %>%
    write_csv("2021_population_by_sex_and_age_lsoa_trafford.csv")


# Ward (Trafford)
df_sex_and_age_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2300_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_age_92=1...91&c_sex=0...2&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           age = C2021_AGE_92_NAME,
           sex = C_SEX_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Electoral ward",
           area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets)
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual resident population by sex and age",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, age, sex, value) %>%
    write_csv("2021_population_by_sex_and_age_ward_trafford.csv")


# Create the wide dataset with specific age groups for whole of GM
df_sex_and_age_groups_la_wide <- df_sex_and_age_la %>%
    pivot_wider(names_from = age, values_from = value) %>%
    # create the commonly required age bands: all ages, 0 -15, 16 - 64 and 65+
    mutate(all_ages = rowSums(select(., `Aged under 1 year`:`Aged 90 years and over`)),
           aged_0_to_15 = rowSums(select(., `Aged under 1 year`:`Aged 15 years`)),
           aged_16_to_64 = rowSums(select(., `Aged 16 years`:`Aged 64 years`)),
           aged_65_and_over = rowSums(select(., `Aged 65 years`:`Aged 90 years and over`))) %>%
    select(area_code, area_name, geography, period, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over) %>%
    write_csv("2021_population_by_sex_and_age_group_wide_la_gm.csv")


# TS006 - Population density (persons) ---------------------------

# LA (GM)
df_pop_density_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2026_1.data.csv?date=latest&geography=645922841...645922850&cell=0&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Local authority",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual residents per square kilometre",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_density_la_gm.csv")


# MSOA (Trafford)
df_pop_density_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2026_1.data.csv?date=latest&geography=637535406...637535433&cell=0&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Middle-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual residents per square kilometre",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_density_msoa_trafford.csv")


# LSOA (Trafford)
df_pop_density_lsoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2026_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&cell=0&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Lower-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual residents per square kilometre",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_density_lsoa_trafford.csv")


# OA (Trafford)
df_pop_density_oa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2026_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&cell=0&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Output Area",
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual residents per square kilometre",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_density_oa_trafford.csv")


# Ward (Trafford)
df_pop_density_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2026_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&cell=0&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Electoral ward",
           area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets)
           period = "2021-03-21",
           measure = "Count",
           indicator = "Usual residents per square kilometre",
           unit = "Persons") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_population_density_ward_trafford.csv")


# TS003 - Household composition (households) ---------------------------

# LA (GM)
df_household_comp_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2023_1.data.csv?date=latest&geography=645922841...645922850&c2021_hhcomp_15=1...14&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHCOMP_15_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Local authority",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_composition_la_gm.csv")


# MSOA (Trafford)
df_household_comp_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2023_1.data.csv?date=latest&geography=637535406...637535433&c2021_hhcomp_15=1...14&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHCOMP_15_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Middle-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_composition_msoa_trafford.csv")


# LSOA (Trafford)
df_household_comp_lsoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2023_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_hhcomp_15=1...14&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHCOMP_15_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Lower-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_composition_lsoa_trafford.csv")


# OA (Trafford)
df_household_comp_oa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2023_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_hhcomp_15=1...14&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHCOMP_15_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_composition_oa_trafford.csv")


# Ward (Trafford)
df_household_comp_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2023_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_hhcomp_15=1...14&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHCOMP_15_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Electoral ward",
           area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets)
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_composition_ward_trafford.csv")


# TS017 - Household size (households) ---------------------------

# LA (GM)
df_household_size_la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2037_1.data.csv?date=latest&geography=645922841...645922850&c2021_hhsize_10=1...9&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHSIZE_10_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Local authority",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_size_la_gm.csv")


# MSOA (Trafford)
df_household_size_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2037_1.data.csv?date=latest&geography=637535406...637535433&c2021_hhsize_10=1...9&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHSIZE_10_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Middle-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_size_msoa_trafford.csv")


# LSOA (Trafford)
df_household_size_lsoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2037_1.data.csv?date=latest&geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&c2021_hhsize_10=1...9&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHSIZE_10_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Lower-layer Super Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_size_lsoa_trafford.csv")


# OA (Trafford)
df_household_size_oa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2037_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_hhsize_10=1...9&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHSIZE_10_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Output Area",
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_size_oa_trafford.csv")


# Ward (Trafford)
df_household_size_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2037_1.data.csv?date=latest&geography=641728593...641728607,641728609,641728608,641728610...641728613&c2021_hhsize_10=1...9&measures=20100") %>%
    rename(area_code = GEOGRAPHY_CODE,
           area_name = GEOGRAPHY_NAME,
           indicator = C2021_HHSIZE_10_NAME,
           value = OBS_VALUE
    ) %>%
    mutate(geography = "Electoral ward",
           area_name = str_replace(area_name, " \\(Trafford\\)", ""), # Some wards which share the same name with other LAs are suffixed with the LA name in brackets)
           period = "2021-03-21",
           measure = "Count",
           unit = "Households") %>%
    select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
    write_csv("2021_household_size_ward_trafford.csv")
