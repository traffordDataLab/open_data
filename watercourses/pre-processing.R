## OS Open Rivers ##

# Source: Ordnance Survey
# Publisher URL: https://www.ordnancesurvey.co.uk/products/os-open-rivers
#                https://osdatahub.os.uk/downloads/open/OpenRivers
# Licence: Open Government Licence 3.0
# Attribution: (C) Crown copyright and database rights. Ordnance Survey 2025
# Last Updated: 2025-02-21


# Load libraries ---------------------------
library(tidyverse) ; library(sf)


# Load the boundaries of Trafford and GM ---------------------------
trafford <- read_sf("http://trafforddatalab.io/spatial_data/local_authority/2021/trafford_local_authority_full_resolution.geojson")
gm <- read_sf("http://trafforddatalab.io/spatial_data/combined_authority/2017/GM_combined_authority_full_resolution.geojson")

# Create a boundary of Trafford with a 10km buffer around it
trafford_with_buffer <- trafford %>%
    st_buffer(10000)


# Download the Watercourses dataset for the whole of GB from Ordnance Survey ---------------------------
data_files <- c("data/WatercourseLink.dbf", "data/WatercourseLink.prj", "data/WatercourseLink.shp", "data/WatercourseLink.shx") # These are the Shapefiles we're interested in from the download
download.file("https://api.os.uk/downloads/v1/products/OpenRivers/downloads?area=GB&format=ESRI%C2%AE+Shapefile&redirect", dest = "oprvrs_essh_gb.zip")
unzip("oprvrs_essh_gb.zip", files = data_files) # just un-zip the files we want, leave the rest


# Load in the GB Watercourses dataset shapefile and tidy the data ---------------------------
watercourses_gb <- read_sf("data/WatercourseLink.shp") %>%
    st_transform(crs = 4326)

watercourses_gb_tidy <- watercourses_gb %>%
    rename(id = identifier,
           start_node_id = startNode,
           end_node_id = endNode,
           length_in_metres = length,
           name = name1,
           alternative_name = name2) %>%
    mutate(form = case_when(form == "inlandRiver" ~ "inland river",
                            form == "tidalRiver" ~ "tidal river",
                            TRUE ~ form),
           form_description = case_when(form == "canal" ~ "A human-made watercourse originally created for inland navigation.",
                                   form == "inland river" ~ "A river or stream that is not influenced by normal tidal action.",
                                   form == "lake" ~ "A large area of non-tidal water without an obvious flow that is enclosed by land.",
                                   form == "tidal river" ~ "Tidal river or stream (that is, below Normal Tidal Limit).",
                                   TRUE ~ "")) %>%
    select(name, alternative_name, form, form_description, length_in_metres, id, start_node_id, end_node_id, geometry)


# Crop the GB dataset to the different boundaries ---------------------------
watercourses_trafford <- watercourses_gb_tidy %>%
    st_intersection(trafford) %>%
    select(-lat, -lon) # These are the centroid coordinates of Trafford - doesn't make sense to have them in this dataset

watercourses_trafford_buffer <- watercourses_gb_tidy %>%
    st_intersection(trafford_with_buffer) %>%
    select(-area_code, -area_name, -lat, -lon) # As this is a dataset cropped to Trafford plus a buffer it isn't correct to associate Trafford's area code and name when the link might be outside Trafford's boundary

watercourses_gm <- watercourses_gb_tidy %>%
    st_intersection(gm) %>%
    select(-lat, -lon) # These are the centroid coordinates of GM - doesn't make sense to have them in this dataset


# Tidy up the filesystem, removing the downloaded files and previous cropped data ---------------------------
file.remove(data_files,
            "data",
            "oprvrs_essh_gb.zip",
            "trafford_watercourses.geojson",
            "trafford_buffer_watercourses.geojson",
            "gm_watercourses.geojson")


# Create the new cropped datasets ---------------------------
write_sf(watercourses_trafford, "trafford_watercourses.geojson", driver = "GeoJSON")
write_sf(watercourses_trafford_buffer, "trafford_buffer_watercourses.geojson", driver = "GeoJSON")
write_sf(watercourses_gm, "gm_watercourses.geojson", driver = "GeoJSON")
