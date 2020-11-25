library(shiny)
library(leaflet)


cities_and_dates <- c("munich", "madrid","amsterdam","berlin")


shinyUI(fluidPage(
  titlePanel("Mini Project"),
      tabsetPanel(
        tabPanel("Actual Page", 
                 tabsetPanel(
                            tabPanel("Analysis1", 
                                    titlePanel("Analysis1"),
                                    sidebarLayout(
                                            sidebarPanel(
                                              selectInput("city_compare1", "Select city from list",
                                                          choices = cities_and_dates,selected = "munich"),
                                              selectInput("city_compare2", "Select city from list",
                                                          choices = cities_and_dates,selected = "amsterdam")
                                            ),
                                            mainPanel(
                                              p()
                                            )
                                    )),
                            
                            
                            # Analysis 2
                            tabPanel("Analysis2", 
                                    titlePanel("Analysis2"),
                                    sidebarLayout(
                                      sidebarPanel(
                                        selectInput("city_select", "Select city from list",
                                                    choices = cities_and_dates,selected = "munich"),
                                        radioButtons("date_select", label = h3("Select The dataset from last 3 available"),
                                                     choices = list("Most Recent" = 1, "2nd Recent" = 2, "3rd Recent" = 3), 
                                                     selected = 1),
                                      ),
                                      mainPanel(
                                        leafletOutput("mymap")
                                      )
                                    )
                 ))
        ),
        tabPanel("Read Me for Help", 
                 includeMarkdown("read_me.Rmd")
        )
    )
))

