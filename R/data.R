#' Pegelonline station metadata
#'
#' A dataset containing metadata for measuring stations from the
#' German Federal Waterways and Shipping Administration (WSV)
#' Pegelonline service.
#'
#' @format
#' A tibble with 716 rows and 10 variables:
#' \describe{
#'   \item{uuid}{Unique station identifier}
#'   \item{number}{Station number}
#'   \item{shortname}{Short station name}
#'   \item{longname}{Full station name}
#'   \item{km}{River kilometer}
#'   \item{agency}{Responsible agency}
#'   \item{long}{Longitude (decimal degrees)}
#'   \item{lat}{Latitude (decimal degrees)}
#'   \item{water_shortname}{Short name of the water body}
#'   \item{water_longname}{Full name of the water body}
#' }
#'
#' @source
#' \url{https://www.pegelonline.wsv.de/webservices/rest-api/v2/stations.json}
#'
#' @examples
#' head(stations_meta)
"stations_meta"

#' Current Water Level Measurements from PegelOnline
#'
#' This dataset contains water level measurements from German river stations, 
#' including timestamps, water level, and status indicators.
#'
#' @format A tibble with 680 rows and 6 variables:
#' \describe{
#'   \item{station}{Name of the river station (character).}
#'   \item{uuid}{Unique station identifier (character).}
#'   \item{timestamp}{Date and time of the measurement (POSIXct / datetime).}
#'   \item{wl}{Water level in cm (numeric).}
#'   \item{stateMnwMhw}{Status relative to mean low/high water (character).}
#'   \item{stateNswHsw}{Status relative to normal / high water (character).}
#' }
#'
#' @source \url{https://www.pegelonline.wsv.de/webservices/}
#' @keywords datasets
#' @examples
#' library(dplyr)
#' data(curr_meas)
#' curr_meas %>% filter(station == "CELLE") %>% head(3)
"curr_meas"

#' Water Level Data List from PegelOnline
#'
#' `wl_list` contains water level measurements for multiple river stations in Germany.
#' Each element of the list is named by the station UUID and contains:
#' 
#' - `sname`: The station name (character)
#' - `wl`: A tibble with columns:
#'   - `timestamp`: Date-time of the measurement (POSIXct)
#'   - `wl_cm`: Water level in centimeters (numeric)
#'
#' Example of accessing data for one station:
#' ```r
#' # Access the first station
#' first_station <- wl_list[[1]]
#' first_station$sname
#' head(first_station$wl)
#' ```
#'
#' @format A named list where each element is a list with:
#'   - `sname` (character)
#'   - `wl` (tibble with columns `timestamp` and `wl_cm`)
#' @source \url{https://www.pegelonline.wsv.de/webservices/}
#' @keywords datasets
"wl_list"