## Median property prices, 2017 ##

# Source: Land Registry, Price Paid Data
# Publisher URL: https://data.gov.uk/dataset/land-registry-monthly-price-paid-data
# Licence: Open Government Licence

# Inclusion and exclusion criteria
# - excludes property transactions where property type is recorded as "otherPropertyType"
# - includes only "standardPricePaidTransaction" transactions 

# load libraries ---------------------------
library(tidyverse) ; library(SPARQL) ; library(sf) 

# load data ---------------------------
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

query <- paste0("
PREFIX xsd:     <http://www.w3.org/2001/XMLSchema#>
PREFIX rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:    <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl:     <http://www.w3.org/2002/07/owl#>
PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>
PREFIX lrppi:   <http://landregistry.data.gov.uk/def/ppi/>
PREFIX lrcommon: <http://landregistry.data.gov.uk/def/common/>
                
SELECT ?date ?paon ?saon ?street ?town ?district ?county ?postcode ?propertytype ?transactiontype ?amount
WHERE {
?transx lrppi:pricePaid ?amount ;
lrppi:transactionDate ?date ;
lrppi:propertyAddress ?addr ;
lrppi:transactionCategory ?transactiontype ;
lrppi:propertyType ?propertytype .
                
?addr lrcommon:county 'GREATER MANCHESTER'^^xsd:string .

FILTER ( ?date >= '2017-01-01'^^xsd:date )
FILTER ( ?date <= '2017-12-31'^^xsd:date )
FILTER ( ?propertytype != lrcommon:otherPropertyType )
FILTER ( ?transactiontype != lrppi:additionalPricePaidTransaction )

OPTIONAL {?addr lrcommon:paon ?paon .}
OPTIONAL {?addr lrcommon:saon ?saon .}
OPTIONAL {?addr lrcommon:street ?street .}
OPTIONAL {?addr lrcommon:town ?town .}
OPTIONAL {?addr lrcommon:district ?district .}
OPTIONAL {?addr lrcommon:county ?county .}
OPTIONAL {?addr lrcommon:postcode ?postcode .}
}
ORDER BY ?date
")

df <- SPARQL(endpoint,query)$results

# tidy data ---------------------------
df_tidy <- df %>% 
  mutate(date = as.POSIXct(date, origin = '1970-01-01'))

# geocode data ---------------------------
# source: ONS Postcode Directory
postcodes <- read_csv("https://opendata.arcgis.com/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>%
  select(postcode = pcds, lat, long)
df_geocoded <- left_join(df_tidy, postcodes, by = "postcode")

# convert to geospatial data ---------------------------
sf <- df_geocoded %>%  
  filter(!is.na(long)) %>%
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326)

# spatial join ---------------------------
wards <- st_read("https://www.traffordDataLab.io/spatial_data/ward/2017/gm_ward_full_resolution.geojson")
wards_sf <- st_join(sf, wards, join = st_within, left = FALSE) 

lsoa <- st_read("https://www.traffordDataLab.io/spatial_data/lsoa/2011/gm_lsoa_full_resolution.geojson")
lsoa_sf <- st_join(sf, lsoa, join = st_within, left = FALSE) 

# summary statistics ---------------------------
wards_df <- wards_sf %>% 
  st_set_geometry(value = NULL) %>% 
  group_by(area_code, area_name) %>% 
  summarise(median_price = as.integer(median(amount)),
            min_price = as.integer(min(amount)),
            max_price = as.integer(max(amount)),
            transactions = n()) %>%
  arrange(median_price)

lsoa_df <- lsoa_sf %>% 
  st_set_geometry(value = NULL) %>% 
  group_by(area_code, area_name) %>% 
  summarise(median_price = as.integer(median(amount)),
            min_price = as.integer(min(amount)),
            max_price = as.integer(max(amount)),
            transactions = n()) %>%
  mutate(median_price = as.integer(median_price)) %>% 
  arrange(median_price)

# write data ---------------------------
wards_df %>%
  write_csv("gm_ward_median_property_prices.csv")

lsoa_df %>%
  write_csv("gm_lsoa_median_property_prices.csv")

filter(wards_df, area_code %in% c(paste0("E0", 5000819:5000839))) %>%
  write_csv("trafford_ward_median_property_prices.csv")            

filter(lsoa_df, area_code %in% c(paste0("E0", 1006074:1006211))) %>% 
  write_csv("trafford_lsoa_median_property_prices.csv") 
