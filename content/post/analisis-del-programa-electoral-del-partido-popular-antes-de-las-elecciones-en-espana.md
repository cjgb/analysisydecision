---
author: rvaquerizo
categories:
- Business Intelligence
- Consultoría
- R
date: '2011-11-01T14:57:14-05:00'
lastmod: '2025-07-13T15:53:59.039765'
related:
- comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
- el-debate-politico-o-como-analizar-textos-con-wps.md
- analisis-de-textos-con-r.md
- ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
- manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii.md
slug: analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana
tags:
- ''
- nchar
- política
- strsplit
- sub
- text mining
- unlist
title: Análisis del programa electoral del Partido Popular antes de las elecciones
  en España
url: /blog/analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana/
---

Ya empleamos R en[ alguna entrada anterior ](https://analisisydecision.es/analisis-de-textos-con-r/)para analizar textos. Ahora nos metemos con el programa electoral del Partido Popular a 20 días de las elecciones en España. En [este link](http://www.pp.es/actualidad-noticia/programa-electoral-pp_5741.html) podéis descargaros el programa del Partido Popular. Lejos de lo insustanciales que suelen ser este tipo de documentos y alguna frase mítica del tipo «Crecimiento sin empleo no es recuperación» nos limitaremos a contar las palabras que emplean en este programa.

En el [link ](http://www.pp.es/actualidad-noticia/programa-electoral-pp_5741.html)donde tenemos el programa accedemos al mismo en formato PDF, seleccionamos todo el documento, lo copiamos en un archivo de texto y ya podemos trabajar con R. El código ya ha sido comentado en este blog:

```r
#Análisis del programa del PP

#Leemos el fichero de una ubicación de nuestro equipo

ubicacion="D:\\raul\\wordpress\\text minning R\\programa_PP.txt"

texto = read.table (ubicacion,sep="\r")

#Dejamos todas las palabras en mayúsculas

texto = toupper(texto$V1)

#El texto lo transformamos en una lista separada por espacios

texto_split = strsplit(texto, split=" ")

#Deshacemos esa lista y tenemos el data.frame

texto_col = as.character(unlist(texto_split))

texto_col = data.frame(texto_col)

names(texto_col) = c("V1")
```

```r
#Eliminamos algunos caracteres regulares

texto_colV1 = sub("([[:space:]])","",texto_colV1)

texto_colV1 = sub("([[:digit:]])","",texto_colV1)

texto_colV1 = sub("([[:punct:]])","",texto_colV1)

#Creo una variable longitud de la palabra

texto_collargo = nchar(texto_colV1)

#Controles que utilizo

head(texto_col)

hist(texto_col$largo)
```

`texto_col = subset(texto_col, largo>4)`

``
```r
library(sqldf)

contador = sqldf("

select V1 as palabra,count(*) as frec

from texto_col

where largo > 4

group by palabra

order by  count(*) desc ;")
```

CAMBIO, POLÍTICA, SOCIEDAD y EMPLEO son las palabras más empleadas. SOCIAL aparece en la posición 50 y JÓVENES mucho más abajo. CRISIS es otra de las palabras que no son muy destacadas. Abrid R, seguid los pasos que os indico y obtendréis un análisis muy interesante. Saludos.