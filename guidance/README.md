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

Geospatial polygon/line data must also be provided in a separate styled form for use in GitHub and on the Lab's [Explore](https://www.trafforddatalab.io/maps/explore/) mapping application. These files should be distinguished from the standard versions by appending *_styled* to the dataset name, e.g. ```trafford_dataset_name_styled.geojson```. [Styling features](https://help.github.com/en/articles/mapping-geojson-files-on-github#styling-features) should be done using [simplestyle spec](https://github.com/mapbox/simplestyle-spec/tree/master/1.1.0) e.g. stroke-width, fill etc. Point data can also be styled e.g. marker-color, marker-size, however this should only be done if the styling is required to differentiate data items.

*Example R script for feature styling*
```r
trafford_sf <- trafford_sf %>%
  mutate(stroke =
           case_when(
             Value == "1" ~ "#c7e9c0",
             Value == "2" ~ "#a1d99b",
             Value == "3" ~ "#74c476",
         `stroke-width` = 3,
         `stroke-opacity` = 1,
         fill = stroke,
         `fill-opacity` = 0.8)
```
