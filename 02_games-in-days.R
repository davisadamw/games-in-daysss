library(tidyverse)
library(zoo)

all_gamelogs <- read_rds("all_games.rds")

# for this analysis, we only need year, day of year, and team names
all_teamgames <- all_gamelogs %>% 
  select(year, doy, away_team, home_team) %>% 
  pivot_longer(c(away_team, home_team), names_to = c("ha", ".value"), names_sep = "_") %>% 
  arrange(year, team, doy)

# for each team-year make a vector of zeroes the same length as the season, replace values with number of games
most_games_in_window <- function(days, games, window = 12) {
  
  # get the length of the season in days
  season_length <- max(days)
  
  # make the 0's
  season <- integer(length = season_length)
  
  # and drop the number of games into the right slots
  season[days] <- games
  
  # return the maximum number of games in window days
  max(rollsum(zoo(season), k = window, align = "left"))
}


most_in_12_result <- all_teamgames %>% 
  group_by(year, team, doy) %>% 
  summarize(games = n(), .groups = "drop_last") %>% 
  mutate(dos = doy - first(doy) + 1) %>% 
  summarize(most_in_12 = most_games_in_window(dos, games, window = 12),
            .groups = "drop")

most_in_12_result %>% 
  count(most_in_12)



