---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2011-11-03'
lastmod: '2025-07-13'
related:
  - analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana.md
  - analisis-de-textos-con-r.md
  - el-debate-politico-o-como-analizar-textos-con-wps.md
  - ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
  - longitud-de-las-frases-del-quijote-con-rstats.md
tags:
  - cloud
  - política
  - snippets
  - text mining
  - unlist
title: Comparamos los programas electorales de PP y PSOE con R
url: /blog/comparamos-los-programas-electorales-de-pp-y-psoe-con-r/
---

[Replicamos el post anterior sobre el análisis del programa electoral del PP](https://analisisydecision.es/analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana/) y lo comparamos con el programa electoral del PSOE. Programas electorales que presentan estos partidos políticos españoles de cara a las elecciones del 20-N. No vamos a entrar en el contenido de ambos programas; sólo nos limitamos a representar gráficamente su contenido con nubes de palabras.

*Programa del PSOE:*

![programa_psoe.jpg](/images/2011/11/programa_psoe.jpg "programa_psoe.jpg")

*Programa del PP:*

![programa_pp.jpg](/images/2011/11/programa_pp.jpg "programa_pp.jpg")

Esto que veis es el análisis más completo que hay sobre los programas electorales. Lo malo (o lo bueno) es que cada uno ha de sacar sus propias conclusiones. Yo he sacado alguna impresión interesante.

A continuación tenéis el código empleado para realizar estos gráficos. Emplea la librería `snippets` para la realización de la nube de palabras. Recordad que tenéis que guardar en modo texto los programas electorales de ambos partidos y modificar la ubicación de los ficheros:

```r
# Análisis del programa del PP
# Leemos el fichero de una ubicación de nuestro equipo
ubicacion <- "D:\\raul\\wordpress\\text minning R\\programa_PP.txt"
texto_df <- read.table(ubicacion, sep = "\r")

# Dejamos todas las palabras en mayúsculas
texto <- toupper(texto_df$V1)

# El texto lo transformamos en una lista separada por espacios
texto_split <- strsplit(texto, split = " ")

# Deshacemos esa lista y tenemos el data.frame
texto_col <- as.character(unlist(texto_split))
texto_col_df <- data.frame(V1 = texto_col)

# Eliminamos algunos caracteres regulares
texto_col_df$V1 <- gsub("([[:space:]])", "", texto_col_df$V1)
texto_col_df$V1 <- gsub("([[:digit:]])", "", texto_col_df$V1)
texto_col_df$V1 <- gsub("([[:punct:]])", "", texto_col_df$V1)

# Creo una variable longitud de la palabra
texto_col_df$largo <- nchar(texto_col_df$V1)

# Controles que utilizo
head(texto_col_df)
hist(texto_col_df$largo)

# Filtramos palabras
texto_col_df <- subset(texto_col_df, largo > 4)

# Nube de palabras
# install.packages('snippets', , 'http://www.rforge.net/')
library(snippets)
wt <- table(texto_col_df$V1)
wt <- wt[wt > 40]

jpeg('D:\\raul\\wordpress\\text minning R\\programa_pp.jpg', quality = 100,
     bg = "white", res = 100, width = 850, height = 500)
cloud(wt, col = col.br(wt, fit = TRUE))
dev.off()
```

```r
# Análisis del programa del PSOE
# Leemos el fichero de una ubicación de nuestro equipo
ubicacion <- "D:\\raul\\wordpress\\text minning R\\programa_Psoe.txt"
texto_df <- read.table(ubicacion, sep = "\r")

# Dejamos todas las palabras en mayúsculas
texto <- toupper(texto_df$V1)

# El texto lo transformamos en una lista separada por espacios
texto_split <- strsplit(texto, split = " ")

# Deshacemos esa lista y tenemos el data.frame
texto_col <- as.character(unlist(texto_split))
texto_col_df <- data.frame(V1 = texto_col)

# Eliminamos algunos caracteres regulares
texto_col_df$V1 <- gsub("([[:space:]])", "", texto_col_df$V1)
texto_col_df$V1 <- gsub("([[:digit:]])", "", texto_col_df$V1)
texto_col_df$V1 <- gsub("([[:punct:]])", "", texto_col_df$V1)

# Creo una variable longitud de la palabra
texto_col_df$largo <- nchar(texto_col_col_df$V1)

# Filtramos palabras
texto_col_df <- subset(texto_col_df, largo > 4)

# Nube de palabras
wt <- table(texto_col_df$V1)
wt <- wt[wt > 40]

jpeg('D:\\raul\\wordpress\\text minning R\\programa_psoe.jpg', quality = 100,
     bg = "white", res = 100, width = 850, height = 500)
cloud(wt, col = col.br(wt, fit = TRUE))
dev.off()
```