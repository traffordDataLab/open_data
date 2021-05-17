# Trafford GP Practice Registrations

# Source: https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice

# Current publication: https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice/may-2021
# GP Practices: https://files.digital.nhs.uk/30/2C2E37/gp-reg-pat-prac-all.csv
# Patients: https://files.digital.nhs.uk/24/2F1356/gp-reg-pat-prac-map.csv

library(tidyverse)

# Load Trafford's postcodes and associated area information
trafford_postcodes <- read_csv("https://www.trafforddatalab.io/spatial_data/postcodes/trafford_postcodes.csv") %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, locality)

# Get the list of GP practices under Trafford CCG
trafford_gp <- read_csv("https://files.digital.nhs.uk/24/2F1356/gp-reg-pat-prac-map.csv") %>%
  filter(CCG_NAME == "NHS Trafford CCG") %>%
  select(practice_code = PRACTICE_CODE,
         practice_name = PRACTICE_NAME,
         postcode = PRACTICE_POSTCODE)

# Get the current number of patient registrations
trafford_gp_patients <- read_csv("https://files.digital.nhs.uk/30/2C2E37/gp-reg-pat-prac-all.csv") %>%
  filter(ONS_CCG_CODE == "E38000187") %>%
  rename(practice_code = CODE,
         registered_patients = NUMBER_OF_PATIENTS) %>%
  left_join(trafford_gp, by = "practice_code") %>%
  left_join(trafford_postcodes, by = "postcode") %>%
  select(practice_code,
         practice_name,
         practice_postcode = postcode,
         registered_patients,
         ward_code,
         ward_name,
         msoa_code,
         msoa_hcl_name,
         locality)

write_csv(trafford_gp_patients, "trafford_gp_patient_registrations.csv")
