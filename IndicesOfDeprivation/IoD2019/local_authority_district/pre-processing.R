# English indices of deprivation 2019 #

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019
# Licence: Open Government Licence 3.0

library(tidyverse) ; library(janitor) ; library(httr) ; library(readxl) 

url <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833995/File_10_-_IoD2019_Local_Authority_District_Summaries__lower-tier__.xlsx"
GET(url, write_disk(tmp <- tempfile(fileext = ".xlsx")))
sheets <- excel_sheets(tmp) 
df <- set_names(sheets[2:11]) %>% 
  map_df(~ read_xlsx(path = tmp, sheet = .x, range = "A1:H318", col_names = FALSE), .id = "sheet") %>% 
  filter(`...1` != "Local Authority District code (2019)") %>% 
  select(index_domain = sheet, 
         lad19cd = `...1`,
         lad19nm = `...2`,
         average_rank = `...3`,
         rank_average_rank = `...4`,
         average_score = `...5`,
         rank_average_score = `...6`,
         proportion_bottom_decile = `...7`,
         rank_proportion_bottom_decile = `...8`) %>% 
  mutate(index_domain = case_when(
    index_domain == "IMD" ~ "Index of Multiple Deprivation", 
    index_domain == "Income" ~ "Income",
    index_domain == "Employment" ~ "Employment",
    index_domain == "Education" ~ "Education, Skills and Training",
    index_domain == "Health" ~ "Health and Disability",
    index_domain == "Crime" ~ "Crime",
    index_domain == "Barriers" ~ "Barriers to Housing and Services",
    index_domain == "Living" ~ "Living Environment",
    index_domain == "IDACI" ~ "Income Deprivation Affecting Children",
    index_domain == "IDAOPI" ~ "Income Deprivation Affecting Older People")) %>% 
  select(lad19cd, lad19nm, everything()) %>% 
  mutate(year = "2019")

write_csv(df, "IoD2019.csv")
