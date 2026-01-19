---
author: rvaquerizo
categories:
- formación
date: '2020-12-22'
lastmod: '2025-07-13'
related:
- graficos-dinamicos-en-r-con-la-funcion-text.md
- analisis-del-discurso-de-navidad-del-rey-de-espana-2013.md
- sas-te-felicita-la-navidad.md
- como-me-encuentro-hoy-con-rstats.md
- truco-r-paletas-de-colores-en-r.md
tags:
- sin etiqueta
title: Analisisydecision.es os desea felices fiestas
url: /blog/analisisydecision-es-os-desea-felices-fiestas/
---
[![](/images/2020/12/navidad.gif)](/images/2020/12/navidad.gif)

Un homenaje a R base del que nadie se acuerda. Una animación donde se usa el paquete snowflakes para hacer copos de nieve y hay algún uso interesante de la función text. En cualquier caso, lo dicho, felices fiestas en estos días extraños.

```r
alturas <- seq(100,200, by = 3)
posiciones <- as.integer(runif(length(alturas),5,95))
radio = round(runif(length(alturas),0.7,1.8),2)
orientacion = posiciones/5 * (pi/6)
grises <- paste0("gray",as.integer(runif(length(alturas),70,95)))

texto =  " AnalisisyDecision.es  "
texto2 = "os desea felices fiestas";

saveGIF(
  for (i in seq(0,100, by = 3)){
    frase2=""
    frase1=substr(texto,1,i/3)
    if (i > nchar(texto)) frase2=substr(texto2,1,i/2 - nchar(texto))
    plot(rep(100,100),rep(100,100),ann=FALSE,type="n",axes=FALSE, ylim=c(0,100), xlim=c(0,100))
    snowflakes(xCoor = posiciones, yCoor = alturas - i, radius = radio,
               orientation = orientacion, seeds = puntas, color = grises)
    text(80,50, frase1, adj = c(1,0), cex=2, col=i)
    text(80,30, frase2, adj = c(1,0), cex=2, col=i)},
  fps= 1 , movie.name="C:/temp/animaciones/navidad.gif")
```