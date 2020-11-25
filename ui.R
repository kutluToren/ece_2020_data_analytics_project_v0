library(shiny)
library(leaflet)


cities_and_dates <- c("munich", "madrid","amsterdam","berlin")
feature_list <- c("id", "neighbourhood_cleansed", 
                  "property_type", "room_type", "accommodates", "bedrooms", 
                  "beds", "price", "availability_30", "minimum_nights",  "maximum_nights")


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
                                                          choices = cities_and_dates,selected = "amsterdam"),
                                              selectInput("feature_select","Select the feature you want to cover",
                                                          choices = feature_list,selected = "price")
                                            ),
                                            mainPanel(
                                              p()
                                            )
                                    )),
                            
                            
                            # Analysis 2 Map
                            tabPanel("Analysis2_map", 
                                    titlePanel("Analysis2 Map"),
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
                                    )),
                            # Analysis 2 Deep Analysis
                            tabPanel("Analysis2_deep", 
                                     titlePanel("Analysis2 Deep Analysis"),
                                     sidebarLayout(
                                       sidebarPanel(
                                         selectInput("city_select2", "Select city from list",
                                                     choices = cities_and_dates,selected = "munich"),
                                         radioButtons("date_select2", label = h3("Select The dataset from last 3 available"),
                                                      choices = list("Most Recent" = 1, "2nd Recent" = 2, "3rd Recent" = 3), 
                                                      selected = 1),
                                       ),
                                       mainPanel(
                                         titlePanel("test")
                                       )
                                     ))

                 )
        ),
        tabPanel("Read Me for Help", 
                 includeMarkdown("read_me.Rmd")
        )
    )
))

