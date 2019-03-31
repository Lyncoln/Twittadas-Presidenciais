# Coleta feita no dia 31/03/2019

library(dplyr)
library(lexiconPT)
library(stringr)
library(tidytext)
library(stopwords)
library(magrittr)

base_dilma <- read.csv2("../data/csv/Dilma Rousseff.csv", encoding = "UTF-8") %>% as_tibble()

base_dilma %<>% 
  mutate(
    tweet = as.character(tweet) %>% str_replace_all("(://|/)", ""),
    line = 1:nrow(.)
    ) %>% 
  select(line, tweet) %>% 
  unnest_tokens(word, tweet) 
  
my_stop_words <- tibble(word = c(stopwords("pt"), base_dilma$word[grep("^http", base_dilma$word)]))

base_dilma %<>% anti_join(my_stop_words)
