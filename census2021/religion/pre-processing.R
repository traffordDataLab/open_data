# Religion data from Census 2021 data
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


# Religion - Simple (Individuals) ---------------------------

# LA (GM)
df_la_religion_simple <- read_csv("religion_simple_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         religion = `Religion (10 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Frequency",
         indicator = "Religious affiliation",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, religion, measure, unit, value) %>%
  write_csv("2021_population_religion_la_gm.csv")


# MSOA (Trafford)
df_msoa_religion_simple <- read_csv("religion_simple_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         religion = `Religion (10 categories)`,
         value = Observation
  ) %>%
  filter(religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Frequency",
         indicator = "Religious affiliation",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, religion, measure, unit, value) %>%
  write_csv("2021_population_religion_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_religion_simple <- read_csv("religion_simple_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         religion = `Religion (10 categories)`,
         value = Observation
  ) %>%
  filter(religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         measure = "Frequency",
         indicator = "Religious affiliation",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, religion, measure, unit, value) %>%
  write_csv("2021_population_religion_lsoa_trafford.csv")


# OA (Trafford)
df_oa_religion_simple <- read_csv("religion_simple_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         religion = `Religion (10 categories)`,
         value = Observation
  ) %>%
  filter(religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         measure = "Frequency",
         indicator = "Religious affiliation",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, religion, measure, unit, value) %>%
  write_csv("2021_population_religion_oa_trafford.csv")


# Religion - Detailed (Individuals) ---------------------------

# LA (GM)
df_la_religion_detailed <- read_csv("religion_detailed_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         religion = `Religion (detailed) (58 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         measure = "Frequency",
         indicator = "Religious affiliation",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, religion, measure, unit, value) %>%
  write_csv("2021_population_religion_detailed_la_gm.csv")


# MSOA (Trafford)
df_msoa_religion_detailed <- read_csv("religion_detailed_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         religion = `Religion (detailed) (58 categories)`,
         value = Observation
  ) %>%
  filter(religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         measure = "Frequency",
         indicator = "Religious affiliation",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, religion, measure, unit, value) %>%
  write_csv("2021_population_religion_detailed_msoa_trafford.csv")


# Religion diversity (Household) ---------------------------

# LA (GM)
df_la_religion_diversity_household <- read_csv("household_religion_diversity_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         household_religion = `Multiple religions in household (7 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         household_religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Classifies households by whether members identify with the same religion, no religion, did not answer the question, or a combination of these options",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_religion, measure, unit, value) %>%
  write_csv("2021_household_religion_diversity_la_gm.csv")


# MSOA (Trafford)
df_msoa_religion_diversity_household <- read_csv("household_religion_diversity_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         household_religion = `Multiple religions in household (7 categories)`,
         value = Observation
  ) %>%
  filter(household_religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classifies households by whether members identify with the same religion, no religion, did not answer the question, or a combination of these options",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_religion, measure, unit, value) %>%
  write_csv("2021_household_religion_diversity_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_religion_diversity_household <- read_csv("household_religion_diversity_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         household_religion = `Multiple religions in household (7 categories)`,
         value = Observation
  ) %>%
  filter(household_religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Classifies households by whether members identify with the same religion, no religion, did not answer the question, or a combination of these options",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_religion, measure, unit, value) %>%
  write_csv("2021_household_religion_diversity_lsoa_trafford.csv")


# OA (Trafford)
df_oa_religion_diversity_household <- read_csv("household_religion_diversity_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         household_religion = `Multiple religions in household (7 categories)`,
         value = Observation
  ) %>%
  filter(household_religion != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Classifies households by whether members identify with the same religion, no religion, did not answer the question, or a combination of these options",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, household_religion, measure, unit, value) %>%
  write_csv("2021_household_religion_diversity_oa_trafford.csv")
