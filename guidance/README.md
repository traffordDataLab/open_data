## Guidance for publishing open data

This guidance is intended to help ensure that open data published by [Trafford Data Lab](www.trafforddatalab.io) is extracted in a reproducible way, provided with accurate metadata and available in an open format.

### Files
Each open dataset needs to be stored in its own folder in the [open_data](https://github.com/traffordDataLab/open_data) GitHub repo with:

- a **[README](template/README.md)** file which provides metadata (licence, attribution etc) for the dataset
- a **[pre-processing](template/pre-processing.R)** R script which shows how the data was retrieved, cleaned, and structured. The script must be scalable so that other local authorities can retrieve data for their area.
- a [**CSV**](https://www.w3.org/TR/tabular-data-primer/), and if geospatial data are available, a [**GeoJSON**](https://geojson.org/) file
- a [**preview**](template/index.Rmd) page with an interactive table displaying the data, concise metadata and links to download the complete data and the pre-processing script.

*Example folder structure*
```r
dataset/
├── README.md
├── index.Rmd
├── index.html
├── pre-processing.R
├── trafford_dataset_name.csv
├── trafford_dataset_name.geojson
```

### Variables
Data that has been aggregated to a geographical area must supply the `area_name` and `area_code` for each observation. These refer to the names and codes used by the [Office for National Statistics](https://www.ons.gov.uk/methodology/geography/geographicalproducts/namescodesandlookups/namesandcodeslistings) for statistical and administrative geographies.

Where available, the coordinates of a location or event need to be provided using the WGS84 Geographic Coordinate System (i.e. Longitude, Latitude). The coordinates need to be consistently labelled as `lon` and `lat` in that order.