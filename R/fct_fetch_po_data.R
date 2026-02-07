

#' Fetch and cache Pegelonline water level data
#'
#' Downloads water level (W) measurements from the Pegelonline REST API
#' for all stations returned by \code{get_stations()}. Data are cached
#' locally and updated incrementally on subsequent calls.
#'
#' @param initial Logical. If \code{TRUE}, performs an initial data load
#'   by fetching the last 30 days of measurements for all stations and
#'   creating a new cache. If \code{FALSE}, only new data since the last
#'   successful query date are fetched and merged into the existing cache.
#'
#' @details
#' When \code{initial = FALSE}, the function:
#' \itemize{
#'   \item Reads the date of the last query from \code{lst_query.rds}
#'   \item Determines the number of days to request from the API
#'   \item Ensures at least one day of data is requested
#'   \item Updates cached station data using \code{dplyr::rows_upsert()}
#' }
#'
#' API responses with no available measurements return empty datasets and
#' are handled gracefully.
#'
#' Cached files are stored in the directory returned by
#' \code{po_cache_dir(folder = "dispPO_data", ...)}.
#'
#' @return
#' A named list indexed by station UUID. Each element is a list with:
#' \describe{
#'   \item{sname}{Station short name}
#'   \item{wl}{A tibble with columns \code{timestamp} (POSIXct, Europe/Berlin)
#'             and \code{wl_cm} (numeric water level in cm)}
#' }
#'
#' @seealso
#' \code{\link{get_stations}}, \code{\link{empty_wl_dt}}
#' @export
fetch_po_data <- function(initial) {
  
  # --- setup 
  if (isTRUE(initial)) {
    days    <- 30L
    wl_list <- list()
  } else {
    last_query <- readRDS(po_cache_dir(
      folder = "dispPO_data", file = "lst_query.rds"
    ))
    
    days <- as.integer(Sys.Date() - as.Date(last_query))
    
    if(days < 1){
      days <- 1
    }
    
    wl_list <- readRDS(po_cache_dir(
      folder = "dispPO_data", file = "wl_list.rds"
    ))
  }
  
  
  
  stations <- get_stations()
  
  
  # --- loop over stations 
  for(i in 1:nrow(stations)){
    
    message(i, " / ", nrow(stations), " — ", stations$shortname[i])
    url_wl <- paste0(
      "https://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/",
      stations$uuid[i],
      "/W/measurements.json?start=P",
      days,"D"
    )
    
    # Create request
    resp <- tryCatch(
      httr2::request(url_wl) |>
        httr2::req_user_agent("Mozilla/5.0") |>
        httr2::req_headers(Accept = "application/json") |>
        httr2::req_perform(),
      error = function(e) {
        message("Request failed: ", stations$shortname[i])
        NULL
      }
    )
    
    wl_dt <- empty_wl_dt()
    
    # Perform request and get response
    
    if (!is.null(resp)) {
      json <- httr2::resp_body_json(resp)
      
      if (length(json) > 0) {
        wl_dt <- data.table::rbindlist(json, idcol = "id") |>
          dplyr::as_tibble() |>
          dplyr::transmute(
            timestamp = lubridate::ymd_hms(timestamp, tz = "Europe/Berlin"),
            wl_cm     = as.double(value)
          )
      }
    }
    
    uuid <- stations$uuid[i]
    
    if (isTRUE(initial)) {
      wl_list[[uuid]] <- list(
        sname = stations$shortname[i],
        wl    = wl_dt
      )
    } else {
      wl_list[[uuid]]$wl <-
        dplyr::rows_upsert(wl_list[[uuid]]$wl, wl_dt, by = "timestamp")
    }
    
  }
  
  # --- cache ------------------------------------------------------------
  lst_query <- Sys.Date()
  saveRDS(lst_query,po_cache_dir(folder = "dispPO_data","lst_query.rds"))
  saveRDS(wl_list,po_cache_dir(folder = "dispPO_data","wl_list.rds"))
  
  return(wl_list)
  
}





