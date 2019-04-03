
# Coleta feita no dia 03/04/2019

# Pacotes utilizados ------------------------------------------------------

library(dplyr)
library(stringr)
# library(readr)
library(purrr)
library(magrittr)
library(tidytext)
# library(lexiconPT)
library(stopwords)
library(tidyr)
library(wordcloud)


# Leitura dos dados -------------------------------------------------------

base <- 
  map(list.files("../data/csv"),
      ~ read.csv2(paste0("../data/csv/", .x), encoding = "UTF-8") %>% 
        cbind(presidente = .x %>% str_sub(end = -5)) %>% as_tibble  
  ) %>% 
  bind_rows() %>% 
  nest(-presidente)


# Tidy Text ---------------------------------------------------------------

base %<>% 
  mutate(
    tidytext = map(
      data,
      ~ .x %>% 
        mutate(
          tweet = as.character(tweet) %>% str_replace_all("(://|/)", ""),
          line = 1:nrow(.)
        ) %>% 
        select(line, tweet) %>% 
        unnest_tokens(word, tweet) %>% 
        anti_join(.,
                  tibble(word = c(stopwords("pt"), .$word[grep("^http", .$word)]))
        )
    )
  )


# Word Cloud --------------------------------------------------------------

base %<>% 
  mutate(
    wordcloud = walk(
      tidytext,
      ~ .x %>% 
        select(word) %>% 
        filter(word != "é") %>% 
        mutate(word = str_remove_all(word, "[:number:]{1,}")) %>% 
        count(word, sort = T) %>% 
        with(wordcloud(word, n, max.words = 100, min.freq = 5, random.order = F, random.color = T, rot.per = 0.05))
    )
  )
