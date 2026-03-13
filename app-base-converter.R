DecodeDigits <- function(word, alphabet = c(0:9, LETTERS)) {
  digits <- unlist(strsplit(toupper(word), NULL))
  return(match(digits, alphabet)-1)
}

#' DÃ©code une chaÃ®ne de caractÃ¨re word reprÃ©sentant un nombre n Ã©crit dans une base comprise entre 2 et 36.
#'
#' @param word la chaÃ®ne de caractÃ¨re reprÃ©sentant le nombre ne contenant que des caractÃ¨res alphanumÃ©riques.
#' @param base la base dans laquelle est Ã©crite le nombre
#' @return le nombre n ou NA si le format de la chaÃ®ne est invalide.
DecodeNumber <- function(word, base) {
  return(NA)
}

#' Ã‰crit le nombre n dans une chaÃ®ne de caractÃ¨res en utilisant une base comprise entre 2 et 36
#' @param n le nombre Ã  encoder
#' @param base la base dans laquelle Ã©crire le nombre
#' @return la chaÃ®ne de caractÃ¨re contenant le nombre n Ã©crit dans la base
EncodeNumber <- function(n, base) {
  return(NA)
}

#' Ã‰crit un nombre n dans une chaÃ®ne de caractÃ¨re avec le systÃ¨me bibi-binaire
#' @param n le nombre Ã  encoder
#' @return la chaÃ®ne de caractÃ¨re contenant le nombre n Ã©crit en bibi-binaire
EncodeBibi <- function(n) {
  return(NA)
}

library(shiny)
#' La fonction server d'une application shiny rÃ©alise le traitement des donnÃ©es et la gÃ©nÃ©ration des graphiques/tableaux.
server <- function(input, output) {
  CheckBase <- function(base) base >= 2 && base <= 36
  fromBase <- reactive( {
    validate(
      need(!is.na(input$fromBase), "Base d'origine manquante"),
      need(CheckBase(input$fromBase), "Base d'origine doit Ãªtre entre 2 et 36.")
    )
    input$fromBase
  })
  number <- reactive( {
    number <- trimws(input$number)
    validate(
      need(nchar(number) > 0, "Pas de nombre en entrÃ©e."),
      need(!grepl("[^a-zA-Z0-9]", number), "Format de nombre incorrect")
    )
    number <- DecodeNumber(number, fromBase())
    validate(
      need(!is.na(number), "Chiffres invalides dans le nombre.")
      )
    number
  })

  ConvertNumber <- function(n, base) {
    validate(
      need(!is.na(base), "Base de destination manquante")
    )
    if( CheckBase(base) ) {
      return(EncodeNumber(n, base))
    } else {
      return(EncodeBibi(n))
    }
  }
  output$toBase1 <- renderText({ ConvertNumber(number(), input$toBase1)})
  output$toBase2 <- renderText({ ConvertNumber(number(), input$toBase2)})
  output$toBase3 <- renderText({ ConvertNumber(number(), input$toBase3)})
}

#' La fonction ui d'une application shiny construit l'interface graphique Ã  partir de ses entrÃ©es/sorties.
ui <- fluidPage(
  titlePanel("Convertisseur Ã  Bibi"),
  sidebarLayout(
    ## Barre latÃ©rale contenant les entrÃ©es de l'application
    sidebarPanel(
      textInput("number", "Nombre", "26"),
      numericInput("fromBase", "Depuis la base:", "10")
    ),
    ## Panneau principal contenant les sorties de l'application
    mainPanel(
      column(4,
             numericInput("toBase1", "Vers la base:", "10"),
             verbatimTextOutput("toBase1")
             ),
      column(4,
             numericInput("toBase2", "Vers la base:", "2"),
             verbatimTextOutput("toBase2")
             ),
    column(4,
           numericInput("toBase3", "Vers la base:", "16"),
           verbatimTextOutput("toBase3")
           )
    )
  )
)

## Construit un objet reprÃ©sentant l'application
shinyApp(ui = ui, server = server)
