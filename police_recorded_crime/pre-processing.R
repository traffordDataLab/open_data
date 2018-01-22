## Greater Manchester Police crime data ##

# download crime data from data.police.uk
# unzip the folders and place all of the CSV files into a single folder called 'data'

# load the necessary R packages
library(tidyverse) ; library(sf) ; library(zoo)

# set the working directory to the folder where the CSV files are stored
setwd("../data")

# find all file names in the 'data' folder that end in .csv
filenames <- dir(pattern = "*.csv")

# read in the files, combine them into one data frame and rename the variables
results <- filenames %>% 
  map(read_csv) %>%
  reduce(rbind) %>% 
  select(month = Month,
         category = `Crime type`,
         location = Location,
         long = Longitude,
         lat = Latitude)

# convert to a simple features object
results_sf <- results %>%
  st_as_sf(crs = 4326, coords = c("long", "lat"))

# load the ward layer
wards <- st_read("https://github.com/traffordDataLab/spatial_data/raw/master/ward/2017/gm_ward_full_resolution.geojson") %>% 
  st_transform(crs = 4326) %>% 
  select(area_code, area_name)

# run point in polygon to obtain ward names and change variable types
crimes_sf <- st_join(results_sf, wards, join = st_within, left = FALSE) %>% 
  mutate(category = factor(category),
         month = as.Date(as.yearmon(month)))

# extract the coordinates
coords <- st_coordinates(crimes_sf)
crimes_sf$long <- coords[,1]
crimes_sf$lat <- coords[,2]

# convert to a data frame
crimes_df <- crimes_sf %>% 
  st_set_geometry(value = NULL) %>% 
  mutate(category = factor(category),
         month = as.Date(as.yearmon(month))) %>% 
  select(month, category, location, area_code, area_name, long, lat)

# write GM crime data using *.gz compression
write_csv(crimes_df, gzfile("crime_data/gm.csv.gz"))

# filter data by local authority and write
lookup <- read_csv("https://opendata.arcgis.com/datasets/046394602a6b415e9fe4039083ef300e_0.csv")
la <- c("Bolton","Bury","Manchester","Oldham","Rochdale","Salford","Stockport","Tameside","Trafford","Wigan")

for(la_search in la){
  
  codes <- lookup %>% 
    filter(LAD17NM == la_search) %>% 
    pull(WD17CD)
  
  la_crimes <- crimes_df %>% 
    filter(area_code %in% codes)
  
  la_name <- paste0(la_search, ".csv")
  write_csv(la_crimes, tolower(la_name))
  
}
