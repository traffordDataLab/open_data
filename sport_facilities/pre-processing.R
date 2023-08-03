## Sports facilities ##

# Source: Active Places Power
# Publisher URL: https://www.activeplacespower.com/OpenData/download
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf)

# download the data manually from https://www.activeplacespower.com/OpenData/download and then unzip using code below ---------------------------
zip_name <- "Active Places Open Data_2023_07_30.zip"
unzip(zip_name)
file.remove(zip_name)

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

# identify sites with missing coordinates
sites_na <- filter(sites, Longitude == 0) %>% 
  select(-Latitude, -Longitude)

# geocode using ONS Postcode Directory
postcodes <- read_csv("https://www.traffordDataLab.io/spatial_data/postcodes/trafford_postcodes.csv") %>%
  select(PostCode = postcode, Latitude = lat, Longitude = lon)

# If sites_na contains observations, fill in the missing lon lat values
#sites_na <- left_join(sites_na, postcodes, by = "PostCode") %>% 
  # add non-matching coordinates for Longford Park (SiteID: 1043161)
#  mutate(Latitude = case_when(SiteID == 1043161 ~ 53.446901, TRUE ~ .$Latitude),
#         Longitude = case_when(SiteID == 1043161 ~ -2.292593, TRUE ~ .$Longitude))

# drop then merge geocoded sites
sites <- filter(sites, Longitude != 0) %>% 
  bind_rows(sites_na)

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
list_facilities <- list_df[c("ArtificialGrassPitch", "Athletics", "Cycling", "Golf", "GrassPitches",
                         "HealthandFitnessGym", "IceRinks", "IndoorBowls", "IndoorTennisCentre", "OutdoorTennisCourts",
                         "SkiSlopes", "SportsHall", "SquashCourts", "Studio", "SwimmingPool")]

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


# Tidy up the filesystem, deleting the downloaded files from the ZIP as we don't need them anymore
file.remove("ArtificialGrassPitch.csv", "Athletics.csv", "Cycling.csv", "Golf.csv", "GrassPitches.csv", "HealthandFitnessGym.csv", "IceRinks.csv", "IndoorBowls.csv",
            "IndoorTennisCentre.csv", "OutdoorTennisCourts.csv", "SkiSlopes.csv", "SportsHall.csv", "SquashCourts.csv", "Studio.csv", "SwimmingPool.csv")

file.remove("Contacts.csv", "Facilities.csv", "FacilityCriteriaExceptions.csv", "FacilityManagement.csv", "FacilitySubType.csv", "FacilityTimings.csv",
            "FacilityType.csv", "Geographic.csv", "SiteActivities.csv", "SiteEquipment.csv", "SiteNameAlias.csv", "SiteQualities.csv", "Sites.csv")


# check for Site duplicates for each Facility Type before proceeding !! ---------------------------
# NOTE: This shouldn't really be the case - so long as the facility IDs are unique then the records should be considered valid.  This may have been required for an earlier version of the Sports Data Model (SDM) dataset.
list_facilities[["HealthandFitnessGym"]] %>% 
    #View()
    filter(SiteID %in% unique(.[["SiteID"]][duplicated(.[["SiteID"]])])) %>% 
    View()


# Function to create the spatial data (geojson) files from the individual data frames created below
createGeoJson <- function(df, filename) {
    df %>%
    rename(`Site ID` = SiteID, `Site name` = SiteName, Street = ThoroughfareName, Town = PostTown,
           Postcode = PostCode, `Telephone number` = TelNumber, `Car park` = CarParkExist,
           `Car park capacity` = NumCarPark, `Cycle park` = CyclePark, Nursery = NurseryFlag,
           `First aid room` = FirstAid, `Disabled access` = DisabilityExist, `Disability notes` = DisabilityNotes,
           `Last updated` = RecLastChkdDate) %>% 
        st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>% 
        st_write(., paste0(filename, ".geojson"))
}


