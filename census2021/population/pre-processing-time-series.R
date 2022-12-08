# Obtain time-series census data 1981 - 2011 and match to first release of Census 2021 data prepared by another script
# 2022-07-06 James Austin.

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

# Census dates:
# 1981-04-05
# 1991-04-21
# 2001-04-29
# 2011-03-27
# 2021-03-21


# Load the required libraries ---------------------------
library(tidyverse); library(httr); library(readxl); library(janitor)


# Setup objects required by this script ---------------------------

# Area codes of the 10 Local Authorities in Greater Manchester"
area_codes_gm <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Area codes of Trafford's Children's Services Statistical Neighbours
area_codes_cssn <- c("E10000015","E09000006","E08000029","E08000007","E06000036","E06000056","E06000014","E06000049","E10000014","E06000060")

# Area codes of Trafford's CIPFA Nearest Neighbours (2019)
area_codes_cipfa <- c("E06000007","E06000030","E08000029","E06000042","E06000025","E06000034","E08000007","E06000014","E06000055","E06000050","E06000031","E06000005","E06000015","E08000002","E06000020")

area_codes = area_codes_gm  # Initially we'll focus on GM, but the other codes are available if we require above


# Time-series population data by sex ---------------------------
# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14796ct1214sextimeseriescensus1981to2011
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14796ct1214sextimeseriescensus1981to2011/ct1214sextimeseriescensus1981to2011.xlsx", write_disk(tmp))

df_pop_time_series_by_sex <- read_xlsx(tmp, sheet = "CT1214 - Sex Time series", skip = 9) %>%
  rename(area_code = 1,
         area_name = 2,
         sex = Sex) %>%
  filter(area_code %in% area_codes) %>%
  mutate(sex = if_else(sex == "Total: Sex", "Persons", sex)) %>%
  # Convert from wide to long format and in doing so make it tidy
  pivot_longer(cols = c(-area_code, -area_name, -sex), names_to = "period", values_to = "value") %>%
  mutate(period = as.Date(case_when(period == "1981" ~ "1981-04-05",
                            period == "1991" ~ "1991-04-21",
                            period == "2001" ~ "2001-04-29",
                            TRUE ~ "2011-03-27")),
         geography = "Local authority",
         age_group = "All ages") %>%
  select(period, area_code, area_name, geography, sex, age_group, value)

# Cleanup the downloaded time-series population data by sex
unlink(tmp)


# Time-series population data by age group (all persons) ---------------------------
# NOTE: last data point is "85 or over", not "90 and over" for the 2021 data
# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14797ct1215agetimeseriescensus1981to2011
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14797ct1215agetimeseriescensus1981to2011/ct1215agetimeseriescensus1981to2011.xlsx", write_disk(tmp))

df_pop_time_series_by_age_all <- read_xlsx(tmp, sheet = "CT1215 - Age Time series", skip = 9) %>%
  rename(area_code = 1,
         area_name = 2,
         age_group = Age) %>%
  rename_with(~str_remove(., "Census ")) %>%
  filter(area_code %in% area_codes) %>%
  pivot_longer(cols = c(-area_code, -area_name, -age_group), names_to = "period", values_to = "value") %>%
  mutate(period = as.Date(case_when(period == "1981" ~ "1981-04-05",
                                    period == "1991" ~ "1991-04-21",
                                    period == "2001" ~ "2001-04-29",
                                    TRUE ~ "2011-03-27")),
         geography = "Local authority",
         sex = "Persons",
         age_group = case_when(age_group == "0 to 4" ~ "Aged 4 years and under",
                              age_group == "85 or over" ~ "Aged 85 years and over",
                              TRUE ~ paste0("Aged ", age_group, " years"))) %>%
  select(period, area_code, area_name, geography, sex, age_group, value) %>%
  arrange(area_name, period)

# Cleanup the downloaded time-series population data by 5-year age bands
unlink(tmp)


# Time-series population data by age group and sex (females and males) ---------------------------
# NOTE: last data point is "85 or over", not "90 and over" for the 2021 data
# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14798ct1216sexbyagetimeseriescensus1981to2011
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14798ct1216sexbyagetimeseriescensus1981to2011/ct1216sexbyagetimeseriescensus1981to2011.xlsx", write_disk(tmp))

# Get data for females first
df_pop_time_series_by_age_females <- read_xlsx(tmp, sheet = "CT1216 Females", skip = 9) %>%
  rename(area_code = 1,
         area_name = 2,
         age_group = `Sex by age`) %>%
  filter(area_code %in% area_codes) %>%
  pivot_longer(cols = c(-area_code, -area_name, -age_group), names_to = "period", values_to = "value") %>%
  mutate(period = as.Date(case_when(period == "1981" ~ "1981-04-05",
                                    period == "1991" ~ "1991-04-21",
                                    period == "2001" ~ "2001-04-29",
                                    TRUE ~ "2011-03-27")),
         geography = "Local authority",
         sex = "Females",
         age_group = str_remove(age_group, "Females "),
         age_group = case_when(age_group == "0 to 4" ~ "Aged 4 years and under",
                               age_group == "85 or over" ~ "Aged 85 years and over",
                               TRUE ~ paste0("Aged ", age_group, " years"))) %>%
  select(period, area_code, area_name, geography, sex, age_group, value) %>%
  arrange(area_name, period)

