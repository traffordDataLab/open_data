# Obtain first release of Census 2021 data
# 2022-06-23 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/census/censustransformationprogramme/census2021outputs/releaseplans
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
data_source <- "https://www.ons.gov.uk/file?uri=/census/censustransformationprogramme/census2021outputs/releaseplans/census2021firstresultsenglandwalestemplate.xlsx"

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


# Overall population estimates: all persons, females, males ---------------------------
# Need this for the overall females and males totals, plus it might come in handy as a table in its own right
df_overall_population_estimates_flat <- read_xlsx(tmp, sheet = "P01", skip = 6) %>%
  rename(area_code = `Area code [note 2]`,
         area_name = `Area name`,
         all_persons = `All persons`,
         females = Females,
         males = Males) %>%
  filter(area_code %in% area_codes)


# Usually resident population by 5-year age bands ---------------------------
# Get females, males and all persons separately then bind to form one dataset
# 3 rows per Local Authority
# Unfortunately the females and males data is in one table, so we'll get just the rows we want first, then split that into 2 separate datasets
df_pop_by_5_year_age_band_by_sex <- read_xlsx(tmp, sheet = "P03", skip = 7) %>%
  # Tidy up the variable names to remove line breaks etc. with Janitor
  clean_names() %>%
  # Finalise the tidying of the variable names to the format we want and to make it easier to select all the female columns separately from the male etc.
  rename(area_code = area_code_note_2) %>%
  rename_with(~str_remove(., "_years_note_12")) %>%
  rename_with(~str_replace(., "4_years_and_under_note_12", "0_to_4")) %>%
  rename_with(~str_replace(., "90_years_and_over_note_12", "90_and_over")) %>%
  # Remove the rows we don't need and ready the dataset for splitting
  filter(area_code %in% area_codes) %>%
  # Join to get the total number of females and males added to the dataset
  left_join(df_overall_population_estimates_flat) %>%
  # Remove the total for all persons so that we are just left with the females and males data
  select(-all_persons)

# Get just the data for females from the combined dataset.  
df_pop_by_5_year_age_band_females <- df_pop_by_5_year_age_band_by_sex %>%
  mutate(sex = "Females") %>%
  select(area_code,
         area_name,
         sex,
         all_ages = females,
         starts_with("females")) %>%
  rename_with(~str_remove(., "females_"))

# Get just the data for males from the combined dataset.  
df_pop_by_5_year_age_band_males <- df_pop_by_5_year_age_band_by_sex %>%
  mutate(sex = "Males") %>%
  select(area_code,
         area_name,
         sex,
         all_ages = males,
         starts_with("males")) %>%
  rename_with(~str_remove(., "males_"))

# Finally get the same data for all persons and then bind to the data for females and males
df_pop_by_5_year_age_band_all <- read_xlsx(tmp, sheet = "P02", skip = 7) %>%
  # Tidy up the variable names to remove line breaks etc. with Janitor
  clean_names() %>%
  # Finalise the tidying of the variable names to the format we want
  rename(area_code = area_code_note_2,
         all_ages = all_persons) %>%
  rename_with(~str_remove(., "_years_note_12")) %>%
  rename_with(~str_replace(., "4_years_and_under_note_12", "0_to_4")) %>%
  rename_with(~str_replace(., "90_years_and_over_note_12", "90_and_over")) %>%
  mutate(sex = "Persons") %>%
  # Just get the rows we are interested in
  filter(area_code %in% area_codes) %>%
  # Select the order of the variables to match those of the female and male datasets
  select(area_code, area_name, sex, everything()) %>%
  # Now bind the data together to form one complete dataset
  bind_rows(df_pop_by_5_year_age_band_females,
            df_pop_by_5_year_age_band_males) %>%
  arrange(area_name, sex) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority") %>%
  select(period, area_code, area_name, geography, everything())

# Create the dataset for Greater Manchester first  
write_csv(df_pop_by_5_year_age_band_all, "2021_population_by_sex_and_age_band_local_authority_gm.csv")

# Then create the same dataset just for Trafford
df_pop_by_5_year_age_band_all %>%
  filter(area_name == "Trafford") %>%
  write_csv("2021_population_by_sex_and_age_band_local_authority_trafford.csv")


# Usually resident population density ---------------------------
df_pop_density_all <- read_xlsx(tmp, sheet = "P04", skip = 6) %>%
  # Tidy up the variable with Janitor
  clean_names() %>%
  rename(area_code = area_code_note_2,
         number_of_residents_per_square_kilometre = population_density_number_of_usual_residents_per_square_kilometre_note_13) %>%
  filter(area_code %in% area_codes) %>%
  # Grab the total population estimates from the flat table
  left_join(df_overall_population_estimates_flat) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority") %>%
  select(period,
         area_code,
         area_name,
         geography,
         number_of_residents = all_persons,
         number_of_residents_per_square_kilometre)

write_csv(df_pop_density_all, "2021_population_density_local_authority_gm.csv")


# Number of households ---------------------------
df_households_all <- read_xlsx(tmp, sheet = "H01", skip = 6) %>%
  # Tidy up the variable with Janitor
  clean_names() %>%
  rename(area_code = area_code_note_2) %>%
  filter(area_code %in% area_codes) %>%
  # Final addition of extra variables
  mutate(period = "2021-03-21",
         geography = "Local authority") %>%
  select(period, area_code, area_name, geography,
         number_of_households = number_of_households_with_at_least_one_usual_resident)

write_csv(df_households_all, "2021_households_local_authority_gm.csv")


# Cleanup the downloaded data ---------------------------
unlink(tmp)
