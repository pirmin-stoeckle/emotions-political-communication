source("scripts/data-preparation.R")

library(tidytext)

# add if to data
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

# maybe from package "lsa" as hinted at hgere: https://sebastiansauer.github.io/textmining_AfD_01/
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
getwd()
neg_df <- read_tsv("data/raw/SentiWS_v2.0_Negative.txt", col_names = FALSE)
names(neg_df) <- c("Wort_POS", "Wert", "Inflektionen")

neg_df <- neg_df %>% 
  mutate(Wort = str_sub(Wort_POS, 1, regexpr("\\|", .$Wort_POS)-1),
         POS = str_sub(Wort_POS, start = regexpr("\\|", .$Wort_POS)+1))

pos_df <- read_tsv("data/raw/SentiWS_v2.0_Positive.txt", col_names = FALSE)
names(pos_df) <- c("Wort_POS", "Wert", "Inflektionen")

pos_df <- pos_df %>% 
  mutate(Wort = str_sub(Wort_POS, 1, regexpr("\\|", .$Wort_POS)-1),
         POS = str_sub(Wort_POS, start = regexpr("\\|", .$Wort_POS)+1))

sentiment_df <- bind_rows("neg" = neg_df, "pos" = pos_df, .id = "neg_pos") 
sentiment_df <- sentiment_df %>% select(neg_pos, Wort, Wert, Inflektionen, -Wort_POS)

