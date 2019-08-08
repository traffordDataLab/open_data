# GP Practices in England and Wales #

# Source: NHS Digital
# Publisher URL: https://digital.nhs.uk/services/organisation-data-service/data-downloads/gp-and-gp-practice-related-data
# Licence: Open Government Licence

library(tidyverse) ; library(httr) ; library(jsonlite) ; library(lubridate) ; library(stringr) ; library(sf)

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

# optional steps ---------------------------------------------------------------

# retrieve postcode centroids for your CCG
ccg = "E38000187"
url <- paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Postcodes/ONS_Postcode_Directory_Latest_Centroids/MapServer/0/query?where=UPPER(ccg)%20like%20'%25", URLencode(toupper(ccg), reserved = TRUE), "%25'&outFields=pcds,ccg,lat,long&outSR=4326&f=json")
postcodes <- fromJSON(content(GET(url), "text", encoding="UTF-8"))$features$attributes %>% 
  rename(Postcode = pcds)

# filter GP Practices by matching postcodes
geo <- left_join(df, postcodes, by = "Postcode") %>% 
  filter(!is.na(ccg))

# remove inactive GP practices and rename variables
results <- geo %>% 
  filter(`Status Code` == "Active") %>% 
  select(Name, Address, Postcode, 
         telephone = `Contact Telephone Number`, lon = long, lat) %>% 
  rename_all(tolower)

# write results as CSV and GeoJSON
write_csv(results, "trafford_general_practices.csv")

st_as_sf(results, coords = c("lon", "lat")) %>%
  st_set_crs(4326) %>%
  st_write("trafford_general_practices.geojson")

