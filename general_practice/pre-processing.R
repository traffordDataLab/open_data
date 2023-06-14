# GP Practices in England and Wales #

# Source: NHS Digital
# Publisher URL: https://digital.nhs.uk/services/organisation-data-service/data-downloads/gp-and-gp-practice-related-data
# Licence: Open Government Licence

library(tidyverse) ; library(lubridate)

# download and unzip data
url <- "https://files.digital.nhs.uk/assets/ods/current/epraccur.zip"
download.file(url, dest = "epraccur.zip")
unzip("epraccur.zip", exdir = ".")
file.remove("epraccur.zip")

# read data
df <- read_csv("epraccur.csv", 
               # provide variable names
               col_names = c(
                 "Organisation Code", "Name", "National Grouping", 
                 "High Level Health Geography", "Address Line 1", 
                 "Address Line 2", "Address Line 3", "Address Line 4",
                 "Address Line 5", "Postcode", "Open Date", "Close Date", 
                 "Status Code",  "Organisation Sub-Type Code", "Commissioner", 
                 "Join Provider/Purchaser Date", "Left Provider/Purchaser Date", 
                 "Contact Telephone Number", "Null", "Null", "Null", 
                 "Amended Record Indicator", "Null", "Provider/Purchaser", 
                 "Null", "Prescribing Setting", "Null")) %>% 
  # recode values
  mutate(`Status Code` = 
           fct_recode(`Status Code`,
                      "Active" = "A", "Closed" = "C", "Dormant" = "D",
                      "Proposed" = "P"),
         `Organisation Sub-Type Code` = 
           fct_recode(`Organisation Sub-Type Code`,
                      "Allocated to a Provider/Purchaser Organisation" = "B", 
                      "Not allocated to a Provider/Purchaser Organisation" = "Z"),
         `Prescribing Setting` = 
           fct_recode(as.character(`Prescribing Setting`),
                      "Other" = "0", "WIC Practice" = "1", "OOH Practice" = "2",
                      "WIC + OOH Practice" = "3", "GP Practice" = "4",
                      "Public Health Service" = "8", "Community Health Service" = "9",
                      "Hospital Service" = "10", "Optometry Service" = "11",
                      "Urgent & Emergency Care" = "12", "Hospice" = "13",
                      "Care Home / Nursing Home" = "14", "Border Force" = "15",
                      "Young Offender Institution" = "16", "Secure Training Centre" = "17",
                      "Secure Children's Home" = "18", "Immigration Removal Centre" = "19",
                      "Court" = "20", "Police Custody" = "21", 
                      "Sexual Assault Referral Centre (SARC)" = "22",
                      "Other – Justice Estate" = "24", "Prison" = "25")) %>% 
  # convert to date format
  mutate(`Open Date` = as_date(as.character(`Open Date`)),
         `Close Date` = as_date(as.character(`Close Date`))) %>% 
  # convert to proper case
  mutate_at(c("Name", "Address Line 1", "Address Line 2", "Address Line 3", "Address Line 4"), str_to_title) %>% 
  # concatenate addresses to a single variable
  unite(Address, `Address Line 1`, `Address Line 2`, `Address Line 3`, 
        `Address Line 4`, `Address Line 5`, sep = ", ", na.rm = TRUE, remove = TRUE) %>% 
  # drop variables starting NULL
  select(-starts_with("NULL"))


# Tidy up filesystem
file.remove("epraccur.csv")
file.remove("epraccur.pdf")


# Get just GPs in Trafford ---------------------------------------------------------------

# NOTE Clinical Commissioning Groups (CCG) were abolished in favour of Integrated Care Boards (ICB) in 2022.
# ICB22NM: NHS Greater Manchester Integrated Care Board
# ICB22CD: E54000057
# ICB22CDH: QOP

library(httr) ; library(jsonlite) ; library(sf)

# Retrieve postcode centroids for Trafford - https://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-may-2023/about
pcode_file_reference <- "ONSPD_MAY_2023_UK" # makes it easier to change this once here than throughout the code below

tmp <- tempfile(fileext = ".zip")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/bd25c421196b4546a7830e95ecdd70bc/data",
    write_disk(tmp))

unzip(tmp, exdir = pcode_file_reference) # extract the contents of the zip

# delete the downloaded zip
unlink(tmp)

postcodes <- read_csv(paste0(pcode_file_reference, "/Data/", pcode_file_reference, ".csv")) %>%
    filter(oslaua == "E08000009") %>%
    select(Postcode = pcds,
           lon = long,
           lat = lat) 

# remove the postcodes folder (contents of the zip)
unlink(pcode_file_reference, recursive = TRUE)

# Get just GPs in Trafford by matching to Trafford postcodes and filtering to select only active GP Practices
gp <- inner_join(df, postcodes, by = "Postcode") %>%
    filter(`Prescribing Setting` == "GP Practice",
           `Status Code` == "Active") %>% 
    select(Name, Address, Postcode, 
           telephone = `Contact Telephone Number`, lon, lat) %>% 
    rename_all(tolower)

# write results as CSV and GeoJSON
write_csv(gp, "trafford_general_practices.csv")

st_as_sf(gp, coords = c("lon", "lat")) %>%
  st_set_crs(4326) %>%
  st_write("trafford_general_practices.geojson")
