# River/water level data from monitoring stations
# Source: DEFRA, published by Environment Agency
# URL: https://environment.data.gov.uk/dataset/ae80cf81-f3aa-4703-88e7-41fbe80c67b2
# API: https://environment.data.gov.uk/flood-monitoring/doc/reference

# Example API calls:
# - All stations recording water levels within 9km of the centre of Trafford: https://environment.data.gov.uk/flood-monitoring/id/stations?lat=53.41671&long=-2.36572&dist=9&parameter=level
# - Get the data from a specific station (which includes historic highs, lows etc.: https://environment.data.gov.uk/flood-monitoring/id/stations/692727 (.json)
# - Get the latest reading from a specific station: https://environment.data.gov.uk/flood-monitoring/id/measures/692727-level-stage-i-15_min-m/readings?latest
# - Get the latest 7 days worth of data from a specific station: https://environment.data.gov.uk/flood-monitoring/id/stations/692727/readings?_sorted&_limit=672
# NOTE: 692727 is Flixton Bridge.  Readings are taken every 15 minutes, so 4 readings per hour for 7 days = 672 stated as the _limit parameter


# Load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(httr) ; library(jsonlite) ; library(lubridate)


# Monitoring stations covering the Trafford area and environs ---------------------------
# Call the API and attempt to get all stations recording water levels within 9km of the centre of Trafford
api_response <- GET(
    url = 'https://environment.data.gov.uk/flood-monitoring/id/stations?lat=53.41671&long=-2.36572&dist=9&parameter=level',
    timeout(50)
)

# After examining the API response, pull out the data we're interested in ("items") into a tibble
monitoring_stations_raw <- fromJSON(content(api_response, as = "text"), flatten = TRUE) %>%
    pluck("items") %>% 
    as_tibble() 

# Tidy up the variables
monitoring_stations <- monitoring_stations_raw %>%
    rename(lon = long,
           station_name = label,
           station_reference = stationReference,
           river_name = riverName,
           catchment_name = catchmentName) %>%
    mutate(station_reference = as.numeric(station_reference)) %>%
    select(station_name, station_reference, river_name, catchment_name, town, lon, lat)
    

# Historic data from the chosen monitoring stations ---------------------------
# Call the API again based on all the monitoring station IDs we've obtained and retrieve the record highs, lows and typical range

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
            rename(typical_range_low = typicalRangeLow,
                   typical_range_high = typicalRangeHigh) %>%
            mutate(station_reference = .station_ref) %>%
            select(station_reference, typical_range_low, typical_range_high) %>%
            head(1) # due to the "items" list containing 3 sub lists (recentHigh, highOnRecord, minOnRecord), the dataframe/tibble contains 3 identical rows, so here we just pick the first row
        
        # Lowest level on record
        df_tmp <- df_tmp %>%
            left_join(
                historic_levels_raw %>%
                    pluck("minOnRecord") %>%
                    as_tibble() %>% # turn list into a tibble so we can work with the data like a dataframe
                    rename(record_low_date = dateTime,
                           record_low = value) %>%
                    mutate(station_reference = .station_ref,
                           record_low_date = as.character(date(record_low_date))) %>%
                    select(station_reference, record_low, record_low_date)
            )
        
        # Highest level on record
        df_tmp <- df_tmp %>%
            left_join(
                historic_levels_raw %>%
                    pluck("maxOnRecord") %>%
                    as_tibble() %>% # turn list into a tibble so we can work with the data like a dataframe
                    rename(record_high_date = dateTime,
                           record_high = value) %>%
                    mutate(station_reference = .station_ref,
                           record_high_date = as.character(date(record_high_date))) %>%
                    select(station_reference, record_high, record_high_date)
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
           across(ends_with(c("_low", "_high")), round, 2)) %>% # Convert all water levels to 2 decimal places
    select(station_name, station_reference, lon, lat, river_name, catchment_name, town, measure, unit, typical_range_low, typical_range_high, record_low, record_high, record_low_date, record_high_date)


# write data  ---------------------------
file.remove("water_level_monitoring_stations_trafford_and_environs.geojson") # first remove the previous file

monitoring_stations %>%
    write_csv("water_level_monitoring_stations_trafford_and_environs.csv") %>% # write out the CSV as-is from above, then make changes for the GeoJSON output below to make it more presentable
    mutate(measure = "Water level in metres (m)",
           typical_range = if_else(is.na(typical_range_low), "Not available", paste0(typical_range_low, "m - ", typical_range_high, "m")),
           record_low = if_else(is.na(record_low), "Not available", paste0(record_low, "m (", record_low_date, ")")),
           record_high = if_else(is.na(record_high), "Not available", paste0(record_high, "m (", record_high_date, ")")),
           latest_levels_url = paste0("https://environment.data.gov.uk/flood-monitoring/id/measures/", station_reference, "-level-stage-i-15_min-m/readings.html?__htmlView=table&_sorted")) %>%
    mutate(across(c(river_name, catchment_name, town), ~replace_na(., "Not available"))) %>%
    st_as_sf(coords = c("lon", "lat")) %>% 
    st_set_crs(4326) %>%
    select(station_name, station_reference, river_name, catchment_name, town, measure, typical_range, record_low, record_high, latest_levels_url) %>%
    st_write("water_level_monitoring_stations_trafford_and_environs.geojson", driver = "GeoJSON")

    