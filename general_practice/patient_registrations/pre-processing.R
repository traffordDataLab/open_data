# Trafford GP Practice Registrations

# Source: https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice

# Current publication: https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice/january-2026
# GP Practices: https://files.digital.nhs.uk/FB/6E37C6/gp-reg-pat-prac-map.zip
# Patients: https://files.digital.nhs.uk/10/0EC6AE/gp-reg-pat-prac-all.zip

# NOTE: Clinical Commissioning Groups (CCG) were abolished in favour of Integrated Care Boards (ICB) in 2022.
# Trafford GPs are now part of:
# ICB22NM: NHS Greater Manchester Integrated Care Board
# ICB22CD: E54000057
# ICB22CDH: QOP


library(tidyverse) ; library(httr)

# Download the ZIP files required ---------
tmp <- tempfile(fileext = ".zip")
GET(url = "https://files.digital.nhs.uk/FB/6E37C6/gp-reg-pat-prac-map.zip",
    write_disk(tmp))
unzip(tmp)
unlink(tmp)

tmp <- tempfile(fileext = ".zip")
GET(url = "https://files.digital.nhs.uk/10/0EC6AE/gp-reg-pat-prac-all.zip",
    write_disk(tmp))
unzip(tmp)
unlink(tmp)


# Load Trafford's postcodes and associated area information
trafford_postcodes <- read_csv("https://www.trafforddatalab.io/spatial_data/postcodes/trafford_postcodes.csv") %>%
  select(postcode, ward_code, ward_name, msoa_code, msoa_hcl_name, locality)

# Get the list of GP practices within Trafford
trafford_gp <- read_csv("gp-reg-pat-prac-map.csv") %>%
  filter(PRACTICE_POSTCODE %in% trafford_postcodes$postcode) %>%
  select(practice_code = PRACTICE_CODE,
         practice_name = PRACTICE_NAME,
         postcode = PRACTICE_POSTCODE) %>%
  mutate(practice_name = str_to_title(practice_name))

# Get the current number of patient registrations
trafford_gp_patients <- read_csv("gp-reg-pat-prac-all.csv") %>%
  filter(POSTCODE %in% trafford_postcodes$postcode) %>%
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


# Tidy up the filesystem ---------
unlink(c("gp-reg-pat-prac-map.csv", "gp-reg-pat-prac-all.csv"))
