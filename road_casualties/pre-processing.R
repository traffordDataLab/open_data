## Road casualties 2010-2021 ##

# Source: Transport for Greater Manchester
# Publisher URL: https://data.gov.uk/dataset/25170a92-0736-4090-baea-bf6add82d118/gm-road-casualty-accidents-full-stats19-data
# Licence: OS "Free to Use Data" Licence

# load libraries ---------------------------
library(tidyverse) ; library(lubridate) ; library(sf)

# download data ---------------------------
accident <- read_csv("https://odata.tfgm.com/opendata/downloads/STATS19AccDataJan2010Dec2021forGMServers.csv")
casualty <- read_csv("https://odata.tfgm.com/opendata/downloads/STATS19CasDataJan2010Dec2021forGMServers.csv")

# merge and recode data  ---------------------------
casualties <- left_join(casualty, accident, by = "Accident Index") %>%
  # date and time
  mutate(date = dmy(OutputDate),
         year = year(date),
         month = month(date, label = TRUE),
         day = wday(date, label = TRUE),
         hour = hour(OutputTime),
         # mode of travel
         mode = case_when(
           CasTypeCode == 0 ~ "Pedestrian",
           CasTypeCode == 1 ~ "Pedal Cycle",
           CasTypeCode %in% c(2, 3, 4, 5, 23, 97) ~ "Powered 2 Wheeler",
           CasTypeCode == 9 ~ "Car",
           CasTypeCode == 8 ~ "Taxi or private hire",
           CasTypeCode == 11 ~ "Bus or Coach",
           CasTypeCode %in% c(19, 20, 21, 98) ~ "Goods Vehicle", 
           CasTypeCode == 18 ~ "Tram",
           TRUE ~ "Other Vehicle"),
         mode = factor(mode),
         # collision severity
         collision_severity = fct_recode(as.factor(Severity), 
                                         "Fatal" = "1", "Serious" = "2", "Slight" = "3"),
         # casualty severity
         casualty_severity = fct_recode(as.factor(CasualtySeverity), 
                               "Fatal" = "1", "Serious" = "2", "Slight" = "3"),
         # sex
         sex = fct_recode(as.factor(Sex), "Male" = "1", "Female" = "2"),
         # ageband 
         ageband = fct_recode(factor(AgeBandOfCasualty), 
                              "0-5" = "1", "6-10" = "2", "11-15" = "3",
                              "16-20" = "4", "21-25" = "5", "26-35" = "6",
                              "36-45" = "7", "46-55" = "8", "56-65" = "9",
                              "66-75" = "10", "Over 75" = "11"),
         # light conditions
         light_conditions = case_when(LightingCondition == 1 ~ "Daylight", TRUE ~ "Dark"),
         # local authority 
         area_name = fct_recode(factor(LocalAuthority), 
                                "Bolton" = "100", "Bury" = "101",
                                "Manchester" = "102", "Oldham" = "104",
                                "Rochdale" = "106", "Salford" = "107",
                                "Stockport" = "109", "Tameside" = "110",
                                "Trafford" = "112", "Wigan" = "114"))

# rename variables ---------------------------
casualties <- select(casualties, AREFNO = `Accident Index`, date, year, month, day, 
                     hour, mode, output_time = OutputTime, collision_severity, casualty_severity, sex, ageband, 
                     light_conditions, speed_limit = SpeedLimit, area_name, Easting, Northing)

# extract coordinates ---------------------------
casualties <- st_as_sf(casualties, coords = c("Easting", "Northing")) %>% 
  st_set_crs(27700) %>% 
  st_transform(4326) %>% 
  mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
         lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>%
  st_set_geometry(NULL)

# write data ---------------------------
write_csv(casualties, "STATS19_road_casualties_2010-2021.csv")
st_as_sf(casualties, coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_write("STATS19_road_casualties_2010-2021.geojson", driver = "GeoJSON")

