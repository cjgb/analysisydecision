---
author: rvaquerizo
categories:
- formación
- monográficos
- r
date: '2011-09-05'
lastmod: '2025-07-13'
related:
- el-debate-politico-o-como-analizar-textos-con-wps.md
- comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
- ejemplo-de-web-scraping-con-r-la-formacion-de-los-diputados-del-congreso.md
- analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana.md
- trucos-r-de-string-a-dataframe-de-palabras.md
tags:
- nchar
- strsplit
- sub
- text mining
- unlist
title: Análisis de textos con R
url: /blog/analisis-de-textos-con-r/
---
[Vamos a replicar un ejemplo ya presentado con WPS en esta misma bitácora](https://analisisydecision.es/el-debate-politico-o-como-analizar-textos-con-wps/). Tratamos de hacer algo tan sencillo como contar palabras y para ello empleamos de nuevo [un debate del Congreso de los Diputados de España](http://www.congreso.es/portal/page/portal/Congreso/PopUpCGI?CMD=VERLST&BASE=puw9&FMT=PUWTXDTS.fmt&DOCS=1-1&QUERY=%28CDP201108300269.CODI.%29#\(Página2\)). Estas intervenciones las transformamos en un fichero de texto que vosotros podéis descargaros de [este link](/images/2011/09/intervencion_congreso.txt "intervencion_congreso.txt"). Bien, partimos de un archivo de texto de Windows y con él vamos a crear un _data frame_ de R que contendrá las palabras empleadas en esa sesión del Congreso español. Pasamos a analizar el código empleado:

```r
#Leemos el fichero de una ubicación de nuestro equipo

ubicacion="D:\\raul\\wordpress\\text minning R\\datos\\intervencion_congreso.txt"

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

Está bien comentado en el código, pero repetimos. Leemos el archivo de texto con una sóla variable y donde el **retorno de carro** es el separador, en R el retorno de carro es **\r**. Con _toupper_ ponemos todas las palabras en mayúsculas y a partir de ahí creamos una lista con los elementos de la tabla inicial partiendo por espacios en blanco. Se deshace la lista y se crea un _data frame_ con una variable que llamamos V1. Ahora es necesario realizar una pequeña depuración de las palabras. Mi hijo acaba de tirar una piedra al portátil así que no me entretendré mucho con esta tarea:

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

Con la función sub vamos a eliminar **caracteres regulares** como espacios («([[:space:]])») números («([[:digit:]])») y signos de puntuación («([[:punct:]])»). Con nchar creamos una variable en el _data frame_ para determinar la longitud de la palabra. Se realiza un histograma para analizar estas longitudes.

Ya disponemos de un _data frame_ preparado para nuestro objetivo, ahora sólo nos queda realizar la tabla de frecuencias y para ello vamos a emplear el paquete **sqldf**(como no):

```r
library(sqldf)

contador = sqldf("

select V1 as palabra,count(*) as frec

from texto_col

where largo > 4

group by palabra

order by  count(*) desc ;")

head(contador)
```

Vemos que el código requiere de una cierta mejora, pero parece claro que les preocupaba la REFORMA CONSTITUCIONAL y la CONSTITUCION (ahora nos acordamos de ella). Esta entrada continuará con la creación de una nube de palabras que realizaremos con **ggplot2**.

Por cierto, este trabajo se intentó hacer con la librería **tm** y no pude con los caracteres especiales tales como ñ o tildes, ¿alguien sabe cómo solventar este problema?