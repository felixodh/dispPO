

#' Calculate Latest Water Level Statistics for Stations
#'
#' `stat_calc_stations` computes the most recent water level (WL) for each station,
#' assigns a status flag, determines a display color, and generates an HTML popup text.
#'
#' The function combines station metadata from `get_stations()` with water level data 
#' provided in `wl_data`. For each station, it finds the latest measurement timestamp, 
#' determines if the measurement is recent (within the last 3 days), assigns a flag and 
#' a color (green, red, or grey), and constructs an HTML string suitable for Leaflet popups.
#'
#' @param wl_data A named list where each element corresponds to a station UUID and 
#'   contains a list with a `wl` data frame. Each `wl` data frame must include at least:
#'   - `timestamp`: POSIXct or datetime of the measurement
#'   - `wl_cm`: numeric water level in cm
#'
#' @return A tibble containing the station metadata with additional columns:
#'   - `lst_wl_date`: datetime of the latest measurement
#'   - `flag`: integer (0 = old/missing, 1 = recent)
#'   - `color`: character ("green", "red", "grey") representing status
#'   - `lst_wl`: numeric value of the latest water level
#'   - `text`: HTML string suitable for Leaflet popups including station name, long name, WL, and date
#'
#' @details
#' This function is useful for Shiny apps or Leaflet maps where you want to display
#' the most recent water level per station, along with a color-coded status and
#' informative popup text. The `flag` is determined by whether the last measurement
#' is within the last 3 days.
#'
#' @examples
#' \dontrun{
#' # Assume wl_list is the output of fetch_po_data()
#' stations_stats <- stat_calc_stations(wl_list)
#' 
#' # Access popup text for the first station
#' stations_stats$text[1]
#' }
#'
#' @export
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



#' Calculate Percentage of Online Stations
#'
#' `percent_online` computes the percentage of stations in each status category 
#' based on the `flag` column in a stats table.
#'
#' @param stats_table A data frame or tibble containing at least a `flag` column.  
#'   Typically, this comes from `stat_calc_stations()` and `flag` indicates:
#'   - `1` = recent/online  
#'   - `0` = old/offline
#'
#' @return A tibble grouped by `flag` with columns:
#'   - `flag`: the status flag (0 or 1)  
#'   - `n`: number of stations in this category  
#'   - `perc`: percentage of stations in this category
#'
#' @details
#' This function is useful for dashboards or Shiny apps where you want to display 
#' the proportion of stations that are currently online or have recent measurements. 
#' The percentages are calculated relative to the total number of stations.
#'
#' @examples
#' \dontrun{
#' stats <- stat_calc_stations(wl_list)
#' percent_online(stats)
#' }
#'
#' @export
percent_online <- function(stats_table){
  
  sum_tab <- stats_table |> 
    dplyr::group_by(flag) |> 
    dplyr::summarise(n = dplyr::n()) |> 
  dplyr::ungroup()
  
  sum_tab[1,"perc"] <- sum_tab$n[1] * 100 / sum(sum_tab$n)
  sum_tab[2,"perc"] <- sum_tab$n[2]*100 / sum(sum_tab$n)
  return(sum_tab)
  
}



#' Prepare Station Status Data with Color Coding
#'
#' `prep_status` merges station metadata with current measurement data and assigns
#' a status color for each station based on water level conditions.
#'
#' @param curr_meas_data A data frame or tibble containing current station measurements.
#'   Must include a `uuid` column to match station metadata, and columns for
#'   `stateMnwMhw` and `stateNswHsw` indicating water level states (e.g., "normal", "low", "high", "unknown", "commented").
#'
#' @return A tibble containing all station metadata from `get_stations()`,
#'   joined with `curr_meas_data`, and an additional `color` column:
#'   - `"green"` = normal or low water level  
#'   - `"red"` = high water level  
#'   - `"grey"` = unknown or commented
#'
#' @details
#' This function is useful for Leaflet maps or Shiny dashboards where you want to
#' display stations with **color-coded markers** based on their current status.
#' It merges station metadata with current measurements and applies a simple
#' rule-based color assignment.
#'
#' @examples
#' \dontrun{
#' curr_data <- fetch_po_data(initial = TRUE) |> stat_calc_stations()
#' prepped_data <- prep_status(curr_data)
#' 
#' # Access first station color
#' prepped_data$color[1]
#' }
#'
#' @export
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


