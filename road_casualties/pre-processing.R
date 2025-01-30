## Road casualties 2022-Jun2024 ##

# Source: Department for Transport
# Publisher URL: https://www.data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-accidents-safety-data
# Licence:  Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(lubridate) ; library(sf)

# download data ---------------------------

accident <- read_csv("https://data.dft.gov.uk/road-accidents-safety-data/dft-road-casualty-statistics-collision-provisional-mid-year-unvalidated-2024.csv")

casualty <- read_csv("https://data.dft.gov.uk/road-accidents-safety-data/dft-road-casualty-statistics-casualty-provisional-mid-year-unvalidated-2024.csv")

accident5y <- read_csv("https://data.dft.gov.uk/road-accidents-safety-data/dft-road-casualty-statistics-collision-last-5-years.csv") %>%
  rename(collision_index = accident_index, legacy_collision_severity = accident_severity) %>%
  mutate(location_easting_osgr = as.numeric(location_easting_osgr), location_northing_osgr = as.numeric(location_northing_osgr))

casualty5y <- read_csv("https://data.dft.gov.uk/road-accidents-safety-data/dft-road-casualty-statistics-casualty-last-5-years.csv") %>%
  rename(collision_index = accident_index)


# merge and recode data  --------------------------


  
  casualties <- left_join(casualty, accident %>%
                              filter(local_authority_ons_district %in% c("E08000001", "E08000002", "E08000003", "E08000004", "E08000005", "E08000006", "E08000007", "E08000008","E08000009", "E08000010")), by = "collision_index") %>%
  bind_rows(left_join(casualty5y, accident5y %>%
                        filter(local_authority_ons_district %in% c("E08000001", "E08000002", "E08000003", "E08000004", "E08000005", "E08000006", "E08000007", "E08000008","E08000009", "E08000010")), by = "collision_index")) %>%
    filter(!is.na(local_authority_ons_district)) %>%
  # date and time
  mutate(date = dmy(date),
         year = year(date),
         month = month(date, label = TRUE),
         day = wday(date, label = TRUE),
         hour = hour(time),
         # mode of travel
         mode = case_when(
           casualty_type == 0 ~ "Pedestrian",
           casualty_type == 1 ~ "Pedal Cycle",
           casualty_type %in% c(2, 3, 4, 5, 23, 97) ~ "Powered 2 Wheeler",
           casualty_type == 9 ~ "Car",
           casualty_type == 8 ~ "Taxi or private hire",
           casualty_type == 11 ~ "Bus or Coach",
           casualty_type %in% c(19, 20, 21, 98) ~ "Goods Vehicle", 
           casualty_type == 18 ~ "Tram",
           TRUE ~ "Other Vehicle"),
         mode = factor(mode),
         # collision severity
         collision_severity = fct_recode(as.factor(legacy_collision_severity), 
                                         "Fatal" = "1", "Serious" = "2", "Slight" = "3"),
         # casualty severity
         casualty_severity = fct_recode(as.factor(casualty_severity), 
                                        "Fatal" = "1", "Serious" = "2", "Slight" = "3"),
         # sex
         sex = fct_recode(as.factor(sex_of_casualty), "Male" = "1", "Female" = "2"),
         # ageband 
         ageband = fct_recode(factor(age_band_of_casualty), 
                              "0-5" = "1", "6-10" = "2", "11-15" = "3",
                              "16-20" = "4", "21-25" = "5", "26-35" = "6",
                              "36-45" = "7", "46-55" = "8", "56-65" = "9",
                              "66-75" = "10", "Over 75" = "11"),
         # light conditions
         light_conditions = case_when(light_conditions == 1 ~ "Daylight", TRUE ~ "Dark"),
         # local authority 
         area_name = fct_recode(factor(local_authority_ons_district), 
                                "Bolton" = "E08000001", "Bury" = "E08000002",
                                "Manchester" = "E08000003", "Oldham" = "E08000004",
                                "Rochdale" = "E08000005", "Salford" = "E08000006",
                                "Stockport" = "E08000007", "Tameside" = "E08000008",
                                "Trafford" = "E08000009", "Wigan" = "E08000010"))
  
  
  # rename variables ---------------------------
casualties <- select(casualties, AREFNO = collision_index, date, year, month, day, 
                     hour, mode, output_time = time, collision_severity, casualty_severity, number_vehicles = number_of_vehicles, number_casualties = number_of_casualties, sex, ageband, 
                     light_conditions, speed_limit, area_name, Easting = location_easting_osgr, Northing = location_northing_osgr)
  # extract coordinates ---------------------------
  casualties <- casualties %>%
    filter(!is.na(Easting)) %>%
    st_as_sf( coords = c("Easting", "Northing")) %>% 
    st_set_crs(27700) %>% 
    st_transform(4326) %>% 
    mutate(lon = map_dbl(geometry, ~st_coordinates(.x)[[1]]),
           lat = map_dbl(geometry, ~st_coordinates(.x)[[2]])) %>%
    st_set_geometry(NULL)
  

# write data ---------------------------
write_csv(casualties, "STATS19_road_casualties_2019-Jun2024.csv")
st_as_sf(casualties, coords = c("lon", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_write("STATS19_road_casualties_2019-Jun2024.geojson", driver = "GeoJSON")

