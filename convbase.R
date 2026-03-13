# app-base-converter.R
# Convertisseur bases 2..36 + bibi-binaire 

library(shiny)

# 0..9 puis A..Z => valeurs 0..35
alphabet <- c(as.character(0:9), LETTERS)

# Table bibi (pour les chiffres hexadécimaux 0..15)
bibi_table <- c(
  "HO","HA","HE","HI",
  "BO","BA","BE","BI",
  "KO","KA","KE","KI",
  "DO","DA","DE","DI"
)

# Convertit un vecteur de caractères en valeurs (0..35) ou NA si invalide
DecodeDigits <- function(chars) {
  chars <- toupper(chars)
  idx <- match(chars, alphabet)  # 1..36 ou NA
  idx - 1                        # "0" -> 0, "A" -> 10, ...
}

# Décode word (base 2..36) en entier décimal ; NA si invalide
DecodeNumber <- function(word, base) {
  # base valide ?
  if (length(base) != 1 || is.na(base) || base < 2 || base > 36) return(NA)
  if (base != as.integer(base)) return(NA)
  base <- as.integer(base)
  
  # word valide ?
  if (length(word) != 1 || is.na(word)) return(NA)
  word <- trimws(word)
  if (nchar(word) == 0) return(NA)
  
  # caractères -> chiffres
  chars <- strsplit(word, "")[[1]]
  digits <- DecodeDigits(chars)
  
  # caractère invalide ou chiffre hors base
  if (any(is.na(digits))) return(NA)
  if (any(digits >= base)) return(NA)
  
  # Horner : n <- n*base + digit
  n <- 0L
  for (d in digits) {
    n <- n * base + d
  }
  n
}

# Encode un entier n (>=0) en base 2..36 ; NA si invalide
EncodeNumber <- function(n, base) {
  if (length(base) != 1 || is.na(base) || base < 2 || base > 36) return(NA)
  if (base != as.integer(base)) return(NA)
  base <- as.integer(base)
  
  if (length(n) != 1 || is.na(n) || n < 0) return(NA)
  if (n != as.integer(n)) return(NA)
  n <- as.integer(n)
  
  if (n == 0L) return("0")
  
  out <- character(0)
  while (n > 0L) {
    r <- n %% base
    out <- c(out, alphabet[r + 1])
    n <- n %/% base
  }
  paste(rev(out), collapse = "")
}

# Encode n en bibi-binaire :
# 1) écrire n en hexadécimal (base 16)
# 2) remplacer chaque chiffre hex (0..15) par HO..DI
EncodeBibi <- function(n) {
  if (length(n) != 1 || is.na(n) || n < 0) return(NA)
  if (n != as.integer(n)) return(NA)
  n <- as.integer(n)
  
  if (n == 0L) return("HO")
  
  hex_str <- EncodeNumber(n, 16)
  chars <- strsplit(hex_str, "")[[1]]
  digits <- DecodeDigits(chars)   # 0..15 ici
  
  if (any(is.na(digits)) || any(digits > 15)) return(NA)
  
  paste(bibi_table[digits + 1], collapse = "")
}

# -----------------------
# SHINY
# -----------------------

ui <- fluidPage(
  titlePanel("Convertisseur (bases 2..36) + Bibi-binaire"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("word", "Nombre (entrée)", value = "1010"),
      numericInput("base_from", "Base de départ (2..36)", value = 2, min = 2, max = 36),
      
      tags$hr(),
      
      radioButtons(
        "mode",
        "Sortie",
        choices = c("Vers une base" = "base", "Vers bibi-binaire" = "bibi"),
        selected = "base"
      ),
      
      conditionalPanel(
        condition = "input.mode == 'base'",
        numericInput("base_to", "Base d'arrivée (2..36)", value = 10, min = 2, max = 36)
      )
    ),
    
    mainPanel(
      h3("Résultats"),
      verbatimTextOutput("status"),
      tags$hr(),
      verbatimTextOutput("decoded"),
      tags$hr(),
      verbatimTextOutput("converted")
    )
  )
)

server <- function(input, output, session) {
  
  # calcule la valeur décimale dès qu'on change word/base_from
  decoded <- reactive({
    DecodeNumber(input$word, input$base_from)
  })
  
  output$status <- renderText({
    n <- decoded()
    if (is.na(n)) "Entrée invalide" else "Entrée valide"
  })
  
  output$decoded <- renderText({
    n <- decoded()
    if (is.na(n)) "" else paste("Décimal :", n)
  })
  
  output$converted <- renderText({
    n <- decoded()
    if (is.na(n)) return("")
    
    if (input$mode == "base") {
      paste("Converti :", EncodeNumber(n, input$base_to))
    } else {
      paste("Bibi :", EncodeBibi(n))
    }
  })
}

app <- shinyApp(ui = ui, server = server)
app
