#Mid-year estimates at Local authority level

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/estimatesofthepopulationforenglandandwales
# Licence: Open Government Licence 3.0

library(httr) ; library(readxl) ; library(tidyverse)

#Local authority

# Local authority
la <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2002_1.data.csv?geography=1778385132&date=latest&gender=0...2&c_age=101...191&measures=20100") %>% 
  mutate(geography = "Local authority") %>% 
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sex = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE, 
         geography) %>% 
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         sex = factor(fct_recode(sex, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"), levels = c("Persons", "Females", "Males")),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", ""))))  %>% 
  spread(age, count) %>% 
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), `90+` = `90`)

write_csv(la, "mid-year_2024_population_estimates_local_authority.csv")


#Wards

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates
# Licence: Open Government Licence 3.0

df_ward <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2014_1.data.csv?geography=729815401...729815421&date=latest&gender=0...2&c_age=101...191&measures=20100") %>% 
  mutate(geography = "Ward") %>% 
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sex = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE, 
         geography) %>% 
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         sex = factor(fct_recode(sex, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"), levels = c("Persons", "Females", "Males")),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", "")))
         )  %>% 
  spread(age, count) %>% 
  mutate(area_name = gsub(" \\(Trafford\\)", "", area_name)) %>%
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), `90+` = `90`)


write_csv(df_ward, "mid-year_2024_population_estimates_ward.csv")

#MSOAs

#House of Commons Library MSOA Names
# URL: https://visual.parliament.uk/msoanames

lookup <- read_csv("https://houseofcommonslibrary.github.io/msoanames/MSOA-Names-Latest.csv") %>%
  filter(Laname=="Trafford") %>%
  select(area_code = msoa11cd, area_name = msoa11hclnm)

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates
# Licence: Open Government Licence 3.0


df_msoa <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2014_1.data.csv?geography=637535406...637535433&date=latest&gender=0...2&c_age=101...191&measures=20100") %>% 
  mutate(geography = "MSOA") %>% 
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         sex = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE, 
         geography) %>% 
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         sex = factor(fct_recode(sex, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"), levels = c("Persons", "Females", "Males")),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", "")))
  )  %>% 
  spread(age, count) %>% 
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  left_join(lookup, by = "area_code") %>%
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), `90+` = `90`)

write_csv(df_msoa, "mid-year_2024_population_estimates_msoa.csv")

#LSOA

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates
# Licence: Open Government Licence 3.0

URL <- "https://www.nomisweb.co.uk/api/v01/dataset/NM_2014_1.data.csv?geography=633345696...633345699,633345774,633371946,633371947,633345703...633345706,633345708,633345728,633345772,633345773,633345775,633345700...633345702,633345732,633345733,633345709...633345711,633345715,633345718,633345742,633345744,633345746,633345769,633345770,633345712...633345714,633345717,633345719,633345743,633345745,633345766,633345771,633345784...633345788,633345707,633345716,633345720,633345783,633345789,633345729...633345731,633345767,633345768,633345734,633345736,633345737,633345741,633345752,633345753,633345756...633345758,633345685,633345686,633345751,633345761,633345765,633345684,633345747...633345750,633345735,633345738...633345740,633345759,633345691...633345695,633345689,633345760,633345762...633345764,633345678,633345679,633345682,633345754,633345755,633345677,633345681,633345683,633345687,633345690,633345688,633345776,633345781,633345782,633345796,633345790,633345792...633345794,633345797,633345680,633345777,633345778,633345791,633345795,633345665,633345667,633345676,633345779,633345780,633345661...633345663,633345666,633345674,633345670,633345671,633345675,633345726,633345727,633345664,633345668,633345669,633345672,633345673,633345721...633345725&date=latest&gender=0...2&c_age=101...191&measures=20100"

lsoa1 <- read_csv(URL)

lsoa2 <- read_csv(paste0(URL,"&RecordOffset=25000"))

df_lsoa <- bind_rows(lsoa1, lsoa2) %>% 
  mutate(geography = "LSOA") %>% 
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sex = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE, 
         geography) %>%
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         sex = factor(fct_recode(sex, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"), levels = c("Persons", "Females", "Males")),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", "")))
  )  %>% 
  spread(age, count) %>% 
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), `90+` = `90`)

write_csv(df_lsoa, "mid-year_2024_population_estimates_lsoa.csv")


#OA

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/censusoutputareapopulationestimatessupportinginformation
# Licence: Open Government Licence 3.0

URL <- "https://www.nomisweb.co.uk/api/v01/dataset/NM_2014_1.data.csv?geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&date=latest&gender=0...2&c_age=101...191&measures=20100"

oa1 <- read_csv(URL)

oa2 <- read_csv(paste0(URL,"&RecordOffset=25000"))

oa3 <- read_csv(paste0(URL,"&RecordOffset=50000"))

oa4 <- read_csv(paste0(URL,"&RecordOffset=75000"))

oa5 <- read_csv(paste0(URL,"&RecordOffset=100000"))

oa6 <- read_csv(paste0(URL,"&RecordOffset=125000"))

oa7 <- read_csv(paste0(URL,"&RecordOffset=150000"))

oa8 <- read_csv(paste0(URL,"&RecordOffset=175000"))

oa9 <- read_csv(paste0(URL,"&RecordOffset=200000"))

tmp <- tempfile(fileext = ".xlsx")

df_oa <- bind_rows(oa1, oa2, oa3, oa4, oa5, oa6, oa7, oa8, oa9) %>% 
  mutate(geography = "OA") %>% 
  select(period = DATE_NAME,
         area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         sex = GENDER_NAME,
         age = C_AGE_NAME,
         count = OBS_VALUE, 
         geography) %>%
  mutate(period = ymd(str_c(period, "06-30", sep = "-")),
         sex = factor(fct_recode(sex, "Females" = "Female" , "Males" = "Male", "Persons" = "Total"), levels = c("Persons", "Females", "Males")),
         age = as.integer(str_trim(str_replace_all(age, "Age.|\\+", "")))
  )  %>% 
  spread(age, count) %>% 
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>% 
  select(period, area_code, area_name, geography, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything(), `90+` = `90`)

write_csv(df_oa, "mid-year_2024_population_estimates_oa.csv")

write_csv(bind_rows(la,df_ward,df_lsoa,df_msoa,df_oa), "mid-year_2024_population_estimates_all_geographies.csv")
