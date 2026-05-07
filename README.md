
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{dispPO}`

dispPO is an R package for fetching, processing, and visualizing water
level measurements from the PegelOnline API. It provides tools to cache
data, calculate station status, generate Leaflet maps, and integrate
with Shiny dashboards.

## Features

- Fetch current and historical water level data for German river
  stations
- Cache data locally for faster subsequent queries
- Calculate station statistics, including latest water level and
  online/offline status
- Color-coded markers for Leaflet maps (green, red, grey) based on
  station status
- Functions compatible with Shiny apps for live dashboards

## Installation

You can install the development version of `{dispPO}` like so:

``` r
# install.packages("devtools") if not already installed
# devtools::install_github("felixodh/dispPO")
```

## Get started

You can launch the application by running:

``` r
# dispPO::run_app()
```

It first checks if the necessary folders and files exist and if not it
creates them. It loads and displays the data available since the last
download.

## App preview

<figure>
<img src="inst/app/www/station_dash.png"
alt="Dashboard: shows some overall meta infos and offers update button for most recent data" />
<figcaption aria-hidden="true">Dashboard: shows some overall meta infos
and offers update button for most recent data</figcaption>
</figure>

<figure>
<img src="inst/app/www/wl_status.png"
alt="Water level status: shows the actual water level status as flagged by WSV" />
<figcaption aria-hidden="true">Water level status: shows the actual
water level status as flagged by WSV</figcaption>
</figure>

<figure>
<img src="inst/app/www/water_level.png"
alt="Water level monitor: shows the actual water level as timeseries by WSV" />
<figcaption aria-hidden="true">Water level monitor: shows the actual
water level as timeseries by WSV</figcaption>
</figure>

## About

Data source: PegelOnline (WSV, Germany) <https://www.pegelonline.wsv.de>

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2026-05-07 11:46:43 CEST"
```
