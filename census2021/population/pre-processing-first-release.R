# Obtain first release of Census 2021 data
# 2022-07-04 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationandhouseholdestimatesenglandandwalescensus2021
# Based on template made available prior to 2022-06-28: https://www.ons.gov.uk/file?uri=/census/censustransformationprogramme/census2021outputs/releaseplans/census2021firstresultsenglandwalestemplate.xlsx

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
data_source <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/populationandhouseholdestimatesenglandandwalescensus2021/census2021/census2021firstresultsenglandwales1.xlsx"

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")

area_codes = area_codes_gm  # Initially we'll focus on GM, but the other codes are available if we require above


# Download the data ---------------------------
tmp <- tempfile(fileext = ".xlsx")
GET(url = data_source, write_disk(tmp))


# Usual resident population by sex: ---------------------------
# We need a wide format for later matching to the data by sex
df_pop_by_sex_wide <- read_xlsx(tmp, sheet = "P01", skip = 6) %>%
  rename(area_code = `Area code [note 2]`,
         area_name = `Area name`,
         Persons = `All persons`) %>%
  filter(area_code %in% area_codes)

# Now turn the wide format into tidy data  
df_pop_by_sex <- df_pop_by_sex_wide %>%  
  pivot_longer(c(-area_code, -area_name),
               names_to = "sex",
               values_to = "usual_residents") %>%
  mutate(period = "2021-03-21",
         geography = "Local authority") %>%
  arrange(area_name, sex) %>%
  select(period, area_code, area_name, geography, sex, usual_residents)


# Usual resident population by 5-year age group ---------------------------
df_pop_by_age_group <- read_xlsx(tmp, sheet = "P02", skip = 7) %>%
  # Tidy up the variable names with Janitor
  clean_names() %>%
  rename_with(~str_remove(., "_note_2")) %>%
  rename_with(~str_remove(., "_note_12")) %>%
  rename_with(~str_replace_all(., "_", " ")) %>%
  rename(area_code = `area code`,
         area_name = `area name`,
         `all ages` = `all persons`) %>%
  filter(area_code %in% area_codes) %>%
  pivot_longer(c(-area_code, -area_name),
               names_to = "age_group",
               values_to = "usual_residents") %>%
  mutate(period = "2021-03-21",
         geography = "Local authority",
         sex = "Persons",
         age_group = str_to_sentence(age_group)) %>%
  select(period, area_code, area_name, geography, sex, age_group, usual_residents)


# Usual resident population by sex and 5-year age group ---------------------------
df_pop_by_sex_and_age_group <- read_xlsx(tmp, sheet = "P03", skip = 7) %>%
  # Tidy up the variable names with Janitor
  clean_names() %>%
  rename_with(~str_remove(., "_note_2")) %>%
  rename_with(~str_remove(., "_note_12")) %>%
  rename_with(~str_replace_all(., "_", " ")) %>%
  rename(area_code = `area code`,
         area_name = `area name`) %>%
  filter(area_code %in% area_codes) %>%
  select(-`all persons`)

# now bring in the female and male population totals from the wide dataset
df_pop_by_sex_and_age_group <- df_pop_by_sex_and_age_group %>%
  left_join(df_pop_by_sex_wide %>%
              select(-Persons)) %>%
  rename(`females all ages` = Females,
         `males all ages` = Males) %>%
  select(area_code, area_name, `females all ages`,
         starts_with("female"),
         `males all ages`, everything())

# Convert to tidy format and finish the cleaning
df_pop_by_sex_and_age_group <- df_pop_by_sex_and_age_group %>%
  pivot_longer(c(-area_code, -area_name),
               names_to = "age_group",
               values_to = "usual_residents") %>%
  mutate(period = "2021-03-21",
         geography = "Local authority",
         sex = if_else(str_detect(age_group, "females"), "Females", "Males"),
         age_group = str_to_sentence(str_remove(age_group, "females |males "))) %>%
  select(period, area_code, area_name, geography, sex, age_group, usual_residents)

# Final step, bind the females and males data with the overall persons totals
df_pop_by_sex_and_age_group <- df_pop_by_sex_and_age_group %>%
  bind_rows(df_pop_by_age_group) %>%
  arrange(area_name, sex)

# Create the dataset as CSV
write_csv(df_pop_by_sex_and_age_group, "2021_population_by_sex_and_age_group_la_gm.csv")

# Then create the same dataset just for Trafford
df_pop_by_sex_and_age_group %>%
  filter(area_name == "Trafford") %>%
  write_csv("2021_population_by_sex_and_age_group_la_trafford.csv")

# Now convert the tidy data to wide format for an "easy read" informative version
df_pop_by_sex_and_age_group_wide <- df_pop_by_sex_and_age_group %>%
  pivot_wider(names_from = "age_group",
              values_from = "usual_residents") %>%
  # Tidy up the variable names with Janitor
  clean_names() %>%
  arrange(area_name, sex)

write_csv(df_pop_by_sex_and_age_group_wide, "2021_population_by_sex_and_age_group_wide_la_gm.csv")


# Usually resident population density ---------------------------
df_pop_density <- read_xlsx(tmp, sheet = "P04", skip = 6) %>%
  # Tidy up the variable names with Janitor
  clean_names() %>%
  rename(area_code = area_code_note_2,
         usual_residents_per_square_kilometre = population_density_number_of_usual_residents_per_square_kilometre_note_13) %>%
  filter(area_code %in% area_codes) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority") %>%
  select(period,
         area_code,
         area_name,
         geography,
         usual_residents_per_square_kilometre)

write_csv(df_pop_density, "2021_population_density_la_gm.csv")


# Number of households ---------------------------
df_households <- read_xlsx(tmp, sheet = "H01", skip = 6) %>%
  # Tidy up the variable names with Janitor
  clean_names() %>%
  rename(area_code = area_code_note_2) %>%
  filter(area_code %in% area_codes) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority") %>%
  select(period, area_code, area_name, geography,
         number_of_households = number_of_households_with_at_least_one_usual_resident)

write_csv(df_households, "2021_households_la_gm.csv")


# Cleanup the downloaded data ---------------------------
unlink(tmp)
