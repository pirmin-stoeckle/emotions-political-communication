source("scripts/data-preparation.R")

library(tidytext)

glimpse(data)

# add id to data
data$id <- rownames(data)

# tokenize post content
tidy_posts <- data %>%
  unnest_tokens(word, Message)

# remove stopwords
tidy_posts <- tidy_posts %>% 
  anti_join(get_stopwords(language = "de")) 

# most common words
tidy_posts %>% 
  count(word, sort = TRUE)
# -> I need more stopwords

# maybe from package "lsa" as hinted at here: https://sebastiansauer.github.io/textmining_AfD_01/
library(lsa)
data(stopwords_de)
stopwords_de <- data_frame(word = stopwords_de)

# remove stopwords
tidy_posts <- tidy_posts %>% 
  anti_join(stopwords_de) 

# most common words
tidy_posts %>% 
  count(word, sort = TRUE)
# -> I stil need more stopwords...

tidy_posts %>% 
  count(word, sort = TRUE) %>% 
  top_n(30) %>% 
  htmlTable::htmlTable()

# word stemming
tidy_posts <- tidy_posts %>% 
  mutate(word_stem = wordStem(.$word, language = "german")) 

tidy_posts %>% 
  count(word_stem, sort = TRUE) %>% 
  top_n(30) %>% 
  htmlTable::htmlTable()


# sentiment (https://wortschatz.uni-leipzig.de/de/download)
neg_df <- read_tsv("data/raw/SentiWS_v2.0_Negative.txt", col_names = FALSE)
names(neg_df) <- c("Wort_POS", "score", "Inflektionen")

neg_df <- neg_df %>% 
  mutate(word = str_sub(Wort_POS, 1, regexpr("\\|", .$Wort_POS)-1),
         POS = str_sub(Wort_POS, start = regexpr("\\|", .$Wort_POS)+1))

pos_df <- read_tsv("data/raw/SentiWS_v2.0_Positive.txt", col_names = FALSE)
names(pos_df) <- c("Wort_POS", "score", "Inflektionen")

pos_df <- pos_df %>% 
  mutate(word = str_sub(Wort_POS, 1, regexpr("\\|", .$Wort_POS)-1),
         POS = str_sub(Wort_POS, start = regexpr("\\|", .$Wort_POS)+1))

sentiment_df <- bind_rows("neg" = neg_df, "pos" = pos_df, .id = "neg_pos") 
sentiment_df <- sentiment_df %>% select(neg_pos, word, score, Inflektionen, -Wort_POS)


# unweighted sentiment analyis
sentiment_neg <- match(tidy_posts$word, filter(sentiment_df, neg_pos == "neg")$Wort)
neg_score <- sum(!is.na(sentiment_neg))

sentiment_pos <- match(tidy_posts$word, filter(sentiment_df, neg_pos == "pos")$Wort)
pos_score <- sum(!is.na(sentiment_pos))

round(pos_score/neg_score, 1)

# which positive and negative words are used?
negative_sentiments <- tidy_posts %>% 
  filter(!is.na(sentiment_neg)) %>% 
  select(word) 

head(negative_sentiments$word,50)

positive_sentiments <- tidy_posts %>% 
  filter(!is.na(sentiment_pos)) %>% 
  select(word) 

head(positive_sentiments$word,50)

# distinct words
tidy_posts %>% 
  filter(!is.na(sentiment_neg)) %>% 
  summarise(n_distinct_neg = n_distinct(word))

tidy_posts %>% 
  filter(!is.na(sentiment_pos)) %>% 
  summarise(n_distinct_pos = n_distinct(word))

# weighted sentiment
tidy_posts <- tidy_posts %>% 
  left_join(sentiment_df, by = "word")

tidy_posts_sentiment <- tidy_posts %>% 
  filter(!is.na(score)) %>% 
  summarise(sentiment_sum = sum(score, na.rm = TRUE))

tidy_posts %>% 
  group_by(neg_pos) %>% 
  filter(!is.na(score)) %>% 
  summarise(sentiment_score = sum(score)) 

# sentiment score by party
tidy_posts %>% 
  group_by(party) %>% 
  filter(!is.na(score)) %>% 
  summarise(sentiment_score = sum(score),
            relevant_words = n()) 


# extreme sentiments
tidy_posts %>% 
  filter(neg_pos == "pos") %>% 
  distinct(word, .keep_all = TRUE) %>% 
  arrange(-score) %>% 
  filter(row_number() < 11) %>% 
  select(word, score)

tidy_posts %>% 
  filter(neg_pos == "neg") %>% 
  distinct(word, .keep_all = TRUE) %>% 
  arrange(score) %>% 
  filter(row_number() < 11) %>% 
  select(word, score)

# aggregate to post
tidy_posts <- tidy_posts %>% 
  group_by(id) %>% 
  mutate(sentiment_per_post = sum(Wert, na.rm = TRUE))

tidy_posts %>% 
  arrange(sentiment_per_post) %>% 
  slice_head(10)
