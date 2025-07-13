---
author: rvaquerizo
categories:
- Formación
- Modelos
- R
date: '2016-04-24T11:54:58-05:00'
slug: valor-atipico-o-pocos-registros-animacion-con-r
tags:
- Animaciones
- animation
- ouliers
- regresión lineal
title: Valor atípico o pocos registros. Animación con R
url: /valor-atipico-o-pocos-registros-animacion-con-r/
---

[![outlier](/images/2016/04/outlier.gif)](/images/2016/04/outlier.gif)¿Cómo influye un solo punto en una recta de regresión? Evidentemente cuanto menos observaciones tengo más puede «descolocar» la recta de regresión. Sin embargo, cuantos más puntos tengo más complicado es encontrar ese punto con una recta de regresión, sin analizar los residuos podríamos hasta pasarlo por alto, aunque puede ser que nos interese ese punto. El código de R que genera la animación es:

**library(animation)**  
**saveGIF(**  
**for (i in c(100,50,25,10,5,1)){**  
**x <\- seq(-500,500, by = i )**  
**y=sin(x)+x/100**  
**y[10]=y[10]+10**  
**plot (y,x,main=paste(«Regresión lineal con «,1000/i,» observaciones»))**  
**reg <\- lm(y~x)**  
**points( fitted.values(reg),x, type=»l», col=»red», lwd=2)},**  
**interval = .85, ,movie.name=»/Users/raulvaquerizo/Desktop/R/animaciones/outlier.gif»)**