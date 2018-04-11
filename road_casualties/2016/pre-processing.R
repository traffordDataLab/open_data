## STATS19 road casualty data - 2016 ##

# Source: Greater Manchester Police
# Publisher URL: https://data.gov.uk/dataset/road-accidents-safety-data
# Licence: Open Government Licence 3.0

# load libraries ---------------------------
library(tidyverse) ; library(lubridate) ; library(sf)

# load data ---------------------------
url <- "http://data.dft.gov.uk/road-accidents-safety-data/dftRoadSafetyData_Casualties_2016.zip"
download.file(url, dest = "dftRoadSafetyData_Casualties_2016.zip")
unzip("dftRoadSafetyData_Casualties_2016.zip")
file.remove("dftRoadSafetyData_Casualties_2016.zip")
casualty <- read.csv("Cas.csv")

url <- "http://data.dft.gov.uk/road-accidents-safety-data/dftRoadSafety_Accidents_2016.zip"
download.file(url, dest = "dftRoadSafety_Accidents_2016.zip")
unzip("dftRoadSafety_Accidents_2016.zip")
file.remove("dftRoadSafety_Accidents_2016.zip")
accident <- read.csv("dftRoadSafety_Accidents_2016.csv") %>% 
  filter(Police_Force == 6)

## merge data ---------------------------
casualties <- merge(casualty, accident, by = "Accident_Index")

## recode data ---------------------------
# date and time
casualties <- mutate(casualties, 
                     date = dmy(Date),
                     month = month(date, label = TRUE),
                     day = wday(date, label = TRUE),
                     hour = as.POSIXlt(Time, format = "%H:%M")$hour)

# mode of travel
casualties <- mutate(casualties, mode = 
                       case_when(
                         Casualty_Type == 0 ~ "Pedestrian",
                         Casualty_Type == 1 ~ "Pedal Cycle",
                         Casualty_Type %in% c(2,3,4,5,23,97) ~ "Powered 2 Wheeler",
                         Casualty_Type == 8 ~ "Taxi",
                         Casualty_Type == 9 ~ "Car",
                         Casualty_Type == 11 ~ "Bus or Coach",
                         Casualty_Type %in% c(19,20,21,98) ~ "Goods Vehicle",
                         Casualty_Type %in% c(10,16,17,18,90) ~ "Other Vehicle"
                       ))

# casualty severity
casualties <- mutate(casualties, severity = 
                       case_when(
                         Casualty_Severity == 1 ~ "Fatal", 
                         Casualty_Severity == 2 ~ "Serious", 
                         Casualty_Severity == 3 ~ "Slight"))

# sex
casualties <- mutate(casualties, sex = 
                       case_when(
                         Sex_of_Casualty == 1 ~ "Male", 
                         Sex_of_Casualty == 2 ~ "Female", 
                         Sex_of_Casualty == -1 ~ "Not known"))

# ageband                     
casualties <- mutate(casualties, ageband = 
                       cut(Age_of_Casualty,
                           breaks = c(0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,120),
                           labels = c("0-4","5-9","10-14","15-19","20-24","25-29","30-34","35-39",
                                      "40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79",
                                      "80-84","85-89","90+"),
                           right = FALSE))

# light conditions
casualties <- mutate(casualties, light = 
                       case_when(
                         Light_Conditions == 1 ~ "Daylight", 
                         Light_Conditions %in% c(4,5,6,7) ~ "Dark"))

# local authority 
casualties <- mutate(casualties, 
                     area_name = factor(Local_Authority_.District.),
                     area_name = fct_recode(area_name, 
                                            "Bolton" = "100",
                                            "Bury" = "101",
                                            "Manchester" = "102",
                                            "Oldham" = "104",
                                            "Rochdale" = "106",
                                            "Salford" = "107",
                                            "Stockport" = "109",
                                            "Tameside" = "110",
                                            "Trafford" = "112",
                                            "Wigan" = "114"))

## rename variables  ---------------------------
casualties <- select(casualties, AREFNO = `Accident_Index`, date, month, day, hour, mode, 
                     severity, light, sex, ageband, area_name, long = Longitude, lat = Latitude)

## ----- write data
write_csv(casualties, "STATS19_casualty_data_2016.csv")
casualties %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("STATS19_casualty_data_2016.geojson", driver = "GeoJSON")