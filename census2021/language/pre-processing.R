# Language data from Census 2021 data
# 2022-12-07 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/ethnicgroupnationalidentitylanguageandreligioncensus2021inenglandandwales

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
library(tidyverse); library(httr); library(janitor)


# Setup objects required by this script ---------------------------

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")


## NOTE: Data has to be downloaded locally via the form on the ONS website


# Languages detailed (Individuals) ---------------------------

# LA (GM)
df_la_languages_detailed <- read_csv("languages_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         language = `Main language (detailed) (95 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "First or preferred language",
         unit = "Usual residents",
         language = case_when(language == "English (English or Welsh in Wales)" ~ "English",
                              language == "Welsh or Cymraeg (in England only)" ~ "Welsh",
                              TRUE ~ language)) %>%
  select(area_code, area_name, geography, period, indicator, language, measure, unit, value) %>%
  write_csv("2021_population_language_detailed_la_gm.csv")


# Proficiency in English (Individuals) ---------------------------

# LA (GM)
df_la_english_proficiency <- read_csv("english_proficiency_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         proficiency = `Proficiency in English language (6 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Proficiency in English",
         unit = "Persons",
         indicator = str_replace(indicator, " \\(English or Welsh in Wales\\)", "")) %>%
  select(area_code, area_name, geography, period, indicator, proficiency, measure, unit, value) %>%
  write_csv("2021_population_english_proficiency_la_gm.csv")


# MSOA (Trafford)
df_msoa_english_proficiency <- read_csv("english_proficiency_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         proficiency = `Proficiency in English language (6 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Proficiency in English",
         unit = "Persons",
         indicator = str_replace(indicator, " \\(English or Welsh in Wales\\)", "")) %>%
  select(area_code, area_name, geography, period, indicator, proficiency, measure, unit, value) %>%
  write_csv("2021_population_english_proficiency_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_english_proficiency <- read_csv("english_proficiency_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         proficiency = `Proficiency in English language (6 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Proficiency in English",
         unit = "Persons",
         indicator = str_replace(indicator, " \\(English or Welsh in Wales\\)", "")) %>%
  select(area_code, area_name, geography, period, indicator, proficiency, measure, unit, value) %>%
  write_csv("2021_population_english_proficiency_lsoa_trafford.csv")


# OA (Trafford)
df_oa_english_proficiency <- read_csv("english_proficiency_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         proficiency = `Proficiency in English language (6 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Count",
         indicator = "Proficiency in English",
         unit = "Persons",
         indicator = str_replace(indicator, " \\(English or Welsh in Wales\\)", "")) %>%
  select(area_code, area_name, geography, period, indicator, proficiency, measure, unit, value) %>%
  write_csv("2021_population_english_proficiency_oa_trafford.csv")


# English Main Language (Household) ---------------------------

# LA (GM)
df_la_eng_main_lang_household <- read_csv("household_language_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         household_language = `Household language (English and Welsh) (5 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Combination of adults and children within a household that have English as a main language",
         measure = "Count",
         unit = "Households",
         household_language = str_replace_all(household_language, c(" in England, or English or Welsh in Wales" = "", ", has English in England or English or Welsh in Wales" = " has English"))) %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_main_language_english_la_gm.csv")


# MSOA (Trafford)
df_msoa_eng_main_lang_household <- read_csv("household_language_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         household_language = `Household language (English and Welsh) (5 categories)`,
         value = Observation
  ) %>%
  filter(household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Combination of adults and children within a household that have English as a main language",
         measure = "Count",
         unit = "Households",
         household_language = str_replace_all(household_language, c(" in England, or English or Welsh in Wales" = "", ", has English in England or English or Welsh in Wales" = " has English"))) %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_main_language_english_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_eng_main_lang_household <- read_csv("household_language_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         household_language = `Household language (English and Welsh) (5 categories)`,
         value = Observation
  ) %>%
  filter(household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Combination of adults and children within a household that have English as a main language",
         measure = "Count",
         unit = "Households",
         household_language = str_replace_all(household_language, c(" in England, or English or Welsh in Wales" = "", ", has English in England or English or Welsh in Wales" = " has English"))) %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_main_language_english_lsoa_trafford.csv")


# OA (Trafford)
df_oa_eng_main_lang_household <- read_csv("household_language_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         household_language = `Household language (English and Welsh) (5 categories)`,
         value = Observation
  ) %>%
  filter(household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Combination of adults and children within a household that have English as a main language",
         measure = "Count",
         unit = "Households",
         household_language = str_replace_all(household_language, c(" in England, or English or Welsh in Wales" = "", ", has English in England or English or Welsh in Wales" = " has English"))) %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_main_language_english_oa_trafford.csv")


# Language diversity (Household) ---------------------------

# LA (GM)
df_la_lang_diversity_household <- read_csv("household_language_diversity_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         household_language = `Multiple main languages in household (6 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Combination of household members speaking the same or different main languages",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_language_diversity_la_gm.csv")


# MSOA (Trafford)
df_msoa_lang_diversity_household <- read_csv("household_language_diversity_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         household_language = `Multiple main languages in household (6 categories)`,
         value = Observation
  ) %>%
  filter(household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Combination of household members speaking the same or different main languages",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_language_diversity_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_lang_diversity_household <- read_csv("household_language_diversity_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         household_language = `Multiple main languages in household (6 categories)`,
         value = Observation
  ) %>%
  filter(household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Combination of household members speaking the same or different main languages",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_language_diversity_lsoa_trafford.csv")


# OA (Trafford)
df_oa_lang_diversity_household <- read_csv("household_language_diversity_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         household_language = `Multiple main languages in household (6 categories)`,
         value = Observation
  ) %>%
  filter(household_language != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Combination of household members speaking the same or different main languages",
         measure = "Count",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_language, measure, unit, value) %>%
  write_csv("2021_household_language_diversity_oa_trafford.csv")
