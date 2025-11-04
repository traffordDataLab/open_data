# English indices of deprivation 2025: Data by Local Authority District #

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2025
# Licence: Open Government Licence 3.0

library(tidyverse) ; library(janitor) ; library(httr) ; library(readxl) 

url <- "https://assets.publishing.service.gov.uk/media/68ff7e26d81972ecd2df5db1/File_10_-_IoD2025_Local_Authority_District_Summaries__lower-tier_.xlsx"
GET(url, write_disk(tmp <- tempfile(fileext = ".xlsx")))
sheets <- excel_sheets(tmp) 
df <- set_names(sheets[2:11]) %>% 
  map_df(~ read_xlsx(path = tmp, sheet = .x, range = "A1:H297", col_names = FALSE), .id = "sheet") %>% 
  filter(`...1` != "Local Authority District code (2024)") %>% 
  select(index_domain = sheet, 
         area_code = `...1`,
         area_name = `...2`,
         average_rank = `...3`,
         rank_average_rank = `...4`,
         average_score = `...5`,
         rank_average_score = `...6`,
         proportion_bottom_decile = `...7`,
         rank_proportion_bottom_decile = `...8`) %>% 
  mutate(index_domain = case_when(index_domain == "IMD" ~ "Index of Multiple Deprivation", 
                                  index_domain == "Income" ~ "Income Deprivation",
                                  index_domain == "Employment" ~ "Employment Deprivation",
                                  index_domain == "Education" ~ "Education, Skills and Training Deprivation",
                                  index_domain == "Health" ~ "Health Deprivation and Disability",
                                  index_domain == "Crime" ~ "Crime",
                                  index_domain == "Barriers" ~ "Barriers to Housing and Services",
                                  index_domain == "Living" ~ "Living Environment Deprivation",
                                  index_domain == "IDACI" ~ "Income Deprivation Affecting Children",
                                  index_domain == "IDAOPI" ~ "Income Deprivation Affecting Older People"),
         area_type = "Local Authority District (2024)",
         deprivation_data_year = 2025,
         average_rank = as.numeric(average_rank),
         rank_average_rank = as.numeric(rank_average_rank),
         average_score = as.numeric(average_score),
         rank_average_score = as.numeric(rank_average_score),
         proportion_bottom_decile = as.numeric(proportion_bottom_decile),
         rank_proportion_bottom_decile = as.numeric(rank_proportion_bottom_decile)) %>%
  arrange(area_code) %>%
  select(area_code, area_name, area_type, deprivation_data_year, everything())

write_csv(df, "indices_of_deprivation_2025_lad.csv")
