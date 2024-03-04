# River/water level data from monitoring stations
# Source: DEFRA, published by Environment Agency
# URL: https://environment.data.gov.uk/dataset/ae80cf81-f3aa-4703-88e7-41fbe80c67b2
# API: https://environment.data.gov.uk/flood-monitoring/doc/reference

# Example API calls:
# - All stations recording water levels within 8km of the centre of Trafford: https://environment.data.gov.uk/flood-monitoring/id/stations?lat=53.41671&long=-2.36572&dist=8&parameter=level
# - Get the data from a specific station (which includes historic highs, lows etc.: https://environment.data.gov.uk/flood-monitoring/id/stations/692727 (.json)
# - Get the latest reading from a specific station: https://environment.data.gov.uk/flood-monitoring/id/measures/692727-level-stage-i-15_min-m/readings?latest
# - Get the latest 7 days worth of data from a specific station: https://environment.data.gov.uk/flood-monitoring/id/stations/692727/readings?_sorted&_limit=672
# NOTE: 692727 is Flixton Bridge.  Readings are taken every 15 minutes, so 4 readings per hour for 7 days = 672 stated as the _limit parameter


# Load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(httr) ; library(jsonlite) ; library(lubridate)


# Monitoring stations covering the Trafford area and environs ---------------------------
# Call the API and attempt to get all stations recording water levels within 8km of the centre of Trafford
api_response <- GET(
    url = 'https://environment.data.gov.uk/flood-monitoring/id/stations?lat=53.41671&long=-2.36572&dist=8&parameter=level',
    timeout(50)
)

# After examining the API response, pull out the data we're interested in ("items") into a tibble
monitoring_stations_raw <- fromJSON(content(api_response, as = "text"), flatten = TRUE) %>%
    pluck("items") %>% 
    as_tibble() 

# Tidy up the variables
monitoring_stations <- monitoring_stations_raw %>%
    rename(lon = long,
           station_label = label,
           station_reference = stationReference,
           river_name = riverName,
           catchment_name = catchmentName) %>%
    select(station_label, station_reference, river_name, catchment_name, town, lon, lat)
    

# Historic data from the chosen monitoring stations ---------------------------
# Call the API again based on all the monitoring station IDs we've obtained and retrieve the historic highs, lows and range

# Function to use within purrr:map_df() to iterate through the monitoring station IDs
getHistoricData <- function(.station_ref) {
    api_response <- GET(
        url = paste0("https://environment.data.gov.uk/flood-monitoring/id/stations/", .station_ref, "/stageScale"),
        timeout(50)
    )
    
    if (api_response$status_code == 200) {
        # Get the node containing the data of interest from the API response - we will then successively pull what we need from this
        historic_levels_raw <- fromJSON(content(api_response, as = "text"), flatten = TRUE) %>%
            pluck("items")
        
        # Typical range low and high values
        df_tmp <- historic_levels_raw %>%
            as_tibble() %>% # turn list into a tibble so we can work with the data like a dataframe
            rename(typical_low_value = typicalRangeLow,
                   typical_high_value = typicalRangeHigh) %>%
            mutate(station_reference = .station_ref) %>%
            select(station_reference, typical_low_value, typical_high_value) %>%
            head(1) # due to the "items" list containing 3 sub lists (recentHigh, highOnRecord, minOnRecord), the dataframe/tibble contains 3 identical rows, so here we just pick the first row
        
        # Lowest level on record
        df_tmp <- df_tmp %>%
            left_join(
                historic_levels_raw %>%
                    pluck("minOnRecord") %>%
                    as_tibble() %>% # turn list into a tibble so we can work with the data like a dataframe
                    rename(historic_low_date = dateTime,
                           historic_low_value = value) %>%
                    mutate(station_reference = .station_ref,
                           historic_low_date = as.character(date(historic_low_date))) %>%
                    select(station_reference, historic_low_value, historic_low_date)
            )
        
        # Highest level on record
        df_tmp <- df_tmp %>%
            left_join(
                historic_levels_raw %>%
                    pluck("maxOnRecord") %>%
                    as_tibble() %>% # turn list into a tibble so we can work with the data like a dataframe
                    rename(historic_high_date = dateTime,
                           historic_high_value = value) %>%
                    mutate(station_reference = .station_ref,
                           historic_high_date = as.character(date(historic_high_date))) %>%
                    select(station_reference, historic_high_value, historic_high_date)
            )
    }
    else {
        df_tmp <- tibble(station_reference = .station_ref)
    }
    
    return(df_tmp)
} 

# Call the GetHistoricData function passing in every `station_reference` from the dataframe monitoring_stations and then join the returned data to it
monitoring_stations <- monitoring_stations %>%
    left_join(map_df(monitoring_stations$station_reference, getHistoricData)) %>%
    mutate(measure = "Water level",
           unit = "Metres",
           across(ends_with("_value"), round, 2)) # Convert all water levels to 2 decimal places


# write data  ---------------------------
monitoring_stations %>%
    write_csv("monitoring_stations_covering_trafford.csv") %>%
    st_as_sf(coords = c("lon", "lat")) %>% 
    st_set_crs(4326) %>%
    st_write("monitoring_stations_covering_trafford.geojson", driver = "GeoJSON")
    
