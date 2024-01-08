

library(shiny)
library(ggplot2)
library(dplyr)

#How does the proportion of shot types for a player vary over different quarters?
#Do specific players exhibit a significant change in the proportion of shot types when transitioning from one team to another, and are there any noticeable patterns or anomalies in these transitions?
#Are there noticeable variations in the shot type preferences of individual players across different quarters, and do these variations suggest any strategic changes or player tendencies during specific periods of a game?

# data <- fread("data/nba.csv", sep = ",")

# Is he type of shots proportion per player differ when he is on a different team ? What is the general proportion of the type of shots per player ?
#It will be cool to have the info of what team are available to choose from for a player
# UI
carlaUi <- fluidPage(
  titlePanel("Proportion of Shot Types per Player"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selectedPlayer", "Choose a player", choices = unique(data$player)),
      selectInput("selectedTeam", "Choose a team", choices = NULL),
      selectInput("selectedMatch", "Choose a match", choices = NULL),
    ),
    mainPanel(
      plotOutput("shotTypePlot")
    )
  )
)

# Serveur
carlaServer <- function(input, output, session) {
  # Reactive values to store filtered data
  reactive_values <- reactiveValues(selectedTeamData = NULL)

  # Filter team based on the selected player
  observe({
    PlayerFilteredData <- data %>%
      filter(player == input$selectedPlayer)

    # Update choices for selectInput
    updateSelectInput(session, "selectedTeam",
                      choices = unique(PlayerFilteredData$team))
  })

  # Filter match based on the selected team & player
  observe({
    PlayerTeamFilteredData <- data %>%
      filter(player == input$selectedPlayer, team == input$selectedTeam)

    # Update choices for selectInput
    updateSelectInput(session, "selectedMatch",
                      choices = unique(PlayerTeamFilteredData$match_id))
  })

  # Observer to store filtered data in reactiveValues
  observe({
    reactive_values$selectedTeamData <- data %>%
      filter(
        player == input$selectedPlayer,
        team == input$selectedTeam,
        match_id == input$selectedMatch
      )
  })

  # Function to filter data based on reactive_values
  filteredData <- reactive({
    reactive_values$selectedTeamData
  })

  output$shotTypePlot <- renderPlot({
    ggplot(filteredData(), aes(x = as.factor(quarter), fill = shot_type)) +
      geom_bar(position = "fill", stat = "count") +
      scale_y_continuous(labels = scales::percent_format()) +
      labs(title = "Proportion of Shot Types per Quarter", x = "Quarter", y = "Proportion (%)", fill = "Type of shot") +
      theme_minimal()
  })
}
