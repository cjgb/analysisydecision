---
author: rvaquerizo
categories:
  - business intelligence
  - consultoría
  - r
date: '2011-11-01'
lastmod: '2025-07-13'
related:
  - comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
  - el-debate-politico-o-como-analizar-textos-con-wps.md
  - analisis-de-textos-con-r.md
  - ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii.md
tags:
  - política
  - text mining
title: Análisis del programa electoral del Partido Popular antes de las elecciones en España
url: /blog/analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana/
---

Ya empleamos R en [alguna entrada anterior](https://analisisydecision.es/analisis-de-textos-con-r/) para analizar textos. Ahora nos metemos con el programa electoral del Partido Popular a 20 días de las elecciones en España. En [este enlace](http://www.pp.es/actualidad-noticia/programa-electoral-pp_5741.html) podéis descargaros el programa. Lejos de lo insustanciales que suelen ser este tipo de documentos y alguna frase mítica del tipo «Crecimiento sin empleo no es recuperación», nos limitaremos a contar las palabras que emplean en este programa mediante técnicas de `Text Mining`.

Accedemos al programa en formato `PDF`, seleccionamos todo el documento, lo copiamos en un archivo `.txt` y ya podemos trabajar con R. El código empleado es similar al ya comentado en este blog:

```r
# Análisis del programa del PP
# Leemos el fichero de una ubicación local
ubicacion <- "D:\\raul\\wordpress\\text minning R\\programa_PP.txt"
texto_raw <- read.table(ubicacion, sep = "\r")

# Dejamos todas las palabras en mayúsculas
texto <- toupper(texto_raw$V1)

# El texto lo transformamos en una lista separada por espacios
texto_split <- strsplit(texto, split = " ")

# Deshacemos esa lista y creamos un data.frame de palabras
texto_col <- as.character(unlist(texto_split))
texto_col_df <- data.frame(V1 = texto_col)

# Limpiamos caracteres especiales usando expresiones regulares
texto_col_df$V1 <- gsub("([[:space:]])", "", texto_col_df$V1)
texto_col_df$V1 <- gsub("([[:digit:]])", "", texto_col_df$V1)
texto_col_df$V1 <- gsub("([[:punct:]])", "", texto_col_df$V1)

# Calculamos la longitud de cada palabra
texto_col_df$largo <- nchar(texto_col_df$V1)

# Filtramos palabras con más de 4 caracteres
texto_filtrado <- subset(texto_col_df, largo > 4)

# Realizamos el conteo de frecuencias con sqldf
library(sqldf)
contador <- sqldf("
  SELECT V1 AS palabra, COUNT(*) AS frec
  FROM texto_filtrado
  GROUP BY palabra
  ORDER BY COUNT(*) DESC
")

head(contador, 20)
```

`CAMBIO`, `POLÍTICA`, `SOCIEDAD` y `EMPLEO` son las palabras más empleadas. `SOCIAL` aparece en la posición 50 y `JÓVENES` mucho más abajo. `CRISIS` es otra de las palabras que no son muy destacadas. Abrid R, seguid los pasos que os indico y obtendréis un análisis muy interesante. Saludos.