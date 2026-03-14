#' current_state UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_current_state_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      leaflet::leafletOutput(
        outputId = ns("wl_status"),
        height = "700px")
    )
  )
}
    
#' current_state Server Functions
#'
#' @noRd 
mod_current_state_server <- function(id,
                                     curr_meas){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    prepped_stat_data <- reactiveValues(data = NULL)
    
    observe({
        prepped_stat_data$data = prep_status(
          curr_meas_data = curr_meas$data)
      # prepped_stat_data <- prep_status(curr_meas_data = curr_meas)
    })

    
    # curr_meas_data <- readRDS(po_cache_dir(folder = "dispPO_data",file = "curr_meas.rds"))
      
    
    
    output$wl_status <- leaflet::renderLeaflet({
      leaflet::leaflet(prepped_stat_data$data) |> 
        leaflet::addTiles() |>    # OpenStreetMap
        leaflet::addCircleMarkers(
          lng = ~long,
          lat = ~lat,
          color = ~color,
          fillColor = ~color,
          fillOpacity = 0.8,
          radius = 6,
          stroke = TRUE,
          popup = ~paste0(
            "<b>", shortname, "</b><br>",
            "Water level: ", wl, " cm"
          )
        ) |> 
        leaflet::addLegend(
          position = "topright",
          colors = c("green", "grey", "black", "red"),
          labels = c("WL between mean low and mean high WL", 
                     "Unknown", 
                     "Inactive", 
                     "WL above mean high WL"),
          opacity = 0.8,
          title = "Station Status"
        )
    })
 
  })
}
    
## To be copied in the UI
# mod_current_state_ui("current_state_1")
    
## To be copied in the server
# mod_current_state_server("current_state_1")
