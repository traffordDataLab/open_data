# Conservation Areas in Trafford where Trafford Council is the Local Planning Authority (LPA) responsible for the area.
# Created 2024-08-16
# Data updated: 2024-07-24
# Data: https://opendata-historicengland.hub.arcgis.com/datasets/historicengland::conservation-areas/about
# Metadata: https://historicengland.org.uk/listing/the-list/data-downloads
# Licence: Open Government Licence v3 (https://historicengland.org.uk/terms/website-terms-conditions/open-data-hub/)

# NOTES:
# These features are obtained from an ArcGIS API service, similar to that of the ONS Geography Portal.
# The default API call returns features for the whole county, therefore it's best to use some extra parameters, such as defining a rectangle (spatial envelope) around the LA, to reduce the amount of data being returned and speed up the process.


# Required packages ---------
library(tidyverse) ; library(sf) ; library(lubridate)

# =========
# VERY IMPORTANT NOTE REGARDING SF PACKAGE AND COORDINATE WINDING ORDER 2023-12-21:
# The IETF standard for GeoJSON has made certain changes over the original non-IETF specification.  The changes can be viewed here: https://datatracker.ietf.org/doc/html/rfc7946#appendix-B
# One key change is that polygon rings MUST follow the right-hand rule for orientation (counter-clockwise external rings, clockwise internal rings).
# This change has caused issues with certain libraries which have historically used the left-hand rule, i.e. clockwise for outer rings and counter-clockwise for interior rings.
# D3-Geo, Vega-Lite and versions of sf below 1.0.0 (default behaviour) use the GEOS library for performing flat-space calculations, known as R^2 (R-squared) which produce polygons wound to the left-hand rule.
# The sf package from version 1.0.0 onwards now uses the S2 library by default which performs S^2 (S-squared) spherical calculations and returns polygons wound according to the right-hand rule.
# At the time of writing, if we want our geography files to work in D3 and Vega-Lite, they must use the left-hand rule and so we need sf to use the GEOS library not S2.
# More information regarding this can be found at: https://r-spatial.github.io/sf/articles/sf7.html#switching-between-s2-and-geos
# =========
sf_vers <- package_version(packageVersion('sf')) # packageVersion returns a character string, package_version converts that into numeric version numbers (major.minor.patch) e.g. 1.0.0

# Only run the following if we are using sf version 1.0.0 or above
if (sf_vers$major >= 1) {
    useS2 <- sf_use_s2()    # store boolean to indicating if sf is currently using the s2 spherical geometry package for geographical coordinate operations
    sf_use_s2(FALSE)        # force sf to use R^2 flat space calculations using GEOS which returns polygons with left-hand windings
}


# API parameters specifying the spatial rectangular area containing Trafford
api_geommetry_envelope <- "&geometryType=esriGeometryEnvelope&geometry=%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22xmin%22%3A-278455.35481123265%2C%22ymin%22%3A7047642.057770884%2C%22xmax%22%3A-244823.0623658004%2C%22ymax%22%3A7073592.428873666%2C%22type%22%3A%22esriGeometryEnvelope%22%7D"


# Local authority district -------------------------
# Source: ONS Open Geography Portal
# URL: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-may-2023-boundaries-uk-bfc/about
# Licence: OGL v3.0
# NOTE: we need the LA boundary stored as an sf object for use in st_intersection() calculations for other boundaries/features
#       we use the full resolution version as this ensures any features near the border are included/not included correctly
la <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_May_2023_UK_BFC_V2/FeatureServer/0/query?outFields=*&where=UPPER(lad23cd)%20like%20%27%25E08000009%25%27&f=geojson") %>%
  select(area_code = LAD23CD, area_name = LAD23NM)


# Get the information for items within Trafford -------------------------
df_conservation_areas <- st_read(paste0("https://services-eu1.arcgis.com/ZOdPfBS3aqqDYPUQ/arcgis/rest/services/Conservation_Areas/FeatureServer/1/query?outFields=*&where=1%3D1&f=geojson", api_geommetry_envelope)) %>% 
  st_intersection(la) %>%
  filter(LPA == "Trafford") %>% # This is required as there are 4 conservation areas touching the Trafford boundary which are the responsibility of neighbouring LAs
  st_cast('POLYGON', warn=F) # The Ashton upon Mersey area is a multipolygon which causes issues in Explore and Plotter. Checking on the source data map shows no requirement for this to be a multipolygon, so converting to a simple polygon instead.

# Process the dataset, renaming and creating required variables
df_conservation_areas <- df_conservation_areas %>%
    rename(site_name = NAME,
           site_area_square_metres = Shape__Area,
           risk_survey_reference = UID) %>%
    mutate(lon = map_dbl(geometry, ~st_centroid(.x)[[1]]), # Calculate the coordinates of the area's centroid as a "lat" and "lon" property
           lat = map_dbl(geometry, ~st_centroid(.x)[[2]]),
           site_area_square_metres = as.numeric(str_trim(format(site_area_square_metres, nsmall = 2))),
           site_area_hectares = format(site_area_square_metres / 10000, nsmall = 2),
           designation_date = if_else(DATE_OF_DE == "02/1976", dmy("01/02/1976"), dmy(DATE_OF_DE))) %>%
    select(site_name,
           site_area_hectares,
           site_area_square_metres,
           designation_date,
           risk_survey_reference,
           lon,
           lat)


# Create the Conservation Areas files for Trafford -------------------------
st_write(df_conservation_areas, "trafford_conservation_areas.geojson")

df_conservation_areas %>%
    st_drop_geometry() %>%
    write_csv("trafford_conservation_areas.csv")


# Ensure sf_use_s2() is reset to the state it was in before running the code above, i.e. whether to use the S2 library (for S^2 spherical coordinates) or GEOS (for R^2 flat space coordinates). Only if using v1 or above of the sf package
if (sf_vers$major >= 1) sf_use_s2(useS2)
