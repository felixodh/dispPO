
#' Fetch recent water level measurements from Pegelonline
#'
#' Downloads water level data for all stations from the German Federal
#' Waterways and Shipping Administration (WSV) Pegelonline REST API.
#'
#' @details
#' For each station obtained via \code{\link{get_stations}}, the function
#' queries the Pegelonline API for the last 30 days of water level measurements.
#' If a request fails (network issues, server error), a fallback row with
#' NA values is returned for that station.
#'
#' Each station in the returned list contains:
#' \describe{
#'   \item{sname}{Short station name}
#'   \item{wl}{A tibble with water level measurements containing:
#'     \describe{
#'       \item{timestamp}{Measurement timestamp (POSIXct, Europe/Berlin)}
#'       \item{wl_cm}{Water level in cm (double)}
#'     }
#'   }
#' }
#'
#' @return
#' A named list where each element corresponds to a station. The list names
#' are station UUIDs. Each element is a list with components \code{sname} and
#' \code{wl} as described above.
#'
#' @examples
#' \dontrun{
#' # Fetch water level data for all stations (may take several minutes)
#' wl_list <- fetch_po_data()
#'
#' # Access first station
#' wl_list[[1]]$sname
#' head(wl_list[[1]]$wl)
#' }
#'
#' @seealso
#' \url{https://www.pegelonline.wsv.de/webservices/rest-api/v2/}
#'
#' @export
fetch_po_data <- function() {
  
  days <- 30
  
  stations <- get_stations()
  
  wl_list <- list()

  for(i in 1:nrow(stations)){
    url_wl <- paste0("https://www.pegelonline.wsv.de/webservices/rest-api/v2/stations/",
                     stations$uuid[i],"/W/measurements.json?start=P",days,"D")
    print(i)
    print(stations$shortname[i])
    # Create request
    wl_request <- httr2::request(url_wl) |> 
      httr2::req_user_agent("Mozilla/5.0") |> 
      httr2::req_headers(Accept = "application/json")
    
    
    # Perform request and get response
    # wl_response <- httr2::req_perform(wl_request)
    wl_response <- tryCatch(
      wl_response <- httr2::req_perform(wl_request),
      error = function(e){
        message("Failed", e$message)
        NULL
      }
    )
    
    if(is.null(wl_response)){
      wl_dt <- dplyr::tibble(
        id = as.integer(NA),
        timestamp = lubridate::ymd_hms(NA,tz = "Europe/Berlin"),
        wl_cm = as.double(NA)
      )
    } else{
      wl_json <- httr2::resp_body_json(wl_response)
      wl_dt <- data.table::rbindlist(wl_json,idcol = "id")
      wl_dt <- dplyr::tibble(wl_dt) |> 
        dplyr::mutate(
          id = as.integer(id),
          timestamp = lubridate::ymd_hms(timestamp,tz = "Europe/Berlin"),
          wl_cm = as.double(value)) |> 
        dplyr::select(2,4)
    }
    

    
    
    wl_list[[stations$uuid[i]]] <- list(
      sname = stations$shortname[i],
      wl = wl_dt)
    
  }
  
  return(wl_list)

}


