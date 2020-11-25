library(shiny)

#to get the functions available in helper.R, Check ReadMe for detail
source("helper.R")

shinyServer(function(input, output) {
  
  
  #display selection
  output$selections <- renderUI(
    paste("Your city selection is",
          input$city_compare1,"in date", 
          find_data_dates(input$city_compare1,input$date_a1_city1),
          "and",input$city_compare2,"in date",
          find_data_dates(input$city_compare2,input$date_a1_city2),
          sep= " ")
  )
  
  
  # render the map by selected city and date (date recovered from database)
  output$mymap <- renderLeaflet({create_leaflet(input$city_select,
                                                find_data_dates(input$city_select,input$date_select)) })

  })
