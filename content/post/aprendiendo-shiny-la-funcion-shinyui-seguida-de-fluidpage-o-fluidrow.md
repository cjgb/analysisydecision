---
author: rvaquerizo
categories:
- Formación
- R
date: '2015-02-13T17:28:19-05:00'
slug: aprendiendo-shiny-la-funcion-shinyui-seguida-de-fluidpage-o-fluidrow
tags:
- shiny
title: Aprendiendo Shiny. La función shinyUI seguida de fluidPage o fluidRow
url: /aprendiendo-shiny-la-funcion-shinyui-seguida-de-fluidpage-o-fluidrow/
---

Con shinyUI creamos el interface de nuestra app de shiny y cuando la usamos inmediatamente ponemos fluidPage o fluidRow (por lo menos en estos primeros acercamientos). Utilizaremos una u otra en función del diseño que deseamos. Los argumentos que pueden tener fluidPage o fluidRow son múltiples. Algunos de los que estoy usando:

  * titlePanel. Imprescindible, sirve para poner títulos a nuestra app
  * headerPanel. Para titular nuestro panel
  * wellPanel para introducir tablas con formato. Podremos jugar con css para cambiar los formatos.
  * Elementos para modificar valores como: 
    * sliderInput. Nos permite crear los slider como hemos visto en los ejemplos
    * textInput. Para introducir texto «libre»
    * selectInput. Crea un combo
    * checkboxInput. Obvio
    * ….
  * actionButton
  * mainPanel. Es el cuerpo de nuestra app y puede estar compuesto de: 
    * plotOutput
    * tabPanel nos permite poner tablas HTML
    * si deseamos crear salidas más complejas podemos usar mainPanel y tabular nuestras salidas. Por ejemplo un cuadro de mando

A muy grandes rasgos esto es lo que podemos empezar a hacer con nuestro interfaz. Cada vez me recuerda más a SAS AF o appDev Studio lenguaje de programación que tengo más olvidado que el JCL. No es programar en R, aunque no es tan difícil como mi querido Tclk. Saludos.