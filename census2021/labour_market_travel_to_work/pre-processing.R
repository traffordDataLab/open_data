# Labour Market and Travel to Work from Census 2021 data
# ONS QUALITY NOTICE: As Census 2021 was during a unique period of rapid change, take care when using this data for planning purposes.

# 2022-12-14 James Austin.
# Source: Office for National Statistics https://www.ons.gov.uk/releases/labourmarketandtraveltoworkcensus2021inenglandandwales

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


# Setup objects required by this script ---------------------------

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")


## NOTE: Data downloaded locally via the form on the ONS website. Can also be downloaded via API from NOMIS


# Distance travelled to work ---------------------------

# LA (GM)
df_la_distance_travelled_to_work <- read_csv("distance_travelled_to_work_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         distance_travelled_category = `Distance travelled to work (11 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_la_gm.csv")


# MSOA (Trafford)
df_msoa_distance_travelled_to_work <- read_csv("distance_travelled_to_work_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         distance_travelled_category = `Distance travelled to work (11 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_distance_travelled_to_work <- read_csv("distance_travelled_to_work_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         distance_travelled_category = `Distance travelled to work (11 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_lsoa_trafford.csv")


# OA (Trafford)
df_oa_distance_travelled_to_work <- read_csv("distance_travelled_to_work_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         distance_travelled_category = `Distance travelled to work (11 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Distance travelled to work by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, distance_travelled_category, measure, unit, value) %>%
  write_csv("2021_distance_travelled_to_work_oa_trafford.csv")


# Hours work ---------------------------

# LA (GM)
df_la_hours_worked <- read_csv("hours_worked_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         hours_worked_category = `Hours worked (5 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_la_gm.csv")


# MSOA (Trafford)
df_msoa_hours_worked <- read_csv("hours_worked_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         hours_worked_category = `Hours worked (5 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_hours_worked <- read_csv("hours_worked_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         hours_worked_category = `Hours worked (5 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_lsoa_trafford.csv")


# OA (Trafford)
df_oa_hours_worked <- read_csv("hours_worked_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         hours_worked_category = `Hours worked (5 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Hours worked per week by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, hours_worked_category, measure, unit, value) %>%
  write_csv("2021_hours_worked_oa_trafford.csv")


# Economic activity ---------------------------

# LA (GM)
df_la_economic_activity <- read_csv("economic_activity_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         economic_activity_status = `Economic activity status (20 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_la_gm.csv")


# MSOA (Trafford)
df_msoa_economic_activity <- read_csv("economic_activity_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         economic_activity_status = `Economic activity status (20 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_msoa_trafford.csv")


# LSOA (Trafford)
df_lsoa_economic_activity <- read_csv("economic_activity_lsoa.csv") %>%
  rename(area_code = `Lower Layer Super Output Areas Code`,
         area_name = `Lower Layer Super Output Areas`,
         economic_activity_status = `Economic activity status (20 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Lower-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_lsoa_trafford.csv")


# OA (Trafford)
df_oa_economic_activity <- read_csv("economic_activity_oa.csv") %>%
  rename(area_code = `Output Areas Code`,
         area_name = `Output Areas`,
         economic_activity_status = `Economic activity status (20 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Output Area",
         period = "2021-03-21",
         indicator = "Economic activity status of usual residents (aged 16 years and over)",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code, area_name, geography, period, indicator, economic_activity_status, measure, unit, value) %>%
  write_csv("2021_economic_activity_status_oa_trafford.csv")

 
# Industry ---------------------------

# LA (GM)
df_la_industry <- read_csv("industry_la.csv") %>%
  rename(area_code = `Lower Tier Local Authorities Code`,
         area_name = `Lower Tier Local Authorities`,
         industry = `Industry (current) (88 categories)`,
         value = Observation
  ) %>%
  filter(area_code %in% area_codes_gm) %>%
  mutate(geography = "Local authority",
         period = "2021-03-21",
         indicator = "Industry worked in by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         industry = str_replace_all(industry, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, industry, measure, unit, value) %>%
  write_csv("2021_industry_la_gm.csv")


# MSOA (Trafford)
df_msoa_industry <- read_csv("industry_msoa.csv") %>%
  rename(area_code = `Middle Layer Super Output Areas Code`,
         area_name = `Middle Layer Super Output Areas`,
         industry = `Industry (current) (88 categories)`,
         value = Observation
  ) %>%
  mutate(geography = "Middle-layer Super Output Area",
         period = "2021-03-21",
         indicator = "Industry worked in by usual residents (aged 16 years and over in employment the week before the census)",
         measure = "Count",
         unit = "Persons",
         industry = str_replace_all(industry, "[0-9]+ ", "")) %>% # remove the category code number
  select(area_code, area_name, geography, period, indicator, industry, measure, unit, value) %>%
  write_csv("2021_industry_msoa_trafford.csv")



