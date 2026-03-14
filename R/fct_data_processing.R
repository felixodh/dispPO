

#' Title
#'
#' @param wl_data 
#'
#' @returns
#' @export
#'
#' @examples
stat_calc_stations <- function(wl_data){
  
  stations_meta <- get_stations()
  
  stations_stats <- stations_meta |> 
    dplyr::mutate(lst_wl_date = lubridate::as_datetime(NA),
                  flag = as.integer(NA),
                  color = as.character(NA),
                  lst_wl = as.double(NA),
                  text = as.character(NA))
  
  for(i in 1:length(wl_data)){
    station <- stations_stats[i,]

    wl_data_stat <- wl_data[[station$uuid]]$wl
    if(length(wl_data_stat$timestamp) != 0){
      lst_date <- lubridate::as_datetime(max(wl_data_stat$timestamp,na.rm = T))
    } else {
      lst_date <- lubridate::as_datetime(NA)
    }
    
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
        color = dplyr::case_when(
          flag == 0 ~ "red",
          flag == 1 ~ "green",
          is.na(flag) ~ "grey"),
        lst_wl = as.double(lst_val),
        text = paste0(
          "<b>", shortname, "</b><br>",
          longname, "<br>",
          "Last WL: ", lst_wl, "<br>",
          "Date: ", lst_wl_date
        )
      )
    stations_stats <- stations_stats |> 
      dplyr::rows_upsert(
        station,
        by = "uuid")
      
  }
  return(stations_stats)
}

# stats_data <- stat_calc_stations(wl_data = wl_data)



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



#' Title
#'
#' @param curr_meas_data 
#'
#' @returns
#' @export
#'
#' @examples
prep_status <- function(curr_meas_data){
  
  stations <- get_stations()
  
   prepped_stat_data <- stations |> 
    dplyr::left_join(curr_meas_data,by = "uuid")
  
   prepped_stat_data <- prepped_stat_data |> 
    dplyr::mutate(
      color = dplyr::case_when(stateMnwMhw == "normal" ~ "green",
                               stateNswHsw ==  "normal" ~ "green",
                               stateMnwMhw == "low" ~ "green",
                               stateNswHsw ==  "low" ~ "green",
                               stateMnwMhw == "high" ~ "red",
                               stateNswHsw ==  "high" ~ "red",
                               stateMnwMhw == "unknown" ~ "grey",
                               stateNswHsw ==  "unknown" ~ "grey",
                               stateMnwMhw == "commented" ~ "grey",
                               stateNswHsw ==  "commented" ~ "grey",))
  
  return(prepped_stat_data)
  
}


