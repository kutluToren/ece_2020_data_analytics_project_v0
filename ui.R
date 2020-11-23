library(shiny)

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
                                    titlePanel("Analysis2")
                                    )
                 )
        ),
        tabPanel("Read Me for Help", 
                 includeMarkdown("test.Rmd")
        )
    )
  )
))

