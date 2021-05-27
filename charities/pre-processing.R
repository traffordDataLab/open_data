# Charity Commission - register of charities
# https://register-of-charities.charitycommission.gov.uk/register/full-register-download
# 2021-05-27. ***NOTE: service is currently in BETA ***

# Obtain a list of all currently registered charities operating within Trafford
# Data is split over multiple tables which need joining, available as TSV and JSON
# Data definitions for all the tables can be found at:
# https://register-of-charities.charitycommission.gov.uk/documents/34602/422354/Data+Definition.docx/f0a342ce-ef45-1401-ee75-26225f6f0d4f?t=1617010186385

library(tidyverse); library(jsonlite); library(lubridate)

# Main dataset: "charity" - all recorded charities whether currently registered or not 
url <- "https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity.zip"

# Download, extract and load in the data
download.file(url, destfile = "publicextract.charity.zip")
unzip("publicextract.charity.zip", exdir = ".")
all_charities <- fromJSON("publicextract.charity.json", flatten = TRUE)

# Tidy-up removing the files we no longer need
file.remove("publicextract.charity.zip")
file.remove("publicextract.charity.json")

# Get the main charities only, i.e. ignore linked charities which share the same number, and tidy the variables
# This dataset includes both currently registered charities and those that have been removed
# All subsequent tables for matching to this main dataset contain all registered and removed charities, so we'll filter for only registered later
main_charities <- all_charities %>%
  filter(linked_charity_number == 0) %>%
  # concatenate the address fields into one for easier representation, but keep the postcode separate
  unite(charity_contact_address,
        charity_contact_address1,
        charity_contact_address2,
        charity_contact_address3,
        charity_contact_address4,
        charity_contact_address5,
        remove = FALSE, sep = "#") %>%
  mutate(charity_contact_address = str_replace_all(charity_contact_address, "#NA", "")) %>%
  mutate(charity_contact_address = str_replace_all(charity_contact_address, "#", ", ")) %>%
  mutate(date_of_registration = ymd(as.Date(date_of_registration))) %>%
  select(registered_charity_number,
         charity_company_registration_number,
         charity_registration_status,
         charity_name,
         charity_type,
         charity_activities,
         date_of_registration,
         charity_insolvent,
         charity_in_administration,
         charity_gift_aid,
         charity_contact_address,
         charity_contact_postcode,
         charity_contact_phone,
         charity_contact_email,
         charity_contact_web)


# Area of operation - where the charities operate:
url <- "https://ccewuksprdoneregsadata1.blob.core.windows.net/data/json/publicextract.charity_area_of_operation.zip"

# Download, extract and load in the data
download.file(url, destfile = "publicextract.charity_area_of_operation.zip")
unzip("publicextract.charity_area_of_operation.zip", exdir = ".")
areas_of_operation <- fromJSON("publicextract.charity_area_of_operation.json", flatten = TRUE)

# Tidy-up removing the files we no longer need
file.remove("publicextract.charity_area_of_operation.zip")
file.remove("publicextract.charity_area_of_operation.json")

# Join the 2 datasets to get just those registered charities that are operating within Trafford
charities_operating_in_trafford <- areas_of_operation %>%
  # Just keep those charities who declare that they operate in Trafford
  filter(geographic_area_description == "Trafford") %>%
  # Keep the charity number for the join but none of the other variables are needed 
  select(registered_charity_number) %>%
  left_join(., main_charities, by = "registered_charity_number") %>%
  # Keep only those charities that are currently registered (i.e. they haven't been removed)
  filter(charity_registration_status == "Registered") %>%
  select(-charity_registration_status)

# Create the CSV output dataset  
write_csv(charities_operating_in_trafford, "charities_operating_in_trafford.csv")
