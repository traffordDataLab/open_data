## Guidance for publishing open data

This guidance is intended to help ensure that open data published by Trafford Data Lab is extracted in a reproducible way, provided with accurate metadata and available in an open format.

#### Files
Each open dataset needs to be stored in its own folder in the [open_data](https://github.com/traffordDataLab/open_data) GitHub repo with:

- a **[README](examples/README.md)** file which provides metadata (licence, attribution etc) for the dataset
- a **[pre-processing](examples/pre-processing.R)** R script which shows how the data was read, [tidied](http://vita.had.co.nz/papers/tidy-data.pdf), and styled
- a **CSV**, and if geospatial data are available, a **GeoJSON** file
- a **thumbnail** image showing a GitHub map preview of the data

Data relating to both Trafford Metropolitan Borough and Greater Manchester Combined Authority must be provided.

*Example folder structure*
```r
dataset/
├── README.md
├── gm_dataset_name.csv
├── gm_dataset_name.geojson
├── pre-processing.R
├── thumbnail.png
├── trafford_dataset_name.csv
├── trafford_dataset_name.geojson
```

#### Variables
Each CSV or GeoJSON file must supply the `area_name` and `area_code` for each observation. These refer to the names and codes used by the [Office for National Statistics](https://www.ons.gov.uk/methodology/geography/geographicalproducts/namescodesandlookups/namesandcodeslistings) for statistical and administrative geographies.

Where available, the coordinates of a location or event need to be provided using the WGS84 Geographic Coordinate System (i.e. Longitude, Latitude). The coordinates need to be consistently labelled as `lon` and `lat` in that order.

#### Styling
Data made available in tabular CSV format must use [snake case](https://en.wikipedia.org/wiki/Snake_case) to name variables and be structured in [long format](http://r4ds.had.co.nz/images/tidy-9.png). Data is structured in this way to facilitate further analysis or visualisation in other statistical programming software.

Geospatial data must be styled for use in GitHub and on the Lab's [Explore](https://www.trafforddatalab.io/maps/explore/) mapping application. Full variable names should be used and [features styled](https://help.github.com/articles/mapping-geojson-files-on-github/), e.g. marker colour and stroke width.

*Example R script for renaming and feature styling*
```r
sf <- df %>%
  st_as_sf(coords = c("lon", "lat")) %>%
  st_set_crs(4326) %>%
  rename(Name = name,
         Address = address,
         Postcode = postcode,
         `Area name` = area_name,
         `Area code` = area_code) %>%
  mutate(`marker-color` = "#fc6721",
         `marker-size` = "medium")
```
