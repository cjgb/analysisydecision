---
author: rvaquerizo
categories:
  - r
  - trucos
date: '2013-12-26'
lastmod: '2025-07-13'
related:
  - cloud-words-con-r-trabajar-con-la-api-del-europe-pmc-con-r.md
  - analisis-de-textos-con-r.md
  - comparamos-los-programas-electorales-de-pp-y-psoe-con-r.md
  - puede-la-informacion-de-twitter-servir-para-tarificar-seguros.md
  - analisisydecision-es-os-desea-felices-fiestas.md
tags:
  - rcolorbrewer
  - text mining
  - wordcloud
title: Análisis del discurso de navidad del Rey de España 2013
url: /blog/analisis-del-discurso-de-navidad-del-rey-de-espana-2013/
---

![](/images/2013/12/Discurso-del-rey-espa%C3%B1a-2013.png)

Me llena de orgullo y satisfacción mostraros un ejemplo de uso de la librería `wordcloud` para la realización de nubes de palabras con R. Esta entrada no es muy innovadora porque ya tenemos alguna similar en el blog. Lo primero que tenéis que hacer es descargaros el discurso del Rey y ejecutad este código:

```r
#Lectura del archivo
ubicacion="C:\\temp\\juancar.txt"
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
#Creamos una variable longitud de la palabra
texto_collargo = nchar(texto_colV1)

#Quitamos palabras cortas
texto_col = subset(texto_col,largo>4)

#Nube de palabras
#install.packages('wordcloud')
library(wordcloud)
library(RColorBrewer)
pesos = data.frame(table(texto_colV1))

#Paleta de colores
pal = brewer.pal(6,"RdYlGn")

#Realizamos el gráfico
png('C:\\temp\\Discurso del rey españa 2013.png', width=500, height=500)
wordcloud(pesosVar1,pesosFreq,scale=c(4,.2),min.freq=2,
max.words=Inf, random.order=FALSE,colors=pal,rot.per=.15)

dev.off()
```

```

Interesante el uso de la librería `RColorBrewer`. Particularmente me gusta mucho el resultado que nos da `wordcloud` para la realización de las nubes de palabras con una sintaxis sencilla. Considero imprescindible el uso de `random.order=FALSE`. Espero que os sea de utilidad.

Quería aprovechar estas líneas para pedir al gabinete de prensa de la Casa del Rey que me permitieran fotografiarme con el Rey de España. **Profesionalmente me viene muy bien** (para determinados ámbitos) una fotografía estrechando la mano del Rey. Ya van unas pocas de veces que lo he pedido y siempre es imposible. Pero bien que estáis todo el día metidos en el blog cogiendo mapas y aprendiendo a usar mejor el Excel.
```
