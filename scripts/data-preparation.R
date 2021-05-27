# load packages
library(tidyverse)
library(lubridate)
# load data from crowdtangle (historical data so available as a download-link sent via email)

data <- read_csv("data/raw/2021-05-27-14-03-55-CEST-Historical-Report-German-Political-Parties-1969-12-31--2021-05-27.csv")

glimpse(data)

# put "Partei" und "Fraktion" in ein label: "party"
# data$party <- fct_collapse(data$`Page Name`,
#              cdu_csu = c("CDU", "CDU/CSU-Bundestagsfraktion"),
#              spd = c("SPD", "SPD-Fraktion im Bundestag"),
#              gruene = c("Bündnis 90/Die Grünen Bundestagsfraktion", "BÜNDNIS 90/DIE GRÜNEN"),
#              fdp = c("FDP", "FDP Fraktion Bundestag"),
#              linke = c("DIE LINKE", "Fraktion DIE LINKE. im Bundestag"),
#              afd = c("AfD", "AfD-Fraktion im Deutschen Bundestag"))

data$party <- as.factor(data$`Page Name`)

summary(data$party)

# date
data <- data %>% 
  mutate(date = data$`Post Created Date`,
         date_day = round_date(date, unit = "day"),
         date_week = round_date(date, unit = "week"),
         date_month = round_date(date, unit = "month"),
         date_year = round_date(date, unit = "year"))
summary(data$date_day)

# interactions
data$total_interactions <-  data$`Total Interactions`

summary(data$total_interactions)

# reactions as share on all interactions
data <- data %>% 
  mutate(reactions = Likes + Love + Wow + Haha + Sad + Angry + Care,
         likes_share = Likes / reactions,
         love_share = Love / reactions,
         wow_share = Wow / reactions,
         haha_share = Haha / reactions,
         sad_share = Sad / reactions,
         angry_share = Angry / reactions,
         care_share = Care / reactions)

data %>% 
  select(reactions:care_share) %>% 
  summary()

