## Indices of Multiple Deptivation 2015 ##
# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
# Licence: Open Government Licence 3.0

# load libraries ---------------------------
library(tidyverse) ; library(sf) ; library(stringi) ; library(forcats)

# load data ---------------------------
imd <- read_csv("http://opendatacommunities.org/downloads/cube-table?uri=http%3A%2F%2Fopendatacommunities.org%2Fdata%2Fsocietal-wellbeing%2Fimd%2Findices") %>% 
  select(lsoa11cd = FeatureCode, measure = Measurement, value = Value, index_domain = `Indices of Deprivation`) %>% 
  mutate(index_domain = as.factor(stri_sub(index_domain, 4)))

lsoa <- st_read("https://www.traffordDataLab.io/spatial_data/lsoa/2011/gm_lsoa_full_resolution.geojson") %>% 
  rename(lsoa11cd = area_code, lsoa11nm = area_name)

lsoa_codes <- lsoa %>% pull(lsoa11cd)

# subset IMD 2015 data by GM LSOAs ---------------------------
df <- filter(imd, lsoa11cd %in% lsoa_codes)

# recode domains ---------------------------
df <- mutate(df, 
             index_domain = fct_recode(index_domain, 
                                       "Index of Multiple Deprivation" = "Index of Multiple Deprivation (IMD)",
                                       "Income" = "Income Deprivation Domain",
                                       "Employment" = "Employment Deprivation Domain",
                                       "Education, Skills and Training" = "Education, Skills and Training Domain",
                                       "Health Deprivation and Disability" = "Health Deprivation and Disability Domain",
                                       "Crime" = "Crime Domain",
                                       "Barriers to Housing and Services" = "Barriers to Housing and Services Domain",
                                       "Living Environment" = "Living Environment Deprivation Domain"))

# write results ---------------------------
write_csv(df, "IMD_2015_long.csv") # long format

df_wide <- df %>% spread(measure, value) %>% # wide format
  rename(score = Score, rank = Rank, decile = Decile)
write_csv(df_wide, "IMD_2015_wide.csv")

# write as geospatial data ---------------------------
sf <- left_join(lsoa, subset(df_wide, index_domain == "Index of Multiple Deprivation"), by = "lsoa11cd")

sf %>% 
  mutate(fill = 
           case_when(
             decile == "1" ~ "#A31A31",
             decile == "2" ~ "#D23B33",
             decile == "3" ~ "#EB6F4A",
             decile == "4" ~ "#FCB562",
             decile == "5" ~ "#F4D78D",
             decile == "6" ~ "#D8E9EC",
             decile == "7" ~ "#AAD1DE",
             decile == "8" ~ "#75A8C8",
             decile == "9" ~ "#4D77AE",
             decile == "10" ~ "#353B91"),
         `fill-opacity` = "0.4",
         stroke = "#757575",
         `stroke-width` = "0.7",
         `stroke-opacity` = 1) %>% 
  st_write("IMD_2015.geojson")
