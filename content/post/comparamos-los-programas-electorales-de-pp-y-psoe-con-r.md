---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2011-11-03T15:56:40-05:00'
slug: comparamos-los-programas-electorales-de-pp-y-psoe-con-r
tags:
- cloud
- nchar
- política
- snippets
- strsplit
- sub
- text mining
- unlist
title: Comparamos los programas electorales de PP y PSOE con R
url: /comparamos-los-programas-electorales-de-pp-y-psoe-con-r/
---

[Replicamos el post anterior sobre el análisis del programa electoral del PP](https://analisisydecision.es/analisis-del-programa-electoral-del-partido-popular-antes-de-las-elecciones-en-espana/) y lo comparamos con el programa electoral del PSOE. Programas electorales que presentan estos partidos políticos españoles de cara a las elecciones del 20-N. No vamos a entrar en el contenido de ambos programas, sólo nos limitamos a representar gráficamente su contenido con nubes de palabras.

_Programa del PSOE:_

[![programa_psoe.jpg](/images/2011/11/programa_psoe.jpg)](/images/2011/11/programa_psoe.jpg "programa_psoe.jpg")

_Programa del PP:_

[![programa_pp.jpg](/images/2011/11/programa_pp.jpg)](/images/2011/11/programa_pp.jpg "programa_pp.jpg")

Esto que véis es el análisis más completo que hay sobre los programas electorales. Lo malo (o lo bueno) es que cada uno ha de sacar sus propias conclusiones. Yo he sacado alguna impresión interesante. A continuación tenéis el código empleado para realizar estos gráficos. Emplea la librería **snippets** que nos dio a conocer Jose Luis para la realización de la nube de palabras. Recordad que tenéis que guardar en modo texto los programas electorales de ambos partidos y modificar la ubicación de los ficheros:

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

hist(texto_collargo)
```

texto_col = subset(texto_col, largo>4)

#Nube de palabras  
#install.packages('snippets',,'http://www.rforge.net/')  
library(snippets)  
wt <\- table(texto_colV1)  
wt <\- wt[wt>40]  
jpeg('D:\\\raul\\\wordpress\\\text minning R\\\programa_pp.jpg', quality = 100,  
bg = "white", res = 100, width=850, height=500)  
cloud(wt, col = col.br(wt, fit=TRUE))  
dev.off()

#Análisis del programa del PSOE  
#Leemos el fichero de una ubicación de nuestro equipo  
ubicacion="D:\\\raul\\\wordpress\\\text minning R\\\programa_Psoe.txt"  
texto = read.table (ubicacion,sep="\r")  
#Dejamos todas las palabras en mayúsculas  
texto = toupper(textoV1)  
#El texto lo transformamos en una lista separada por espacios  
texto_split = strsplit(texto, split=" ")  
#Deshacemos esa lista y tenemos el data.frame  
texto_col = as.character(unlist(texto_split))  
texto_col = data.frame(texto_col)  
names(texto_col) = c("V1")

#Eliminamos algunos caracteres regulares  
texto_colV1 = sub("([[:space:]])","",texto_colV1)  
texto_colV1 = sub("([[:digit:]])","",texto_colV1)  
texto_colV1 = sub("([[:punct:]])","",texto_colV1)  
#Creo una variable longitud de la palabra  
texto_collargo = nchar(texto_colV1)  
#Controles que utilizo  
head(texto_col)  
hist(texto_collargo)

texto_col = subset(texto_col, largo>4)

```r
wt <- table(texto_col$V1)

wt <- wt[wt>40]

jpeg('D:\\raul\\wordpress\\text minning R\\programa_psoe.jpg', quality = 100,

bg = "white", res = 100, width=850, height=500)

cloud(wt, col = col.br(wt, fit=TRUE))

dev.off()
```