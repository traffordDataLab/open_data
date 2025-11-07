# English indices of deprivation 2025: Data by LSOA #

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/announcements/english-indices-of-deprivation-2025
# Licence: Open Government Licence 3.0

library(tidyverse) ; library(janitor)

df <- read_csv("https://assets.publishing.service.gov.uk/media/68ff5daabcb10f6bf9bef911/File_7_IoD2025_All_Ranks_Scores_Deciles_Population_Denominators.csv") %>% 
  clean_names() %>% 
  select(area_code = 1, area_name = 2, la_code = 3, la_name = 4, 5:34) %>% 
  gather(variable, value, -area_code, -area_name, -la_code, -la_name) %>% 
  mutate(measure = case_when(str_detect(variable, "score") ~ "score", 
                             str_detect(variable, "decile") ~ "decile", 
                             str_detect(variable, "rank") ~ "rank"),
         index_domain = case_when(str_detect(variable, "index_of_multiple_deprivation") ~ "Index of Multiple Deprivation",
                                  str_detect(variable, "employment") ~ "Employment Deprivation",
                                  str_detect(variable, "education") ~ "Education, Skills and Training Deprivation",
                                  str_detect(variable, "health") ~ "Health Deprivation and Disability",
                                  str_detect(variable, "crime") ~ "Crime",
                                  str_detect(variable, "barriers") ~ "Barriers to Housing and Services",
                                  str_detect(variable, "living") ~ "Living Environment Deprivation",
                                  str_detect(variable, "idaci") ~ "Income Deprivation Affecting Children",
                                  str_detect(variable, "idaopi") ~ "Income Deprivation Affecting Older People",
                                  TRUE ~ "Income Deprivation")) %>%
  select(area_code, area_name, la_code, la_name, measure, value, index_domain) %>%
  spread(measure, value) %>%
  mutate(area_type = "Lower-layer Super Output Area (2021)",
         la_type = "Local Authority District (2024)",
         deprivation_data_year = 2025) %>%
  select(area_code, area_name, area_type, la_code, la_name, la_type, deprivation_data_year, index_domain, decile, rank, score) %>%
  arrange(area_name, index_domain)
    
write_csv(df, "indices_of_deprivation_2025_lsoa.csv")
