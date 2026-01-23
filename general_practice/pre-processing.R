# GP Practices in Trafford - from the complete dataset for England and Wales.

# Source: NHS Digital
# Publisher URL: https://digital.nhs.uk/services/organisation-data-service/data-search-and-export/csv-downloads/gp-and-gp-practice-related-data
# Dateset   URL: https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=epraccur
# Metadata  URL: https://www.odsdatasearchandexport.nhs.uk/referenceDataCatalogue/565791179.html#GPPractices(PrescribingCostCentres)-epraccur.csv
# Licence: Open Government Licence

# **Useful information from FAQ section of the API Help and Guidance document available on https://www.odsdatasearchandexport.nhs.uk/:**
#
# How do I find a list of English GP Practices?
#    
# English GP Practices codes are created primarily for prescribing, they therefore have a primary role of RO177 Prescribing Cost Centre.
# The non primary role of RO76 GP Practice allows GP Practice records to be distinguished from other prescribing cost centres/settings (such as Walk in Centres).
# Refer to the Prescribing Cost Centre section within the Reference Data Catalogue for further information. (James Austin NOTE: this is the metadata URL above.)

# The information is refreshed at 2am each night.


library(tidyverse) ; library(httr) ; library(jsonlite) ; library(sf) ; library(lubridate)

# Read in data via the API and replace codes with meanings via the metadata information
df <- read_csv("https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=epraccur", 
               # Provide variable names as the file only contains data starting on the first row.
               # These names come from the "Report Alias (legacy csv) column on the metadata page (see URL above)
               # Only changes are the fields containing LegalStartDate/LegalEndDate. There are duplicates of these
               # specified on the page, so I've had to differentiate using the legacy names.
               col_names = c(
                 "OrganisationCode", "OrgName", "NHSER_code", "ICB_code",
                 "Address1", "Address2", "Address3", "Town", "County", "Postcode",
                 "Open Date", "Close Date", "StatusName", "Primary Role / OrgTypeID", "TargetOrgCode", 
                 "Join Provider/Purchaser Date", "Left Provider/Purchaser Date", 
                 "TelephoneNumber", "NULL", "NULL", "NULL", 
                 "Amended Record Indicator", "NULL", "TargetOrgCode", 
                 "NULL", "RoleID", "NULL")) %>% 
  # recode values
  mutate(`Primary Role / OrgTypeID` = 
           fct_recode(`Primary Role / OrgTypeID`,
                      "Allocated to a Provider/Purchaser Organisation" = "B", 
                      "Not allocated to a Provider/Purchaser Organisation" = "Z"),
         RoleID = 
           fct_recode(as.character(RoleID),
                      "Other" = "RO72", "WIC Practice" = "RO87", "OOH Practice" = "RO80",
                      "WIC + OOH Practice" = "RO80|RO87", "GP Practice" = "RO76",
                      "Public Health Service" = "RO255", "Community Health Service" = "RO247",
                      "Hospital Service" = "RO250", "Optometry Service" = "RO252",
                      "Urgent & Emergency Care" = "RO259", "Hospice" = "RO249",
                      "Care Home / Nursing Home" = "RO246", "Border Force" = "RO245",
                      "Young Offender Institution" = "RO260", "Secure Training Centre" = "RO257",
                      "Secure Children's Home" = "RO256", "Immigration Removal Centre" = "RO251",
                      "Court" = "RO248", "Police Custody" = "RO254", 
                      "Sexual Assault Referral Centre (SARC)" = "RO258",
                      "Other – Justice Estate" = "RO253", "Prison" = "RO82",
                      "Primary Care Network" = "RO321", "Independent Pharmacy Prescriber Pathfinder" = "RO323")) %>% 
  # convert to date format
  mutate(`Open Date` = as_date(as.character(`Open Date`)),
         `Close Date` = as_date(as.character(`Close Date`)),
         `Join Provider/Purchaser Date` = as_date(as.character(`Join Provider/Purchaser Date`)),
         `Left Provider/Purchaser Date` = as_date(as.character(`Left Provider/Purchaser Date`))) %>% 
  # convert to proper case
  mutate_at(c("OrgName", "Address1", "Address2", "Address3", "Town"), str_to_title) %>% 
  # concatenate addresses to a single variable
  unite(Address, Address1, Address2, Address3, Town, sep = ", ", na.rm = TRUE, remove = TRUE) %>%
  # drop variables starting NULL
  select(-starts_with("NULL"))


# Get just GPs in Trafford ---------------------------------------------------------------

# NOTE Clinical Commissioning Groups (CCG) were abolished in favour of Integrated Care Boards (ICB) in 2022.
# ICB22NM: NHS Greater Manchester Integrated Care Board
# ICB22CD: E54000057
# ICB22CDH: QOP

# Retrieve postcode centroids for Trafford - https://geoportal.statistics.gov.uk/datasets/ons::ons-postcode-directory-november-2025-for-the-uk/about
pcode_file_reference <- "ONSPD_NOV_2025_UK" # makes it easier to change this once here than throughout the code below

tmp <- tempfile(fileext = ".zip")
GET(url = "https://www.arcgis.com/sharing/rest/content/items/3635ca7f69df4733af27caf86473ffa1/data",
    write_disk(tmp))

unzip(tmp, exdir = pcode_file_reference) # extract the contents of the zip

# delete the downloaded zip
unlink(tmp)

postcodes <- read_csv(paste0(pcode_file_reference, "/Data/", pcode_file_reference, ".csv")) %>%
    filter(lad25cd == "E08000009") %>%
    select(Postcode = pcds,
           lon = long,
           lat = lat) 

# remove the postcodes folder (contents of the zip)
unlink(pcode_file_reference, recursive = TRUE)

# Get just GPs in Trafford by matching to Trafford postcodes and filtering to select only active GP Practices
gp <- inner_join(df, postcodes, by = "Postcode") %>%
    filter(RoleID == "GP Practice",
           StatusName == "ACTIVE") %>% 
    select(name = OrgName, Address, Postcode, 
           telephone = TelephoneNumber, lon, lat) %>% 
    rename_all(tolower)

# write results as CSV and GeoJSON
write_csv(gp, "trafford_general_practices.csv")

st_as_sf(gp, coords = c("lon", "lat")) %>%
  st_set_crs(4326) %>%
  st_write("trafford_general_practices.geojson")
