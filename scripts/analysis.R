# load data from data-preparation
source("scripts/data-preparation.R")


library(lubridate)
# set standard theme
theme_set(theme_minimal())

# total interactions by party
data %>% 
  group_by(party) %>% 
  summarize(n_posts = n(),
            sum_interactions = sum(total_interactions)) %>% 
  arrange(desc(sum_interactions))


# interactions by party over time
data %>%
  filter(date > "2017-01-01") %>% 
  ggplot(aes(x = date, y = total_interactions, group = party)) +
  geom_point(aes(color = party)) + 
  geom_smooth() +
  facet_wrap(~party) 


# when was the introduction of reactions? (2016)
data %>% 
  filter(Angry > 0) %>% 
  arrange(date) %>% 
  select(Message, party, Angry, date) %>% 
  head()

ggplot(data[data$date > "2017-01-01",], aes(x = date, y = Angry)) +
  geom_point()

# angry by party over time
data %>%
  filter(date > "2017-01-01") %>% 
  group_by(party) %>% 
  ggplot(aes(x = date, y = angry_share, group = party)) +
  geom_point(aes(color = party), alpha = 0.2) + 
  geom_smooth() +
  #geom_vline(xintercept = date("2017-09-24")) + # BTW
  #geom_vline(xintercept = date("2020-03-19")) + # Merkels Anpsrache
  facet_wrap(~party)

# was ist da bei der spd los
data %>% 
  filter(party == "SPD") %>% 
  arrange(desc(angry_share)) %>% 
  select(date, Message, angry_share) %>% 
  head(20)

# love by party over time
data %>%
  filter(date > "2017-01-01") %>% 
  group_by(party) %>% 
  ggplot(aes(x = date, y = love_share, group = party)) +
  geom_point(aes(color = party), alpha = 0.2) + 
  geom_smooth() +
  facet_wrap(~party)

# Since 2017, what is the distribution of love and share
summary(data[data$date > "2017-01-01",]$Love)
summary(data[data$date > "2017-01-01",]$Angry)

table(data[data$date > "2017-01-01",]$Love>10)
table(data[data$date > "2017-01-01",]$Angry>8)

table(data[data$date > "2017-01-01",]$Angry>10, data[data$date > "2017-01-01",]$Love>8)
# -> these things could be predicted by a machine learning model from characteristics of the post

library(tidytext)

data_token <- data %>%
  unnest_tokens(word, Message)
head(data_token$word)

# most successful post
data %>% 
  arrange(desc(total_interactions)) %>% 
  select(party, total_interactions, Message) %>% 
  head() %>% 
  pull(Message)

# post with most angry reactions
data %>% 
  arrange(desc(Angry)) %>% 
  head() %>% 
  pull(Message, Angry)


table(str_detect(data$Message, "Corona"))
