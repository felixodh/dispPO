
#' Filter water level data by rivers and station names
#'
#' This function filters a named data object (e.g., list or environment)
#' containing water level time series by selecting stations that match
#' specified river names and station short names. The matching is performed
#' using a station metadata table.
#'
#' @param data A named object (e.g., list) containing water level data.
#'   Names must correspond to station UUIDs.
#' @param rivers A character vector of river short names
#'   (e.g., \code{c("ALLER", "DONAU")}).
#' @param stations A tibble/data.frame containing station metadata.
#'   Must include at least the columns \code{uuid}, \code{shortname},
#'   and \code{water_shortname}.
#' @param stations_sel A character vector of station short names to select
#'   (e.g., \code{c("CELLE", "VILSHOFEN")}).
#'
#' @return A subset of \code{data} containing only entries whose names
#'   (UUIDs) match the filtered stations. Returns \code{NULL} if no stations match.
#'
#' @details
#' The function performs several input checks:
#' \itemize{
#'   \item Ensures all arguments are provided
#'   \item Validates that \code{rivers} and \code{stations_sel} are character vectors
#'   \item Checks that \code{stations} is a tibble/data.frame
#'   \item Ensures inputs are non-empty
#' }
#'
#' If no stations match the filtering criteria, a warning is issued and
#' \code{NULL} is returned. If some station UUIDs are not present in
#' \code{data}, a warning is also issued.
#'
#' @examples
#' \dontrun{
#' rivers <- c("ALLER", "DONAU")
#' stations_sel <- c("CELLE", "VILSHOFEN")
#'
#' result <- display_wl_plot(
#'   data = wl_data,
#'   rivers = rivers,
#'   stations = stations_tbl,
#'   stations_sel = stations_sel
#' )
#' }
#'
#' @export
display_wl_plot <- function(data, rivers, stations, stations_sel){
  
  if (missing(data) || missing(rivers) || missing(stations_sel) || missing(stations)) {
    stop("All arguments (data, rivers, stations_sel, stations) must be provided")
  }
  
  if (!is.character(rivers)) {
    stop("rivers must be a character vector")
  }
  
  if (!is.character(stations_sel)) {
    stop("stations_sel must be a character vector")
  }
  
  if (!tibble::is_tibble(stations)) {
    stop("stations must be a data.frame")
  }
  
  if (length(rivers) == 0) {
    stop("rivers must not be empty")
  }
  
  if (length(stations_sel) == 0) {
    stop("stations_sel must not be empty")
  }
  

  stations_selected <- stations |> dplyr::filter(
    water_shortname %in% rivers,
    shortname %in% stations_sel
  )
  
  if (nrow(stations_selected) == 0) {
    warning("No matching stations found for given rivers/stations_sel")
    return(NULL)
  }
  
  # Extract UUIDs
  uuids <- stations_selected$uuid
  
  # Check if UUIDs exist in data
  missing_uuids <- setdiff(uuids, names(data))
  if (length(missing_uuids) > 0) {
    warning(paste("Some UUIDs not found in data:", paste(missing_uuids, collapse = ", ")))
  }
  
  sel_data <- data[names(data) %in% uuids]
  
  return(sel_data)
  
}
