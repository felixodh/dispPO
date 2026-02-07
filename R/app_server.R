#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  
  wl_data <- reactiveValues(
    # data = fetch_po_data(initial = F)
    data = readRDS(po_cache_dir(folder = "dispPO_data",file = "wl_list.rds"))
  )
  # wl_data <- readRDS(po_cache_dir(folder = "dispPO_data",file = "wl_list.rds"))
  # wl_data <- fetch_po_data(initial = F)
  stations_meta <- reactiveValues(
    data = stations_meta
  )
  
  mod_station_dashboard_server(
    "station_dashboard_1",
    wl_data = wl_data,
    stations_meta = stations_meta
  )
}
