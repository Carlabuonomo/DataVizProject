

library(shiny)
library(ggplot2)
library(dplyr)

#How does the proportion of shot types for a player vary over different quarters?
#Do specific players exhibit a significant change in the proportion of shot types when transitioning from one team to another, and are there any noticeable patterns or anomalies in these transitions?
#Are there noticeable variations in the shot type preferences of individual players across different quarters, and do these variations suggest any strategic changes or player tendencies during specific periods of a game?

# data <- read.csv("data/merge.csv", sep = ",")

# Is he type of shots proportion per player differ when he is on a different team ? What is the general proportion of the type of shots per player ?
#It will be cool to have the info of what team are available to choose from for a player
# UI
carlaUi <- fluidPage(
  titlePanel("Proportion of Shot Types per Player"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selectedPlayer", "Choose a player", choices = c(unique(data$player))),
      checkboxGroupInput("selectedQuarters", "Choose a time", choices = c(unique(data$quarter)),selected="1st quarter"),
      checkboxGroupInput("Shots", "Shots made", choices = c(unique(data$made)), selected="True"),
      checkboxGroupInput("selectedTeam", "Choose a team", choices = c(unique(data$team))),
    ),
    mainPanel(
      plotOutput("shotTypePlot")
    )
  )
)

# Serveur
carlaServer <- function(input, output) {
  filteredData <- reactive({
    data %>%
      filter(player == input$selectedPlayer, quarter %in% input$selectedQuarters, made %in% input$Shots, team %in% input$selectedTeam) #,  , # team %in% input$selectedTeam
  })

  output$shotTypePlot <- renderPlot({
    ggplot(filteredData(), aes(x = player, fill = shot_type)) +
      geom_bar(position = "fill") +
      scale_y_continuous(labels = scales::percent_format()) +
      labs(title = "Proportion of Shot Types per Player", x = "Player", y = "Proportion (%)", fill = "Type of shot") +
      theme_minimal()
  })
}
