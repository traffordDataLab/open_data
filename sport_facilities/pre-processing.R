## Sports facilities ##

# Source: Active Places Power
# Publisher URL: https://www.activeplacespower.com/pages/downloads#download
#       ZIP URL: https://api.activeplacespower.com/download/activeplacescsvs.zip
# Licence: Open Government Licence

# load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(janitor)


# Initial tidy up the filesystem, deleting the existing dataset files
file.remove("artificial_grass_pitch.csv", "athletics.csv", "golf.csv", "grass_pitches.csv", "health_and_fitness_gym.csv", "ice_rinks.csv",
            "indoor_tennis_centre.csv", "outdoor_tennis_courts.csv", "ski_slopes.csv", "sports_hall.csv", "squash_courts.csv", "studio.csv", "swimming_pools.csv",
            "artificial_grass_pitch.geojson", "athletics.geojson", "golf.geojson", "grass_pitches.geojson", "health_and_fitness_gym.geojson", "ice_rinks.geojson",
            "indoor_tennis_centre.geojson", "outdoor_tennis_courts.geojson", "ski_slopes.geojson", "sports_hall.geojson", "squash_courts.geojson", "studio.geojson",
            "swimming_pools.geojson")


# Download and un-zip the full CSV dataset ---------------------------
data_url <- "https://api.activeplacespower.com/download/activeplacescsvs.zip"
zip_name <- "activeplacescsvs.zip"

download.file(data_url, destfile = zip_name, timeout = 5000)
unzip(zip_name)
file.remove(zip_name)


# Read all CSV files as a list ---------------------------
filenames <- list.files(pattern = "*.csv")
list_df <- lapply(setNames(filenames, make.names(gsub("*.csv$", "", filenames))), read_csv) 


