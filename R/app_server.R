#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  # googledrive::drive_auth(
  #   path = "inst/app/river-data-491212-i8-cd1b0daa92df.json"
  # )
  # # 
  # googledrive::drive_upload(
  #   media = "/Felix/Privat/R_Projekte/dispPO_data/curr_meas.rds",
  #   path = "dispPO_data/data.rds"
  # )
  
  wl_data <- reactiveValues(
    data = readRDS(po_cache_dir(folder = "dispPO_data",file = "wl_list.rds"))
  )
  
  # wl_data <- readRDS(po_cache_dir(folder = "dispPO_data",file = "wl_list.rds"))

  stations_meta <- reactiveValues(
    data = get_stations()
  )
  # stations_meta <- get_stations()
  
  
  mod_station_dashboard_server(
    "station_dashboard_1",
    wl_data = wl_data,
    stations_meta = stations_meta
  )
  
  curr_meas <- reactiveValues(
    # curr_meas <- fetch_po_curr_meas()
    data = readRDS(po_cache_dir(folder = "dispPO_data",file = "curr_meas.rds"))
    # curr_meas <- readRDS(po_cache_dir(folder = "dispPO_data",file = "curr_meas.rds"))
  )


  mod_current_state_server(
    "current_state_1",
    curr_meas = curr_meas
  )
  
  mod_wl_monitor_server(
    "wl_monitor_1",
    stations_meta = stations_meta,
    wl_data = wl_data)
}
