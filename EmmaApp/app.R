library(shiny)
library(dplyr)
library(ggplot2)

data <- read.csv("/Users/macbook/Desktop/etsiinf/dataViz/projet/nba2.csv")

# Define UI ----
ui <- fluidPage(
  titlePanel("NBA Application"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Let's take a look at the team scores for each match"),
      
      dateInput("selectedDate", "Select a Date",
                value = min(data$date),
                min = min(data$date),
                max = max(data$date)),
      
      selectInput("match_id", "Match",
                  choices = NULL)
    ),
    
    mainPanel(
      textOutput("team_names"),
      plotOutput("points_plot")
    )
  )
)

# Define server logic ----
server <- function(input, output, session) {
  
  # Filtrer les match_id en fonction de la date sélectionnée
  observe({
    dateFilteredData <- data %>%
      filter(date == input$selectedDate)
    
    # Mettre à jour les choix du selectInput
    updateSelectInput(session, "match_id",
                      choices = unique(dateFilteredData$match_id))
  })
  
  # Observer pour réagir aux changements dans le sélecteur de match_id
  observe({
    selectedMatchData <- data %>%
      filter(match_id == input$match_id) %>%
      select(team) %>%
      distinct()
    
    teamNames <- unique(selectedMatchData$team)
    output$team_names <- renderText({
      if (length(teamNames) == 2) {
        paste("The match is between", teamNames[1], " & ", teamNames[2])
      } else {
        "Select a match to display team names."
      }
    })
  })
  
  observe({
    selectedMatchData <- data %>%
      filter(match_id == input$match_id)
    
    # Convertir la colonne time_game en POSIXct
    selectedMatchData$time_game <- as.POSIXct(selectedMatchData$time_game, format = "%H:%M:%S")
    
    output$points_plot <- renderPlot({
      ggplot(selectedMatchData, aes(x = time_game, y = teamPoints, color = team, group = team)) +
        geom_line() +
        labs(title = "Evolution of points for both teams in the match",
             x = "Game time",
             y = "Number of points") +
        scale_x_datetime(labels = scales::date_format("%M:%S")) +  # Formater la légende du temps
        theme_minimal()
    })
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)
