
# server logic 

function(input, output, session) {
  
  # Wordcloud
  output$wc_dilma     <- renderPlot({base$wordcloud[[1]]})
  output$wc_collor    <- renderPlot({base$wordcloud[[2]]})
  output$wc_bolsonaro <- renderPlot({base$wordcloud[[3]]})
  output$wc_lula      <- renderPlot({base$wordcloud[[4]]})
  output$wc_temer     <- renderPlot({base$wordcloud[[5]]})
  
  # Bar Charts
  output$bc_dilma     <- renderPlot({base$barras[[1]]})
  output$bc_collor    <- renderPlot({base$barras[[2]]})
  output$bc_bolsonaro <- renderPlot({base$barras[[3]]})
  output$bc_lula      <- renderPlot({base$barras[[4]]})
  output$bc_temer     <- renderPlot({base$barras[[5]]})
  
  # Grafos
  output$grafo_dilma     <- renderPlot({base$grafos[[1]]})
  output$grafo_collor    <- renderPlot({base$grafos[[2]]})
  output$grafo_bolsonaro <- renderPlot({base$grafos[[3]]})
  output$grafo_lula      <- renderPlot({base$grafos[[4]]})
  output$grafo_temer     <- renderPlot({base$grafos[[5]]})
  
  # Tweets
  output$tweets_neg_dilma     <- renderPrint({base$tweet_neg[[1]] %>% matrix() %>% `colnames<-`("Tweets ranqueados como os mais negativos") %>% `rownames<-`(c("-", "-"))})
  output$tweets_pos_dilma     <- renderPrint({base$tweet_pos[[1]] %>% matrix() %>% `colnames<-`("Tweets ranqueados como os mais positivos") %>% `rownames<-`(c("-", "-"))})
  
  output$tweets_neg_collor    <- renderPrint({base$tweet_neg[[2]][1] %>% matrix() %>% `colnames<-`("Tweet ranqueado como o mais negativo") %>% `rownames<-`(c("-"))})
  output$tweets_pos_collor    <- renderPrint({base$tweet_pos[[2]] %>% matrix() %>% `colnames<-`("Tweets ranqueados como os mais positivos") %>% `rownames<-`(c("-", "-"))})
  
  output$tweets_neg_bolsonaro <- renderPrint({base$tweet_neg[[3]] %>% matrix() %>% `colnames<-`("Tweet ranqueado como o mais negativo") %>% `rownames<-`(c("-"))})
  output$tweets_pos_bolsonaro <- renderPrint({base$tweet_pos[[3]] %>% matrix() %>% `colnames<-`("Tweet ranqueado como o mais positivo") %>% `rownames<-`(c("-"))})
  
  output$tweets_neg_lula      <- renderPrint({base$tweet_neg[[4]] %>% matrix() %>% `colnames<-`("Tweets ranqueados como os mais negativos") %>% `rownames<-`(c("-", "-"))})
  output$tweets_pos_lula      <- renderPrint({base$tweet_pos[[4]] %>% matrix() %>% `colnames<-`("Tweet ranqueado como o mais positivo") %>% `rownames<-`(c("-"))})
  
  output$tweets_neg_temer     <- renderPrint({base$tweet_neg[[5]] %>% matrix() %>% `colnames<-`("Tweets ranqueados como os mais negativos") %>% `rownames<-`(c("-", "-"))})
  output$tweets_pos_temer     <- renderPrint({base$tweet_pos[[5]] %>% matrix() %>% `colnames<-`("Tweets ranqueados como os mais positivos") %>% `rownames<-`(c("-", "-"))})
  
}











