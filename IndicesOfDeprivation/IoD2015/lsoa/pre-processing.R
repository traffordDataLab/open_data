# English indices of deprivation 2015 #

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
# Licence: Open Government Licence 3.0

library(tidyverse) ; library(janitor)

df <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/467774/File_7_ID_2015_All_ranks__deciles_and_scores_for_the_Indices_of_Deprivation__and_population_denominators.csv") %>% 
  clean_names() %>% 
  select(lsoa11cd = 1, lsoa11nm = 2, 5:34) %>% 
  gather(variable, value, -lsoa11cd, -lsoa11nm) %>% 
  mutate(measure = case_when(str_detect(variable, "score") ~ "score", 
                             str_detect(variable, "decile") ~ "decile", 
                             str_detect(variable, "rank") ~ "rank"),
         index_domain = case_when(str_detect(variable, "index_of_multiple_deprivation") ~ "Index of Multiple Deprivation", 
                                  str_detect(variable, "employment") ~ "Employment",
                                  str_detect(variable, "education") ~ "Education, Skills and Training",
                                  str_detect(variable, "health") ~ "Health and Disability",
                                  str_detect(variable, "crime") ~ "Crime",
                                  str_detect(variable, "barriers") ~ "Barriers to Housing and Services",
                                  str_detect(variable, "living") ~ "Living Environment",
                                  str_detect(variable, "idaci") ~ "Income Deprivation Affecting Children",
                                  str_detect(variable, "idaopi") ~ "Income Deprivation Affecting Older People",
                                  TRUE ~ "Income")) %>% 
  select(lsoa11cd, lsoa11nm, measure, value, index_domain) %>% 
  spread(measure, value) %>% 
  mutate(year = "2015")

# Create LSOA > LA lookup for 2019 boundaries using IoD2019 data
lookup <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833982/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators.csv") %>% 
  clean_names() %>% 
  select(lsoa11cd = 1, lad19cd = 3, lad19nm = 4) %>% 
  distinct(lsoa11cd, .keep_all = TRUE)

# Join data
reaggregated_df <- left_join(df, lookup, by = "lsoa11cd") %>% 
  select(lsoa11cd, lsoa11nm, lad19cd, lad19nm, everything())

# Write results
write_csv(reaggregated_df, "IoD2015.csv")
