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