library(data.table)
data <- fread("data/nba_full.csv")
marwinServer = function(input, output, session) {

  court_plot = reactive({
    plot_court()
  })

  shots = reactive({
    shots = data
    # Player filter
    if (input$group_type == "Player") {
      shots = shots[date %between% input$player_date_range]
      shots = shots[player == input$player_name]
    }
    
    # Team filter
    if (input$group_type == "Team") {
      shots = shots[date %between% input$team_date_range]
      shots = shots[team == input$team_name]
    }
    
    # Match filter
    if (input$group_type == "Match") {
      shots = shots[match_id == input$selected_match]
      if (input$selected_quarter != "All") {
        shots = shots[quarter == input$selected_quarter]
      }
    }
    
    if (input$shot_type != "All") {
      shots = shots[shot_type == input$shot_type]
    }
    if (input$made_type != "Both") {
      shots = shots[made == input$made_type]
    }
    shots = shots[distance %between% input$distance_range]
    
    shots
  })

  shot_chart = reactive({
    req(
      input$chart_type,
      court_plot()
    )

    if (input$chart_type == "Scatter") {
      generate_scatter_chart(
        shots(),
        base_court = court_plot()
      )
    } else if (input$chart_type == "Heat Map") {
      generate_heatmap_chart(
        shots(),
        base_court = court_plot()
      )
    } else {
      stop("invalid chart type")
    }
  })
  
  output$card_header = renderUI({
    if (input$group_type == "Player") {
      tagList(
        h1(input$player_name, align="center"),
        h2(paste(" (",
                 input$player_date_range[1],
                 ", ",
                 input$player_date_range[2],
                 ")",
                 sep=""), align="center"),
      )
    } else if (input$group_type == "Team") {
      tagList(
        h1(input$team_name, align="center"),
        h2(paste(" (",
                 input$team_date_range[1],
                 ", ",
                 input$team_date_range[2],
                 ")",
                 sep=""), align="center"),
      )
    } else if (input$group_type == "Match") {
      tagList(
        h1(input$selected_match, align="center")
      )
    }
  })
  
  output$match_filter = renderUI({
    req(input$group_type == "Match")
    tagList(
      selectizeInput(inputId = "selected_match",
                     label = "Match",
                     choices = c(unique(data$match))),
      selectInput(inputId = "selected_quarter",
                  label = "Quarter",
                  choices = NULL,
                  selected = "All"),
    )
  })
  
  observe({input$selected_match
    updateSelectizeInput(session = session,
                         inputId = "selected_quarter",
                         choices = unique(data[match_id %in% input$selected_match]$quarter))
  })
  
  output$team_filter = renderUI({
    req(input$group_type == "Team")
    tagList(
      selectizeInput(inputId = "team_name",
                     label = "Team",
                     choices = c(unique(data$team))),
      
      dateRangeInput(inputId = "team_date_range",
                     label = "Date range")
  )})
  
  observe({input$team_name
    updateDateRangeInput(session = session,
                         inputId = "team_date_range",
                         start = min(data$date),
                         end = min(data[team %in% input$team_name]$date),
                         min = min(data[team %in% input$team_name]$date),
                         max = max(data[team %in% input$team_name]$date))
                         
  })
  
  output$player_filter = renderUI({
    req(input$group_type == "Player")
    tagList(
      selectizeInput(inputId = "player_name",
                     label = "Player",
                     choices = c(unique(data$player)),
                     selected = "Please Select Player"),
      
      dateRangeInput(inputId = "player_date_range",
                     label = "Date range")
  )})
  
  observe({input$player_name
    updateDateRangeInput(session = session,
                         inputId = "player_date_range",
                         start = min(data[player %in% input$player_name]$date),
                         end = min(data[player %in% input$player_name]$date),
                         min = min(data[player %in% input$player_name]$date),
                         max = max(data[player %in% input$player_name]$date))
    
  })

  output$court = renderPlot({
    req(shot_chart())
    withProgress({
      shot_chart()
    }, message = "Calculating...")
  }, height = 600, width = 800, bg = "transparent")
  
}
