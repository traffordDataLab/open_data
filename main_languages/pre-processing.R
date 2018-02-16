## Main languages ##
# Source: 2011 Census
# Publisher URL: https://www.nomisweb.co.uk/census/2011/qs204ew
# Licence: Open Government Licence

# load libraries
library(tidyverse) ; library(stringr)

# load data ---------------------------
df <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/nm_525_1.bulk.csv?time=latest&measures=20100&rural_urban=total&geography=TYPE295")
lookup <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/lookups/ward_to_local_authority.csv") %>% 
  select(area_code = ward_code, la_code, la_name)
ward_codes <- pull(lookup, area_code)

# tidy data ---------------------------
df_tidy <- df %>% 
  select(-c(date, `Rural Urban`), 
         -contains("Total"),
         area_code = `geography code`, area_name = geography, `All languages` = `Main Language: All usual residents aged 3 and over; measures: Value`) %>% 
  filter(area_code %in% ward_codes) %>% 
  gather(language, n, -area_code, -area_name) %>% 
  mutate(language = str_replace(language, "Main Language: ", "")) %>% 
  mutate(language = str_replace(language, "African Language: |Caribbean Creole: |East Asian Language: |Other European Language \\(EU\\): |Other European Language \\(non EU\\): |Other European Language \\(non-national\\): |Other Languages: |Other UK language: |Sign Language: |South Asian Language: |West/Central Asian Language: ", "")) %>% 
  mutate(language = str_replace(language, "; measures: Value", "")) %>% 
  spread(language, n) %>% 
  select(area_code, area_name, `All languages`, everything()) %>% 
  left_join(., lookup) %>% 
  select(ward_code = area_code, ward_name = area_name, la_code, la_name, everything())

# write data   ---------------------------
write_csv(df_tidy, "main_languages.csv")
