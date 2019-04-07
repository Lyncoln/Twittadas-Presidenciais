
# Coleta feita no dia 03/04/2019 via API do twitter pelo python

# Pacotes utilizados ------------------------------------------------------

library(dplyr)
library(stringr)
library(purrr)
library(magrittr)
library(tidytext)
library(lexiconPT)
library(stopwords)
library(tidyr)
library(ggplot2)
library(ggwordcloud)


# Leitura dos dados -------------------------------------------------------

base <- 
  map(list.files("../data/csv"),
      ~ read.csv2(paste0("../data/csv/", .x), encoding = "UTF-8") %>% 
        cbind(presidente = .x %>% str_sub(end = -5)) %>% as_tibble  
  ) %>% 
  bind_rows() %>% 
  nest(-presidente)


# Tidy Text ---------------------------------------------------------------


# STOPWORDS
sw <- c(
  stopwords("pt"), 
  "",",","rt","é","q","p","c","link","en","r","ai","h","a","ñ","ª","º","pq","el","la","d"
)


base %<>% 
  mutate(
    tidytext = map(
      data,
      ~ .x %>% 
        mutate(
          line = 1:nrow(.),
          tweet = as.character(tweet) %>% str_replace_all("(://|/)", "")
        ) %>% 
        select(line, tweet) %>% 
        unnest_tokens(word, tweet) %>% 
        mutate(word = str_remove_all(word, "[:number:]{1,}")) %>% 
        anti_join(., tibble(word = c(sw, .$word[grep("^http", .$word)]))) 
    )
  )


{
  base$tidytext[[1]] %<>% filter(!word %in% c("dilma", "dilmabr"))                 # Dilma
  base$tidytext[[2]] %<>% filter(!word %in% c("collor"))                           # Collor
  base$tidytext[[3]] %<>% filter(!word %in% c("itamar", "franco", "itamarfranco")) #Itamar
  base$tidytext[[4]] %<>% filter(!word %in% c("jair", "bolsonaro"))                #Bolsonaro
  base$tidytext[[5]] %<>% filter(!word %in% c("lula", "lulapresidente"))           #Lula
  base$tidytext[[6]] %<>% filter(!word %in% c("michel", "temer"))                  #Temer
  }


# Word Cloud --------------------------------------------------------------


base %<>% 
  mutate(
    wordcloud = map2(
      tidytext, presidente,
      ~ .x %>% 
        select(word) %>%
        count(word, sort = T) %>%
        head(150) %>%
        ggplot(aes(
          label = word, size = n, color = factor(n)
        )) +
        scale_size_area(max_size = 7) +
        geom_text_wordcloud() + 
        theme_minimal() +
        ggtitle(paste0("Word Cloud - ", .y)) +
        theme(plot.title = element_text(size = 8))
    )
  )


# Salvando
walk2(base$wordcloud, base$presidente,
      ~ ggsave(
        paste0("../man/img/wordcloud/", .y, ".png"), 
        plot = .x, dpi = "retina", width = 6.53, height = 3.11
      )
)


# 20 palavras mais frequentes ---------------------------------------------

base %<>% 
  mutate(
    barras = map2(
      tidytext, base$presidente,
      ~ .x %>% 
        select(word) %>% 
        count(word, sort = T) %>% 
        head(20) %>% 
        mutate(word = str_to_title(word)) %>% 
        
        ggplot(aes(x = reorder(word, n), y = n, fill = n)) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        labs(x = "", y = "Frequência", title = paste0("As 20 palavras mais frequentes - ", .y),
             caption = "Fonte: Twitter pessoal") +
        theme_minimal() +
        guides(fill = FALSE) +
        geom_text(aes(label = n), hjust = 1.3, color = "white", fontface = "bold")
    )
  )


# Salvando
walk2(base$barras, base$presidente,
  ~ ggsave(
    paste0("../man/img/bar chart/", .y, ".png"), 
    plot = .x, dpi = "retina", width = 12.38, height = 6.22    
    )
)


# Analise de Sentimento ---------------------------------------------------

data("oplexicon_v3.0")
data("sentiLex_lem_PT02")

op30 <- oplexicon_v3.0
sent <- sentiLex_lem_PT02


base %<>% 
  mutate(
    sentiment = map(
      tidytext,
      ~ .x %>%  
        filter(!word %in% "temer") %>% 
        inner_join(op30, by = c("word" = "term")) %>% 
        inner_join(sent %>% select(term, lex_polarity = polarity), by = c("word" = "term")) 
    )
  )


base$sentiment %<>% 
  map(
    ~ .x %>% 
      group_by(line) %>% 
      summarise(
        tweet_sentiment_op = sum(polarity),
        tweet_sentiment_lex = sum(lex_polarity),
        n_words = n()
      ) %>% 
      ungroup() %>% 
      rowwise() %>% 
      mutate(
        most_neg = min(tweet_sentiment_lex, tweet_sentiment_op),
        most_pos = max(tweet_sentiment_lex, tweet_sentiment_op)
      ) %>% 
      filter(n_words > 2)
  )


# Tweet(s) mais positivo(s)/negativo(s)
base %<>% 
  mutate(
    #POS
    tweet_pos = pmap(
      list(x = data, y = sentiment),
      function(x, y) {
        
        most_pos_max <- y$most_pos %>% max
        
        n_lines <- y %>% filter(most_pos == most_pos_max) %$% line
        
        x[n_lines, ]$tweet
        
      }
    ),
    #NEG
    tweet_neg = pmap(
      list(x = data, y = sentiment),
      function(x, y) {
        
        most_neg_max <- y$most_neg %>% min
        
        n_lines <- y %>% filter(most_neg == most_neg_max) %$% line
        
        x[n_lines, ]$tweet
        
      }
    )
  )


# # - -----------------------------------------------------------------------

# library(igraph)
# library(ggraph)
# 
# dilma_bigram <- base$data[[1]] %>%
#   mutate(
#     tweet = as.character(tweet) %>% str_replace_all("(://|/)", ""),
#     line = 1:nrow(.)
#   ) %>%
#   select(line, tweet) %>%
#   unnest_tokens(bigram, tweet, token = "ngrams", n = 2) %>%
#   separate(bigram, c("word1", "word2"), sep = " ") %>%
#   mutate(
#     word1 = str_remove_all(word1, "[:number:]{1,}"),
#     word2 = str_remove_all(word2, "[:number:]{1,}")
#     ) %>%
#   filter(!word1 %in% sw) %>%
#   filter(!word2 %in% sw) %>%
#   count(word1, word2, sort = TRUE)
# 
# dilma_bigram_graph <-
#   dilma_bigram %>%
#   filter(n > 10) %>%
#   graph_from_data_frame()
# 
# set.seed(2019)
# 
# ggraph(dilma_bigram_graph, layout = "fr") +
#   geom_edge_link() +
#   geom_node_point() +
#   geom_node_text(aes(label = name), vjust = 1, hjust = 1)

