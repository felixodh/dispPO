
#' Retrieve Pegelonline station metadata
#'
#' Downloads metadata for all measuring stations from the
#' German Federal Waterways and Shipping Administration
#' (WSV) Pegelonline REST API.
#'
#' @details
#' The function queries the Pegelonline API endpoint
#' \url{https://www.pegelonline.wsv.de/webservices/rest-api/v2/stations.json}
#' and returns station-level metadata including location,
#' identifiers, and associated water body information.
#'
#' @return
#' A tibble with one row per station and the following columns:
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
#' @examples
#' \dontrun{
#' stations <- get_stations()
#' dplyr::glimpse(stations)
#' }
#'
#' @seealso
#' \url{https://www.pegelonline.wsv.de/webservices/rest-api/v2/}
#'
#' @export
get_stations <- function(){
  
  station_url <- "https://www.pegelonline.wsv.de/webservices/rest-api/v2/stations.json"
  
  # Create request
  station_request <- httr2::request(station_url) |> 
    httr2::req_user_agent("Mozilla/5.0") |> 
    httr2::req_headers(Accept = "application/json")
  
  
  # Perform request and get response
  station_response <- httr2::req_perform(station_request)
  
  station_json <- httr2::resp_body_json(station_response)
  # create empty tibble
  meta_station <- dplyr::tibble(
    uuid = as.character(),
    number = as.character(),
    shortname = as.character(),
    longname = as.character(),
    km = as.double(),
    agency = as.character(),
    long = as.integer(),
    lat = as.integer(),
    water_shortname = as.character(),
    water_longname = as.character()
  )

  # loop through stations and add station to tibble
  for(i in 1:length(station_json)){
    add_stat <- dplyr::tibble(
      uuid = as.character(station_json[[i]]$uuid),
      number = as.character(station_json[[i]]$number),
      shortname = as.character(station_json[[i]]$shortname),
      longname = as.character(station_json[[i]]$longname),
      km = as.double(station_json[[i]]$km),
      agency = as.character(station_json[[i]]$agency),
      long = as.double(station_json[[i]]$longitude),
      lat = as.double(station_json[[i]]$latitude),
      water_shortname = as.character(station_json[[i]]$water$shortname),
      water_longname = as.character(station_json[[i]]$water$longname))
      
      meta_station <- meta_station |> 
        dplyr::bind_rows(add_stat)
  }
  
  return(meta_station)
  
}

#' Create an empty water level tibble
#'
#' Returns an empty tibble with the correct column structure and types
#' for water level data. This is mainly used as a safe fallback when
#' no measurements are returned by the Pegelonline API or a request fails.
#'
#' @details
#' The returned tibble contains the expected columns \code{timestamp}
#' and \code{wl_cm} with appropriate classes, but no valid observations.
#' It can be safely combined with existing data using
#' \code{dplyr::rows_upsert()} or similar operations.
#'
#' @return
#' A tibble with columns:
#' \describe{
#'   \item{timestamp}{POSIXct datetime (Europe/Berlin), \code{NA}}
#'   \item{wl_cm}{Numeric water level in centimeters, \code{NA}}
#' }
#'
#' @examples
#' empty_wl_dt()
empty_wl_dt <- function(){
  wl_dt <- dplyr::tibble(
    timestamp = lubridate::ymd_hms(NA,tz = "Europe/Berlin"),
    wl_cm = as.double(NA))
  return(wl_dt)
}
