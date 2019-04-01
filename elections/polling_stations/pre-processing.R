# Retrieve the list of polling stations within Greater Manchester from the Democracy Club API:
# https://wheredoivote.co.uk/api/beta/pollingstations.json?council_id=E08000009
# https://wheredoivote.co.uk/api/beta/pollingstations/geo.json?council_id=E08000009

# load libraries---------------------------
library(tidyverse) ; library(sf) ; library(stringr) ; library(jsonlite)

# Create a vector of Greater Manchester (GM) Local Authorities (LA) by their 9-digit Government Statistical Service (GSS) code---------------------------
gm_authorities_vector <- c("E08000001", "E08000002", "E08000003", "E08000004", "E08000005", "E08000006", "E08000007", "E08000008", "E08000009", "E08000010")

# Associate the names of the LAs with their codes---------------------------
names(gm_authorities_vector) <- c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale", "Salford", 
                                  "Stockport", "Tameside", "Trafford", "Wigan")

# Create the list of 10 URLs to call the API---------------------------
api_urls <- paste0("https://wheredoivote.co.uk/api/beta/pollingstations.json?council_id=", gm_authorities_vector)

# Loop through the urls vector, calling the API in turn and return a complete dataset of GM polling stations
df_gm_stations_src <- map_df(api_urls, function(i) {
  df_temp <- fromJSON(i, flatten = TRUE) %>% as.tibble() # create a temporary dataframe object for each url in turn
    
  df_subset <- if (nrow(df_temp) > 0) { # so long as we have data for the LA...
      bind_rows(df_temp) # ...bind it with the other data obtained
  }
  
  return(df_subset)
})


# Tidy the data---------------------------
df_gm_stations <- df_gm_stations_src %>%  # create a new dataframe so that we don't amend the source
  # just select the variables we are interested in
  select(station_id, address, postcode) %>%
  # concatenate the address and postcode as some have their postcode within the address field and others have it separate
  unite(full_address, address, postcode, remove = TRUE, sep = "\n") %>%
  # replace any commas in the address with newline characters for consistency and to ensure we get the correct station name later on
  mutate(full_address = str_replace_all(full_address, ", ", "\n")) %>%
  # use a regex to move the postcodes to their own variable (NOTE: postcode regex from: https://andrewwburns.com/2018/04/10/uk-postcode-validation-regex/)
  mutate(station_postcode = str_extract(full_address, "\n([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) [0-9][A-Za-z]{2})")) %>%
  # use the same regex to remove the postcode from the address field
  mutate(full_address = str_remove(full_address, "\n([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) [0-9][A-Za-z]{2})")) %>%
  # Take all the characters in full_address up to the first newline char, which is the name of the polling station, and create a new variable with it
  mutate(station_name = str_extract(full_address, ".*")) %>%
  # use the same regex to remove the station name from the address
  mutate(full_address = str_remove(full_address, ".*\n")) %>%
  # remove any newline characters at the end of the address
  mutate(full_address = str_replace_all(full_address, "\n$", "")) %>%
  # replace all newline characters with a comma followed by a space
  mutate(full_address = str_replace_all(full_address, "\n", ", ")) %>%
  # change the name of the address variable
  rename(id = station_id,
         name = station_name,
         address = full_address,
         postcode = station_postcode)

# Amend incorrect or missing data---------------------------
df_gm_stations <- df_gm_stations %>%
  mutate(postcode = case_when(
      postcode == "M5 3QW" ~ "M5 3LQ",   # St. Clement's Church, Salford (postcode provided is incorrect)
      postcode == "M41 2WW" ~ "M41 7NP", # Woodhouse Primary School, Davyhulme (postcode provided is incorrect)
      address == "Marple Sixth Form College, Buxton Lane, Marple" ~ "SK6 7QY", # No postcode provided
      address == "Corner of St Andrews Avenue, and Bridge Grove, Timperley" ~ "WA15 6LD", # No postcode provided
      TRUE ~ postcode
    )
  )

# load postcode data (Source: ONS Postcode Directory)
postcodes <- read_csv("https://www.trafforddatalab.io/spatial_data/postcodes/gm_postcodes.csv")

# Match postcodes to retrieve coordinates and area code/name---------------------------
df_gm_stations <- left_join(df_gm_stations, postcodes, by = "postcode")

# Change the order of the variables---------------------------
df_gm_stations <- select(df_gm_stations, id, name, address, postcode, area_code, area_name, lon, lat)

# Export the data as CSV---------------------------
write_csv(df_gm_stations, "gm_polling_stations.csv")
write_csv(filter(df_gm_stations, area_name == "Trafford"), "trafford_polling_stations.csv")

# Convert to spatial features object---------------------------
sf_gm_stations <- df_gm_stations %>% st_as_sf(crs = 4326, coords = c("lon", "lat"))

# Export the spatial data as GeoJSON---------------------------
st_write(sf_gm_stations, "gm_polling_stations.geojson")
st_write(filter(sf_gm_stations, area_name == "Trafford"), "trafford_polling_stations.geojson")