# Extract 'Sites' dataframe ---------------------------
sites <- list_df[["sites"]] %>%
    # Tidy up the variable names
    clean_names() %>%
    # Filter just for Trafford sites that are not closed
    filter(local_authority_name == "Trafford",
           is.na(closure_reason)) %>%
    # Convert to Proper case
    mutate(site_name = str_to_title(site_name),
           street = str_to_title(thoroughfare_name),
           town = str_to_title(town)) %>% 
  # Choose relevant variables
  select(site_id, site_name,
         # Address
         street, town, postcode,
         # Contact details
         telephone = telephone_number,
         email, website,
         # Amenities
         nursery = has_nursery,
         first_aid_room = has_first_aid_room,
         cycle_park,
         car_park = car_park_exists,
         car_park_capacity,
         # Disability provision
         disability_parking,
         disability_finding_reaching_entrance = disability_finding_and_reaching_the_entrance,
         disability_reception_area,
         disability_activity_area,
         disability_social_areas,
         disability_spectator_areas,
         disability_doorways,
         disability_emergency_exits,
         disability_toilets,
         disability_changing_facilities,
         disability_notes,
         # Geographical positioning
         ward_code,
         ward_name,
         msoa_code = middle_super_output_area_code,
         lsoa_code = lower_super_output_area_code,
         oa_code = output_area_code,
         lon = long,
         lat,
         # Other site fields
         site_last_updated_date = last_updated_date) %>%
    # Convert columns to factors for recoding
    mutate_at(c("car_park", "cycle_park", "nursery", "first_aid_room", "disability_activity_area", "disability_changing_facilities", "disability_doorways", "disability_emergency_exits", "disability_finding_reaching_entrance", "disability_parking", "disability_reception_area", "disability_social_areas", "disability_spectator_areas", "disability_toilets"), factor) %>%
    mutate(car_park = fct_recode(car_park, "No" = "0", "Yes" = "1", "Not known" = "2"),
           cycle_park = fct_recode(cycle_park, "No" = "0", "Yes" = "1", "Not known" = "2"),
           nursery = fct_recode(nursery, "No" = "0", "Yes" = "1", "Not known" = "2"),
           first_aid_room = fct_recode(first_aid_room, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_activity_area = fct_recode(disability_activity_area, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_changing_facilities = fct_recode(disability_changing_facilities, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_doorways = fct_recode(disability_doorways, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_emergency_exits = fct_recode(disability_emergency_exits, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_finding_reaching_entrance = fct_recode(disability_finding_reaching_entrance, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_parking = fct_recode(disability_parking, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_reception_area = fct_recode(disability_reception_area, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_social_areas = fct_recode(disability_social_areas, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_spectator_areas = fct_recode(disability_spectator_areas, "No" = "0", "Yes" = "1", "Not known" = "2"),
           disability_toilets = fct_recode(disability_toilets, "No" = "0", "Yes" = "1", "Not known" = "2"),
           site_last_updated_date = as.Date(site_last_updated_date)) # remove the time element


# subset list to include Facility Types only ---------------------------
list_facilities <- list_df[c("artificialgrasspitches", "athletics", "cycling", "golf", "grasspitches",
                         "healthandfitnessgym", "icerinks", "indoorbowls", "indoortenniscentre", "outdoortenniscourts",
                         "skislopes", "sportshalls", "squashcourts", "studios", "swimmingpools")]


# Tidy up the filesystem, deleting the downloaded files from the ZIP as we don't need them anymore
file.remove("artificialgrasspitches.csv", "athletics.csv", "cycling.csv", "facilities.csv", "facilitycriteriaexceptions.csv", "facilitysubtype.csv",
            "facilitytimings.csv", "facilitytype.csv", "golf.csv", "grasspitches.csv", "healthandfitnessgym.csv", "icerinks.csv", "indoorbowls.csv",
            "indoortenniscentre.csv", "information.txt", "outdoortenniscourts.csv", "sitequalityawards.csv", "sites.csv", "skislopes.csv",
            "sportshalls.csv", "squashcourts.csv", "studios.csv", "swimmingpools.csv")


# Function to create the spatial data (geojson) files from the individual data frames created below
createGeoJson <- function(df, filename) {
    df %>%
        # In case you don't want null to appear in the GeoJSON (which is what NA is converted to), however Explore replaces null with ""
        #mutate(across(where(is.character), ~replace_na(., ""))) %>% # Happy for the NA's to appear in the CSV, but not in the GeoJSON
        st_as_sf(crs = 4326, coords = c("lon", "lat")) %>% 
        st_write(., paste0(filename, ".geojson"))
}


# Artificial Grass Pitches ---------------------------
artificial_grass_pitch <- list_facilities[["artificialgrasspitches"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>%
    # These are all numbers indicating the number of pitches
    summarise(pitches_on_site = sum(pitches),
              indoor_pitches = sum(indoor),
              artificial_sports_lighting_pitches = sum(artificial_sports_lighting)) %>% 
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Artificial grass pitches") %>%
    select(site_id, site_name, facility_type, access_type, pitches_on_site, indoor_pitches, artificial_sports_lighting_pitches, everything())

write_csv(artificial_grass_pitch, "artificial_grass_pitch.csv")
createGeoJson(artificial_grass_pitch, "artificial_grass_pitch")


# Athletics ---------------------------
athletics <- list_facilities[["athletics"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    mutate(facility_areas = 1,   # this will become a sum in the case of multiple facilities at the same site
           indoor_facility = if_else(facility_subtype %in% c(1008, 1009), 1, 0)) %>%
    group_by(site_id, access_type) %>%
    # We want to sum numeric columns, so "na.rm = TRUE" in sum() below ignores NA values
    summarise(facility_areas_on_site = sum(facility_areas, na.rm = TRUE),
              indoor_facility_areas = sum(indoor_facility, na.rm = TRUE),
              oval_track_lanes_total = sum(oval_track_lanes, na.rm = TRUE),
              straight_track_lanes_total = sum(straight_track_lanes, na.rm = TRUE),
              other_track_lanes_total = sum(track_lanes, na.rm = TRUE),
              # The following are summing values of 0 for No and 1 for Yes.
              # We're using the summed value to indicate the number of facility areas which have those facilities.
              # E.g. if there are 2 facility areas and both have long jump facilities, both records will contain 1 for Yes, thus the result will be 2 in long_jump_facility_areas
              artificial_sports_lighting_facility_areas = sum(artificial_sports_lighting, na.rm = TRUE),
              discus_throw_facility_areas = sum(discuss_throw_facility, na.rm = TRUE),
              hammer_throw_facility_areas = sum(hammer_throw_facility, na.rm = TRUE),
              high_jump_facility_areas = sum(high_jump_facility, na.rm = TRUE),
              indoor_javelin_net_facility_areas = sum(indoor_throw_net_for_javelin, na.rm = TRUE),
              indoor_throws_cage_facility_areas = sum(indoor_throws_training_cage, na.rm = TRUE),
              javelin_throw_facility_areas = sum(javelin_throw_facility, na.rm = TRUE),
              long_jump_facility_areas = sum(long_jump_facility, na.rm = TRUE),
              pole_vault_facility_areas = sum(pole_vault_facility, na.rm = TRUE),
              shot_put_facility_areas = sum(shot_put_facility, na.rm = TRUE),
              steeplechase_water_jump_facility_areas = sum(steeplechase_water_jump, na.rm = TRUE),
              triple_jump_facility_areas = sum(triple_jump_facility, na.rm = TRUE)) %>%
    left_join(sites, by = "site_id") %>% 
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Athletics") %>%
    select(site_id, site_name, facility_type, access_type, facility_areas_on_site, indoor_facility_areas, artificial_sports_lighting_facility_areas, 
           oval_track_lanes_total, straight_track_lanes_total, other_track_lanes_total, steeplechase_water_jump_facility_areas,
           long_jump_facility_areas, triple_jump_facility_areas, high_jump_facility_areas, pole_vault_facility_areas,
           discus_throw_facility_areas, shot_put_facility_areas, hammer_throw_facility_areas, javelin_throw_facility_areas,
           indoor_javelin_net_facility_areas, indoor_throws_cage_facility_areas, everything())

write_csv(athletics, "athletics.csv")
createGeoJson(athletics, "athletics")


# Cycling ---------------------------
# NOTE: THERE ARE NO CYCLING FACILITIES IN TRAFFORD
cycling <- list_facilities[["cycling"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>%
    # Summarise and mutate statements are needed here
    left_join(sites, by = "site_id") %>% 
    filter(!is.na(site_name))   # if NA it's a site outside Trafford


# Golf ---------------------------
golf <- list_facilities[["golf"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    mutate(facility_areas = 1) %>%  # this will become a sum in the case of multiple facilities at the same site
    # We want to sum numeric columns, so "na.rm = TRUE" in sum() below ignores NA values
    group_by(site_id, access_type) %>%
    summarise(facility_areas_on_site = sum(facility_areas),
              artificial_sports_lighting_facility_areas = sum(artificial_sports_lighting, na.rm = TRUE),
              golf_course_holes_total = sum(holes, na.rm = TRUE),
              driving_range_bays_total = sum(bays, na.rm = TRUE)) %>%
    left_join(sites, by = "site_id") %>% 
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Golf") %>%
    select(site_id, site_name, facility_type, access_type, facility_areas_on_site, artificial_sports_lighting_facility_areas, golf_course_holes_total, driving_range_bays_total, everything())

write_csv(golf, "golf.csv")
createGeoJson(golf, "golf")


# Grass Pitches ---------------------------
grass_pitches <- list_facilities[["grasspitches"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>% 
    # These are all numbers indicating the number of pitches
    summarise(pitches_on_site = sum(pitches),
              artificial_sports_lighting_pitches = sum(artificial_sports_lighting)) %>% 
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Grass pitches") %>%
    select(site_id, site_name, facility_type, access_type, pitches_on_site, artificial_sports_lighting_pitches, everything())

write_csv(grass_pitches, "grass_pitches.csv")
createGeoJson(grass_pitches, "grass_pitches")


# Health and Fitness Gyms ---------------------------
health_and_fitness_gym <- list_facilities[["healthandfitnessgym"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>% 
    summarise(stations_on_site = sum(stations)) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Health and fitness gyms") %>%
    select(site_id, site_name, facility_type, access_type, stations_on_site, everything())

write_csv(health_and_fitness_gym, "health_and_fitness_gym.csv")
createGeoJson(health_and_fitness_gym, "health_and_fitness_gym")


# Ice Rinks ---------------------------
ice_rinks <- list_facilities[["icerinks"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    mutate(rinks = 1) %>%  # this will become a sum in the case of multiple facilities at the same site
    group_by(site_id, access_type) %>% 
    summarise(rinks_on_site = sum(rinks)) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Ice rinks") %>%
    select(site_id, site_name, facility_type, access_type, rinks_on_site, everything())

write_csv(ice_rinks, "ice_rinks.csv")
createGeoJson(ice_rinks, "ice_rinks")


# Indoor Bowls ---------------------------
# NOTE: THERE ARE NO INDOOR BOWLS FACILITIES IN TRAFFORD
bowls <- list_facilities[["indoorbowls"]] %>% # no facilities in Trafford
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>% 
    # Summarise and mutate statements are needed here
    left_join(sites, by = "site_id") %>% 
    filter(!is.na(site_name))   # if NA it's a site outside Trafford


# Indoor Tennis Centre ---------------------------
indoor_tennis_centre <- list_facilities[["indoortenniscentre"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>% 
    summarise(courts_on_site = sum(courts)) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Indoor tennis centres") %>%
    select(site_id, site_name, facility_type, access_type, courts_on_site, everything())
    
write_csv(indoor_tennis_centre, "indoor_tennis_centre.csv")
createGeoJson(indoor_tennis_centre, "indoor_tennis_centre")


# Outdoor Tennis Courts ---------------------------
outdoor_tennis_courts <- list_facilities[["outdoortenniscourts"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>% 
    summarise(courts_on_site = sum(courts),
              artificial_sports_lighting_courts = sum(artificial_sports_lighting)) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Outdoor tennis courts") %>%
    select(site_id, site_name, facility_type, access_type, courts_on_site, artificial_sports_lighting_courts, everything())

write_csv(outdoor_tennis_courts, "outdoor_tennis_courts.csv")
createGeoJson(outdoor_tennis_courts, "outdoor_tennis_courts")


# Ski Slopes ---------------------------
ski_slopes <- list_facilities[["skislopes"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    mutate(slopes = 1) %>%  # this will become a sum in the case of multiple slopes at the same site
    group_by(site_id, access_type) %>% 
    summarise(slopes_on_site = sum(slopes)) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Ski slopes") %>%
    select(site_id, site_name, facility_type, access_type, slopes_on_site, everything())

write_csv(ski_slopes, "ski_slopes.csv")
createGeoJson(ski_slopes, "ski_slopes")


# Sports Halls ---------------------------
sports_hall <- list_facilities[["sportshalls"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    mutate(facility_areas = 1,   # this will become a sum in the case of multiple facilities at the same site
           # The following are to replace the values 1 for Yes and 2 for Not Known into 1000 for Yes and 50 for Not Known
           # 0 for No remains unchanged and NA values are converted to 50 for Not Known
           # We can then determine by summing if a site does have certain facilities (>= 1000), whether it's Not Known (>= 50) or it doesn't (== 0)
           clearance_exists_ball_shuttlecock = case_when(clearance_exists_ball_shuttlecock == 1 ~ 1000,
                                                         clearance_exists_ball_shuttlecock == 2 ~ 50,
                                                         is.na(clearance_exists_ball_shuttlecock) ~ 50,
                                                         TRUE ~ clearance_exists_ball_shuttlecock),
           gymnastics_trampoline_use = case_when(gymnastics_trampoline_use == 1 ~ 1000,
                                                 gymnastics_trampoline_use == 2 ~ 50,
                                                 is.na(gymnastics_trampoline_use) ~ 50,
                                                 TRUE ~ gymnastics_trampoline_use),
           floor_matting = case_when(floor_matting == 1 ~ 1000,
                                     floor_matting == 2 ~ 50,
                                     is.na(floor_matting) ~ 50,
                                     TRUE ~ floor_matting),
           moveable_balance_apparatus = case_when(moveable_balance_apparatus == 1 ~ 1000,
                                                  moveable_balance_apparatus == 2 ~ 50,
                                                  is.na(moveable_balance_apparatus) ~ 50,
                                                  TRUE ~ moveable_balance_apparatus),
           moveable_large_apparatus = case_when(moveable_large_apparatus == 1 ~ 1000,
                                                moveable_large_apparatus == 2 ~ 50,
                                                is.na(moveable_large_apparatus) ~ 50,
                                                TRUE ~ moveable_large_apparatus),
           moveable_rebound_apparatus = case_when(moveable_rebound_apparatus == 1 ~ 1000,
                                                  moveable_rebound_apparatus == 2 ~ 50,
                                                  is.na(moveable_rebound_apparatus) ~ 50,
                                                  TRUE ~ moveable_rebound_apparatus),
           moveable_trampolines = case_when(moveable_trampolines == 1 ~ 1000,
                                            moveable_trampolines == 2 ~ 50,
                                            is.na(moveable_trampolines) ~ 50,
                                            TRUE ~ moveable_trampolines),
           small_apparatus = case_when(small_apparatus == 1 ~ 1000,
                                       small_apparatus == 2 ~ 50,
                                       is.na(small_apparatus) ~ 50,
                                       TRUE ~ small_apparatus),
           swinging_and_hanging_apparatus = case_when(swinging_and_hanging_apparatus == 1 ~ 1000,
                                                      swinging_and_hanging_apparatus == 2 ~ 50,
                                                      is.na(swinging_and_hanging_apparatus) ~ 50,
                                                      TRUE ~ swinging_and_hanging_apparatus)) %>%
    group_by(site_id, access_type) %>%
              # These are all numbers indicating the quantity of types of facility
              # We want to sum them, so "na.rm = TRUE" in sum() below ignores NA values
    summarise(facility_areas_on_site = sum(facility_areas, na.rm = TRUE),
              badminton_courts_total = sum(badminton_courts, na.rm = TRUE),
              basketball_courts_total = sum(basketball_courts, na.rm = TRUE),
              cricket_nets_total = sum(cricket_nets, na.rm = TRUE),
              five_a_side_pitches_total = sum(five_a_side_pitches, na.rm = TRUE),
              futsal_courts_total = sum(futsal_courts, na.rm = TRUE),
              netball_courts_total = sum(netball_courts, na.rm = TRUE),
              volleyball_courts_total = sum(volleyball_courts, na.rm = TRUE),
              badminton_courts_total = sum(badminton_courts, na.rm = TRUE),
              # The following will require a further mutate based on the summed values
              clearance_exists_ball_shuttlecock = sum(clearance_exists_ball_shuttlecock),
              gymnastics_trampoline_use = sum(gymnastics_trampoline_use),
              floor_matting = sum(floor_matting),
              moveable_balance_apparatus = sum(moveable_balance_apparatus),
              moveable_large_apparatus = sum(moveable_large_apparatus),
              moveable_rebound_apparatus = sum(moveable_rebound_apparatus),
              moveable_trampolines = sum(moveable_trampolines),
              small_apparatus = sum(small_apparatus),
              swinging_and_hanging_apparatus = sum(swinging_and_hanging_apparatus)) %>%   
    mutate(clearance_exists_ball_shuttlecock = case_when(clearance_exists_ball_shuttlecock >= 1000 ~ "Yes",
                                                         clearance_exists_ball_shuttlecock >= 50 ~ "Not Known",
                                                         TRUE ~ "No"),
           gymnastics_trampoline_use = case_when(gymnastics_trampoline_use >= 1000 ~ "Yes",
                                                        gymnastics_trampoline_use >= 50 ~ "Not Known",
                                                        TRUE ~ "No"),
           floor_matting = case_when(floor_matting >= 1000 ~ "Yes",
                                     floor_matting >= 50 ~ "Not Known",
                                     TRUE ~ "No"),
           moveable_balance_apparatus = case_when(moveable_balance_apparatus >= 1000 ~ "Yes",
                                                  moveable_balance_apparatus >= 50 ~ "Not Known",
                                                  TRUE ~ "No"),
           moveable_large_apparatus = case_when(moveable_large_apparatus >= 1000 ~ "Yes",
                                                moveable_large_apparatus >= 50 ~ "Not Known",
                                                TRUE ~ "No"),
           moveable_rebound_apparatus = case_when(moveable_rebound_apparatus >= 1000 ~ "Yes",
                                                  moveable_rebound_apparatus >= 50 ~ "Not Known",
                                                  TRUE ~ "No"),
           moveable_trampolines = case_when(moveable_trampolines >= 1000 ~ "Yes",
                                            moveable_trampolines >= 50 ~ "Not Known",
                                            TRUE ~ "No"),
           small_apparatus = case_when(small_apparatus >= 1000 ~ "Yes",
                                       small_apparatus >= 50 ~ "Not Known",
                                       TRUE ~ "No"),
           swinging_and_hanging_apparatus = case_when(swinging_and_hanging_apparatus >= 1000 ~ "Yes",
                                                      swinging_and_hanging_apparatus >= 50 ~ "Not Known",
                                                      TRUE ~ "No")) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Sports halls") %>%
    select(site_id, site_name, facility_type, access_type, facility_areas_on_site, badminton_courts_total, basketball_courts_total, cricket_nets_total, five_a_side_pitches_total,
           futsal_courts_total, netball_courts_total, volleyball_courts_total, badminton_courts_total, clearance_exists_ball_shuttlecock, gymnastics_trampoline_use, floor_matting,
           moveable_balance_apparatus, moveable_large_apparatus, moveable_rebound_apparatus, moveable_trampolines, small_apparatus, swinging_and_hanging_apparatus, everything())
  
write_csv(sports_hall, "sports_hall.csv")
createGeoJson(sports_hall, "sports_hall")

  
# Squash Courts ---------------------------
squash_courts <- list_facilities[["squashcourts"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    group_by(site_id, access_type) %>% 
    summarise(courts_on_site = sum(courts),
              doubles_courts = sum(doubles),
              movable_wall = sum(movable_wall)) %>%
    mutate(doubles_courts = if_else(doubles_courts >= 1, "Yes", "No"),
           movable_wall = if_else(movable_wall >= 1, "Yes", "No")) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Squash courts") %>%
    select(site_id, site_name, facility_type, access_type, courts_on_site, doubles_courts, movable_wall, everything())

write_csv(squash_courts, "squash_courts.csv")
createGeoJson(squash_courts, "squash_courts")


# Studios ---------------------------
studio <- list_facilities[["studios"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text) %>%
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    # The following are to replace the values 1 for Yes and 2 for Not Known into 1000 for Yes and 50 for Not Known
    # 0 for No remains unchanged and NA values are converted to 50 for Not Known
    # We can then determine by summing if a site does have certain facilities (>= 1000), whether it's Not Known (>= 50) or it doesn't (== 0)
    # NOTE:
    # Fitness Studios (facility_sub_type 12001) all have NA for bike_stations so we know that we can regard these as 0
    # Cycle Studios (facility_sub_type 12002) all have NA for the other facility variables, so we know we can regard these as 0
    mutate(floor_matting = case_when(floor_matting == 1 ~ 1000,
                                     floor_matting == 2 ~ 50,
                                     is.na(floor_matting) ~ 50,
                                     TRUE ~ floor_matting),
           moveable_balance_apparatus = case_when(moveable_balance_apparatus == 1 ~ 1000,
                                                  moveable_balance_apparatus == 2 ~ 50,
                                                  is.na(moveable_balance_apparatus) ~ 50,
                                                  TRUE ~ moveable_balance_apparatus),
           moveable_large_apparatus = case_when(moveable_large_apparatus == 1 ~ 1000,
                                                moveable_large_apparatus == 2 ~ 50,
                                                is.na(moveable_large_apparatus) ~ 50,
                                                TRUE ~ moveable_large_apparatus),
           moveable_rebound_apparatus = case_when(moveable_rebound_apparatus == 1 ~ 1000,
                                                  moveable_rebound_apparatus == 2 ~ 50,
                                                  is.na(moveable_rebound_apparatus) ~ 50,
                                                  TRUE ~ moveable_rebound_apparatus),
           moveable_trampolines = case_when(moveable_trampolines == 1 ~ 1000,
                                            moveable_trampolines == 2 ~ 50,
                                            is.na(moveable_trampolines) ~ 50,
                                            TRUE ~ moveable_trampolines),
           small_apparatus = case_when(small_apparatus == 1 ~ 1000,
                                       small_apparatus == 2 ~ 50,
                                       is.na(small_apparatus) ~ 50,
                                       TRUE ~ small_apparatus),
           swinging_and_hanging_apparatus = case_when(swinging_and_hanging_apparatus == 1 ~ 1000,
                                                      swinging_and_hanging_apparatus == 2 ~ 50,
                                                      is.na(swinging_and_hanging_apparatus) ~ 50,
                                                      TRUE ~ swinging_and_hanging_apparatus)) %>%
    group_by(site_id, access_type) %>%
    # We want to sum numeric columns, so "na.rm = TRUE" in sum() below ignores NA values
    summarise(bike_stations = sum(bike_stations, na.rm = TRUE),
              partitionable_spaces = sum(partitionable_spaces, na.rm = TRUE),
              # The following will require a further mutate based on the summed values
              floor_matting = sum(floor_matting),
              moveable_balance_apparatus = sum(moveable_balance_apparatus),
              moveable_large_apparatus = sum(moveable_large_apparatus),
              moveable_rebound_apparatus = sum(moveable_rebound_apparatus),
              moveable_trampolines = sum(moveable_trampolines),
              small_apparatus = sum(small_apparatus),
              swinging_and_hanging_apparatus = sum(swinging_and_hanging_apparatus)) %>%
    mutate(floor_matting = case_when(floor_matting >= 1000 ~ "Yes",
                              floor_matting >= 50 ~ "Not Known",
                              TRUE ~ "No"),
           moveable_balance_apparatus = case_when(moveable_balance_apparatus >= 1000 ~ "Yes",
                                                  moveable_balance_apparatus >= 50 ~ "Not Known",
                                                  TRUE ~ "No"),
           moveable_large_apparatus = case_when(moveable_large_apparatus >= 1000 ~ "Yes",
                                                moveable_large_apparatus >= 50 ~ "Not Known",
                                                TRUE ~ "No"),
           moveable_rebound_apparatus = case_when(moveable_rebound_apparatus >= 1000 ~ "Yes",
                                                  moveable_rebound_apparatus >= 50 ~ "Not Known",
                                                  TRUE ~ "No"),
           moveable_trampolines = case_when(moveable_trampolines >= 1000 ~ "Yes",
                                            moveable_trampolines >= 50 ~ "Not Known",
                                            TRUE ~ "No"),
           small_apparatus = case_when(small_apparatus >= 1000 ~ "Yes",
                                       small_apparatus >= 50 ~ "Not Known",
                                       TRUE ~ "No"),
           swinging_and_hanging_apparatus = case_when(swinging_and_hanging_apparatus >= 1000 ~ "Yes",
                                                      swinging_and_hanging_apparatus >= 50 ~ "Not Known",
                                                      TRUE ~ "No")) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Studios") %>%
    select(site_id, site_name, facility_type, access_type, bike_stations, partitionable_spaces,
           floor_matting, moveable_balance_apparatus, moveable_large_apparatus, moveable_rebound_apparatus,
           moveable_trampolines, small_apparatus, swinging_and_hanging_apparatus, everything())

write_csv(studio, "studio.csv")
createGeoJson(studio, "studio")


# Swimming Pools ---------------------------
swimming_pools <- list_facilities[["swimmingpools"]] %>%
    clean_names() %>%
    rename(access_type = accessibility_type_text,
           moveable_floor = movable_floor) %>% # Doing this for consistency with other "moveable" fields in Sports Halls and Studios datasets
    filter(is.na(closure_reason)) %>%   # remove closed facilities
    mutate(pools = 1, # this will become a sum in the case of multiple pools at the same site
           # The following are to replace the values 1 for Yes and 2 for Not Known into 1000 for Yes and 50 for Not Known
           # 0 for No remains unchanged and NA values are converted to 50 for Not Known
           # We can then determine by summing if a site does have certain facilities (>= 1000), whether it's Not Known (>= 50) or it doesn't (== 0)
           accessible_pool_entry_system = case_when(accessible_pool_entry_system == 1 ~ 1000,
                                                    accessible_pool_entry_system == 2 ~ 50,
                                                    is.na(accessible_pool_entry_system) ~ 50,
                                                    TRUE ~ accessible_pool_entry_system),
           diving_boards = case_when(diving_boards == 1 ~ 1000,
                                     diving_boards == 2 ~ 50,
                                     is.na(diving_boards) ~ 50,
                                     TRUE ~ diving_boards),
           movable_floor = case_when(moveable_floor == 1 ~ 1000,
                                     moveable_floor == 2 ~ 50,
                                     is.na(moveable_floor) ~ 50,
                                     TRUE ~ moveable_floor)) %>%
    group_by(site_id, access_type) %>% 
    summarise(pools_on_site = sum(pools),
              lanes_total = sum(lanes),
              # The following will require a further mutate based on the summed values
              accessible_pool_entry_system = sum(accessible_pool_entry_system),
              diving_boards = sum(diving_boards),
              moveable_floor = sum(moveable_floor)) %>%
    mutate(accessible_pool_entry_system = case_when(accessible_pool_entry_system >= 1000 ~ "Yes",
                                                    accessible_pool_entry_system >= 50 ~ "Not Known",
                                                    TRUE ~ "No"),
           diving_boards = case_when(diving_boards >= 1000 ~ "Yes",
                                     diving_boards >= 50 ~ "Not Known",
                                     TRUE ~ "No"),
           moveable_floor = case_when(moveable_floor >= 1000 ~ "Yes",
                                      moveable_floor >= 50 ~ "Not Known",
                                      TRUE ~ "No")) %>%
    left_join(sites, by = "site_id") %>%
    filter(!is.na(site_name)) %>%   # if NA it's a site outside Trafford
    mutate(facility_type = "Swimming pools") %>%
    select(site_id, site_name, facility_type, access_type, pools_on_site, lanes_total, accessible_pool_entry_system, diving_boards, moveable_floor, everything())

write_csv(swimming_pools, "swimming_pools.csv")
createGeoJson(swimming_pools, "swimming_pools")


# Combine all the datasets into one ---------------------------
# First normalise all the individual datasets
artificial_grass_pitch <- artificial_grass_pitch %>%
    rename(facility_areas_on_site = pitches_on_site) %>%
    select(-indoor_pitches, -artificial_sports_lighting_pitches)

athletics <- athletics %>%
    select(-indoor_facility_areas, -artificial_sports_lighting_facility_areas, -oval_track_lanes_total, - straight_track_lanes_total, -other_track_lanes_total,
           -steeplechase_water_jump_facility_areas, -long_jump_facility_areas, -triple_jump_facility_areas, -high_jump_facility_areas, -pole_vault_facility_areas,
           -discus_throw_facility_areas, -shot_put_facility_areas, -hammer_throw_facility_areas, -javelin_throw_facility_areas, -indoor_javelin_net_facility_areas,
           -indoor_throws_cage_facility_areas)

golf <- golf %>%
    select(-artificial_sports_lighting_facility_areas, -golf_course_holes_total, -driving_range_bays_total)

grass_pitches <- grass_pitches %>%
    rename(facility_areas_on_site = pitches_on_site) %>%
    select(-artificial_sports_lighting_pitches)

health_and_fitness_gym <- health_and_fitness_gym %>%
    mutate(facility_type = "Health and fitness gym stations") %>%
    rename(facility_areas_on_site = stations_on_site)

ice_rinks <- ice_rinks %>%
    rename(facility_areas_on_site = rinks_on_site)

indoor_tennis_centre <- indoor_tennis_centre %>%
    mutate(facility_type = "Indoor tennis courts") %>%
    rename(facility_areas_on_site = courts_on_site)

outdoor_tennis_courts <- outdoor_tennis_courts %>%
    rename(facility_areas_on_site = courts_on_site) %>%
    select(-artificial_sports_lighting_courts)

ski_slopes <- ski_slopes %>%
    rename(facility_areas_on_site = slopes_on_site)

sports_hall <- sports_hall %>%
    select(-badminton_courts_total, -basketball_courts_total, -cricket_nets_total, -five_a_side_pitches_total, -futsal_courts_total, -netball_courts_total, -volleyball_courts_total,
           -clearance_exists_ball_shuttlecock, -gymnastics_trampoline_use, -floor_matting, -moveable_balance_apparatus, -moveable_large_apparatus, -moveable_rebound_apparatus,
           -moveable_trampolines, -small_apparatus, -swinging_and_hanging_apparatus)

squash_courts <- squash_courts %>%
    rename(facility_areas_on_site = courts_on_site) %>%
    select(-doubles_courts, -movable_wall)

studio <- studio %>%
    mutate(facility_areas_on_site = rowSums(across(c(bike_stations, partitionable_spaces)))) %>%
    select(site_id, site_name, facility_type, facility_areas_on_site, everything(),
           -bike_stations, -partitionable_spaces, -floor_matting, -moveable_balance_apparatus, -moveable_large_apparatus, -moveable_rebound_apparatus, -moveable_trampolines,
           -small_apparatus, -swinging_and_hanging_apparatus)

swimming_pools <- swimming_pools %>%
    rename(facility_areas_on_site = pools_on_site) %>%
    select(-lanes_total, -accessible_pool_entry_system, -diving_boards, -moveable_floor)

# now combine them into one dataset
sports_facilities <- bind_rows(artificial_grass_pitch, athletics, golf, grass_pitches, health_and_fitness_gym, ice_rinks, indoor_tennis_centre, outdoor_tennis_courts,
                               ski_slopes, sports_hall, squash_courts, studio, swimming_pools) %>%
    arrange(site_name, facility_type)

write_csv(sports_facilities, "sports_facilities.csv")
createGeoJson(sports_facilities, "sports_facilities")

