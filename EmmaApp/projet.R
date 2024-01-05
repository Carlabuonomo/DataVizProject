# Pour virgule comme séparateur
#install.packages("hms")
#install.packages("chron")
dataTest <- read.csv("/Users/macbook/Desktop/etsiinf/dataViz/projet/nba.csv")

dataTest <- read.csv("/Users/macbook/Desktop/etsiinf/dataViz/projet/nba2.csv")
View(data)

library(dplyr)
library(hms)
library(stringr)
library(chron)
library(lubridate)

View(data)
#dataTest <- read.csv("/Users/macbook/Desktop/etsiinf/dataViz/projet/dataTest.csv")
#View(dataTest)

dataTest$time_remaining <- as.POSIXct(dataTest$time_remaining, format = "%M:%S")

######## Ajouter la nouvelle variable time_game en fonction du quart-temps
dataTest <- dataTest %>%
  mutate(
    x = case_when(
      quarter == "1st quarter" ~ as.POSIXct("00:00.0", format = "%M:%S"),
      quarter == "2nd quarter" ~ as.POSIXct("12:00.0", format = "%M:%S"),
      quarter == "3rd quarter" ~ as.POSIXct("24:00.0", format = "%M:%S"),
      quarter == "4th quarter" ~ as.POSIXct("36:00.0", format = "%M:%S")
    ),
    time_game = x + (as.POSIXct("12:00.0", format = "%M:%S") - time_remaining),
    time_game = format(time_game, "%H:%M:%S"),  # Nouvelle colonne pour l'affichage
    
    # Nouvelle colonne pour l'affichage de time_remaining
    time_remaining = format(time_remaining, "%H:%M:%S")
  )%>%
  select(-x)


########### Ajout variable point (Point de l'équipe)
dataTest <- dataTest %>%
  mutate(
    teamPoints= as.numeric(str_extract(score, "^\\d+"))
  )



write.csv(dataTest, "/Users/macbook/Desktop/etsiinf/dataViz/projet/nba2.csv", row.names = FALSE)



