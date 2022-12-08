# Unrounded population and household data from second release of Census 2021 data
# 2022-11-02 James Austin.
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

# Trafford's Output Area codes
tmp <- tempfile(fileext = ".csv")
GET(url = "https://www.trafforddatalab.io/spatial_data/lookups/2021/statistical_lookup.csv", write_disk(tmp))

trafford_oa <- read_csv(tmp) %>%
  filter(lad22nm == "Trafford") %>%
  select(oa21cd)

unlink(tmp)


# Population by single year of age ---------------------------

# LA - all persons
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS007_resident_age_101a/UR-ltla%2Bresident_age_101a.xlsx", write_disk(tmp))

df_pop_by_single_year_age_la <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         age_number = `Age (101 categories) Code`,
         age_group = `Age (101 categories) Label`,
         value = Count
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(sex = "Persons",
         # Although the single year of age for all persons goes up to 100+, by sex it's only 90+.
         # Therefore we need to sum all counts from 90 onwards to normalise the data
         age_number = as.integer(age_number),
         age_number = if_else(age_number >= 90, 90, as.double(age_number)),
         age_group = if_else(age_number == 90, "Aged 90 years and over", age_group)) %>%
  group_by(area_code, area_name, age_number, age_group, sex) %>%
  summarise(value = sum(value)) %>%
  arrange(area_code, age_number) %>%
  ungroup()

unlink(tmp)

# LA - by sex
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS009_sex_resident_age_91a/UR-ltla%2Bsex%2Bresident_age_91a.xlsx", write_disk(tmp))

df_pop_by_single_year_age_la_by_sex <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         sex = `Sex (2 categories) Label`,
         age_number = `Age (91 categories) Code`,
         age_group = `Age (91 categories) Label`,
         value = Count
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(age_number = as.integer(age_number),
         sex = if_else(sex == "Female", "Females", "Males")) %>%
  select(area_code, area_name, age_number, age_group, sex, value)

unlink(tmp)

# Merge the separate datasets together
df_pop_by_single_year_age_la_all <- df_pop_by_single_year_age_la %>%
  bind_rows(df_pop_by_single_year_age_la_by_sex) %>%
  arrange(area_code, sex, age_number)

# Create the tidy datasets for GM and Trafford
df_pop_by_single_year_age_la_all %>%
  mutate(indicator = "Usual resident population by sex and age group",
         measure = "Count",
         unit = "Usual residents",
         geography = "Local authority",
         period = "2021-03-21") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, sex, age_group, value) %>%
  write_csv("2021_population_by_sex_and_age_group_la_gm.csv") %>%
  filter(area_name == "Trafford") %>%
  write_csv("2021_population_by_sex_and_age_group_la_trafford.csv")

# Create the wide dataset for GM
df_pop_by_single_year_age_la_all_wide <- df_pop_by_single_year_age_la_all %>%
  mutate(geography = "Local authority",
         period = "2021-03-21") %>%
  select(-age_group) %>%
  pivot_wider(names_from = age_number, values_from = value) %>%
  # create the commonly required age bands: all ages, 0 -15, 16 - 64 and 65+
  mutate(all_ages = rowSums(select(., `0`:`90`)),
         aged_0_to_15 = rowSums(select(., `0`:`15`)),
         aged_16_to_64 = rowSums(select(., `16`:`64`)),
         aged_65_and_over = rowSums(select(., `65`:`90`))) %>%
  rename(`90+` = `90`) %>%
  select(area_code, area_name, geography, period, sex, all_ages, aged_0_to_15, aged_16_to_64, aged_65_and_over, everything())

# Create the wide format CSV
write_csv(df_pop_by_single_year_age_la_all_wide, "2021_population_by_sex_and_age_group_wide_la_gm.csv")


# Usually resident population density ---------------------------
# Data is provided separately for the different geographies: LA, MSOA, LSOA, OA
# Produce one dataset for all GM LAs then another dataset for Trafford at all geographies

# LA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS006_population_density/atc-ts-demmig-ur-pd-oa-ltla.xlsx", write_disk(tmp))

df_pop_density_la <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         value = `Population Density`) %>%
  filter(area_code %in% area_codes_gm) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority",
         indicator = "Usual resident population density",
         measure = "Rate",
         unit = "Number of usual residents per square kilometre") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_pop_density_la, "2021_population_density_la_gm.csv")

unlink(tmp)

# MSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS006_population_density/atc-ts-demmig-ur-pd-oa-msoa.xlsx", write_disk(tmp))

df_pop_density_msoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas Label`,
         value = `Population Density`) %>%
  filter(grepl('Trafford', area_name)) %>%
  mutate(geography = "Middle-layer Super Output Area")

unlink(tmp)

# LSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS006_population_density/atc-ts-demmig-ur-pd-oa-lsoa.xlsx", write_disk(tmp))

df_pop_density_lsoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas Label`,
         value = `Population Density`) %>%
  filter(grepl('Trafford', area_name)) %>%
  mutate(geography = "Lower-layer Super Output Area")

unlink(tmp)

