# Green Flag Awards #

# Source: Ministry of Housing, Communities & Local Government / Keep Britain Tidy
# Publisher URL: http://www.greenflagaward.org.uk
# Licence: Open Government Licence v3.0

# -------- Load required libraries
library(tidyverse) ; library(httr) ; library(jsonlite) ; library(purrr) ; library(sf) ; library(rvest)

# -------- Get the boundary of Greater Manchester
bdy <- st_read("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Local_Authority_Districts_December_2018_Boundaries_UK_BGC/MapServer/0/query?where=lad18nm%20IN%20(%27Bolton%27,%27Bury%27,%27Manchester%27,%27Oldham%27,%27Rochdale%27,%27Salford%27,%27Stockport%27,%27Tameside%27,%27Trafford%27,%27Wigan%27)&outFields=lad18cd,lad18nm&outSR=4326&f=geojson") %>% 
  select(area_code = lad18cd, area_name = lad18nm)

# -------- Get the list of parks that have been awarded the Green Flag and lie within the GM boundary
r <- POST("http://www.greenflagaward.org.uk/umbraco/surface/parks/getparks/")
sf <- content(r, as = "text", encoding = "UTF-8") %>% 
  fromJSON(flatten = TRUE) %>% 
  purrr::pluck("Parks") %>% 
  as_tibble() %>% 
  filter(WonGreenFlagAward == TRUE) %>% 
  mutate(name = str_trim(Title),
         green_flag_page = str_c("http://www.greenflagaward.org.uk/park-summary/?park=", ID),
         lon = as.numeric(as.character(Longitude)),
         lat = as.numeric(as.character(Latitude))) %>% 
  select(name, green_flag_page, lon, lat) %>% 
  arrange(name) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>% 
  st_join(bdy, join = st_within) %>% 
  filter(!is.na(area_code)) %>% 
  select(name, green_flag_page, area_code, area_name) 

# -------- Get the additional information, such as contact details etc. from each individual park page in turn
url <- "http://www.greenflagaward.org.uk/park-summary/?park=%d"
meta <- map_df(as.numeric(gsub("\\D", "", sf$green_flag_page)), function(i) {
  query <- tryCatch(read_html(sprintf(url, i)),
                    error = function(cond) { return(NULL) },
                    warning = function(cond) { return(NULL) },
                    finally = NA)
  if (!is.null(query)) {
    html <- read_html(sprintf(url, i))
    tibble(name = str_trim(html_text(html_nodes(html, "h1"))),
           managed = str_trim(html_text(html_nodes(html, ".item:nth-child(1) .value"))),
           contact = str_trim(html_text(html_nodes(html, ".item:nth-child(2) .value"))),
           telephone = str_trim(html_text(html_nodes(html, ".item:nth-child(3) .value"))),
           email = str_trim(html_text(html_nodes(html, ".item:nth-child(4) .value"))),
           website = str_trim(html_text(html_nodes(html, ":nth-child(5) .value"))))
  }
})

# -------- Join the meta data to the park boundary data obtained earlier
sf_meta <- left_join(sf, meta, by = "name") %>% 
  select(name, managed, contact, telephone, email, website, area_code, area_name)

sf_meta_trafford <- sf_meta %>%
  filter(area_name == "Trafford")

# -------- Write out the spatial files for GM & Trafford
st_write(sf_meta, "gm_green_flags.geojson")
st_write(sf_meta_trafford, "trafford_green_flags.geojson")

# -------- Write out the CSV data files for GM & Trafford
sf_meta %>% 
  cbind(st_coordinates(.)) %>%
  rename(lon = X, lat = Y) %>% 
  st_set_geometry(NULL) %>% 
  write_csv("gm_green_flags.csv")

sf_meta_trafford %>%
  cbind(st_coordinates(.)) %>%
  rename(lon = X, lat = Y) %>%
  st_set_geometry(NULL) %>%
  write_csv("trafford_green_flags.csv")
