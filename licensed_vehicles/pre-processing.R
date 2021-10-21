# Licensed Vehicles.
# Created: 2021-10-20

# Source: Department for Transport (DfT) & Driver and Vehicle Licensing Authority (DVLA)
#         https://www.gov.uk/government/statistical-data-sets/all-vehicles-veh01

# Data comes from 3 separate datasets:
# Ultra low emission vehicles:    https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1021017/veh0132.ods
# All plug-in electric vehicles:  https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1021016/veh0131.ods
# All Vehicles by body type:      https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/985605/veh0105.ods

# Sheets contained within the veh0132.ods workbook (ULEV) - headings start at row 7:
# 1 - All ULEV
# 2 - All BEV (Battery Electric Vehicle) - subset of ULEV
# 3 - All PHEV (Plug-in Hybrid Electric Vehicle) - subset of ULEV
# 4 - Private ULEV
# 5 - Private BEV - subset of private ULEV
# 6 - Private PHEV - subset of private ULEV
# 7 - Company ULEV
# 8 - Company BEV - subset of company ULEV
# 9 - Company PHEV - subset of company ULEV


# Load required packages ---------------------------

library(tidyverse); library(readODS); library(lubridate)


# Download the data --------------------------- 

download.file("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/985605/veh0105.ods", "veh0105.ods")
download.file("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1021016/veh0131.ods", "veh0131.ods")
download.file("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1021017/veh0132.ods", "veh0132.ods")


# Setup objects ---------------------------

# E92000001: England
# E12000002: North West
# E11000001: Greater Manchester
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

# Codes of the 10 Local Authorities in Greater Manchester:
gm_la_codes <- c("E08000001","E08000002","E08000003","E08000004","E08000005","E08000006","E08000007","E08000008","E08000009","E08000010")

# Function to tidy the data in both veh0131.ods (ULEV) and veh0132.ods (All plug-in electric)
tidyUlevData <- function(df, area_codes, category) {
  as_tibble(df) %>%
    rename(area_code = `ONS LA Code (Apr-2019)`,
           area_name = `Region/Local Authority (Apr-2019)3`) %>%
    filter(area_code %in% area_codes) %>%
    
    # convert to 'tidy' data by transposing the dataset to long format
    pivot_longer(c(-area_code, -area_name), names_to = "period", values_to = "vehicle_count") %>%
    
    # convert the reporting period into a separate year and quarter, then create an additional date value in yyyy-mm-dd to allow easier plotting and sub-setting of the data
    # the notes say that the vehicle counts are the end of each stated quarter
    
    separate(period, into = c("year", "quarter"), sep = " ") %>% 
    mutate(year = as.integer(year),
           quarter = as.integer(str_extract(quarter, "[1-4]")),
           effective_date = ymd(paste0(year, "-", case_when(quarter == 1 ~ "03-31",
                                                            quarter == 2 ~ "06-30",
                                                            quarter == 3 ~ "09-30",
                                                            quarter == 4 ~ "12-31"))),
           vehicle_count = as.integer(na_if(vehicle_count, "c")),
           category = category
    ) %>%
    
    # select the variables and the order we want them in the output
    select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)
}


# All ULEV ---------------------------
# All types of privately and commercially licensed Ultra Low Emission Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 1, skip = 6)

# Tidy the data
df_all_ulev <- tidyUlevData(df_raw, gm_la_codes, "All licensed ultra low emission vehicles (ULEV)")


# All BEV ---------------------------
# All privately and commercially licensed Battery Electric Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 2, skip = 6)

# Tidy the data
df_all_bev <- tidyUlevData(df_raw, gm_la_codes, "All licensed battery electric vehicles (BEV)")


# All PHEV ---------------------------
# All privately and commercially licensed Plug-in Hybrid Electric Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 3, skip = 6)

# Some of the vehicle count columns are type 'num' rather than 'chr', need to convert to 'chr' before tidying
df_raw <- df_raw %>%
  mutate(`2012 Q2` = as.character(`2012 Q2`),
         `2012 Q1` = as.character(`2012 Q1`),
         `2011 Q4` = as.character(`2011 Q4`))

# Tidy the data
df_all_phev <- tidyUlevData(df_raw, gm_la_codes, "All licensed plug-in hybrid electric vehicles (PHEV)")


# Private ULEV ---------------------------
# All types of privately licensed Ultra Low Emission Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 4, skip = 6)

# Tidy the data
df_private_ulev <- tidyUlevData(df_raw, gm_la_codes, "Private licensed ultra low emission vehicles (ULEV)")


# Private BEV ---------------------------
# All privately licensed Battery Electric Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 5, skip = 6)

# Tidy the data
df_private_bev <- tidyUlevData(df_raw, gm_la_codes, "Private licensed battery electric vehicles (BEV)")


# Private PHEV ---------------------------
# All privately licensed Plug-in Hybrid Electric Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 6, skip = 6)

# Some of the vehicle count columns are type 'num' rather than 'chr', need to convert to 'chr' before tidying
df_raw <- df_raw %>%
  mutate(`2012 Q2` = as.character(`2012 Q2`),
         `2012 Q1` = as.character(`2012 Q1`),
         `2011 Q4` = as.character(`2011 Q4`))

# Tidy the data
df_private_phev <- tidyUlevData(df_raw, gm_la_codes, "Private licensed plug-in hybrid electric vehicles (PHEV)")


# Company ULEV ---------------------------
# All types of commercially licensed Ultra Low Emission Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 7, skip = 6)

# Tidy the data
df_company_ulev <- tidyUlevData(df_raw, gm_la_codes, "Company licensed ultra low emission vehicles (ULEV)")


# Company BEV ---------------------------
# All commercially licensed Battery Electric Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 8, skip = 6)

