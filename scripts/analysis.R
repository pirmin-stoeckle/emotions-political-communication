# load data from data-preparation
source("scripts/data-preparation.R")


library(lubridate)

data %>% 
  group_by(`Page Name`) %>% 
  summarize(sum_interactions = sum(`Total Interactions`)) %>% 
  arrange(desc(sum_interactions))


data %>% 
  mutate(year_month = format(data$`Post Created Date`, "%Y-%m")) %>% 
  filter(year_month > "2017-01") %>% 
  group_by(`Page Name`, year_month) %>% 
  summarize(sum_interactions = sum(`Total Interactions`)) %>% 
  ggplot(aes(x = year_month, y = sum_interactions, group = `Page Name`)) +
    geom_point(aes(color = `Page Name`)) + 
    geom_smooth() +
    facet_wrap(~`Page Name`)

head(format(data$`Post Created Date`, "%Y-%m"))



head(data$Message)

library(tidytext)

data_token <- data %>%
  mutate(year_month = format(data$`Post Created Date`, "%Y-%m")) %>% 
  unnest_tokens(word, Message)
head(data_token$word)
