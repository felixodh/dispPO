#' station_dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_station_dashboard_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        shinydashboard::infoBoxOutput(
          outputId = ns("count_box"),
          width = 3
        ),
        shinydashboard::infoBoxOutput(
          outputId = ns("on_box"),
          width = 3
        ),
        shinydashboard::infoBoxOutput(
          outputId = ns("off_box"),
          width = 3
        )
      )
    )
  )
}
    
#' station_dashboard Server Functions
#'
#' @noRd 
mod_station_dashboard_server <- function(id,
                                         wl_data,
                                         stations_meta){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    stats_table <- reactiveValues(data = NULL)
    perc_table <- reactiveValues(data = NULL)
    
    observe({
      stats_table$data <- stat_calc_stations(wl_data = wl_data$data)
      perc_table$data <- percent_online(stats_table = stats_table$data)
    })
    
    output$count_box <- shinydashboard::renderInfoBox({
      shinydashboard::infoBox(
        title = "Station Number",
        value = paste(nrow(stations_meta$data),"stations",sep = " "),
        icon = icon("list"),
        color = "green"
      )
    })


    output$on_box <- shinydashboard::renderInfoBox({
      shinydashboard::infoBox(
        title = "Stations Online",
        subtitle = "based on last data transmission",
        value = paste(round(perc_table$data$perc[2],digits = 1),"%",sep = ""),
        icon = icon("tower-broadcast"),
        color = "green"
      )
    })
    
    output$off_box <- shinydashboard::renderInfoBox({
      shinydashboard::infoBox(
        title = "Stations Offline",
        subtitle = "based on last data transmission",
        value = paste(round(perc_table$data$perc[1],digits = 1),"%",sep = ""),
        icon = icon("tower-broadcast"),
        color = "red"
      )
    })
    
    

    
    
 
  })
}
    
## To be copied in the UI
# mod_station_dashboard_ui("station_dashboard_1")
    
## To be copied in the server
# mod_station_dashboard_server("station_dashboard_1")
