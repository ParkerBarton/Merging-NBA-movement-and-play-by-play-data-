
library(RCurl)
library(jsonlite)
library(dplyr)
source("_functions.R")
all.movements <- sportvu_convert_json("/Users/parkerbarton/Desktop/UNZIPPED/0021500001.json")
str(all.movements)

gameid = "0021500001"
pbp <- get_pbp(gameid) 
head(pbp)

pbp <- pbp[-1,]
colnames(pbp)[2] <- c('event.id')
#Trying to limit the fiels to join to keep the overall size manageable
pbp <- pbp %>% select (event.id,EVENTMSGTYPE,EVENTMSGACTIONTYPE,SCORE)
pbp$event.id <- as.numeric(levels(pbp$event.id))[pbp$event.id]
all.movements.merged <- merge(x = all.movements, y = pbp, by = "event.id", all.x = TRUE)

id304 <- all.movements.merged[which(all.movements.merged$event.id == 304),]
head(id304)

#looking at how far players travel on misses, makes, and rebounds
Teague_make <- all.movements.merged[which(all.movements.merged$lastname == "Teague" & all.movements.merged$EVENTMSGTYPE == 1),]
Teague_miss <- all.movements.merged[which(all.movements.merged$lastname == "Teague" & all.movements.merged$EVENTMSGTYPE == 2),]
Teague_rebound <- all.movements.merged[which(all.movements.merged$lastname == "Teague" & all.movements.merged$EVENTMSGTYPE == 4),]
#Makes
travelDist(Teague_make$x_loc, Teague_make$y_loc)
#misses
travelDist(Teague_miss$x_loc, Teague_miss$y_loc)
#rebounds
travelDist(Teague_rebound$x_loc, Teague_rebound$y_loc)


#Comparing player distance on layups
player_layup <- all.movements.merged[which(all.movements.merged$EVENTMSGACTIONTYPE == 5),]
player.groups <- group_by(player_layup, lastname)
dist.traveled.players <- summarise(player.groups, totalDist=travelDist(x_loc, y_loc),playerid = max(player_id))
arrange(dist.traveled.players, desc(totalDist))

#Comparing player distance on dunks
player_dunk <- all.movements.merged[which(all.movements.merged$EVENTMSGACTIONTYPE == 7),]
player.groups2 <- group_by(player_dunk, lastname)
dist.traveled.players_dunk <- summarise(player.groups2, totalDist=travelDist(x_loc, y_loc),playerid = max(player_id))
arrange(dist.traveled.players_dunk, desc(totalDist))
