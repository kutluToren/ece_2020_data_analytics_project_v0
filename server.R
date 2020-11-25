library(shiny)

#to get the functions available in helper.R, Check ReadMe for detail
source("helper.R")

shinyServer(function(input, output) {
  
  
  output$info_box <- renderUI(as.numeric(input$date_select))
  # render the map by selected city and date (date recovered from database)
  output$mymap <- renderLeaflet({create_leaflet(input$city_select,
                                                find_data_dates(input$city_select,input$date_select)) })
 
  })