# Then the males
df_pop_time_series_by_age_males <- read_xlsx(tmp, sheet = "CT1216 Males", skip = 9) %>%
  rename(area_code = 1,
         area_name = 2,
         age_group = `Sex by age`) %>%
  filter(area_code %in% area_codes) %>%
  pivot_longer(cols = c(-area_code, -area_name, -age_group), names_to = "period", values_to = "value") %>%
  mutate(period = as.Date(case_when(period == "1981" ~ "1981-04-05",
                                    period == "1991" ~ "1991-04-21",
                                    period == "2001" ~ "2001-04-29",
                                    TRUE ~ "2011-03-27")),
         geography = "Local authority",
         sex = "Males",
         age_group = str_remove(age_group, "Males "),
         age_group = case_when(age_group == "0 to 4" ~ "Aged 4 years and under",
                               age_group == "85 or over" ~ "Aged 85 years and over",
                               TRUE ~ paste0("Aged ", age_group, " years"))) %>%
  select(period, area_code, area_name, geography, sex, age_group, value) %>%
  arrange(area_name, period)

# Cleanup the downloaded time-series population data by sex and 5-year age bands
unlink(tmp)


# Complete the time-series data by sex and age for the last 5 censuses ---------------------------
# Bring in Census 2021 data prepared by another script
# Convert 85-89 and 90+ to "85 and over" to match the older time-series data
df_pop_by_sex_and_age_2021 <- read_csv("2021_population_by_sex_and_age_group_wide_la_gm.csv") %>%
  mutate(aged_85_years_and_over = aged_85_to_89_years + aged_90_years_and_over) %>%
  select(-aged_85_to_89_years, -aged_90_years_and_over) %>%
  pivot_longer(cols = c(-period, -area_code, -area_name, -geography, -sex), names_to = "age_group", values_to = "value") %>%
  mutate(age_group = str_to_sentence(str_replace_all(age_group, "_", " ")))

# Finally bind all the data together to create the completed dataset
df_pop_by_time_series_by_sex_and_age <- bind_rows(df_pop_time_series_by_sex,         # "All ages" for females, males and persons (total) 1981 - 2011
                                                  df_pop_time_series_by_age_females, # age groups for females 1981 - 2011
                                                  df_pop_time_series_by_age_males,   # age groups for males 1981 - 2011
                                                  df_pop_time_series_by_age_all,     # age groups for persons 1981 - 2011
                                                  df_pop_by_sex_and_age_2021) %>%    # all the above for 2021
  arrange(area_name, period, sex) %>%
  mutate(indicator = "Usual resident population by sex and age group",
         measure = "Count",
         unit = "Usual residents") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, sex, age_group, value)

# Create the dataset for Greater Manchester first
write_csv(df_pop_by_time_series_by_sex_and_age, "1981-2021_population_by_sex_and_age_group_la_gm.csv")

# Then create the same dataset just for Trafford
df_pop_by_time_series_by_sex_and_age %>%
  filter(area_name == "Trafford") %>%
  write_csv("1981-2021_population_by_sex_and_age_group_la_trafford.csv")


# Time-series density data ---------------------------
# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14799ct1217populationdensitytimeseriescensus1981to2011
tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/adhocs/14799ct1217populationdensitytimeseriescensus1981to2011/ct1217populationdensitytimeseriescensus1981to2011.xlsx", write_disk(tmp))

# Data for 2021 previously prepared
df_pop_density_2021 <- read_csv("2021_population_density_la_gm.csv")

df_pop_density_time_series <- read_xlsx(tmp, sheet = "CT1217 Population density", skip = 9) %>%
  rename(area_code = 1,
         area_name = 2) %>%
  filter(area_code %in% area_codes) %>%
  select(-`Number of persons per square kilometre *`) %>% # This column actually just contains the word "density" not the data!
  # Convert from wide to tall format and in doing so make it tidy
  pivot_longer(cols = c(-area_code, -area_name), names_to = "period", values_to = "value") %>%
  # Amend the period to the full date of the census
  mutate(period = as.Date(case_when(period == "1981" ~ "1981-04-05",
                            period == "1991" ~ "1991-04-21",
                            period == "2001" ~ "2001-04-29",
                            TRUE ~ "2011-03-27")),
         geography = "Local authority",
         indicator = "Usual resident population density",
         measure = "Rate",
         unit = "Number of usual residents per square kilometre") %>%
  select(area_code, area_name, geography, period, indicator, measure, unit, value) %>%
  # Add in the latest density figures for 2021 and then sort the data into the correct order
  bind_rows(df_pop_density_2021) %>%
  arrange(area_name, period)

write_csv(df_pop_density_time_series, "1981-2021_population_density_la_gm.csv")

# Cleanup the downloaded time-series density data
unlink(tmp)
