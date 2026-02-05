---
author: rvaquerizo
categories:
  - data mining
  - formación
  - sas
date: '2010-06-29'
lastmod: '2025-07-13'
related:
  - un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
  - un-acercamiento-a-graph-primeros-graficos-con-sas.md
  - graficos-descriptivos-basicos-con-seaborn-python.md
  - un-acercamiento-a-graph-sentencias-graficas.md
  - capitulo-5-representacion-basica-con-ggplot.md
tags:
  - data mining
  - formación
  - sas
title: Gráficos de densidades con SAS y el PROC KDE
url: /blog/graficos-de-densidades-con-sas-y-el-proc-kde/
---

![histogram1.png](/images/2010/06/histogram1.png "histogram1.png")

El `PROC KDE` de SAS está incluido en el módulo `SAS/STAT`. Es un procedimiento que nos permite estudiar gráficamente las distribuciones de variables continuas. Lo que nos produce son gráficos de densidades. 

Para seguir el ejemplo, nos vamos a ir a [Yahoo Finance](http://es.finance.yahoo.com/q/hp?s=%5EIBEX) y descargarnos un evolutivo del IBEX de los últimos tres meses (yo realizo este proceso con `Excel`). Una vez tengamos el *dataset* creado, para el análisis de la densidad univariante podemos hacer:

```sas
ods graphics on;

title "Análisis de volumen";
proc kde data=ibex;
    univar volumen / plots=(density densityoverlay histdensity histogram);
run;

title;
ods graphics off;
```

`KDE` es uno de los procedimientos que trabajan con gráficos de `ODS`. Ya hemos hecho mención al cambio de filosofía de algunos procedimientos gráficos en SAS. Yo me atrevería a decir que los procedimientos clásicos tienen una curva de aprendizaje muy complicada, pero los procedimientos de `ODS` empiezan a crear gráficos más que interesantes con una sintaxis más sencilla. Para los análisis univariantes, yo prefiero el `PROC SGPLOT`. Pero si en algo destaca `KDE` es en los gráficos de densidades bivariables. Ejecutemos:

```sas
ods graphics on;

title "Análisis de volumen X cierre en IBEX35";
proc kde data=ibex;
    bivar cierre_ajustado volumen / plots=(contour contourscatter histogram histsurface scatter surface);
run;

title;
ods graphics off;
```

Y obtenemos resultados visuales potentes. Destacan muy por encima de todos `surface` y `contour`. Imprescindibles en vuestros informes. Por cierto, vemos que hay dos picos bien diferenciados: uno con valores altos del IBEX y otro con valores bajos. El pico en torno a los 9.000 puntos es más alto que el pico de los 11.000; cuánto especulador hay suelto. Saludos.