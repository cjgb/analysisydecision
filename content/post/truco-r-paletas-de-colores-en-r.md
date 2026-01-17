---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2011-01-30T10:02:04-05:00'
lastmod: '2025-07-13T16:07:57.709922'
related:
- trucos-r-graficos-de-velocimetro-con-r.md
- graficos-de-burbuja-con-r.md
- graficos-dinamicos-en-r-con-la-funcion-text.md
- grafico-de-correlaciones-entre-variables.md
- truco-r-insertar-imagen-en-un-grafico.md
slug: truco-r-paletas-de-colores-en-r
tags:
- gráficos
- gráficos con R
title: Truco R. Paletas de colores en R
url: /blog/truco-r-paletas-de-colores-en-r/
---

[](/images/2011/01/paletas_colores_r.png "Paletas de colores en R")

![Paletas de colores en R](/images/2011/01/paletas_colores_r.png)


En cuántas ocasiones habéis querido dar color a un gráfico y por aligerar código creáis gráficos de este tipo:

```r
x = rpois(100,as.integer(runif(10)*1000))

barplot(sort(x))
```

Pues en R esta labor puede costarnos muy poco si empleamos las paletas de colores. Hoy quiero presentaros las siguientes:

  * rainbow
  * heat.colors
  * terrain.colors
  * topo.colors

Ejemplos de uso:

```r
require(graphics)

barplot(sort(x),col = rainbow(x),main="Paleta rainbow")

barplot(sort(x),col = heat.colors(length(x)),main="Paleta heat")

barplot(sort(x),col = topo.colors(length(x)),main="Paleta topo")
```

Comparad, metemos los 4 gráficos en una sóla ventana y tendremos la figura con la que iniciamos esta entrada:

```r
png(file="C:\\temp\\paletas_colores_R.png",

width=1200, height=800)

par(mfrow = c(2, 2))

barplot(sort(x),main="Sin paleta")

barplot(sort(x),col = rainbow(x),main="Paleta rainbow")

barplot(sort(x),col = heat.colors(length(x)),main="Paleta heat")

barplot(sort(x),col = topo.colors(length(x)),main="Paleta topo")

dev.off()
```

Podéis hacer vuestra propia paleta de colores, pero eso lo veremos otro día, ahora mis hijos me reclaman.