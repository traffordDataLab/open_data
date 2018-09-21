## Road casualties 2005-2017 ##

# Source: TfGM
# Publisher URL: https://data.gov.uk/dataset/25170a92-0736-4090-baea-bf6add82d118/gm-road-casualty-accidents-full-stats19-data
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(lubridate) ; library(sf)

# download data ---------------------------
accident <- read_csv("http://odata.tfgm.com/opendata/downloads/STATS19AccData20052017.csv") 
casualty <- read_csv("http://odata.tfgm.com/opendata/downloads/STATS19CasData20052017.csv")

# merge data ---------------------------
casualties <- merge(casualty, accident, by = "Accident Index")
rm(accident, casualty)

## recode data ---------------------------
# date and time
casualties <- mutate(casualties, 
                     date = dmy(OutputDate),
                     year = year(date),
                     month = month(date, label = TRUE),
                     day = wday(date, label = TRUE),
                     hour = hour(OutputTime))

# mode of travel
casualties <- mutate(casualties, mode = 
                       case_when(
                         CasTypeCode == 0 ~ "Pedestrian",
                         CasTypeCode == 1 ~ "Pedal Cycle",
                         CasTypeCode %in% c(2,3,4,5,96,97) ~ "Powered 2 Wheeler",
                         CasTypeCode == 8 ~ "Taxi",
                         CasTypeCode == 9 ~ "Car",
                         CasTypeCode == 11 ~ "Bus or Coach",
                         CasTypeCode %in% c(19,20,21,98) ~ "Goods Vehicle",
                         CasTypeCode %in% c(10,14,15,16,17,18,99) ~ "Other Vehicle"
                       ))

# casualty severity
casualties <- mutate(casualties, severity = 
                       case_when(
                         CasualtySeverity == 1 ~ "Fatal", 
                         CasualtySeverity == 2 ~ "Serious", 
                         CasualtySeverity == 3 ~ "Slight"))

# sex
casualties <- mutate(casualties, sex = 
                       case_when(
                         Sex == 1 ~ "Male", 
                         Sex == 2 ~ "Female", 
                         Sex == -1 ~ "Not known"))

# ageband                     
casualties <- mutate(casualties, ageband = 
                       cut(AgeBandOfCasualty,
                           breaks = c(0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,120),
                           labels = c("0-4","5-9","10-14","15-19","20-24","25-29","30-34","35-39",
                                      "40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79",
                                      "80-84","85-89","90+"),
                           right = FALSE))

# local authority 
casualties <- mutate(casualties, 
                     area_name = factor(LocalAuthority),
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


# rename variables ---------------------------
casualties <- select(casualties, AREFNO = `Accident Index`, date, year, month, day, hour, mode, 
                     severity, sex, ageband, area_name, easting = Easting, northing = Northing)

# write data ---------------------------
write_csv(filter(casualties, year == 2017), "STATS19_casualty_data_2017.csv")

st_as_sf(filter(casualties, year == 2017), coords = c("easting", "northing")) %>% 
  st_set_crs(27700) %>% 
  st_transform(4326) %>% 
  mutate(lng = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>% 
  st_write("STATS19_casualty_data_2017.geojson", driver = "GeoJSON")
