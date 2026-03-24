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
    fluidRow(
      column(
        width = 3,
        shinydashboard::box(
          title = "Selection",
          status = "danger",
          solidHeader = T,
          width = 12,
          selectInput(
            inputId = ns("river_sel"),
            label = "River Selection",
            choices = c("",unique(get_stations()$water_longname)),
            selected = "",
            multiple = T
          ),
          selectInput(
            inputId = ns("station_sel"),
            label = "Station Selection",
            choices = c("",unique(get_stations()$shortname)),
            selected = "",
            multiple = T
          ),
          shinyWidgets::actionBttn(
            inputId = "load_data",
            label = "Load Data",
            color = "primary",
            style = "jelly",
            block = F
          )
        )
      ),
      column(
        width = 9,
        shinydashboard::box(
          title = "Plot",
          status = "primary",
          solidHeader = T,
          width = 12,
          plotly::plotlyOutput(
            outputId = ns("wl_plot")
          )
        )
      )
    )
 
  )
}
    
#' wl_monitor Server Functions
#'
#' @noRd 
mod_wl_monitor_server <- function(id, 
                                  stations_meta,
                                  wl_data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    
    selected_stations <- reactiveValues(data = NULL)
    wl_selected <- reactiveValues(data = NULL)
    
    observeEvent(input$river_sel,{

      
      selected_stations$data <- stations_meta$data |> 
        dplyr::filter(water_longname %in% input$river_sel)
        # dplyr::filter(water_longname %in% c("RHEIN","ELBE"))
      
      
      updateSelectInput(
        session = session,
        inputId = "station_sel",
        choices = c("", unique(selected_stations$data$shortname)),
        selected = ""
      )
      
    })
    

    
    observeEvent(input$load_data,{
      req(selected_stations$data)
      wl_sel$data <- wl_data[station_sel$uuid]
      
      
      
      
      
    })
    
    
    
 
  })
}
    
## To be copied in the UI
# mod_wl_monitor_ui("wl_monitor_1")
    
## To be copied in the server
# mod_wl_monitor_server("wl_monitor_1")
