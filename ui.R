library(shiny)
library(leaflet)


cities_and_dates <- c("munich", "madrid","amsterdam","berlin","antwerp")
feature_list <- c("id", "neighbourhood_cleansed", 
                  "property_type", "room_type", "accommodates", "bedrooms", 
                  "beds", "price", "availability_30", "minimum_nights",  "maximum_nights","estimated_revenue_30")
plot_list <- c("bar","hist")


shinyUI(fluidPage(
  titlePanel("Mini Project"),
      tabsetPanel(
        tabPanel("Actual Page", 
                 tabsetPanel(
                            tabPanel("Analysis1", 
                                    titlePanel("Analysis1"),
                                    sidebarLayout(
                                            sidebarPanel(
                                              selectInput("city_compare2", "Select city from list",
                                                          choices = cities_and_dates,selected = "amsterdam"),
                                              radioButtons("date_a1_city2", label = ("Select The dataset from last 3 available"),
                                                           inline = TRUE,
                                                           choices = list("Most Recent" = 1, "2nd Recent" = 2, "3rd Recent" = 3), 
                                                           selected = 1),
                                              selectInput("city_compare1", "Select city from list",
                                                          choices = cities_and_dates,selected = "munich"),
                                              radioButtons("date_a1_city1", label = ("Select The dataset from last 3 available"),
                                                           inline = TRUE,
                                                           choices = list("Most Recent" = 1, "2nd Recent" = 2, "3rd Recent" = 3), 
                                                           selected = 1),
                                              selectInput("feature_select","Select the feature you want to cover",
                                                          choices = feature_list,selected = "price"),
                                            ),
                                            mainPanel(
                                              radioButtons("plot_select_a1", label = ("Select The Plot type"),
                                                           inline = TRUE,
                                                           choices = list("box" = "box","jitter"="jitter", "bar" = "bar"), 
                                                           selected = "box"),
                                              uiOutput("selections"),
                                              plotOutput("analysis1",width = "100%")
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
                                         selectInput("feature_select_a2","Select the feature you want to cover",
                                                     choices = list("price","room_type","bedrooms","availability_30"),selected = "price"),
                                       ),
                                       mainPanel(
                                         #radioButtons("plot_select_a2", label = ("Select The Plot type"),
                                         #             inline = TRUE,
                                         #             choices = list("box" = "box","jitter"="jitter", "bar" = "bar"), 
                                         #             selected = "box"),
                                         plotOutput("analysis2")
                                       )
                                     ))

                 )
        ),
        tabPanel("Read Me for Help", 
                 includeMarkdown("read_me.Rmd")
        )
    )
))

