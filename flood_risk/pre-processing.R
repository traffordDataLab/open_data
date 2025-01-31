## Risk of Flooding from Rivers and Sea ##

# Source: Environment Agency
# Publisher URL: https://environment.data.gov.uk/dataset/96ab4342-82c1-4095-87f1-0082e8d84ef1
#                NOTE: previous dataset now retired: https://www.data.gov.uk/dataset/bad20199-6d39-4aad-8564-26a46778fd94/risk-of-flooding-from-rivers-and-sea
# Licence: Open Government Licence 3.0
# Attribution: (C) Environment Agency copyright and/or database right 2025. All rights reserved.
# Last Updated: 2025-01-28
# Update frequency: Quarterly
# The dataset is downloaded from https://environment.data.gov.uk/explore/96ab4342-82c1-4095-87f1-0082e8d84ef1?download=true by uploading a bounding polygon around Trafford. This file is large ~40MB.


# Load libraries ---------------------------
library(tidyverse) ; library(sf)


# Set sf geometry calculation method if required ---------------------------
# Refer to the following for further information: https://github.com/r-spatial/sf/issues/1771
# Uncomment and run the following 2 lines if you encounter issues working with the spatial files
#is_sf_using_s2 <- sf_use_s2() # Store whether sf is using S2 or R2 geometry calculations
#sf_use_s2(FALSE)              # Set sf to use R2 calculations as we get errors using S2


# Convert the boundary of Trafford and its immediate environs (created in Plotter) from GeoJSON into a ShapeFile ---------------------------
read_sf("trafford_and_environs_boundary.geojson") %>%
    # This creates 4 files with the extensions .dbf, .prj, .shp and .shx
    write_sf("trafford_and_environs_boundary.shp", driver = "ESRI Shapefile")

# The above process creates 4 files which we need to ZIP up, create a list with their names so that we can reuse it in the following 2 lines below
shp_files <- c("trafford_and_environs_boundary.dbf", "trafford_and_environs_boundary.prj", "trafford_and_environs_boundary.shp", "trafford_and_environs_boundary.shx")

# Add them to a ZIP ready to upload
zip(zipfile = "trafford_and_environs_boundary", files = shp_files)

# Remove the 4 individual files as they are no longer needed
file.remove(shp_files)


# Manually download the flood risk data from the Environment Agency ---------------------------
# 1. Visit https://environment.data.gov.uk/explore/96ab4342-82c1-4095-87f1-0082e8d84ef1?download=true
# 2. Change the "Area of interest" drop-down to "Upload sharefile"
# 3. Use the "Browse..." button to select the "trafford_and_environs_boundary.zip" file created above
# 4. Change the "Layers" drop-down to "rofs_4band" (NOTE: data is also available for risk of flooding to a depth of 0.2m, 0.3m, 0.6m, 0.9m and 1.2m)
# 5. Change the "File format" drow-down to "GeoJSON"
# 6. Select the "Download file" button
# 7. Copy the downloaded file "rofs_4band.json" from your "Downloads" folder to the "flood_risk" folder containing this script


# Load raw flood risk data and tidy up the variables ---------------------------
trafford_flood_risk <- read_sf("rofrs_4band.json") %>%
    rename(flood_risk = risk_band) %>%
    filter(st_geometry_type(geometry) != "POINT") %>% # Just in case there is any point data, remove it as this will show up as a marker pin on the map which will be confusing. The previous version of this dataset had 6 within Trafford.
    select(object_id = objectid, flood_risk, geometry)


# write data  ---------------------------
file.remove("trafford_flood_risk.geojson") # first remove the previous file
write_sf(trafford_flood_risk, "trafford_flood_risk.geojson", driver = "GeoJSON")


# Clean up the filesystem removing the downloaded flood risk JSON file and the shapefile ZIP ---------------------------
file.remove(c("rofrs_4band.json", "trafford_and_environs_boundary.zip"))

# reset R's spherical geometry if required ---------------------------
#sf_use_s2(is_sf_using_s2) # Reset whether sf is using S2 or R2 geometry calculations
