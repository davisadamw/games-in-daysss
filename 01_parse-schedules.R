library(tidyverse)
library(lubridate)

# all I care about here is date and teams, but I'll grab scores too
read_gamelogs <- function(path, width = 161) {
  # using the readr short representation of column types
  col_types_use <- str_pad("cc_ccicciii", width = width, side = "right", pad = "_")
  
  # read the columns we want
  data <- read_csv(path, col_names = FALSE, col_types = col_types_use)
  
  # assign column names
  names(data) <- c("date", "gametype", 
                   "away_team", "away_league", "away_gameno",
                   "home_team", "home_league", "home_gameno",
                   "away_score", "home_score")

  # return the result  
  data
}

# do this for all the years, parse the dates 
all_gamelogs <- list.files("gl1871_2019", full.names = TRUE) %>% 
  map_dfr(read_gamelogs) %>% 
  mutate(year = as.integer(str_sub(date, 1, 4)),
         doy  = yday(ymd(date)),
         .after = date)

all_gamelogs %>% 
  write_rds("all_games.rds", compress = "gz")
