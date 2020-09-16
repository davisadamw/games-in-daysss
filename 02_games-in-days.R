library(tidyverse)

all_gamelogs <- read_rds("all_games.rds")

# for this analysis, we only need year, day of year, and team names
all_teamgames <- all_gamelogs %>% 
  select(year, doy, away_team, home_team) %>% 
  pivot_longer(c(away_team, home_team), names_to = c("ha", ".value"), names_sep = "_") %>% 
  arrange(year, team, doy)

down_to_days <- all_teamgames %>% 
  group_by(year, team, doy) %>% 
  summarize(games = n(), .groups = "drop_last") %>% 
  mutate(dos = doy - first(doy))

# for each team-year make a vector of zeroes the same length as the season, replace values with number of games

