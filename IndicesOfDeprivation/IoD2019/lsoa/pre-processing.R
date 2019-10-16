# English indices of deprivation 2019 #

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/announcements/english-indices-of-deprivation-2019
# Licence: Open Government Licence 3.0

library(tidyverse) ; library(janitor)

df <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833982/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators.csv") %>% 
  clean_names() %>% 
  select(lsoa11cd = 1, lsoa11nm = 2, lad19cd = 3, lad19nm = 4, 5:34) %>% 
  gather(variable, value, -lsoa11cd, -lsoa11nm, -lad19cd, -lad19nm) %>% 
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
  select(lsoa11cd, lsoa11nm, lad19cd, lad19nm, measure, value, index_domain) %>% 
  spread(measure, value) %>% 
  mutate(year = "2019")

write_csv(df, "IoD2019.csv")
