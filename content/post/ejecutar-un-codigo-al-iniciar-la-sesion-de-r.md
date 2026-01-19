---
author: rvaquerizo
categories:
  - r
  - trucos
date: '2019-07-30'
lastmod: '2025-07-13'
related:
  - comunicar-sas-con-r-creando-ejecutables-windows.md
  - macros-sas-dataset-a-data-frame-r.md
  - truco-r-eval-parse-y-paste-para-automatizar-codigo.md
  - truco-excel-y-sas-ejecutar-sas-desde-macro-en-excel.md
  - intro-rcommander-1-que-es-rcommander.md
tags:
  - r
  - trucos
title: Ejecutar un código al iniciar la sesión de R
url: /blog/ejecutar-un-codigo-al-iniciar-la-sesion-de-r/
---

A raíz de [una conversación en Twitter](https://twitter.com/r_vaquerizo/status/1155839211653742592) os traigo un pequeño truco de R para aquellos que tenéis funciones predefinidas y que tenéis que cargarlas al iniciar las sesiones de R, es como ejecutar el código nada más abrir R. En mi caso el código que quiero ejecutar son una serie de utilidades que tengo guardadas en C:\\carpeta, con source(«C:/carpeta/Utils.R», encoding=»UTF-8″) R cargaría todo el código R alojado en ese script de R y necesito que se ejecute el script al inicial la sesión de R, no quiero poner esa línea al principio de cada programa. Lo primero que tenemos que hacer es buscar donde tenemos instalado R, una vez hallamos accedido a la correspondiente carpeta vamos a la subcarpeta /etc y tenemos un archivo llamado Rprofile.site lo abrimos con un editor de texto:

```r
# Things you might want to change

# options(papersize="a4")
# options(editor="notepad")
# options(pager="internal")

# set the default help type
# options(help_type="text")
  options(help_type="html")

# set a site library
# .Library.site <- file.path(chartr("\\", "/", R.home()), "site-library")

# set a CRAN mirror
# local({r <- getOption("repos")
#       r["CRAN"] <- "http://my.local.cran"
#       options(repos=r)})

# Give a fortune cookie, but only to interactive sessions
# (This would need the fortunes package to be installed.)
#  if (interactive())
#    fortunes::fortune()

source("C:/carpeta/Utils.R", encoding="UTF-8")
```

Pues en ese archivo ponemos source("C:/carpeta/Utils.R", encoding="UTF-8") y cada vez que abramos nuestro R, desde RStudio por ejemplo, se ejecutará el script con nuestras utilidades.
