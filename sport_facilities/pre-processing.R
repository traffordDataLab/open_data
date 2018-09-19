## Sports facilities ##

# Source: Active Places Power
# Publisher URL: https://www.activeplacespower.com/OpenData/download
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# download and unzip data ---------------------------
url <- "https://cdn.activeplacespower.com/cdn/opendata.csv.zip"
download.file(url, dest = "Active Places Open Data_2018_09_17.zip")
unzip("Active Places Open Data_2018_09_17.zip")
file.remove("Active Places Open Data_2018_09_17.zip")

# read all CSV files as a list ---------------------------
filenames <- list.files(pattern = "*.csv")
list_df <- lapply(setNames(filenames, make.names(gsub("*.csv$", "", filenames))), read_csv) 

# extract 'Sites' dataframe ---------------------------
sites <- list_df[["Sites"]] %>% 
  # filter closed sites
  filter(ClosureCode == 0) %>%
  #  convert to Proper case
  mutate(SiteName = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(SiteName), perl=TRUE),
         ThoroughfareName = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(ThoroughfareName), perl=TRUE),
         PostTown = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(PostTown), perl=TRUE)) %>% 
  # choose relevant variables
  select(SiteID, SiteName,
         ThoroughfareName, PostTown, PostCode, # Address
         CarParkExist, NumCarPark, CyclePark, NurseryFlag, FirstAid, # Amenities
         DisabilityExist, DisabilityNotes, # Disabled access
         RecLastChkdDate) %>% 
  # convert columns to factors for recoding
  mutate_at(c("CarParkExist", "CyclePark", "NurseryFlag", "FirstAid", "DisabilityExist"), factor) %>%
  mutate(CarParkExist = fct_recode(CarParkExist, "No" = "0", "Yes" = "1", "Don't know" = "2"),
         CyclePark = fct_recode(CyclePark, "No" = "0", "Yes" = "1", "Don't know" = "2"),
         NurseryFlag = fct_recode(NurseryFlag, "No" = "0", "Yes" = "1", "Don't know" = "2"),
         FirstAid = fct_recode(FirstAid, "No" = "0", "Yes" = "1", "Don't know" = "2"),
         DisabilityExist = fct_recode(DisabilityExist, "No" = "0", "Yes" = "1", "Don't know" = "2"))

# extract 'Geographic' dataframe ---------------------------
geographic <- list_df[["Geographic"]] %>%
  select(SiteID,
         `Local Authority Name`,
         Latitude,
         Longitude) %>% 
  # drop duplicate rows
  unique()

# join 'Geographic' dataframe to sites ---------------------------
sites <- left_join(sites, geographic, by = "SiteID")

# filter sites within Trafford ---------------------------
sites <- filter(sites, `Local Authority Name` == "Trafford") %>% 
  select(-`Local Authority Name`)

# extract 'Contacts' dataframe ---------------------------
contacts <- list_df[["Contacts"]] %>%
  select(SiteID,
         TelNumber,
         Email,
         Website)

# join 'Contacts' dataframe to sites ---------------------------
sites <- left_join(sites, contacts, by = "SiteID") %>% 
  select(SiteID, SiteName, 
         ThoroughfareName, PostTown, PostCode, Latitude, Longitude,
         TelNumber, Email, Website,
         everything())

# subset list to include Facility Types only ---------------------------
list_facilities <- list_df[c("ArtificialGrassPitch", "AthleticsTracks", "Cycling", "Golf", "GrassPitches",
                         "HealthandFitnessSuite", "IceRinks", "IndoorBowls", "IndoorTennisCentre", "SkiSlopes",
                         "SportsHall", "SquashCourts", "Studio", "SwimmingPool", "TennisCourts")]

# overwrite 'Geographic' dataframe and add FacilityID ---------------------------
geographic <- list_df[["Geographic"]] %>%
  select(SiteID,
         FacilityID = FACILITYID,
         `Local Authority Name`) %>% 
  unique() # drop duplicates

# join 'Geographic' dataframe to Facility Types list ---------------------------
list_facilities <- lapply(list_facilities, left_join, geographic, by = "FacilityID")

# filter list to Facility Types within Trafford ---------------------------
list_facilities <- lapply(list_facilities, function(x) filter(x, `Local Authority Name` == "Trafford"))

# check for Site duplicates for each Facility Type before proceeding !! ---------------------------
list_facilities[["TennisCourts"]] %>% 
  filter(SiteID %in% unique(.[["SiteID"]][duplicated(.[["SiteID"]])])) %>% 
  View()

# ArtificialGrassPitch ---------------------------
artificial_grass_pitch <- list_facilities[["ArtificialGrassPitch"]] %>% 
  group_by(SiteID) %>% 
  summarise(Pitches = sum(Pitches),
            Floodlit = sum(Floodlit)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Pitches, Floodlit, everything()) 
write_csv(artificial_grass_pitch, "data/artificial_grass_pitch.csv")

