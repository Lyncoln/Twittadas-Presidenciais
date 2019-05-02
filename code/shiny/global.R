
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
library(igraph)
library(ggraph)
library(shinydashboard)


# Leitura dos dados -------------------------------------------------------

users <- list('dilmabr', 'Collor', 'jairbolsonaro', 'LulaOficial', 'MichelTemer')

base <- 
  map2(list.files("www/csv/"), users,
      ~ read.csv2(paste0("www/csv/", .x), encoding = "UTF-8") %>% 
        cbind(presidente = .x %>% str_sub(end = -5)) %>%
        cbind(user = .y) %>% 
        as_tibble  
  ) %>% 
  map(~ .x %>% mutate_if(is.factor, as.character)) %>% 
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
          tweet_line = 1:nrow(.),
          tweet = as.character(tweet) %>% str_replace_all("(://|/)", "")
        ) %>% 
        select(tweet_line, tweet) %>% 
        unnest_tokens(word, tweet) %>% 
        mutate(word = str_remove_all(word, "[:number:]{1,}")) %>% 
        anti_join(., tibble(word = c(sw, .$word[grep("^http", .$word)]))) 
    )
  )

{
  base$tidytext[[1]] %<>% filter(!word %in% c("dilma", "dilmabr"))         # Dilma
  base$tidytext[[2]] %<>% filter(!word %in% c("collor"))                   # Collor
  base$tidytext[[3]] %<>% filter(!word %in% c("jair", "bolsonaro"))        # Bolsonaro
  base$tidytext[[4]] %<>% filter(!word %in% c("lula", "lulapresidente"))   # Lula
  base$tidytext[[5]] %<>% filter(!word %in% c("michel", "temer"))          # Temer
}


# Word Cloud --------------------------------------------------------------

base %<>% 
  mutate(
    wordcloud = map2(
      tidytext, c(60,60,54,71,62),
      ~ .x %>% 
        select(word) %>%
        count(word, sort = T) %>%
        head(100) %>%
        ggplot(aes(
          label = word, size = n, color = factor(n)
        )) +
        scale_size_area(max_size = 11) +
        geom_text_wordcloud() + 
        scale_color_manual(values = c(rep("#009c3b", .y/1.6), rep("#ffdf00", .y/3), rep("#002776", .y/10))) +
        theme_minimal() +
        # ggtitle(paste0("Word Cloud - ", .y)) +
        theme(plot.title = element_text(size = 16))
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
        
        ggplot(aes(x = reorder(word, n), y = n, fill = "black")) +
        geom_bar(stat = 'identity', width = 0.8) +
        coord_flip() +
        scale_fill_manual(values = c("#3c8dbc")) +
        labs(x = "", y = "Frequência", title = paste0("As 20 palavras mais frequentes - ", .y),
             caption = "Fonte: Twitter pessoal") +
        theme_minimal() +
        guides(fill = FALSE) +
        geom_text(aes(label = n), hjust = 1.3, color = "white", fontface = "bold")
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
      group_by(tweet_line) %>% 
      summarise(
        tweet_sentiment_op = sum(polarity),
        tweet_sentiment_lex = sum(lex_polarity),
        n_words = n()
      ) %>% 
      ungroup() %>% 
      rowwise() %>% 
      mutate(
        most_neg = min(tweet_sentiment_lex, tweet_sentiment_op),
        most_pos = max(tweet_sentiment_lex, tweet_sentiment_op),
        soma_sentiment = most_neg+most_pos
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
        
        # most_pos_max <- y$most_pos %>% max
        most_pos_max <- y$soma_sentiment %>% max
        
        # n_lines <- y %>% filter(most_pos == most_pos_max) %$% tweet_line
        n_lines <- y %>% filter(soma_sentiment == most_pos_max) %$% tweet_line
        
        x[n_lines, ]$tweet
        
      }
    ),
    tweet_pos_id = pmap(
      list(x = data, y = sentiment),
      function(x, y) {
        
        # most_pos_max <- y$most_pos %>% max
        most_pos_max <- y$soma_sentiment %>% max
        
        # n_lines <- y %>% filter(most_pos == most_pos_max) %$% tweet_line
        n_lines <- y %>% filter(soma_sentiment == most_pos_max) %$% tweet_line
        
        x[n_lines, ]$id
        
      }
    ),
    #NEG
    tweet_neg = pmap(
      list(x = data, y = sentiment),
      function(x, y) {
        
        # most_neg_max <- y$most_neg %>% min
        most_neg_max <- y$soma_sentiment %>% min
        
        # n_lines <- y %>% filter(most_neg == most_neg_max) %$% tweet_line
        n_lines <- y %>% filter(soma_sentiment == most_neg_max) %$% tweet_line
        
        x[n_lines, ]$tweet
        
      }
    ),
    tweet_neg_id = pmap(
      list(x = data, y = sentiment),
      function(x, y) {
        
        # most_neg_max <- y$most_neg %>% min
        most_neg_max <- y$soma_sentiment %>% min
        
        # n_lines <- y %>% filter(most_neg == most_neg_max) %$% tweet_line
        n_lines <- y %>% filter(soma_sentiment == most_neg_max) %$% tweet_line
        
        x[n_lines, ]$id
        
      }
    )
  )


