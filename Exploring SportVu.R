library(RCurl)
library(jsonlite)
library(dplyr)
library(plotly)
source("_functions.R")

all.movements <- sportvu_convert_json("/Users/parkerbarton/Desktop/UNZIPPED/0021500001.json")
str(all.movements)
id303 <- all.movements[which(all.movements$event.id == 303),]
Teague <- all.movements[which(all.movements$lastname == "Teague" & all.movements$event.id == 303),]

p <- plot_ly(data = Teague, x = Teague$x_loc, y = Teague$y_loc, mode = "markers", color=cut(Teague$game_clock, breaks=3)) %>% 
    layout(xaxis = list(range = c(0, 100)),
           yaxis = list(range = c(0, 50))) 

p

#Distance Traveled
travelDist(Teague$x_loc, Teague$y_loc)

#speed 
seconds = max(Teague$game_clock) - min(Teague$game_clock)
speed = travelDist(Teague$x_loc, Teague$y_loc)/seconds  #in feet per second
speed

#generalizing this approach to all the players
player.groups <- group_by(id303, lastname)
dist.traveled.players <- summarise(player.groups, totalDist=travelDist(x_loc, y_loc),playerid = max(player_id))
arrange(dist.traveled.players, desc(totalDist))

#Get distance for all the players for the entire game
move.data <- unique( all.movements[ , 1:12 ] )  ##This takes about 30 seconds to run
player.groups <- group_by(move.data, lastname)
dist.traveled.players <- summarise(player.groups, totalDist=travelDist(x_loc,y_loc),playerid = max(player_id))
total <- arrange(dist.traveled.players, desc(totalDist))
total

#Get the distance between a player and the ball for one event (using functions)
#Get Clock Info
clockinfo <- get_game_clock("Teague",303)

playerdistance <- player_dist("Teague","ball",303)

plot_ly(data = clockinfo, x=Teague$game_clock, y=playerdistance,mode = "markers")





