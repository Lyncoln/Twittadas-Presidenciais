
# user-interface

dashboardPage(
    # enable_preloader = T,
    dashboardHeader(title = "Twittadas Presidenciais", titleWidth = 250),
    dashboardSidebar(
        width = 250,
        sidebarMenu(
            menuItem("Fernando Collor", tabName = "collor"),
            menuItem("Luiz Inácio Lula da Silva", tabName = "lula"),
            menuItem("Dilma Rousseff", tabName = "dilma"),
            menuItem("Michel Temer", tabName = "temer"),
            menuItem("Jair Bolsonaro", tabName = "bolsonaro")
        )
    ),
    dashboardBody(
        tabItems(
            
            # Collor ------------------------------------------------------------------
            tabItem("collor",
                    fluidRow(
                        box(
                            width = 12,
                            status = "primary",
                            column(width = 3, 
                                   img(
                                       src = 'collor.jpg', height = '280px', 
                                       style = "display: block; margin-left: auto; margin-right: auto;"
                                   )
                            ),
                            column(width = 9, 
                                   # verbatimTextOutput("tweets_neg_collor"),
                                   # verbatimTextOutput("tweets_pos_collor")
                                   helpText(
                                       br(),
                                       tags$b("Nome:"), "Fernando Collor de Mello",
                                       br(),
                                       tags$b("Nascimento:"), "12 de agosto de 1949 - Rio de Janeiro, Distrito Federal",
                                       br(),
                                       br(),
                                       tags$b("32º Presidente do Brasil"),
                                       br(),
                                       tags$b("Período:"), "15 de março de 1990 a 29 de dezembro de 1992",
                                       br(),
                                       tags$b("Vice-presidente:"), "Itamar Franco",
                                       br(),
                                       tags$b("Antecessor:"), "José Sarney",
                                       br(),
                                       tags$b("Sucessor:"), "Itamar Franco",
                                       br(),
                                       br(),
                                       tags$b("Partido:"), "ARENA (1979), PDS (1980–1985), PMDB (1986–1988), PRN (1989–1992), PRTB (2000–2006), PTB (2007–2016), PTC (2016–2019), PROS (2019–presente)",
                                       br(),
                                       br(),
                                       tags$b("Fonte:"), "Wikipédia"
                                   )
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, title = "Tweets", 
                            solidHeader = T, status = "primary",
                            column(width = 12,
                                   verbatimTextOutput("tweets_neg_collor"),
                                   verbatimTextOutput("tweets_pos_collor")
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, status = "primary",
                            column(width = 6,  plotOutput("wc_collor")),
                            column(width = 6,  plotOutput("bc_collor")),
                            column(width = 12, plotOutput("grafo_collor"))
                        )
                    )
            ),
            
            # Lula --------------------------------------------------------------------
            tabItem("lula",
                    fluidRow(
                        box(
                            width = 12,
                            status = "primary",
                            column(width = 3, 
                                   img(
                                       src = 'lula.jpg', height = '280px', 
                                       style = "display: block; margin-left: auto; margin-right: auto;"
                                   )
                            ),
                            column(width = 9, 
                                   # verbatimTextOutput("tweets_neg_lula"),
                                   # verbatimTextOutput("tweets_pos_lula")
                                   helpText(
                                       br(),
                                       tags$b("Nome:"), "Luiz Inácio Lula da Silva",
                                       br(),
                                       tags$b("Nascimento:"), "27 de outubro de 1945 - Caetés, Pernambuco",
                                       br(),
                                       br(),
                                       tags$b("35º Presidente do Brasil"),
                                       br(),
                                       tags$b("Período:"), "1º de janeiro de 2003 a 1º de janeiro de 2011",
                                       br(),
                                       tags$b("Vice-presidente:"), "José Alencar",
                                       br(),
                                       tags$b("Antecessor:"), "Fernando Henrique Cardoso",
                                       br(),
                                       tags$b("Sucessor:"), "Dilma Rousseff",
                                       br(),
                                       br(),
                                       tags$b("Partido:"), "PT (1980-presente)",
                                       br(),
                                       br(),
                                       br(),
                                       tags$b("Fonte:"), "Wikipédia"
                                   )
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, title = "Tweets", 
                            solidHeader = T, status = "primary",
                            column(width = 12,
                                   verbatimTextOutput("tweets_neg_lula"),
                                   verbatimTextOutput("tweets_pos_lula")
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, status = "primary",
                            column(width = 6,  plotOutput("wc_lula")),
                            column(width = 6,  plotOutput("bc_lula")),
                            column(width = 12, plotOutput("grafo_lula"))
                        )
                    )
            ),
            
            # Dilma -------------------------------------------------------------------
            tabItem("dilma",
                    fluidRow(
                        box(
                            width = 12,
                            status = "primary",
                            column(width = 3, 
                                   img(
                                       src = 'dilma.jpg', height = '280px', 
                                       style = "display: block; margin-left: auto; margin-right: auto;"
                                   )
                            ),
                            column(width = 9, 
                                   # verbatimTextOutput("tweets_neg_dilma"),
                                   # verbatimTextOutput("tweets_pos_dilma")
                                   helpText(
                                       br(),
                                       tags$b("Nome:"), "Dilma Vana Rousseff",
                                       br(),
                                       tags$b("Nascimento:"), "14 de dezembro de 1947 - Belo Horizonte, Minas Gerais",
                                       br(),
                                       br(),
                                       tags$b("36ª Presidente do Brasil"),
                                       br(),
                                       tags$b("Período:"), "1º de janeiro de 2011 a 31 de agosto de 2016",
                                       br(),
                                       tags$b("Vice-presidente:"), "Michel Temer",
                                       br(),
                                       tags$b("Antecessor:"), "Luiz Inácio Lula da Silva",
                                       br(),
                                       tags$b("Sucessor:"), "Michel Temer",
                                       br(),
                                       br(),
                                       tags$b("Partido:"), "PDT (1980-2001), PT (2001-presente)",
                                       br(),
                                       br(),
                                       br(),
                                       tags$b("Fonte:"), "Wikipédia"
                                   )
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, title = "Tweets", 
                            solidHeader = T, status = "primary",
                            column(width = 12,
                                   verbatimTextOutput("tweets_neg_dilma"),
                                   verbatimTextOutput("tweets_pos_dilma")
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, status = "primary",
                            column(width = 6,  plotOutput("wc_dilma")),
                            column(width = 6,  plotOutput("bc_dilma")),
                            column(width = 12, plotOutput("grafo_dilma"))
                        )
                    )
            ),
            
            # Temer -------------------------------------------------------------------
            tabItem("temer",
                    fluidRow(
                        box(
                            width = 12,
                            status = "primary",
                            column(width = 3, 
                                   img(
                                       src = 'temer.jpg', height = '280px', 
                                       style = "display: block; margin-left: auto; margin-right: auto;"
                                   )
                            ),
                            column(width = 9, 
                                   # verbatimTextOutput("tweets_neg_temer"),
                                   # verbatimTextOutput("tweets_pos_temer")
                                   helpText(
                                       br(),
                                       tags$b("Nome:"), "Michel Miguel Elias Temer Lulia",
                                       br(),
                                       tags$b("Nascimento:"), "23 de setembro de 1940 - Tietê, São Paulo",
                                       br(),
                                       br(),
                                       tags$b("37.º Presidente do Brasil"),
                                       br(),
                                       tags$b("Período:"), "31 de agosto de 2016 a 1º de janeiro de 2019",
                                       br(),
                                       tags$b("Presidente:"), "Dilma Rousseff",
                                       br(),
                                       tags$b("Antecessor:"), "Dilma Rousseff",
                                       br(),
                                       tags$b("Sucessor:"), "Jair Bolsonaro",
                                       br(),
                                       br(),
                                       tags$b("Partido:"), "MDB (1981–atualidade)",
                                       br(),
                                       br(),
                                       br(),
                                       tags$b("Fonte:"), "Wikipédia"
                                   )
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, title = "Tweets", 
                            solidHeader = T, status = "primary",
                            column(width = 12,
                                   verbatimTextOutput("tweets_neg_temer"),
                                   verbatimTextOutput("tweets_pos_temer")
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, status = "primary",
                            column(width = 6,  plotOutput("wc_temer")),
                            column(width = 6,  plotOutput("bc_temer")),
                            column(width = 12, plotOutput("grafo_temer"))
                        )
                    )
            ),

            # Bolsonaro ---------------------------------------------------------------
            tabItem("bolsonaro",
                    fluidRow(
                        box(
                            width = 12,
                            status = "primary",
                            column(width = 3, 
                                   img(
                                       src = 'bolsonaro.jpg', height = '280px', 
                                       style = "display: block; margin-left: auto; margin-right: auto;"
                                   )
                            ),
                            column(width = 9, 
                                   # verbatimTextOutput("tweets_neg_bolsonaro"),
                                   # verbatimTextOutput("tweets_pos_bolsonaro")
                                   helpText(
                                       br(),
                                       tags$b("Nome:"), "Jair Messias Bolsonaro",
                                       br(),
                                       tags$b("Nascimento:"), "21 de março de 1955 - Glicério, São Paulo",
                                       br(),
                                       br(),
                                       tags$b("38.º Presidente do Brasil"),
                                       br(),
                                       tags$b("Período:"), "1º de janeiro de 2019 a atualidade",
                                       br(),
                                       tags$b("Vice-presidente:"), "Hamilton Mourão",
                                       br(),
                                       tags$b("Antecessor:"), "Michel Temer",
                                       br(),
                                       # tags$b("Sucessor:"), "",
                                       br(),
                                       br(),
                                       tags$b("Partido:"), "PDC (1989-1993), PP (1993–1993), PPR (1993–1995), PPB (1995–2003), PTB (2003–2005), PFL (2005–2005), PP (2005–2016), PSC (2016–2018), PSL (2018–presente)",
                                       br(),
                                       br(),
                                       tags$b("Fonte:"), "Wikipédia"
                                   )
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, title = "Tweets", 
                            solidHeader = T, status = "primary",
                            column(width = 12,
                                   verbatimTextOutput("tweets_neg_bolsonaro"),
                                   verbatimTextOutput("tweets_pos_bolsonaro")
                            )
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12, status = "primary",
                            column(width = 6,  plotOutput("wc_bolsonaro")),
                            column(width = 6,  plotOutput("bc_bolsonaro")),
                            column(width = 12, plotOutput("grafo_bolsonaro"))
                        )
                    )
            )
        )
    )
)
