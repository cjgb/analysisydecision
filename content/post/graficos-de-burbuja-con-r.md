---
author: rvaquerizo
categories:
  - formación
  - r
date: '2010-12-05'
lastmod: '2025-07-13'
related:
  - truco-r-paletas-de-colores-en-r.md
  - trucos-r-graficos-de-velocimetro-con-r.md
  - grafico-de-correlaciones-entre-variables.md
  - descubriendo-ggplot2-421.md
  - manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
tags:
  - ggplot2
  - palette
  - symbols
title: Gráficos de burbuja con R
url: /blog/graficos-de-burbuja-con-r/
---

El otro día en [R-bloggers leí este post](http://www.r-bloggers.com/bubble-chart-by-using-ggplot2/). Entonces busqué información sobre estos gráficos con `R` en español y sólo encontré ayuda para realizarlos con `Excel`. Es verdad que el enlace que os pongo es más que suficiente para realizar los gráficos de burbuja pero en pocas líneas puedo ilustrar mejor un ejemplo y proponeros varias formas de crearlo. La primera de ellas emplea la función `symbols` y genera el siguiente gráfico:

![R Bubble Plot 1](/images/2010/12/r_bubble_plot1.thumbnail.png "r_bubble_plot1.png")

```r
x=c(2,4,7,12,15)

y=c(12,10,15,25,23)

tamanio=c(100,120,230,340,800)

etiqueta=c("uno","dos","tres","cuatro")

palette(heat.colors(5))

symbols(x,y,circle=tamanio, bg=1:length(tamanio),

fg="white")

text(x,y,etiqueta)

palette("default")
```

Para etiquetar las variables empleao la función `text` y \_\_ me parece interesante el uso de la función `palette` (así tenéis un ejemplo de uso) para la leyenda he tenido que tirar de búsqueda y [encontré esta idea](http://flowingdata.com/2010/11/23/how-to-make-bubble-charts/) pero he tenido algún problema para realizarla, por ello he preferido evitarla. Y la otra forma de realizar el gráfico es emplear el `ggplot2` con una sintaxis muy similar a la que se utilizaba en el link de Rbloggers que os ponía al principio:

```r
datos=data.frame(x,y,tamanio)

g1 = ggplot (datos,aes(x,y))

g1 + geom_point(aes(size=tamanio)) +

geom_text (aes(label=etiqueta),hjust=1, vjust=1)
```

![R Bubble Plot 2](/images/2010/12/r_bubble_plot2.thumbnail.png "r_bubble_plot2.png")

O bien podemos hacer algo que particularmente me gusta, el tamaño de la etiqueta en función del tamaño de la burbuja:

```r
qplot(x,y,data=datos, size=tamanio) + scale_colour_identity() +

geom_text (aes(label=etiqueta),hjust=1, vjust=1)
```

![R Bubble Plot 3](/images/2010/12/r_bubble_plot3.thumbnail.png "r_bubble_plot3.png")

Os dejo varias posibilidades para realizar los gráficos de burbuja con `R`. Ya no tendréis escusas para hacer estos gráficos con `Excel`, a partir de ahora seguro que emplearéis `R`. Saludos.
