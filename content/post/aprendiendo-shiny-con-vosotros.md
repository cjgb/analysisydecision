---
author: rvaquerizo
categories:
  - formación
  - r
date: '2015-02-01'
lastmod: '2025-07-13'
related:
  - aprendiendo-shiny-server-r-ui-r.md
  - aprendiendo-shiny-la-funcion-shinyui-seguida-de-fluidpage-o-fluidrow.md
  - rstats-shiny-leaftlet-mapas-interactivos.md
  - informes-con-r-en-html-comienzo-con-r2html-i.md
  - ajuste-de-splines-con-r.md
tags:
  - shiny
  - r
title: Aprendiendo shiny con vosotros
url: /blog/aprendiendo-shiny-con-vosotros/
---

No queda otro remedio. Necesito actualizarme un poco y comenzar a usar [Shiny](http://shiny.rstudio.com/), y espero poder llegar a publicar en el blog las aplicaciones resultantes. No sé si seré capaz, pero allá vamos. Lo primero es tener [RStudio](http://www.rstudio.com/) instalado y empezar a escribir:

```r
install.packages("shiny")
library(shiny)
system.file("examples", package = "shiny")
```

Ya podemos ver los ejemplos de un modo muy sencillo:

```r
runExample("05_sliders") # slider bars
```

Aparece una *app* que podemos ver tanto en RStudio como en nuestro navegador. Si modificamos las barras, cambian los números de la tabla de la derecha. Muy sencillo. Para comenzar a trabajar debemos conocer dos códigos de R que están guardados en su correspondiente carpeta. Son `server.R` y `ui.R`, que podemos abrir en la carpeta de Windows (ruta aproximada) `C:\Users\fulanito\Documents\R\win-library\x.x\shiny\examples\05_sliders`. Sin embargo, nosotros vamos a copiar y pegar esta carpeta en una nueva ubicación, le damos el nombre `prueba` y abrimos `server.R`:

```r
library(shiny)

# Define server logic for slider examples
shinyServer(function(input, output) {

  # Reactive expression to compose a data frame containing all of the values
  sliderValues <- reactive({
    # Compose data frame
    data.frame(
      Name = c("Integer",
               "Decimal",
               "Range",
               "Custom Format",
               "Animation"),
      Value = as.character(c(input$integer,
                             input$decimal,
                             paste(input$range, collapse = ' '),
                             input$format,
                             input$animation)),
      stringsAsFactors = FALSE)
  })

  # Show the values using an HTML table
  output$values <- renderTable({
    sliderValues()
  })
})
```

Interesante el botón "Run App" de arriba a la derecha para ejecutar la aplicación; eso implica que estamos ante una aplicación de Shiny. `shinyServer` define una función con una entrada (`input`) y una salida (`output`). La entrada será alguno de los datos que le pasamos a la aplicación y la salida una tabla HTML. Veamos qué tiene `ui.R`:

```r
library(shiny)

# Define UI for slider demo application
shinyUI(fluidPage(

  # Application title
  titlePanel("Sliders"),

  # Sidebar with sliders that demonstrate various available options
  sidebarLayout(
    sidebarPanel(
      # Simple integer interval
      sliderInput("integer", "Integer:",
                  min = 0, max = 1000, value = 500),

      # Decimal interval with step value
      sliderInput("decimal", "Decimal:",
                  min = 0, max = 1, value = 0.5, step = 0.1),

      # Specification of range within an interval
      sliderInput("range", "Range:",
                  min = 1, max = 1000, value = c(200, 500)),

      # Provide a custom currency format for value display, with basic animation
      sliderInput("format", "Custom Format:",
                  min = 0, max = 10000, value = 0, step = 2500,
                  format = "$#,##0", locale = "us", animate = TRUE),

      # Animation with custom interval (in ms) to control speed, plus looping
      sliderInput("animation", "Looping Animation:", 1, 2000, 1,
                  step = 10, animate =
                  animationOptions(interval = 300, loop = TRUE))
    ),

    # Show a table summarizing the values entered
    mainPanel(
      tableOutput("values")
    )
  )
))
```

Vemos que podemos cambiar el título y creamos cada uno de los *sliders* con la función `sliderInput`. Y tendremos un panel principal con la función `mainPanel` con una tabla que representa los valores que tenemos en los *sliders*. Os confieso que este código me recuerda mucho al AF de SAS y no es un código R al uso. Sobre este mismo ejemplo vamos a ir cambiando código para ir conociendo cómo creamos nuestras aplicaciones. Saludos.