# ArtificialGrassPitch ---------------------------
artificial_grass_pitch <- list_facilities[["ArtificialGrassPitch"]] %>% 
  group_by(SiteID) %>% 
  summarise(Pitches = sum(Pitches),
            Floodlit = sum(Floodlit)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Pitches, Floodlit, everything())

write_csv(artificial_grass_pitch, "artificial_grass_pitch.csv")
createGeoJson(artificial_grass_pitch, "artificial_grass_pitch")


# Athletics ---------------------------
athletics <- list_facilities[["Athletics"]] %>%
  left_join(., sites, by = "SiteID") %>% 
  filter(!is.na(SiteName)) %>% 
  select(-FacilityID, -`Local Authority Name`) %>% 
  select(Floodlit, SiteID, SiteName, ThoroughfareName, PostTown, PostCode, TelNumber, Email, Website, everything())

write_csv(athletics, "athletics.csv")
createGeoJson(athletics, "athletics")


# Cycling ---------------------------
list_facilities[["Cycling"]] # no facilities in Trafford


# Golf ---------------------------
golf <- list_facilities[["Golf"]] %>% 
  left_join(., sites, by = "SiteID") %>% 
  filter(!is.na(SiteName)) %>% 
  select(-FacilityID, -Length, -`Local Authority Name`) %>% 
  select(Holes, Bays, Floodlit, everything())

write_csv(golf, "golf.csv")
createGeoJson(golf, "golf")


# GrassPitches ---------------------------
grass_pitches <- list_facilities[["GrassPitches"]] %>% 
  group_by(SiteID) %>% 
  summarise(Pitches = sum(Pitches),
            Floodlit = sum(Floodlit)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Pitches, Floodlit, everything())

write_csv(grass_pitches, "grass_pitches.csv")
createGeoJson(grass_pitches, "grass_pitches")


# HealthandFitnessGym ---------------------------
health_and_fitness_gym <- list_facilities[["HealthandFitnessGym"]] %>% 
  group_by(SiteID) %>% 
  summarise(Stations = sum(Stations)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Stations, everything())

write_csv(health_and_fitness_gym, "health_and_fitness_gym.csv")
createGeoJson(health_and_fitness_gym, "health_and_fitness_gym")


# IceRinks ---------------------------
ice_rinks <- list_facilities[["IceRinks"]] %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(-FacilityID, -Area, -Length, -Width, -`Local Authority Name`, -`Dimensions Estimate`)

write_csv(ice_rinks, "ice_rinks.csv")
createGeoJson(ice_rinks, "ice_rinks")


# IndoorBowls ---------------------------
list_facilities[["IndoorBowls"]] # no facilities in Trafford


# IndoorTennisCentre ---------------------------
indoor_tennis_centre <- list_facilities[["IndoorTennisCentre"]] %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(-FacilityID, -`Surface Type`, -`Local Authority Name`) %>% 
  select(Courts, everything())

write_csv(indoor_tennis_centre, "indoor_tennis_centre.csv")
createGeoJson(indoor_tennis_centre, "indoor_tennis_centre")


# OutdoorTennisCourts ---------------------------
outdoor_tennis_courts <- list_facilities[["OutdoorTennisCourts"]] %>% 
    group_by(SiteID) %>% 
    summarise(Courts = sum(Courts),
              Floodlit = sum(Floodlit)) %>% 
    left_join(., sites, by = "SiteID") %>%
    filter(!is.na(SiteName)) %>% 
    select(Courts, Floodlit, everything()) 

write_csv(outdoor_tennis_courts, "outdoor_tennis_courts.csv")
createGeoJson(outdoor_tennis_courts, "outdoor_tennis_courts")


