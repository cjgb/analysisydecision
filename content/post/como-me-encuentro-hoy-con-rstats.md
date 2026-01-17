---
author: rvaquerizo
categories:
- R
date: '2017-03-28T08:54:56-05:00'
lastmod: '2025-07-13T15:55:03.348917'
related:
- trucos-r-graficos-de-velocimetro-con-r.md
- analisisydecision-es-os-desea-felices-fiestas.md
- graficos-dinamicos-en-r-con-la-funcion-text.md
- descubriendo-ggplot2-421.md
- truco-r-paletas-de-colores-en-r.md
slug: como-me-encuentro-hoy-con-rstats
tags: []
title: 'Como me encuentro hoy, con #rstats'
url: /blog/como-me-encuentro-hoy-con-rstats/
---

[![Happy_con_R](/images/2017/03/Happy_con_R.png)](/images/2017/03/Happy_con_R.png)

Gráfico absurdo con R y un buen ejemplo de las cosas que hace pi. Tras 2 meses de dolores intensos en mi hombro hoy sólo noto una molestia, y claro…

[source language=»R»]
plot(rep(10,10),rep(10,10),ann=FALSE,type="n",
,xlim=c(-1,1),ylim=c(-1,1),axes=FALSE)
radio <\- 1
theta <\- seq(0, 2 * pi, length = 200)
lines(x = radio * cos(theta), y = radio * sin(theta))
radio <\- 1.1
theta <\- seq(-0.75, -3*pi/4 , length = 100)
lines(x = radio * cos(theta) , y = radio * sin(theta) + 0.5 )
points(-0.5,0.5,pch=1,cex=3)
points(0.5,0.5,pch=1,cex=3)
[/source]