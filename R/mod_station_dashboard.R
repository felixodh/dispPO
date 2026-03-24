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
        shinyWidgets::actionBttn(
          inputId = ns("load_data"),
          label = "Update data",
          color = "primary",
          style = "jelly",
          block = F
        ),
        shinydashboard::infoBoxOutput(
          outputId = ns("count_box"),
          width = 3
        ),
        # shinydashboard::infoBoxOutput(
        #   outputId = ns("on_box"),
        #   width = 3
        # ),
        shinydashboard::infoBoxOutput(
          outputId = ns("off_box"),
          width = 3
        ),
        shinydashboard::infoBoxOutput(
          outputId = ns("date_box"),
          width = 3
        )
        
      ),
      column(
        width = 12,
        leaflet::leafletOutput(
          outputId = ns("po_map"),
          height = "700px")
      )
    )
  )
}
    
#' station_dashboard Server Functions
#'
#' @noRd 
mod_station_dashboard_server <- function(id,
                                         stations_meta,
                                         wl_data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    stats_table <- reactiveValues(data = NULL)
    perc_table <- reactiveValues(data = NULL)
    # wl_data <- reactiveValues(
    #   data = readRDS(po_cache_dir(folder = "dispPO_data",file = "wl_list.rds"))
    # )
    
    observeEvent(input$load_data, {
      
      notif_id <- NULL
      
      data <- withCallingHandlers(
        
        fetch_po_data(initial = F),
        
        message = function(m) {
          
          msg <- conditionMessage(m)
          
          if (!is.null(notif_id)) {
            removeNotification(notif_id)
          }
          
          notif_id <<- showNotification(
            msg,
            duration = NULL,
            closeButton = FALSE,
            type = "message"
          )
          
          invokeRestart("muffleMessage")
        }
        
      )
      
      if (!is.null(notif_id)) {
        removeNotification(notif_id)
      }
      
      wl_data <- reactiveValues(
        data = data
      )
      
    })
    
    
    
    observe({
      stats_table$data <- stat_calc_stations(wl_data = wl_data$data)
      # stats_table <-  stat_calc_stations(wl_data = wl_data)
      perc_table$data <- percent_online(stats_table = stats_table$data)
      # perc_table <- percent_online(stats_table = stats_table)
    })


    
    output$count_box <- shinydashboard::renderInfoBox({
      shinydashboard::infoBox(
        title = "Station Number",
        value = paste(nrow(stations_meta$data),"stations",sep = " "),
        icon = icon("list"),
        color = "aqua"
      )
    })


    # output$on_box <- shinydashboard::renderInfoBox({
    #   shinydashboard::infoBox(
    #     title = "Stations Online",
    #     subtitle = "based on last request",
    #     value = paste(round(perc_table$data$perc[2],digits = 1),"%",sep = ""),
    #     icon = icon("tower-broadcast"),
    #     color = "green"
    #   )
    # })
    
    output$off_box <- shinydashboard::renderInfoBox({
      shinydashboard::infoBox(
        title = "Stations Offline",
        subtitle = "last date > 3 days ago",
        value = paste(round(perc_table$data$perc[1],digits = 1),"%",sep = ""),
        icon = icon("tower-broadcast"),
        color = "red"
      )
    })
    
    output$date_box <- shinydashboard::renderInfoBox({
      shinydashboard::infoBox(
        title = "Request date",
        subtitle = "last request",
        value = Sys.Date(),
        icon = icon("rotate"),
        color = "blue"
      )
    })
    
    output$po_map <- leaflet::renderLeaflet({
      leaflet::leaflet(stats_table$data) |> 
        leaflet::addTiles() |>    # OpenStreetMap
        leaflet::addCircleMarkers(
          lng = ~long,
          lat = ~lat,
          color = ~color,
          fillColor = ~color,
          fillOpacity = 0.8,
          radius = 6,
          stroke = TRUE,
          popup = ~shortname
        )
    })
    
    

    
    
 
  })
}
    
## To be copied in the UI
# mod_station_dashboard_ui("station_dashboard_1")
    
## To be copied in the server
# mod_station_dashboard_server("station_dashboard_1")
