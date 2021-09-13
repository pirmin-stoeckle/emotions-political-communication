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
  filter(date > "2016-01-01") %>% 
  group_by(party, date_week) %>% 
  summarize(total_interactions = sum(total_interactions)/1000) %>% 
  ggplot(aes(x = date_week, y = total_interactions)) +
  geom_point(aes(color = party), alpha = 0.4) + 
  #geom_smooth() +
  facet_wrap(~fct_inorder(party)) +
  labs(title = "Total weekly interactions with Facebook posts by the respective party (in thousands)",
       x = "",
       y = "") +
  scale_color_manual(breaks = c("AfD", 
                                "CSU (Christlich-Soziale Union)", 
                                "DIE LINKE",
                                "SPD",
                                "CDU",
                                "FDP",
                                "BÜNDNIS 90/DIE GRÜNEN"),
                     values=c("darkblue", 
                              "skyblue1", 
                              "magenta4",
                              "red",
                              "black",
                              "yellow2",
                              "green")) +
  theme(legend.position = "NONE")

ggsave(filename = "./figures/total_interactions.png", device = png(), width = 20, height = 10, units = "cm")

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
  filter(date > "2016-01-01") %>% 
  ggplot(aes(x = date, y = angry_share)) +
  geom_point(aes(color = party), alpha = 0.4) + 
  geom_smooth() +
  facet_wrap(~party) +
  labs(title = "Share of 'Angry' reactions on all reactions to a post",
       x = "",
       y = "") +
  ylim(c(0, 1)) +
  scale_color_manual(breaks = c("AfD", 
                                "CSU (Christlich-Soziale Union)", 
                                "DIE LINKE",
                                "SPD",
                                "CDU",
                                "FDP",
                                "BÜNDNIS 90/DIE GRÜNEN"),
                     values=c("darkblue", 
                              "skyblue1", 
                              "magenta4",
                              "red",
                              "black",
                              "yellow2",
                              "green")) +
  theme(legend.position = "NONE")

ggsave(filename = "./figures/angry_share.png", device = png())

getwd()
# was ist da bei der spd los
data %>% 
  filter(party == "SPD") %>% 
  arrange(desc(angry_share)) %>% 
  select(date, Message, angry_share) %>% 
  head(20)

# love by party over time
data %>%
  filter(date > "2016-01-01") %>% 
  ggplot(aes(x = date, y = love_share)) +
  geom_point(aes(color = party), alpha = 0.4) + 
  geom_smooth() +
  facet_wrap(~party) +
  labs(title = "Share of 'Love' reactions on all reactions to a post",
       x = "",
       y = "") +
  ylim(c(0, 1)) +
  scale_color_manual(breaks = c("AfD", 
                                "CSU (Christlich-Soziale Union)", 
                                "DIE LINKE",
                                "SPD",
                                "CDU",
                                "FDP",
                                "BÜNDNIS 90/DIE GRÜNEN"),
                     values=c("darkblue", 
                              "skyblue1", 
                              "magenta4",
                              "red",
                              "black",
                              "yellow2",
                              "green")) +
  theme(legend.position = "NONE")

ggsave(filename = "./figures/love_share.png", device = png())

# Since 2017, what is the distribution of love and share
summary(data[data$date > "2017-01-01",]$Love)
summary(data[data$date > "2017-01-01",]$Angry)

table(data[data$date > "2017-01-01",]$Love>10)
table(data[data$date > "2017-01-01",]$Angry>8)

table(data[data$date > "2017-01-01",]$Angry>10, data[data$date > "2017-01-01",]$Love>8)
# -> these things could be predicted by a machine learning model from characteristics of the post

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