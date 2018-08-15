## Median property prices, 2017 ##

# Source: Land Registry
# Publisher URL: https://data.gov.uk/dataset/land-registry-monthly-price-paid-data
# Licence: Open Government Licence

# Notes: excludes sales where propertyType is recorded as "otherPropertyType"

# load libraries ---------------------------
library(tidyverse) ; library(SPARQL) ; library(sf) 

# load data ---------------------------
endpoint <- "http://landregistry.data.gov.uk/landregistry/query"

query <- paste0("
PREFIX xsd:     <http://www.w3.org/2001/XMLSchema#>
PREFIX rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:    <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl:     <http://www.w3.org/2002/07/owl#>
PREFIX lrppi:   <http://landregistry.data.gov.uk/def/ppi/>
PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>
PREFIX lrcommon: <http://landregistry.data.gov.uk/def/common/>
                
SELECT ?date ?paon ?saon ?street ?town ?district ?county ?postcode ?propertytype ?amount
WHERE {
?transx lrppi:pricePaid ?amount ;
lrppi:transactionDate ?date ;
lrppi:propertyAddress ?addr ;
lrppi:propertyType ?propertytype .
                
?addr lrcommon:district 'TRAFFORD'^^xsd:string .

FILTER ( ?date >= '2017-01-01'^^xsd:date )
FILTER ( ?date <= '2017-12-31'^^xsd:date )
FILTER ( ?propertytype != lrcommon:otherPropertyType )
                
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
# source: http://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-latest-centroids
postcodes <- read_csv("https://opendata.arcgis.com/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>%
  select(postcode = pcds, lat, long)
df_geocoded <- left_join(df_tidy, postcodes, by = "postcode")

# convert to geospatial data ---------------------------
sf <- df_geocoded %>%  
  filter(!is.na(long)) %>%
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326)

# spatial join ---------------------------
wards <- st_read("https://www.traffordDataLab.io/spatial_data/ward/2017/trafford_ward_full_resolution.geojson")
sf <- st_join(sf, wards, join = st_within, left = FALSE) 

# write data ---------------------------
sf %>% 
  st_set_geometry(value = NULL) %>% 
  group_by(area_name) %>% 
  summarise(median = median(amount)) %>% 
  arrange(median) %>% 
  write_csv("ward_median_property_prices.csv")


            
