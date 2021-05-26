# load packages
library(tidyverse)

# load data from crowdtangle (historical data so available as a download-link sent via email)

data <- read_csv("data/raw/2021-05-17-10-59-15-CEST-Historical-Report-German-Parties-2004-02-03--2021-05-17.csv")

glimpse(data)

# put "Partei" und "Fraktion" in ein label: "party"
data$party <- fct_collapse(data$`Page Name`,
             cdu_csu = c("CDU", "CDU/CSU-Bundestagsfraktion"),
             spd = c("SPD", "SPD-Fraktion im Bundestag"),
             gruene = c("Bündnis 90/Die Grünen Bundestagsfraktion", "BÜNDNIS 90/DIE GRÜNEN"),
             fdp = c("FDP", "FDP Fraktion Bundestag"),
             linke = c("DIE LINKE", "Fraktion DIE LINKE. im Bundestag"),
             afd = c("AfD", "AfD-Fraktion im Deutschen Bundestag"))
# date

data <- data %>% 
  mutate(date = data$`Post Created Date`,
         year_month = format(data$`Post Created Date`, "%Y-%m"))

