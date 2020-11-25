library(shiny)

#to get the functions available in helper.R, Check ReadMe for detail
source("helper.R")

shinyServer(function(input, output) {
  

  # render the map by selected city and date
  output$mymap <- renderLeaflet({
    create_leaflet(
                  unlist(strsplit(input$city_date_select,"@"))[1],
                  unlist(strsplit(input$city_date_select,"@"))[2])
  })

})
