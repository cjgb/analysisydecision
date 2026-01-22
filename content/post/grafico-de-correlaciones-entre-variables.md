---
author: rvaquerizo
categories:
  - formación
  - r
date: '2013-02-20'
lastmod: '2025-07-13'
related:
  - grafico-de-correlaciones-entre-factores-grafico-de-la-v-de-cramer.md
  - truco-sas-grafico-de-correlaciones.md
  - graficos-de-burbuja-con-r.md
  - graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
  - anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie.md
tags:
  - ggplot2
title: Gráfico de correlaciones entre variables
url: /blog/grafico-de-correlaciones-entre-variables/
---

![Gráfico de correlaciones R](/images/2013/02/Grafico-correlaciones-R.png)

Los gráficos de correlaciones no me gustan especialmente pero empiezo a verlos en algunas presentaciones. En `R` tenemos algunos ejemplos interesantes pero con códigos que, bajo mi prisma, son complejos. Por este motivo me he puesto manos a la obra para realizar este gráfico de correlaciones con un código lo más sencillo posible. Para ello vamos a emplear `ggplot2`:

```r
library(ggplot2)

datos = cor(mtcars)

datos.lista = melt(datos)

names(datos.lista)=c("Variable_1","Variable_2","Correlacion")

escala = seq(-1,1,0.1)
```

Vamos a emplear el famoso conjunto de datos `mtcars` para ilustrar el ejemplo. Con él creamos la matriz de correlaciones pero esta matriz la hemos de transformar en una lista, para ello empleamos la función `melt` del paquete `reshape`, en este punto hemos pasado de una matriz de correlaciones a una lista con pares de variables y su correspondiente coeficiente de correlación. A esta lista le asignamos los nombres que deseamos con la función `names` y por último generamos un vector que denominamos `escala` que nos permitirá establecer los colores que deseamos utilizar cuando pintemos nuestra matriz de correlaciones.

El código de `ggplot2` que utilizamos para pintarla es muy sencillo:

## Editado tras el comentario de Felix

```r
(p <- ggplot(datos.lista, aes(Variable_1, Variable_2, fill=Correlacion)) +
geom_tile(aes(fill=Correlacion)) +
scale_fill_continuous(low = "white", high = "steelblue" ,breaks=escala) +
labs(title = "Correlación de variables") +
theme(plot.title = element_text(face = "bold", size = 14)))
```

La clave es `geom_tile` que nos permite pintar mapas que estarán compuestos de cuadrados y representarán el coeficiente de correlación entre las variables. Con `scale_fill_continous` especificamos el rango de colores y el número de grupos que utilizamos, como vemos es el objeto `escala` el que nos indica el número de grupos. Por último añadimos un `title` y tenemos un gráfico de correlaciones tan bonito como el que tenemos arriba.
