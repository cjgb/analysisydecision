---
author: rvaquerizo
categories:
- Formación
- Modelos
- Monográficos
- R
date: '2012-04-23T09:34:30-05:00'
lastmod: '2025-07-13T15:59:20.215089'
related:
- evaluando-la-capacidad-predictiva-de-mi-modelo-tweedie.md
- modelos-tweedie-con-h2o-mutualizar-siniestralidad-en-base-a-factores-de-riesgo.md
- determinar-la-distribucion-de-un-vector-de-datos-con-r.md
- manual-curso-introduccion-de-r-capitulo-8-inferencia-estadistica.md
- capitulo-5-representacion-basica-con-ggplot.md
slug: la-distribucion-tweedie
tags:
- modelo de riesgo
- tweedie
title: La distribución tweedie
url: /la-distribucion-tweedie/
---

[![tweedie.png](/images/2012/04/tweedie.png)](/images/2012/04/tweedie.png "tweedie.png")

Reconozco que hace muy poco tiempo que trabajo con las **distribuciones tweedie**. Un viejo dinosaurio que trabaja sobre todo con SAS se hace el sordo cuando le hablan de la distribución tweedie. Quizá sea el trabajo con SAS el que me ha nublado. Pero ahora que empiezo a trabajar con otras herramientas… Para comprender mejor la base teórica para este tipo de distribuciones os [enlazo a la wikipedia](http://en.wikipedia.org/wiki/Tweedie_distributions). Pero despierta mi interés debido a que se puede considerar una gamma con punto de masa en el 0 ¡toma aberración matemática! Aspecto interesante.

Este tipo de distribución necesita 3 parámetros; p que nos indica el tipo de distribución en R se denomina _power_ , mu que es la media y phi que es la desviación típica. En R disponemos del paquete **tweedie** para trabajar con este tipo de distribuciones, la función rtweedie es la que genera números aleatorios según una tweedie con parámetros p, mu y phi:

_#install.packages(«tweedie»)_  
_library(tweedie)_  
_#Números aleatorios distribuidos según una tweedie_  
_y1 <\- rtweedie( 10000, p=1, mu=600, phi=1000)_  
_summary(y1)
```r
y1.5 <- rtweedie( 10000, p=1.5, mu=600, phi=1000)

summary(y1.5)
```

```r
y2 <- rtweedie( 10000, p=2, mu=600, phi=1000)

summary(y2)
```

```r
par(mfrow=c(2,2))

plot(density(y1),main="Densidad con parámetro p=1")

plot(density(y1.5),main=" Densidad con parámetro p=1.5")

plot(density(y2),main=" Densidad con parámetro p=2")
```
_

Más que interesante el resultado obtenido. Con p=1 fijaos que forma tiene la función de densidad con distintos puntos de masa, con p=1.5 estamos ante una distribución que se parece mucho a una gamma salvo por un “pequeño detalle” tenemos muchos ceros. Con p=2 deberíamos tener una gamma. Pero es entre el 1 y el 2 donde esta distribución es más interesante sobre todo si se aplica a modelos de riesgo en estudios actuariales ya que nos permite modelizar directamente la prima de riesgo sin ser necesario modelizar el coste y la frecuencia por separado.