base %<>% 
  mutate(
    #POS
    tweet_pos = pmap(
      list(x = tweet_pos, y = tweet_pos_id, z = 1:5),
      function(x, y, z) {
        paste0(x, " <https://twitter.com/", data[[z]]$user[1], "/status/", y, ">.")
      }
    ),
    #NEG
    tweet_neg = pmap(
      list(x = tweet_neg, y = tweet_neg_id, z = 1:5),
      function(x, y, z) {
        paste0(x, " <https://twitter.com/", data[[z]]$user[1], "/status/", y, ">.")
      }
    )
  )



# Grafos ------------------------------------------------------------------

base %<>% 
  mutate(
    base_grafo = map2(
      data, c(10,10,8,15,14),
      ~ .x %>% 
        mutate(
          tweet = as.character(tweet) %>% str_replace_all("(://|/)", "") %>% str_remove_all("^http"),
          line = 1:nrow(.),
          tweet = case_when(
            str_detect(tweet, "Dilma Rousseff")            ~ str_replace_all(tweet, "Dilma Rousseff", "Jair_Bolsonaro"),
            str_detect(tweet, "Fernando Collor")           ~ str_replace_all(tweet, "Fernando Collor", "Fernando_Collor"),
            str_detect(tweet, "Jair Bolsonaro")            ~ str_replace_all(tweet, "Jair Bolsonaro", "Jair_Bolsonaro"),
            str_detect(tweet, "Luiz Inácio Lula da Silva") ~ str_replace_all(tweet, "Luiz Inácio Lula da Silva", "Luiz_Inácio_Lula_da_Silva"),
            str_detect(tweet, "Michel Temer")              ~ str_replace_all(tweet, "Michel Temer", "Michel_Temer"),
            str_detect(tweet, "Paulo Guedes")              ~ str_replace_all(tweet, "Paulo Guedes", "Paulo_Guedes"),
            str_detect(tweet, "Fernando Haddad")           ~ str_replace_all(tweet, "Fernando Haddad", "Fernando_Haddad"),
            str_detect(tweet, "Célia Rocha")               ~ str_replace_all(tweet, "Célia Rocha", "Célia_Rocha"),
            str_detect(tweet, "Renan Calheiros")           ~ str_replace_all(tweet, "Renan Calheiros", "Renan_Calheiros"),
            str_detect(tweet, "Ronaldo Lessa")             ~ str_replace_all(tweet, "Ronaldo Lessa", "Ronaldo_Lessa"),
            str_detect(tweet, "José Alexandre")            ~ str_replace_all(tweet, "José Alexandre", "José_Alexandre"),
            str_detect(tweet, "Celso Amorim")              ~ str_replace_all(tweet, "Celso Amorim", "Celso_Amorim"),
            str_detect(tweet, "Gleisi Hoffmann")           ~ str_replace_all(tweet, "Gleisi Hoffmann", "Gleisi_Hoffmann"),
            str_detect(tweet, "Sérgio Moro")               ~ str_replace_all(tweet, "Sérgio Moro", "Sérgio_Moro"),
            str_detect(tweet, "Rui Costa")                 ~ str_replace_all(tweet, "Rui Costa", "Rui_Costa"),
            str_detect(tweet, "Ricardo Stuckert")          ~ str_replace_all(tweet, "Ricardo Stuckert", "Ricardo_Stuckert"),
            TRUE ~ as.character(tweet)
          )
        ) %>%
        select(line, tweet) %>%
        unnest_tokens(bigram, tweet, token = "ngrams", n = 2) %>%
        separate(bigram, c("word1", "word2"), sep = " ") %>%
        mutate(
          word1 = str_remove_all(word1, "[:number:]{1,}"),
          word2 = str_remove_all(word2, "[:number:]{1,}")
        ) %>%
        na.omit() %>% 
        filter(!word1 %in% sw) %>%
        filter(!word2 %in% sw) %>%
        count(word1, word2, sort = TRUE) %>%
        filter(n > .y) %>%
        graph_from_data_frame()
    )
  )

base %<>% 
  mutate(
    grafos = map2(
      base_grafo, presidente,
      ~ .x %>% 
        ggraph(layout = 'fr') +
        geom_edge_link(
          aes(start_cap = label_rect(node1.name),
              end_cap = label_rect(node2.name)),
              # edge_alpha = n, edge_width = n), 
          arrow = arrow(length = unit(2, 'mm'))
        ) +
        geom_node_point() +
        geom_node_text(aes(label = name), repel = TRUE,
                       point.padding = unit(0.2, "lines")) +
        theme_void() +
        ggtitle(paste0("Grafo - ", .y)) +
        theme(plot.title = element_text(size = 18))
    )
  )
