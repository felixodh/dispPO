dispPO

dispPO is an R package for fetching, processing, and visualizing water level measurements from the PegelOnline API
. It provides tools to cache data, calculate station status, generate Leaflet maps, and integrate with Shiny dashboards.

Features

Fetch current and historical water level data for German river stations.

Cache data locally for faster subsequent queries.

Calculate station statistics, including latest water level and online/offline status.

Color-coded markers for Leaflet maps (green, red, grey) based on station status.

Functions compatible with Shiny apps for live dashboards.

Installation

You can install the development version directly from GitHub:

# install.packages("devtools") if not already installed
devtools::install_github("felixodh/dispPO")
Usage
Fetch current measurements
library(dispPO)

# Fetch latest water level measurements
curr_meas <- fetch_po_curr_meas()
head(curr_meas)
Prepare station status
# Prepare data with color coding for Leaflet
prepped_data <- prep_status(curr_meas)
head(prepped_data)
Calculate station statistics
# Calculate latest water level stats per station
stations_stats <- stat_calc_stations(curr_meas)
head(stations_stats)
Calculate percentage of online stations
# Compute percentage of stations online/offline
percent_online(stations_stats)
Leaflet map example
library(leaflet)

leaflet(prepped_data) |>
  addTiles() |>
  addCircleMarkers(
    lng = ~long,
    lat = ~lat,
    color = ~color,
    fillColor = ~color,
    fillOpacity = 0.8,
    radius = 6,
    stroke = TRUE,
    popup = ~text
  )
Caching

The package uses a local cache directory to store fetched data:

po_cache_dir(folder = "dispPO_data", file = "lst_query.rds")

The cache helps avoid repeated requests to the PegelOnline API.

Functions like fetch_po_data() will read from or write to this cache automatically.

Shiny Integration

dispPO is designed to work seamlessly in Shiny dashboards:

Use wl_list as a reactive object to update Leaflet maps dynamically.

Show loading notifications while fetching data.

Color-coded station markers and popups with latest water levels.

Dependencies

R (>= 4.1)

shiny

dplyr

httr2

lubridate

leaflet

tibble

All dependencies are listed in DESCRIPTION.

Development

Clone the repo locally:

git clone https://github.com/felixodh/dispPO.git

Install the package:

devtools::install_local("dispPO")

Run the development Shiny app:

golem::run_dev()
Contributing

Contributions are welcome! Please submit issues or pull requests via GitHub.

License

MIT License – see LICENSE
 for details.