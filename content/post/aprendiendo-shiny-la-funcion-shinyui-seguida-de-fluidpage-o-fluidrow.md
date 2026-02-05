---
author: rvaquerizo
categories:
  - formación
  - r
date: '2015-02-13'
lastmod: '2025-07-13'
related:
  - aprendiendo-shiny-server-r-ui-r.md
  - aprendiendo-shiny-con-vosotros.md
  - rstats-shiny-leaftlet-mapas-interactivos.md
  - manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias.md
  - nuestras-funciones-de-r-en-menus-con-rpanel-y-svwidgets.md
tags:
  - shiny
title: Aprendiendo Shiny. La función shinyUI seguida de fluidPage o fluidRow
url: /blog/aprendiendo-shiny-la-funcion-shinyui-seguida-de-fluidpage-o-fluidrow/
---

Con `shinyUI` creamos la interfaz de nuestra app de `shiny` y cuando la usamos inmediatamente ponemos `fluidPage` o `fluidRow` (por lo menos en estos primeros acercamientos). Utilizaremos una u otra en función del diseño que deseamos. Los argumentos que pueden tener `fluidPage` o `fluidRow` son múltiples. Algunos de los que estoy usando:

- `titlePanel`: Imprescindible, sirve para poner títulos a nuestra app.
- `headerPanel`: Para titular nuestro panel.
- `wellPanel`: Para introducir tablas con formato. Podremos jugar con CSS para cambiar los formatos.
- Elementos para modificar valores como:
  - `sliderInput`: Nos permite crear los slider como hemos visto en los ejemplos.
  - `textInput`: Para introducir texto «libre».
  - `selectInput`: Crea un combo.
  - `checkboxInput`: Obvio.
  - ….
- `actionButton`
- `mainPanel`: Es el cuerpo de nuestra app y puede estar compuesto de:
  - `plotOutput`
  - `tabPanel`: Nos permite poner tablas HTML.
  - Si deseamos crear salidas más complejas podemos usar `mainPanel` y tabular nuestras salidas. Por ejemplo, un cuadro de mando.

A muy grandes rasgos esto es lo que podemos empezar a hacer con nuestra interfaz. Cada vez me recuerda más a SAS AF o AppDev Studio, lenguajes de programación que tengo más olvidados que el JCL. No es programar en R, aunque no es tan difícil como mi querido Tcl/Tk. Saludos.
