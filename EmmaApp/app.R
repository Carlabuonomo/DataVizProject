library(shiny)
library(dplyr)
library(ggplot2)

# data <- read.csv("/Users/macbook/Desktop/etsiinf/dataViz/projet/nba2.csv")

# Define UI ----
emmaUi <- fluidPage(
  titlePanel("NBA Application"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Let's take a look at the team scores for each match"),
      
      dateInput("selectedDate", "Select a Date",
                value = min(data$date),
                min = min(data$date),
                max = max(data$date)),
      
      selectInput("match_id", "Select a Match",
                  choices = NULL),
      
      radioButtons("plotType", "Select Plot Type:",
                   choices = c("Line Chart", "Bar Chart"),
                   selected = "Line Chart")
    ),
    
    mainPanel(
      textOutput("team_names"),
      plotOutput("selected_plot")
    )
  )
)

# Define server logic ----
emmaServer <- function(input, output, session) {
  # Reactive values to store filtered data
  reactive_values <- reactiveValues(selectedMatchData = NULL)
  
  # Filter match_id based on the selected date
  observe({
    dateFilteredData <- data %>%
      filter(date == input$selectedDate)
    
    # Update choices for selectInput
    updateSelectInput(session, "match_id",
                      choices = unique(dateFilteredData$match_id))
  })
  
  # Observer to react to changes in the match_id selector
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
  
  # Observer to store filtered data in reactiveValues
  observe({
    reactive_values$selectedMatchData <- data %>%
      filter(match_id == input$match_id)
  })
  
  # Observer to create either a line chart or a bar chart based on user choice
  observe({
    selectedMatchData <- reactive_values$selectedMatchData
    selectedMatchData$time_game <- as.POSIXct(selectedMatchData$time_game, format = "%H:%M:%S")
    
    if (input$plotType == "Line Chart") {
      output$selected_plot <- renderPlot({
        ggplot(selectedMatchData, aes(x = time_game, y = teamPoints, color = team, group = team)) +
          geom_line() +
          labs(title = "Evolution of points for both teams in the match",
               x = "Game time",
               y = "Number of points") +
          scale_x_datetime(labels = scales::date_format("%M:%S")) +
          theme_minimal()
      })
    } else if (input$plotType == "Bar Chart") {
      output$selected_plot <- renderPlot({
        selectedMatchData <- selectedMatchData %>%
          mutate(time_group = case_when(
            time_game < as.POSIXct("00:12:00", format = "%H:%M:%S") ~ "Q1",
            time_game >= as.POSIXct("00:12:00", format = "%H:%M:%S") & time_game < as.POSIXct("00:24:00", format = "%H:%M:%S") ~ "Q2",
            time_game >= as.POSIXct("00:24:00", format = "%H:%M:%S") & time_game < as.POSIXct("00:36:00", format = "%H:%M:%S") ~ "Q3",
            time_game >= as.POSIXct("00:36:00", format = "%H:%M:%S") ~ "Q4"
          ))
        time_group_order <- c("Q1", "Q2", "Q3", "Q4")
        selectedMatchData$time_group <- factor(selectedMatchData$time_group, levels = time_group_order)
        head(selectedMatchData$teamPoints)
        selectedMatchData$teamPoints <- selectedMatchData$teamPoints 
        head(selectedMatchData$teamPoints)
        
        ggplot(selectedMatchData, aes(x = time_group, y = teamPoints , fill = team)) +
          geom_bar(stat = "identity", position = "dodge") +
          labs(title = "Score Evolution Over Time",
               x = "Time Group",
               y = "Number of points") +
          theme_minimal()
      })
    }
  })
  
}

# Run the app ----
# shinyApp(ui = ui, server = server)
