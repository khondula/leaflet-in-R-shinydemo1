library(shiny)
library(leaflet)
# shiny app for worksheet 3 of leaflet in R lesson
# https://cyberhelp.sesync.org/leaflet-in-R-lesson/

# Run in external window to avoid error:
# ERROR: [on_request_read] connection reset by peer
# https://github.com/rstudio/shiny/issues/1469

# # simple user interface with just map
# ui <- fluidPage(
#   leafletOutput("map", height = 800)
# )

# user interface with map and input widget
ui <- fluidPage(
  leafletOutput("map", height = 500),
  absolutePanel(top = 100, right = 10, draggable = TRUE,
                dateInput("dateinput", "Imagery Date",
                          value = Sys.Date() - 1, # todays imagery may not be available yet
                          max = Sys.Date() # avoid requesting future dates
                )),
  a("See the code on github",
    href="https://github.com/khondula/leaflet-in-R-shinydemo1"))

# server definition
server <- function(input, output) {
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "OSM") %>%
      addProviderTiles(providers$NASAGIBS.ModisTerraTrueColorCR, group = "Modis",
                       options = providerTileOptions(time = input$dateinput)) %>%
                       # options = providerTileOptions(time = Sys.Date()-1)) %>% # use this line instead of previous for no interactivity
      setView(lng = -76.505206, lat = 38.9767231, zoom = 7) %>%
      addLayersControl(baseGroups = c("Modis", "OSM"),
                       options = layersControlOptions(collapsed = FALSE)
      )
  })
  
}

shinyApp(ui, server)