# OA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS006_population_density/atc-ts-demmig-ur-pd-oa-oa.xlsx", write_disk(tmp))

df_pop_density_oa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas Label`,
         value = `Population Density`) %>%
  filter(area_code %in% trafford_oa$oa21cd) %>%
  mutate(geography = "Output Area")

unlink(tmp)

# Bind MSOA, LSOA and OA together, then mutate the consistent, extra variables
df_pop_density <- bind_rows(df_pop_density_msoa,
                            df_pop_density_lsoa,
                            df_pop_density_oa) %>%
  mutate(period = "2021-03-21",
         indicator = "Usual resident population density",
         measure = "Rate",
         unit = "Number of usual residents per square kilometre") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

# Finally get the Trafford LA density and add to form the completed all geography dataset for Trafford
df_pop_density <- df_pop_density_la %>%
  filter(area_name == "Trafford") %>%
  bind_rows(df_pop_density)

write_csv(df_pop_density, "2021_population_density_all_geographies_trafford.csv")


# Household composition ---------------------------
# Data is provided separately for the different geographies: LA, MSOA, LSOA, OA
# Produce one dataset for all GM LAs then separate datasets for Trafford at MSOA, LSOA and OA

# LA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS003_hh_family_composition_15a/HH-ltla%2Bhh_family_composition_15a.xlsx", write_disk(tmp))

df_household_comp_la <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         indicator = `Household composition (15 categories) Label`,
         value = Count) %>%
  filter(area_code %in% area_codes_gm,
         indicator != "Does not apply") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_comp_la, "2021_household_composition_la_gm.csv")

unlink(tmp)

# MSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS003_hh_family_composition_15a/HH-msoa%2Bhh_family_composition_15a.xlsx", write_disk(tmp))

df_household_comp_msoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas Label`,
         indicator = `Household composition (15 categories) Label`,
         value = Count) %>%
  filter(grepl('Trafford', area_name),
         indicator != "Does not apply") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Middle-layer Super Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_comp_msoa, "2021_household_composition_msoa_trafford.csv")

unlink(tmp)

# LSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS003_hh_family_composition_15a/HH-lsoa%2Bhh_family_composition_15a.xlsx", write_disk(tmp))

df_household_comp_lsoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas Label`,
         indicator = `Household composition (15 categories) Label`,
         value = Count) %>%
  filter(grepl('Trafford', area_name),
         indicator != "Does not apply") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Lower-layer Super Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_comp_lsoa, "2021_household_composition_lsoa_trafford.csv")

unlink(tmp)

# OA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS003_hh_family_composition_15a/HH-oa%2Bhh_family_composition_15a_north_west.xlsx", write_disk(tmp))

df_household_comp_oa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas Label`,
         indicator = `Household composition (15 categories) Label`,
         value = Count) %>%
  filter(area_code %in% trafford_oa$oa21cd,
         indicator != "Does not apply") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_comp_oa, "2021_household_composition_oa_trafford.csv")

unlink(tmp)


# Household size ---------------------------
# Data is provided separately for the different geographies: LA, MSOA, LSOA, OA
# Produce one dataset for all GM LAs then separate datasets for Trafford at MSOA, LSOA and OA

# LA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS017_hh_size_9a/HH-ltla%2Bhh_size_9a.xlsx", write_disk(tmp))

df_household_size_la <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities Label`,
         indicator = `Household size (9 categories) Label`,
         value = Count) %>%
  filter(area_code %in% area_codes_gm,
         indicator != "0 people in household") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_size_la, "2021_household_size_la_gm.csv")

unlink(tmp)

# MSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS017_hh_size_9a/HH-msoa%2Bhh_size_9a.xlsx", write_disk(tmp))

df_household_size_msoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas Label`,
         indicator = `Household size (9 categories) Label`,
         value = Count) %>%
  filter(grepl('Trafford', area_name),
         indicator != "0 people in household") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Middle-layer Super Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_size_msoa, "2021_household_size_msoa_trafford.csv")

unlink(tmp)

# LSOA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS017_hh_size_9a/HH-lsoa%2Bhh_size_9a.xlsx", write_disk(tmp))

df_household_size_lsoa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas Label`,
         indicator = `Household size (9 categories) Label`,
         value = Count) %>%
  filter(grepl('Trafford', area_name),
         indicator != "0 people in household") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Lower-layer Super Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_size_lsoa, "2021_household_size_lsoa_trafford.csv")

unlink(tmp)

# OA
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://ons-dp-prod-census-publication.s3.eu-west-2.amazonaws.com/TS017_hh_size_9a/HH-oa%2Bhh_size_9a_north_west.xlsx", write_disk(tmp))

df_household_size_oa <- read_xlsx(tmp, sheet = "Table") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas Label`,
         indicator = `Household size (9 categories) Label`,
         value = Count) %>%
  filter(area_code %in% trafford_oa$oa21cd,
         indicator != "0 people in household") %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Output Area",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value)

write_csv(df_household_size_oa, "2021_household_size_oa_trafford.csv")

unlink(tmp)