# SkiSlopes ---------------------------
ski_slopes <- list_facilities[["SkiSlopes"]] %>% 
  group_by(SiteID) %>% 
  summarise(Floodlit = sum(Floodlit),
            Tow = sum(Tow)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>%
  select(Tow, Floodlit, everything())

write_csv(ski_slopes, "ski_slopes.csv")
createGeoJson(ski_slopes, "ski_slopes")


# SportsHall ---------------------------
sports_hall <- list_facilities[["SportsHall"]] %>%
  group_by(SiteID) %>% 
  summarise(`Badminton Courts` = sum(`Badminton Courts`),
            `Basketball Courts` = sum(`Basketball Courts`),
            `Cricket Nets` = sum(`Cricket Nets`),
            `Floor Matting` = sum(`Floor Matting`),
            `Gymnastics/Trampoline Use` = sum(`Gymnastics/Trampoline Use`),
            `Moveable Balance Apparatus` = sum(`Moveable Balance Apparatus`),
            `Moveable Large Apparatus` = sum(`Moveable Large Apparatus`),
            `Moveable Rebound Apparatus` = sum(`Moveable Rebound Apparatus`),
            `Moveable Trampolines` = sum(`Moveable Trampolines`),
            `Netball Courts` = sum(`Netball Courts`),
            `Swinging And Hanging Apparatus` = sum(`Swinging And Hanging Apparatus`),
            `Volleyball Courts` = sum(`Volleyball Courts`),
            `Five-A-Side Pitches` = sum(`Five-A-Side Pitches`),
            `Futsal Courts` = sum(`Futsal Courts`)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(`Badminton Courts`, `Basketball Courts`, `Cricket Nets`, `Floor Matting`, 
         `Gymnastics/Trampoline Use`, `Moveable Balance Apparatus`, `Moveable Large Apparatus`,
         `Moveable Rebound Apparatus`, `Moveable Trampolines`, `Netball Courts`,
         `Swinging And Hanging Apparatus`, `Volleyball Courts`, `Five-A-Side Pitches`, `Futsal Courts`,
         everything())
  
write_csv(sports_hall, "sports_hall.csv")
createGeoJson(sports_hall, "sports_hall")

  
# SquashCourts ---------------------------
squash_courts <- list_facilities[["SquashCourts"]] %>% 
  group_by(SiteID) %>% 
  summarise(Courts = sum(Courts),
            Doubles = sum(Doubles),
            `Movable Wall` = sum(`Movable Wall`)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(Courts, Doubles, `Movable Wall`, everything())

write_csv(squash_courts, "squash_courts.csv")
createGeoJson(squash_courts, "squash_courts")


# Studio ---------------------------
studio <- list_facilities[["Studio"]] %>%
  group_by(SiteID) %>% 
  summarise(`Bike Stations` = sum(`Bike Stations`),
            `Floor Matting` = sum(`Floor Matting`),
            `Gymnastics/Trampoline Use` = sum(`Gymnastics/Trampoline Use`),
            `Moveable Balance Apparatus` = sum(`Moveable Balance Apparatus`),
            `Moveable Large Apparatus` = sum(`Moveable Large Apparatus`),
            `Moveable Rebound Apparatus` = sum(`Moveable Rebound Apparatus`),
            `Moveable Trampolines` = sum(`Moveable Trampolines`),
            `Partitionable Spaces` = sum(`Partitionable Spaces`),
            `Small Apparatus` = sum(`Small Apparatus`),
            `Swinging And Hanging Apparatus` = sum(`Swinging And Hanging Apparatus`)) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(`Bike Stations`, `Floor Matting`, `Gymnastics/Trampoline Use`, `Moveable Balance Apparatus`,
         `Moveable Large Apparatus`, `Moveable Rebound Apparatus`, `Moveable Trampolines`,
         `Partitionable Spaces`, `Small Apparatus`, `Swinging And Hanging Apparatus`, everything())  

write_csv(studio, "studio.csv")
createGeoJson(studio, "studio")


# SwimmingPool ---------------------------
swimming_pools <- list_facilities[["SwimmingPool"]] %>%
  group_by(SiteID) %>% 
  summarise(Pools = n()) %>% 
  left_join(., sites, by = "SiteID") %>%
  filter(!is.na(SiteName)) %>% 
  select(Pools, everything())

write_csv(swimming_pools, "swimming_pools.csv")
createGeoJson(swimming_pools, "swimming_pools")

