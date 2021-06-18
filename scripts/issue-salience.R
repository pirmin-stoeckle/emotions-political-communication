# load packages
library(tidyverse)
library(lubridate)
# load data from crowdtangle (historical data so available as a download-link sent via email)

data <- read_csv("data/raw/2021-05-27-17-30-45-CEST-Historical-Report-1969-12-31-Klimawandel-2021-05-27.csv")

glimpse(data)

data$date <- data$`Post Created Date`

data %>% 
  group_by(date) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(index = n/max(n)*100) %>% 
  ggplot(aes(x = date, y = index)) +
  geom_point() +
  geom_smooth()

library(gtrendsR)
library(tidyverse)
library(ggthemes)


searchterm <- "Klimawandel"
timeframe <- "2015-01-01 2021-03-11"
country <- "DE"

# gtrends data 
gtrends <- gtrends(keyword = c(searchterm), geo = country, time = timeframe)$interest_over_time

ggplot(gtrends, aes(x = date, y = hits)) +
  geom_point()

data %>% 
  group_by(date) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(index = n/max(n)*100) %>% 
  inner_join(gtrends, by = "date") %>% 
  ggplot(aes(x = date, y = index)) +
    geom_line() +
    geom_line(aes(x = date, y = hits), color = "blue")


