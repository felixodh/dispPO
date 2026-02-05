

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

# stats_table <- stat_calc_stations(wl_data = wl_data)

#' Title
#'
#' @param stats_table 
#'
#' @returns
#' @export
#'
#' @examples
percent_online <- function(stats_table){
  
  sum_tab <- stats_table |> 
    dplyr::group_by(flag) |> 
    dplyr::summarise(n = dplyr::n()) |> 
  dplyr::ungroup()
  
  sum_tab[1,"perc"] <- sum_tab$n[1] * 100 / sum(sum_tab$n)
  sum_tab[2,"perc"] <- sum_tab$n[2]*100 / sum(sum_tab$n)
  return(sum_tab)
  
}


