
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
library(ggplot2)
library(ggsci)


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
        mutate(word = str_remove_all(word, "[:number:]{1,}")) %>% 
        anti_join(.,
                  tibble(
                    word = c(stopwords("pt"), 
                             .$word[grep("^http", .$word)],
                             "",",","rt","é","q","p","c","link","en","r","ai")
                  )
        ) 
    )
  )
  

# Word Cloud --------------------------------------------------------------

# PROBLEMA #

# base %<>%
#   mutate(
#     wordcloud = map(
#       tidytext,
#       ~ .x %>%
#         select(word) %>% 
#         count(word, sort = T) %>% 
#         with(wordcloud(word, n, max.words = 100, min.freq = 5, 
#                        random.order = F, random.color = F, colors = rainbow(10)))
#     )
#   )


# 10 palavras mais frequentes ---------------------------------------------

base %<>% 
  mutate(
    freq_word = map(
      tidytext,
      ~ .x %>% 
        select(word) %>% 
        count(word, sort = T) %>% 
        head(10) %>% 
        mutate(word = str_to_title(word))
    )
  )


# Grafico

base %<>% 
  mutate(
    grafico = map(
      freq_word,
      ~ .x %>% 
        ggplot(aes(x = reorder(word, n), y = n, fill = word)) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        labs(x = "", y = "Frequência", title = "Palavras mais frequentes") +
        theme_minimal() +
        scale_fill_rickandmorty() +
        guides(fill = FALSE) 
        # geom_text(aes(label = n))
    )
  )

base$grafico







