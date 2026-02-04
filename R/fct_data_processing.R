

#' Title
#'
#' @param wl_data 
#'
#' @returns
#' @export
#'
#' @examples
stat_calc_stations <- function(wl_data){
  
  stations_stats <- stations_meta |> 
    dplyr::mutate(lst_wl_date = lubridate::as_datetime(NA),
                  flag = as.integer(NA),
                  lst_wl = as.double(NA))
  
  for(i in 1:length(wl_data)){
    station <- stations_stats[i,]
    wl_data_stat <- wl_data[[station$uuid]]$wl
    lst_date <- lubridate::as_datetime(max(wl_data_stat$timestamp))
    lst_val <- as.double(wl_data_stat |> 
      dplyr::filter(timestamp == lst_date) |> 
      dplyr::select(wl_cm))
    station <- station |> 
      dplyr::mutate(
        lst_wl_date = lubridate::as_datetime(lst_date),
        flag = dplyr::case_when(
          is.na(lst_wl_date) ~ 0,
          lst_wl_date <= Sys.Date() - 3 ~ 0,
          lst_wl_date > Sys.Date() - 3 ~ 1),
        lst_wl = as.double(lst_val)
      )
    stations_stats <- stations_stats |> 
      dplyr::rows_upsert(
        station,
        by = "uuid")
      
  }
  return(stations_stats)
}


