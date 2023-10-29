# Possible questions for Data Visualization

## Question 1
> How does the distribution of successful shots evolve as a function of time remaining, distinguishing between 3-point shots and 2-point shots for each quarter?

**Graph**
Line graph with two curves (3-points and 2-points) per quarter

**Associated variables**
time_remaining, made, shot_type, quarter

## Question 2
> What is the relationship between the position of shots on the court (shotX and shotY) and the success rate (made), taking into account the time remaining and the type of shot (3-points or 2-points)?

**Graph**
Heatmap with interactive filters for time remaining and shot type

**Associated variables**
shotX, shotY, made, time_remaining, shot_type

## Question 3
> How does the distribution of successful shots per player evolve as a function of playing time, taking into account the quarter and the type of shot (3-points or 2-points)?

**Graph**
Stacked bar graph per player with filters for quarter and shot type

**Associated variables**
player, made, time_remaining, quarter, shot_type

## Question 4
> What is the correlation between the position of shots on the court (shotX and shotY) and the number of successful shots per quarter, differentiating between teams?

**Graph**
Heatmap with colored areas for each team and correlation curves

**Associated variables**
shotX, shotY, made, quarter, team

## Question 5
> How does the distribution of successful shots evolve as a function of time remaining, differentiating players by color codes and showing 3-point and 2-point shots?

**Graph**
Density diagram with color-coded player, divided into 3-point and 2-point shots.

**Associated variables**
time_remaining, made, player, shot_type

## Question 6
> What is the trend in successful shots as a function of time remaining, taking into account the total number of rebounds after each shot?

**Graph**
Line graph with a curve for successful shots and a curve for rebounds as a function of time remaining.
**Associated variables**
time_remaining, made, rebounds

## Question 7
> How does the distribution of successful shots evolve as a function of time remaining and player fatigue (which can be measured by the number of previous games played by each player)?

**Graph**
Stacked bar chart with time remaining on the abscissa and number of previous matches played on the color scale.
**Associated variables**
time_remaining, made, player, match_id

## Question 8
> What is the relationship between shot position (shotX and shotY), match period (1st or 2nd) and success rate (made)?

**Graph**
Heatmap with filters for match period and correlation curves
**Associated variables**
shotX, shotY, made, quarter

## Question 9
> How does the distribution of successful shots evolve as a function of time remaining, taking into account the position of shots on the field (shotX and shotY) and differentiating between teams?

**Graph**
Heatmap with interactive filters for time remaining, shot coordinates and teams
**Associated variables**
time_remaining, made, shotX, shotY, team

## Question 10
> What is the trend in successful shots as a function of time remaining, taking into account the score difference between teams (point difference)?

**Graph**
Line graph with a curve for successful shots as a function of time remaining, colored according to the score difference.
**Associated variables**
time_remaining, made, score_difference

## Question 11
> How does the distribution of successful shots as a function of time remaining evolve, differentiating between home and away games?

**Graph**
Grouped bar chart with time remaining on the x-axis, home and away matches in color
**Associated variables**
time_remaining, made, home/away

## Question 12
> What is the relationship between success rate (made) and time remaining, distinguishing between players who have already achieved a double-double (double digit in points and rebounds) in the game?

**Graph**
Line graph with separate curves for players with and without a double-double, as a function of time remaining.
**Associated variables**
time_remaining, made, player, double-double

## Question 13
> How does the distribution of successful shots evolve as a function of time remaining, taking into account the position of shots on the court (shotX and shotY), and showing evolutions between quarters?

**Graph**
Heatmap with animation for each quarter showing evolution over time
**Associated variables**
time_remaining, made, shotX, shotY, quarter

## Question 14
> What is the relationship between success rate (made) and shot position (shotX and shotY), taking into account individual player characteristics such as height and number of games played this season?

**Graph**
Scatter plot with one point size dimension for individual player characteristics
**Associated variables**
shotX, shotY, made, player, size, matches_played
