library(shiny)
library(tidyverse)
library(hexbin)
library(httr)
library(jsonlite)
library(data.table)

marwinUi <- sidebarLayout(
              sidebarPanel(
               radioButtons(inputId = "chart_type",
                            label = "Chart Type",
                            choices = c("Scatter", "Heat Map"),
                            selected = "Scatter"),
               
               radioButtons(inputId = "group_type",
                            label = "Filter by",
                            choices = c("Player", "Team", "Match"),
                            selected = "Player"),
               uiOutput("team_filter"),
               uiOutput("player_filter"),
               uiOutput("match_filter"),
               
               radioButtons(inputId = "shot_type",
                            label = "Type of Shot",
                            choices = c("All", "2-pointer", "3-pointer"),
                            selected= "All"),
               
               radioButtons(inputId = "made_type",
                            label = "Made or Miss",
                            choices = c("Both", "Made"=TRUE, "Missed"=FALSE),
                            selected= "Both"),
               
               sliderInput(inputId = "distance_range",
                           label = "Distance",
                           value = c(0,50),
                           min = 0,
                           max = 50),
               
               
             ),
             mainPanel(
               uiOutput("card_header"),
               plotOutput("court", width = "auto", height = "auto"),
             )
           )