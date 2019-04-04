
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
                             "",",","rt","é","q","p","c","link","en","r","ai","h","a","ñ")
                  )
        ) 
    )
  )
  

# Word Cloud --------------------------------------------------------------

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

# library(ggwordcloud)
# library(wordcloud)
# library(RColorBrewer)
# 
# # map(
# #   base$tidytext,
# #   ~ base$tidytext[[1]] %>%
# #     select(word) %>%
# #     count(word, sort = T) %>%
# #     with(wordcloud(word, n, max.words = 200, min.freq = 5, colors = brewer.pal(8, "Dark2")))
# # )
# 
# base$tidytext[[1]] %>% 
#   select(word) %>%
#   count(word, sort = T) %>% 
#   head(100) %>% 
#   mutate(angle = 45 * sample(-2:2, n(), replace = TRUE, prob = c(1, 1, 4, 1, 1))) %>% 
#   ggplot(aes(
#     label = word, size = n, angle = angle
#   )) +
#   geom_text_wordcloud()



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
    grafico = map2(
      freq_word, base$presidente,
      ~ .x %>% 
        ggplot(aes(x = reorder(word, n), y = n, fill = word)) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        labs(x = "", y = "Frequência", title = paste0("Palavras mais frequentes - ", .y),
             caption = "Fonte: Twitter pessoal do presidente") +
        theme_minimal() +
        scale_fill_rickandmorty() +
        guides(fill = FALSE) +
        geom_text(aes(label = n), hjust = -0.2)
    )
  )









