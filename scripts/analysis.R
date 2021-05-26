# load data from data-preparation
source("scripts/data-preparation.R")


library(lubridate)

data %>% 
  group_by(party) %>% 
  summarize(sum_interactions = sum(`Total Interactions`)) %>% 
  arrange(desc(sum_interactions))

data %>% 
  ggplot(aes(x = `Total Interactions`)) +
  geom_histogram(bins = 100) +
  facet_wrap(~party)


data %>%
  filter(date > "2017-09-24") %>% 
  mutate(date_week = round_date(date, unit = "week")) %>% 
  group_by(party, date_week) %>% 
  summarize(sum_interactions = sum(`Total Interactions`)) %>% 
  ggplot(aes(x = date_week, y = sum_interactions, group = party)) +
  geom_point(aes(color = party)) + 
  geom_smooth() +
  facet_wrap(~party)

data %>% 
  mutate(year_month = format(data$`Post Created Date`, "%Y-%m")) %>% 
  filter(year_month > "2017-01") %>% 
  group_by(party, year_month) %>% 
  summarize(sum_interactions = sum(`Total Interactions`)) %>% 
  ggplot(aes(x = year_month, y = sum_interactions, group = party)) +
    geom_point(aes(color = party)) + 
    geom_smooth() +
    facet_wrap(~party)

head(format(data$`Post Created Date`, "%Y-%m"))

names(data)
data %>% 
  filter(year_month > "2017-01") %>% 
  group_by(party, year_month) %>% 
  summarize(n = n(),
            interactions = sum(`Total Interactions`),
            love = sum(Love),
            angry = sum(Angry),
            shares = sum(Shares),
            interaction_per_post = interactions/n,
            love_per_post = love/n) %>% 
  ggplot(aes(x = date, y = n, group = party)) +
  geom_point(aes(color = party)) + 
  geom_smooth() +
  facet_wrap(~party)

ggplot(data, aes(x = date, y = `Total Interactions`, group = party)) +
  geom_point(aes(color = party)) + 
  geom_smooth() +
  facet_wrap(~party)


head(data$Message)

library(tidytext)

data_token <- data %>%
  mutate(year_month = format(data$`Post Created Date`, "%Y-%m")) %>% 
  unnest_tokens(word, Message)
head(data_token$word)
