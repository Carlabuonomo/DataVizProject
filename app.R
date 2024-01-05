library(shiny)

source("MarwinApp/plot_court.R")
source("MarwinApp/server.R")
source("MarwinApp/ui.R")

source("CarlaApp/app.R")

source("EmmaApp/app.R")


ui <- navbarPage("NBA Visualizer",
                 navbarMenu("Plots",
                            tabPanel("Marwin", marwinUi),
                            tabPanel("Carla", carlaUi),
                            tabPanel("Emma", emmaUi)
                )
      )

server <- function(input, output, session) {
  marwinServer(input, output)
  carlaServer(input, output)
  emmaServer(input, output, session)
}

shinyApp(ui=ui, server=server)