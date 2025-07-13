---
author: rvaquerizo
categories:
- Data Mining
- Formación
- SAS
date: '2010-06-29T09:21:11-05:00'
lastmod: '2025-07-13T15:58:16.279269'
related:
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
- un-acercamiento-a-graph-primeros-graficos-con-sas.md
- graficos-descriptivos-basicos-con-seaborn-python.md
- un-acercamiento-a-graph-sentencias-graficas.md
- capitulo-5-representacion-basica-con-ggplot.md
slug: graficos-de-densidades-con-sas-y-el-proc-kde
tags: []
title: Gráficos de densidades con SAS y el PROC KDE
url: /graficos-de-densidades-con-sas-y-el-proc-kde/
---

[](/images/2010/06/histogram1.png "histogram1.png")El PROC KDE de SAS está incluido en el módulo SAS/STAT. Es un procedimiento que nos permite estudiar gráficamente las distribuciones de variables continuas. Lo que nos produce son gráficos de densidades. Para seguir el ejemplo nos vamos a ir a [Yahoo Finance ](http://es.finance.yahoo.com/q/hp?s=%5EIBEX)y descargarnos un evolutivo del IBEX de los últimos 3 meses (yo realizo este proceso con Excel), una vez tengamos el dataset creado, para el análisis de la densidad univariante podemos hacer:  

```r
ods graphics on;

title "Análisis de volumen";

proc kde data=ibex;

univar volumen / plots=(DENSITY DENSITYOVERLAY

HISTDENSITY HISTOGRAM);

run;

title;

ods graphics off;
```

Tenemos los siguientes gráficos:

[![densityoverlayplot1.png](/images/2010/06/densityoverlayplot1.thumbnail.png)](/images/2010/06/densityoverlayplot1.png "densityoverlayplot1.png")[![histogram1.png](/images/2010/06/histogram1.thumbnail.png)](/images/2010/06/histogram1.png "histogram1.png")[![histogramdensity1.png](/images/2010/06/histogramdensity1.thumbnail.png)](/images/2010/06/histogramdensity1.png "histogramdensity1.png")

KDE es uno de los procedimientos que trabajan con gráficos de ODS. Ya hemos hecho mención al cambio de filosofía de algunos procedimientos gráficos en SAS. Yo me atrevería a decir que los procedimientos clásicos tienen una «curva de parendizaje» muy complicada pero los procedimientos de ODS empiezan a crear gráficos más que interesantes con una sintaxis más sencilla. Para los análisis univariantes yo prefiero el SGPLOT. Pero si en algo destaca KDE es en los gráficos de densidades bivariables. Ejecutemos:

```r
ods graphics on;

title "Análisis de volumen X cierre en IBEX35";

proc kde data=ibex;

bivar cierre_ajustado_ volumen / plots=(CONTOUR CONTOURSCATTER HISTOGRAM

HISTSURFACE SCATTER SURFACE);

run;

title;

ods graphics off;
```

Y obtenemos…

[![surfaceplot6.png](/images/2010/06/surfaceplot6.thumbnail.png)](/images/2010/06/surfaceplot6.png "surfaceplot6.png")[![scatterplot.png](/images/2010/06/scatterplot.thumbnail.png)](/images/2010/06/scatterplot.png "scatterplot.png")[![histogramsurface.png](/images/2010/06/histogramsurface.thumbnail.png)](/images/2010/06/histogramsurface.png "histogramsurface.png")

[![contourscatterplot.png](/images/2010/06/contourscatterplot.thumbnail.png)](/images/2010/06/contourscatterplot.png "contourscatterplot.png")[![contourplot6.png](/images/2010/06/contourplot6.thumbnail.png)](/images/2010/06/contourplot6.png "contourplot6.png")

Destacan muy por encima de todos _surface_ y _contour_. Imprescindibles en vuestros informes. Por cierto, vemos que hay dos picos bien diferenciados, uno con valores altos del IBEX y otro con valores bajos. El pico en torno a los 9.000 puntos es más alto que el pico de los 11.000, cuando especulador hay suelto. Saludos