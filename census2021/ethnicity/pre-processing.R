# Ethnic group data from Census 2021 data
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


# Ethnic Group non-detailed (Individuals) ---------------------------

# LA (GM)
df_la_ethnicity <- read_csv("ethnicity_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         ethnic_group = `Ethnic group (20 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         ethnic_group != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "The ethnic group that the person completing the census feels they belong to",
         measure = "Frequency",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_group, measure, unit, value) %>%
  write_csv("2021_population_ethnic_group_la_gm.csv")


# MSOA (Trafford)
df_msoa_ethnicity <- read_csv("ethnicity_msoa_trafford.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         ethnic_group = `Ethnic group (20 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_group != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The ethnic group that the person completing the census feels they belong to",
         measure = "Frequency",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_group, measure, unit, value) %>%
  write_csv("2021_population_ethnic_group_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_ethnicity <- read_csv("ethnicity_lsoa_trafford.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         ethnic_group = `Ethnic group (20 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_group != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The ethnic group that the person completing the census feels they belong to",
         measure = "Frequency",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_group, measure, unit, value) %>%
  write_csv("2021_population_ethnic_group_lsoa_trafford.csv")


# OA (Trafford)
df_oa_ethnicity <- read_csv("ethnicity_oa_trafford.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         ethnic_group = `Ethnic group (20 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_group != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "The ethnic group that the person completing the census feels they belong to",
         measure = "Frequency",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_group, measure, unit, value) %>%
  write_csv("2021_population_ethnic_group_oa_trafford.csv")


# Ethnic Group detailed (Individuals) ---------------------------

# LA (GM)
df_la_ethnicity_detailed <- read_csv("ethnicity_detailed_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         ethnic_group = `Ethnic Group (detailed) (288 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         ethnic_group != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "The ethnic group that the person completing the census feels they belong to",
         measure = "Frequency",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_group, measure, unit, value) %>%
  write_csv("2021_population_ethnic_group_detailed_la_gm.csv")


# MSOA (Trafford)
df_msoa_ethnicity_detailed <- read_csv("ethnicity_detailed_msoa_trafford.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         ethnic_group = `Ethnic Group (detailed) (288 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_group != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "The ethnic group that the person completing the census feels they belong to",
         measure = "Frequency",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_group, measure, unit, value) %>%
  write_csv("2021_population_ethnic_group_detailed_msoa_trafford.csv")


# Multiple Ethnic Group (Household) ---------------------------

# LA (GM)
df_la_ethnic_group_household <- read_csv("household_multiple_ethnicity_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         ethnic_diversity = `Multiple ethnic groups in household (6 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm,
         ethnic_diversity != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Diversity in ethnic group of household members in different relationships",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_diversity, measure, unit, value) %>%
  write_csv("2021_household_ethnic_diversity_la_gm.csv")


# MSOA (Trafford)
df_msoa_ethnic_group_household <- read_csv("household_multiple_ethnicity_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         ethnic_diversity = `Multiple ethnic groups in household (6 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_diversity != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Diversity in ethnic group of household members in different relationships",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_diversity, measure, unit, value) %>%
  write_csv("2021_household_ethnic_diversity_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_ethnic_group_household <- read_csv("household_multiple_ethnicity_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         ethnic_diversity = `Multiple ethnic groups in household (6 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_diversity != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Diversity in ethnic group of household members in different relationships",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_diversity, measure, unit, value) %>%
  write_csv("2021_household_ethnic_diversity_lsoa_trafford.csv")


# OA (Trafford)
df_oa_ethnic_group_household <- read_csv("household_multiple_ethnicity_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         ethnic_diversity = `Multiple ethnic groups in household (6 categories)`,
         value = Observation
  ) %>%
  filter(ethnic_diversity != "Does not apply") %>% # These are all 0 for all areas
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Diversity in ethnic group of household members in different relationships",
         measure = "Frequency",
         unit = "Households") %>%
  select(area_code, area_name, geography, period, indicator, ethnic_diversity, measure, unit, value) %>%
  write_csv("2021_household_ethnic_diversity_oa_trafford.csv")

