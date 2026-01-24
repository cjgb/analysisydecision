---
author: rvaquerizo
categories:
  - formación
  - r
  - trucos
date: '2011-08-09'
lastmod: '2025-07-13'
related:
  - analisis-de-textos-con-r.md
  - dividir-en-palabras-un-texto-con-sas.md
  - truco-r-eval-parse-y-paste-para-automatizar-codigo.md
  - comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
  - como-ordenar-un-data-frame-en-r.md
tags:
  - strsplit
  - unlist
title: Trucos R. De string a data.frame de palabras
url: /blog/trucos-r-de-string-a-dataframe-de-palabras/
---

Manejo de textos con R en este truco. Partimos de un vector de _string_ y deseamos dividir ese _string_ en palabras y posteriormente crear un _data frame_ de una sola columna con tantos elementos como palabras tenga nuestro vector de cadenas de texto. Es decir, vamos a transformar un texto en una tabla de palabras. Veamos una posible situación:

````r
```r
#Este es nuestro elemento inicial

texto=c("Este es el elemento ","que me gustaría"," poner en una tabla")

#Tenemos que generar un data frame con con las palabras

#que componen este vector

texto_split = strsplit(texto, split=" ")

texto_columnas = data.frame(unlist(texto_split))
````

Un código sencillo donde destaca el uso de la función _strsplit_ para crear una lista de palabras con los elementos del vector inicial. Es importante el uso de _unlist_ para realizar el proceso correctamente. Con estas 3 líneas podemos hacer cosas muy interesantes los lectores habituales ya sabrán por donde voy y como obtener los debates del Congreso de los Diputados. Saludos.
