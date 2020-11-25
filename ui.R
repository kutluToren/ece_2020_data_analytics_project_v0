library(shiny)
library(leaflet)


cities_and_dates <- c("munich@2020-06-20", "madrid@2020-09-13")


shinyUI(fluidPage(
  titlePanel("Mini Project"),
  mainPanel(
      tabsetPanel(
        tabPanel("Actual Page", 
                 tabsetPanel(
                            tabPanel("Analysis1", 
                                    titlePanel("Analysis1")
                                    ),
                            tabPanel("Analysis2", 
                                    titlePanel("Analysis2"),
                                    selectInput("city_date_select", "Select dataset from list",
                                                c("munich@2020-06-20", "madrid@2020-09-13")),
                                    textOutput("test_output"),
                                    leafletOutput("mymap")
                                    )
                 )
        ),
        tabPanel("Read Me for Help", 
                 includeMarkdown("read_me.Rmd")
        )
    )
  )
))

