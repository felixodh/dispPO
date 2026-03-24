#' wl_monitor UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_wl_monitor_ui <- function(id) {
  ns <- NS(id)
  tagList(
 
  )
}
    
#' wl_monitor Server Functions
#'
#' @noRd 
mod_wl_monitor_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_wl_monitor_ui("wl_monitor_1")
    
## To be copied in the server
# mod_wl_monitor_server("wl_monitor_1")
