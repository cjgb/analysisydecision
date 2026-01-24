---
author: rvaquerizo
categories:
  - r
date: '2010-11-14'
lastmod: '2025-07-13'
related:
  - descubriendo-ggplot2-421.md
  - graficos-de-burbuja-con-r.md
  - truco-r-paletas-de-colores-en-r.md
  - manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
  - grafico-con-eje-secundario-en-ggplot2.md
tags:
  - ggplot2
  - lattice
title: Haciendo gráficos con R ¿cuáles son vuestras preferencias?
url: /blog/haciendo-graficos-con-r-c2bfcuales-son-vuestras-preferencias/
---

¿Cúal de estos gráficos de cajas os gusta más?

- Base de R:

![base.png](/images/2010/11/base.png)

````r
```r
png('C://temp//base.png',bg = "white",

res = 100, width=450, height=600)

boxplot(Petal.Length~Species, data=iris,

main="Gráfico con Base")

dev.off()
````

- Con lattice:

![lattice.png](/images/2010/11/lattice.png)

````r
```r
png('C://temp//lattice.png',bg = "white",

res = 100, width=450, height=600)

#Paquete lattice

require(lattice)

x<-bwplot(Petal.Length~Species, data=iris,

main="Gráfico con Lattice")

print(x)

dev.off()
````

- Con ggplot2:

![ggplot2.png](/images/2010/11/ggplot2.png)

````r
```r
png('C://temp//ggplot2.png',bg = "white",

res = 100, width=450, height=600)

#Paquete ggplot

require(ggplot2)

x2 <- ggplot(iris,aes(Species,Petal.Length))

x2 + geom_boxplot() + opts(title="Gráfico con ggplot2")

dev.off()
````

Tres muestras del mismo gráfico de cajas realizado con R. Tres sintaxis muy sencillas pero _boxplot_ es más fácil si cabe. Parece que estéticamente ganaría _ggplot2_ sin embargo todo es jugar con más opciones, pero se complicaría el código. En mi opinión creo que sale ganando _ggplot2_ pero no es tanta la diferencia.
