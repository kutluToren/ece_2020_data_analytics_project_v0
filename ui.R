library(shiny)
library(leaflet)


cities_and_dates <- c("munich", "madrid","amsterdam","berlin")


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
                                    selectInput("city_select", "Select city from list",
                                                choices = cities_and_dates,selected = "munich"),
                                    radioButtons("date_select", label = h3("Select The dataset from last 3 available"),
                                                 choices = list("Most Recent" = 1, "2nd Recent" = 2, "3rd Recent" = 3), 
                                                 selected = 1),
                                    uiOutput("info_box"),
                                    p(),
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

