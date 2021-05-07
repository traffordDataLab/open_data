# Retrieve the list of polling stations within Greater Manchester from the Democracy Club API:
# https://wheredoivote.co.uk/api/beta/councils/E08000009.json
# https://wheredoivote.co.uk/api/beta/pollingstations.json?council_id=TRF
# Latest update for the elections on 2021-05-06

# load libraries
library(tidyverse) ; library(sf) ; library(stringr) ; library(jsonlite)

# Create a vector of Greater Manchester (GM) Local Authorities (LA) by their 9-digit Government Statistical Service (GSS) code
gm_la_gss_code <- c("E08000001", "E08000002", "E08000003", "E08000004", "E08000005", "E08000006", "E08000007", "E08000008", "E08000009", "E08000010")

# Associate the names of the LAs with their codes
#names(gm_la_gss_code) <- c("Bolton", "Bury", "Manchester", "Oldham", "Rochdale", 
#                           "Salford", "Stockport", "Tameside", "Trafford", "Wigan")

# Create a list of 10 URLs to call the API and obtain the council ids
gm_la_urls <- paste0("https://wheredoivote.co.uk/api/beta/councils/", gm_la_gss_code, ".json")

# List the URLs - (this can be used to get the ids below)
gm_la_urls

# Create a vector of IDs for the GM LAs
gm_la_id <- c("BOL", "BUR", "MAN", "OLD", "RCH", "SLF", "SKP", "TAM", "TRF", "WGN")

# Create the list of 10 URLs to call the API to fetch the polling stations
api_urls <- paste0("https://wheredoivote.co.uk/api/beta/pollingstations.json?council_id=", gm_la_id)

# Loop through the urls vector, calling the API in turn and return a complete dataset of GM polling stations
df_gm_stations_src <- map_df(api_urls, function(i) {
  df_temp <- fromJSON(i, flatten = TRUE) %>% as_tibble() # create a temporary dataframe object for each url in turn
    
  df_subset <- if (nrow(df_temp) > 0) { # so long as we have data for the LA...
      bind_rows(df_temp) # ...bind it with the other data obtained
  }
  
  return(df_subset)
})

# Tidy the data
df_gm_stations <- df_gm_stations_src %>%  # create a new dataframe so that we don't amend the source
  # just select the variables we are interested in
  select(council_api_url = council, station_id, address, postcode) %>%
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

# --------------- THIS IS SPECIFIC TO EACH REFRESH OF THE DATA AS THE STATIONS MAY HAVE CHANGED ---------------
# Amend incorrect or missing data
df_gm_stations <- df_gm_stations %>%
  mutate(postcode = case_when(
      postcode == "M5 3QW" ~ "M5 3LQ",   # St. Clement's Church, Salford (postcode provided is incorrect)
      postcode == "M41 2WW" ~ "M41 7NP", # Woodhouse Primary School, Davyhulme (postcode provided is incorrect)
      address == "Marple Sixth Form College, Buxton Lane, Marple" ~ "SK6 7QY", # No postcode provided
      address == "Corner of St Andrews Avenue, and Bridge Grove, Timperley" ~ "WA15 6LD", # No postcode provided
      TRUE ~ postcode
    )
  )
# ----------------------------------------------------------------------------

# load postcode data (Source: ONS Postcode Directory)
postcodes <- read_csv("https://www.trafforddatalab.io/spatial_data/postcodes/gm_postcodes.csv")

# Match postcodes to retrieve coordinates plus ward and LA code/name
df_gm_stations <- left_join(df_gm_stations, postcodes, by = "postcode")

# Fill in any blank LA code and names (due to non matches to the postcode) based on the council api URL
df_gm_stations <- df_gm_stations %>%
    mutate(la_code = case_when(
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/BOL/" ~ "E08000001",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/BUR/" ~ "E08000002",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/MAN/" ~ "E08000003",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/OLD/" ~ "E08000004",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/RCH/" ~ "E08000005",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/SLF/" ~ "E08000006",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/SKP/" ~ "E08000007",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/TAM/" ~ "E08000008",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/TRF/" ~ "E08000009",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/WGN/" ~ "E08000010",
    )) %>%
    mutate(la_name = case_when(
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/BOL/" ~ "Bolton",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/BUR/" ~ "Bury",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/MAN/" ~ "Manchester",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/OLD/" ~ "Oldham",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/RCH/" ~ "Rochdale",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/SLF/" ~ "Salford",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/SKP/" ~ "Stockport",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/TAM/" ~ "Tameside",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/TRF/" ~ "Trafford",
      council_api_url == "https://wheredoivote.co.uk/api/beta/councils/WGN/" ~ "Wigan",
    ))

# Select the variables we want in a better order
df_gm_stations <- select(df_gm_stations, id, name, address, postcode, ward_code, ward_name, la_code, la_name, lon, lat)

# Export the data as CSV
write_csv(df_gm_stations, "gm_polling_stations.csv")
write_csv(filter(df_gm_stations, la_name == "Trafford"), "trafford_polling_stations.csv")

# Convert to spatial features object
sf_gm_stations <- df_gm_stations %>% 
  drop_na() %>%
  st_as_sf(crs = 4326, coords = c("lon", "lat"))

# Export the spatial data as GeoJSON
st_write(sf_gm_stations, "gm_polling_stations.geojson")
st_write(filter(sf_gm_stations, la_name == "Trafford"), "trafford_polling_stations.geojson")