# Tidy the data
df_company_bev <- tidyUlevData(df_raw, gm_la_codes, "Company licensed battery electric vehicles (BEV)")


# Company PHEV ---------------------------
# All commercially licensed Plug-in Hybrid Electric Vehicles

# Read in the raw data from the file
df_raw <- read_ods("veh0132.ods", sheet = 9, skip = 6)

# Some of the vehicle count columns are type 'num' rather than 'chr', need to convert to 'chr' before tidying
df_raw <- df_raw %>%
  mutate(`2012 Q2` = as.character(`2012 Q2`),
         `2012 Q1` = as.character(`2012 Q1`),
         `2011 Q4` = as.character(`2011 Q4`))

# Tidy the data
df_company_phev <- tidyUlevData(df_raw, gm_la_codes, "Company licensed plug-in hybrid electric vehicles (PHEV)")


# Plug-in electric vehicles ---------------------------
# This includes all BEV, PHEV and range-extended electric vehicles (REEV)

# Read in the raw data from the file
df_raw <- read_ods("veh0131.ods", sheet = 1, skip = 6)

# Tidy the data
df_plug_ev <- tidyUlevData(df_raw, gm_la_codes, "All licensed plug-in electric vehicles")


# All vehicles ---------------------------
# These data are reported at the end of each year, so we'll align to the Q4 data in the other datasets

# The data is arranged within the workbook with a separate tab for each year, so we first need to load it into a single data frame 
df_raw <- "veh0105.ods" %>%
  list_ods_sheets() %>%
  set_names() %>% # instead of using the sheet ordinal, this uses the name within the map function
  map_df(~ read_ods(path = "veh0105.ods", sheet = .x, 
                    col_names = TRUE, col_types = NA, skip = 7), .id = "year")

# Tidy the raw data within the same data frame as we will be using it later to create new tibbles, one for each vehicle type as required
# NOTE: the headings for the area code and area name are different for years pre-2020
df_raw <- df_raw %>%
  mutate(area_code = if_else(is.na(`ONS LA Code`), `ONS LA Code (Apr-2019)`, `ONS LA Code`),
         area_name = if_else(is.na(`Region/Local Authority`), `Region/Local Authority (Apr-2019)3`, `Region/Local Authority`),
         year = as.integer(year),
         quarter = as.integer(4), # the notes in the workbook state that the data is correct at the end of each year, so align with the Q4 data from the ULEV and plug-in EV workbooks
         effective_date = ymd(paste0(year, "-12-31"))) %>%
  filter(area_code %in% gm_la_codes,
         year >= 2011) # The other datasets are from 2011 Q4 so discard any earlier data

df_all_vehicles <- df_raw %>%
  mutate(category = "All licensed vehicles",
         vehicle_count = as.integer(as.numeric(`Total`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_cars <- df_raw %>%
  mutate(category = "All licensed cars",
         vehicle_count = as.integer(as.numeric(`Cars`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_motorcycles <- df_raw %>%
  mutate(category = "All licensed motorcycles",
         vehicle_count = as.integer(as.numeric(`Motorcycles`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_lgv <- df_raw %>%
  mutate(category = "All licensed light goods vehicles (LGV)",
         vehicle_count = as.integer(as.numeric(`Light Goods Vehicles`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_hgv <- df_raw %>%
  mutate(category = "All licensed heavy goods vehicles (HGV)",
         vehicle_count = as.integer(as.numeric(`Heavy Goods Vehicles`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_bus_coach <- df_raw %>%
  mutate(category = "All licensed buses and coaches",
         vehicle_count = as.integer(as.numeric(`Buses and coaches`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_other <- df_raw %>%
  mutate(category = "All other licensed vehicles",
         vehicle_count = as.integer(as.numeric(`Other vehicles2`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_diesel_cars <- df_raw %>%
  mutate(category = "All licensed diesel cars",
         vehicle_count = as.integer(as.numeric(`Diesel Cars`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

df_all_diesel_vans <- df_raw %>%
  mutate(category = "All licensed diesel vans",
         vehicle_count = as.integer(as.numeric(`Diesel Vans`)*1000)) %>% # data expressed as a string in 'thousands' within workbook
  select(area_code, area_name, category, year, quarter, effective_date, vehicle_count)

# Join datasets together ---------------------------
df_gm_authorities_ulev_data <- bind_rows(df_all_ulev,
                                        df_all_bev,
                                        df_all_phev,
                                        df_private_ulev,
                                        df_private_bev,
                                        df_private_phev,
                                        df_company_ulev,
                                        df_company_bev,
                                        df_company_phev,
                                        df_plug_ev)

df_gm_authorities_vehicles_data <- bind_rows(df_all_cars,
                                             df_all_motorcycles,
                                             df_all_lgv,
                                             df_all_hgv,
                                             df_all_bus_coach,
                                             df_all_other,
                                             df_all_vehicles,
                                             df_all_diesel_cars,
                                             df_all_diesel_vans)

# Export the tidied data ---------------------------
write_csv(df_gm_authorities_ulev_data, "licensed_ulev_gm_authorities.csv")
write_csv(filter(df_gm_authorities_ulev_data, area_name == "Trafford"), "licensed_ulev_trafford.csv")
write_csv(df_gm_authorities_vehicles_data, "licensed_vehicles_gm_authorities.csv")
write_csv(filter(df_gm_authorities_vehicles_data, area_name == "Trafford"), "licensed_vehicles_trafford.csv")


# Clean up ---------------------------
if (file.exists("veh0105.ods")) file.remove("veh0105.ods")
if (file.exists("veh0131.ods")) file.remove("veh0131.ods")
if (file.exists("veh0132.ods")) file.remove("veh0132.ods")
