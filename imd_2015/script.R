##  Processing IMD 2015 data ##

library(tidyverse) ; library(sf) ; library(stringi) ; library(forcats)

# ------- load IMD 2015 data
# source: http://opendatacommunities.org/data/societal-wellbeing/imd/indices
imd <- read_csv("http://opendatacommunities.org/downloads/cube-table?uri=http%3A%2F%2Fopendatacommunities.org%2Fdata%2Fsocietal-wellbeing%2Fimd%2Findices") %>% 
  select(lsoa11cd = GeographyCode, measure = Measurement, value = Value, index_domain = `Indices of Deprivation`) %>% 
  mutate(index_domain = as.factor(stri_sub(index_domain, 4)))

# ------- extract LSOA codes for GM
# source: http://geoportal.statistics.gov.uk/
lsoa_codes <- st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_3.geojson") %>% 
  filter(grepl('Bolton|Bury|Manchester|Oldham|Rochdale|Salford|Stockport|Tameside|Trafford|Wigan', lsoa11nm)) %>% 
  pull(lsoa11cd)

# ------- filter IMD 2015 data by GM LSOAs
df <- filter(imd, lsoa11cd %in% lsoa_codes)

# ------- recode domains
df <- mutate(df, index_domain = fct_recode(index_domain, 
                                           "Index of Multiple Deprivation" = "Index of Multiple Deprivation (IMD)",
                                           "Income" = "Income Deprivation Domain",
                                           "Employment" = "Employment Deprivation Domain",
                                           "Education Skills and Training" = "Education, Skills and Training Domain",
                                           "Health Deprivation and Disability" = "Health Deprivation and Disability Domain",
                                           "Crime" = "Crime Domain",
                                           "Barriers to Housing and Services" = "Barriers to Housing and Services Domain",
                                           "Living Environment" = "Living Environment Deprivation Domain"))

# ------- write results (long format)
write_csv(df, "IMD_2015_long.csv")

# ------- write results (wide format)
df %>% spread(measure, value) %>% 
  rename(score = Score, rank = Rank, decile = Decile) %>% 
  write_csv("IMD_2015_wide.csv")
