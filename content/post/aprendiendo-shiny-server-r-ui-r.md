---
author: rvaquerizo
categories:
  - formación
  - r
date: '2015-02-02'
lastmod: '2025-07-13'
related:
  - aprendiendo-shiny-con-vosotros.md
  - aprendiendo-shiny-la-funcion-shinyui-seguida-de-fluidpage-o-fluidrow.md
  - intro-rcommander-1-que-es-rcommander.md
  - nuestras-funciones-de-r-en-menus-con-rpanel-y-svwidgets.md
  - rstats-shiny-leaftlet-mapas-interactivos.md
tags:
  - shiny
title: Aprendiendo shiny. server.R ui.R
url: /blog/aprendiendo-shiny-server-r-ui-r/
---

Sigo con shiny y RStudio aver que cosas soy capaz de hacer. Hay dos elementos básicos a la hora de crear aplicaciones con shiny:

- server.R es el lugar donde definimos la función _server._ Es necesario empezar a familiarizarnos con el lenguaje de shiny.
- ui.R es el _user interface_ es el lugar donde definimos lo que vamos a ver con nuestra aplicación.

El elemento fundamental de server.R es shinyServer(función) en los ejemplos que he estado viendo la función tiene una entrada y una salida. Imagino que podremos dar más complejidad a estas funciones. De momento una entrada y una salida. En ui.R es donde definimos la salida en HTML que deseamos para nuestra aplicación en [el tutorial de shiny podéis ver muchas posibilidades](http://shiny.rstudio.com/tutorial/lesson2/). La función principal para crear estos interfaces es shinyUI(definición del interface). No parece complicado de definir el interface con unos conocimientos básicos de HTML y conociendo el código específico de shiny. Ya no programamos tanto con R, ahora programamos con shiny.

Sobre la misma app prueba que creamos en la anterior entrega podemos hacer:

# Define UI for slider demo application

shinyUI(fluidPage(

# Application title

titlePanel(«Ejemplo de uso de Sliders»),

# Sidebar with sliders that demonstrate various available

# options

sidebarLayout(
sidebarPanel(

# Simple integer interval

sliderInput(«integer», «Entero:»,
min=0, max=1000, value=500),

# Decimal interval with step value

sliderInput(«decimal», «Decimal:»,
min = 0, max = 1, value = 0.5, step= 0.1),

# Specification of range within an interval

sliderInput(«range», «Rangos:»,
min = 1, max = 1000, value = c(200,500)),

# Provide a custom currency format for value display,

# with basic animation

sliderInput(«format», «Formato personalizado:»,
min = 0, max = 10000, value = 0, step = 2500,
format=»$#,##0″, locale=»us», animate=TRUE),

# Animation with custom interval (in ms) to control speed,

# plus looping

sliderInput(«animation», «Bucle animado:», 1, 2000, 1,
step = 10, animate=
animationOptions(interval=300, loop=TRUE))
),

# Show a table summarizing the values entered

mainPanel(
tableOutput(«values»)
)
)
))

El mismo ejemplo poniendo los títulos en español. Lo más simple. Seguiré contando las cosas que voy aprendiendo con shiny. Saludos.
