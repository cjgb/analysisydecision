---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2014-05-12'
lastmod: '2025-07-13'
related:
- grafico-de-correlaciones-entre-variables.md
- un-acercamiento-a-graph-primeros-graficos-con-sas.md
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
- truco-sas-proc-contents.md
- macros-sas-informe-de-un-dataset-en-excel.md
tags:
- matriz de correlaciones
- proc corr
title: Truco SAS. Gráfico de correlaciones
url: /blog/truco-sas-grafico-de-correlaciones/
---
Un truco SAS interesante para **representar matrices de correlaciones**. El ejemplo es muy sencillo, pero previamente tenéis que crear el conjunto de datos SAS para ilustrar el ejemplo. Así que lo primero que hay que hacer es ir a [este enlace](http://www.ats.ucla.edu/stat/sas/modules/subset.htm) y copiar el código necesario para crear el conjunto de datos SAS auto. Una vez tenemos ese conjunto de datos de 74 observaciones y 12 variables sólo tenemos que emplear el PROC CORR con una sintaxis muy sencilla:

```r
ods graphics on;

title 'Correlaciones datos Auto';

proc corr data=auto nomiss plots=matrix(histogram);

var price mpg rep78 hdroom trunk weight length turn

displ gratio foreign;

run;

ods graphics off;
```

Como vemos solo hay que hacer ODS GRAPHICS y la opción plot=matrix(histogram) SAS nos presenta un análisis gráfico muy completo de las correlaciones:

[![](/images/2014/05/matriz_correlaciones_sas-300x300.png)](/images/2014/05/matriz_correlaciones_sas.png)

Os recomiendo jugar también con plot=scater para intervalos de confianza elipsoidales. Podréis encontrar literatura y ejemplos en la web. Saludos.