# AthleticsTracks ---------------------------
athletics_tracks <- list_facilities[["AthleticsTracks"]] %>% 
  left_join(., sites, by = "SiteID") %>% 
  filter(!is.na(SiteName)) %>% 
  select(-FacilityID, -`Local Authority Name`) %>% 
  select(Lanes, Floodlit, everything()) 
write_csv(athletics_tracks, "data/athletics_tracks.csv")

# Cycling ---------------------------
list_facilities[["Cycling"]] # no facilities in Trafford

# Golf ---------------------------
golf <- list_facilities[["Golf"]] %>% 
  left_join(., sites, by = "SiteID") %>% 
  filter(!is.na(SiteName)) %>% 
  select(-FacilityID, -Length, -`Local Authority Name`) %>% 
  select(Holes, Bays, Floodlit, everything())
write_csv(golf, "data/golf.csv")

# GrassPitches ---------------------------
grass_pitches <- list_facilities[["GrassPitches"]] %>% 
  group_by(SiteID) %>% 
  summarise(Pitches = sum(Pitches),
            Floodlit = sum(Floodlit)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Pitches, Floodlit, everything())
write_csv(grass_pitches, "data/grass_pitches.csv")

# HealthandFitnessSuite ---------------------------
health_and_fitness_suite <- list_facilities[["HealthandFitnessSuite"]] %>% 
  group_by(SiteID) %>% 
  summarise(Stations = sum(Stations)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Stations, everything()) 
write_csv(health_and_fitness_suite, "data/health_and_fitness_suite.csv")

# IceRinks ---------------------------
ice_rinks <- list_facilities[["IceRinks"]] %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(-FacilityID, -Area, -Length, -Width, -`Local Authority Name`) %>% 
  select(Rinks, everything()) 
write_csv(ice_rinks, "data/ice_rinks.csv")

# IndoorBowls ---------------------------
list_facilities[["IndoorBowls"]] # no facilities in Trafford

# IndoorTennisCentre ---------------------------
indoor_tennis_centre <- list_facilities[["IndoorTennisCentre"]] %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(-FacilityID, -`Surface Type`, -`Local Authority Name`) %>% 
  select(Courts, everything())
write_csv(indoor_tennis_centre, "data/indoor_tennis_centre.csv")

# SkiSlopes ---------------------------
ski_slopes <- list_facilities[["SkiSlopes"]] %>% 
  group_by(SiteID) %>% 
  summarise(Floodlit = sum(Floodlit),
            Tow = sum(Tow)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Tow, Floodlit, everything())
write_csv(ski_slopes, "data/ski_slopes.csv")

# SportsHall ---------------------------
sports_hall <- list_facilities[["SportsHall"]] %>%
  group_by(SiteID) %>% 
  summarise(`Badminton Courts` = sum(`Badminton Courts`),
            `Basketball Courts` = sum(`Basketball Courts`),
            `Cricket Nets` = sum(`Cricket Nets`),
            `Netball Courts` = sum(`Netball Courts`),
            `Volleyball Courts` = sum(`Volleyball Courts`)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(`Badminton Courts`, `Basketball Courts`, `Cricket Nets`, `Netball Courts`, `Volleyball Courts`,
         everything())
write_csv(sports_hall, "data/sports_hall.csv")
  
# SquashCourts ---------------------------
squash_courts <- list_facilities[["SquashCourts"]] %>% 
  group_by(SiteID) %>% 
  summarise(Courts = sum(Courts),
            Doubles = sum(Doubles),
            `Movable Wall` = sum(`Movable Wall`)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(Courts, Doubles, `Movable Wall`, everything())
write_csv(squash_courts, "data/squash_courts.csv")

# Studio ---------------------------
studio <- list_facilities[["Studio"]] %>% 
  group_by(SiteID) %>% 
  summarise(Studios = sum(Studios)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(Studios, everything())
write_csv(studio, "data/studio.csv")

# SwimmingPool ---------------------------
swimming_pools <- list_facilities[["SwimmingPool"]] %>%
  group_by(SiteID) %>% 
  summarise(Pools = n()) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(Pools, everything())
write_csv(swimming_pools, "data/swimming_pools.csv")

# TennisCourts ---------------------------
tennis_courts <- list_facilities[["TennisCourts"]] %>% 
  group_by(SiteID) %>% 
  summarise(Courts = sum(Courts),
            Floodlit = sum(Floodlit)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(Courts, Floodlit, everything()) 
write_csv(tennis_courts, "data/tennis_courts.csv")

# style and export aqs GeoJSON ---------------------------
tennis_courts %>% 
  rename(`Site ID` = SiteID, `Site name` = SiteName, Street = ThoroughfareName, Town = PostTown,
         Postcode = PostCode, `Telephone number` = TelNumber, `Car park` = CarParkExist,
         `Car park capacity` = NumCarPark, `Cycle park` = CyclePark, Nursery = NurseryFlag,
         `First aid room` = FirstAid, `Disabled access` = DisabilityExist, `Disability notes` = DisabilityNotes,
         `Last updated` = RecLastChkdDate) %>% 
  mutate(`marker-color` = "#fc6721", `marker-size` = "medium") %>% 
  st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>% 
  st_write(., "data/tennis_courts.geojson")