# dispPO

[![R-CMD-check](https://github.com/felixodh/dispPO/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/felixodh/dispPO/actions/workflows/R-CMD-check.yaml)

**dispPO** is an R package for fetching, processing, and visualizing water level measurements from the [PegelOnline API](https://www.pegelonline.wsv.de/webservices/). It provides tools to cache data, calculate station status, generate Leaflet maps, and integrate with Shiny dashboards.

## Features

- Fetch **current and historical water level data** for German river stations
- Cache data locally for faster subsequent queries
- Calculate station statistics, including latest water level and online/offline status
- Color-coded markers for Leaflet maps (`green`, `red`, `grey`) based on station status
- Functions compatible with **Shiny apps** for live dashboards

## Installation

You can install the development version directly from GitHub:

```r
# install.packages("devtools") if not already installed
devtools::install_github("felixodh/dispPO")