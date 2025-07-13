---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2010-03-30T03:56:59-05:00'
lastmod: '2025-07-13T16:10:49.195510'
related:
- un-acercamiento-a-graph-proc-gchart.md
- un-acercamiento-a-graph-sentencias-graficas.md
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
- un-acercamiento-a-graph-proc-ganno.md
- graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
slug: un-acercamiento-a-graph-primeros-graficos-con-sas
tags:
- ''
- graficos SAS
- GRAPH
title: Un acercamiento a GRAPH. Primeros gráficos con SAS
url: /un-acercamiento-a-graph-primeros-graficos-con-sas/
---

SAS es muy caro y tiene muchas limitaciones. Aunque puedas enchufarle gigas y gigas de datos tiene importantes lagunas y una de ellas es su motor gráfico. Por ello quiero dedicarle una serie de monográficos de acercamiento e intentar analizar las (pocas) posibilidades graficas de SAS. Los monográficos van a ser un poco inconexos y orientados a personas con algo de nivel de programación. Nos centraremos en el modulo GRAPH. Antes de empezar quiero recomendaros una web donde podréis ver mejor todas las posibilidades que nos ofrece SAS a la hora de graficar: <http://robslink.com/SAS/Home.htm> Esto si que es contenido y no lo que aporta esta web. Para comenzar esta serie vamos a trabajar con los procedimientos GCHART, GPLOT y GREPLAY. Como es habitual el primer paso es generar un _dataset_ con datos mas o menos aleatorios:  

```r
data datos;

do i=1 to 100;

normal=rannor(4);

exponencial=ranexp(5);

seno=sin(i);

coseno=cos(i);

poisson=ranpoi(40,3);

output;end;

un;
```

La idea es realizar 4 gráficos: 2 diagramas de barras para las variables normal y exponencial. Un gráfico de tarta en 3d para la variable poisson y un gráfico de líneas donde veamos el seno y el coseno juntos. Veamos el procedimiento para realizar los diagramas de barras y el grafico de tarta:

```r
proc gchart data=datos;

hbar normal/name='normal';

vbar exponencial/name='exp' midpoints=0 to 4 by 0.2;

pie3d poisson/name='poisson';

run; quit;
```

Empezamos a conocer las rarezas de GRAPH. Siempre hemos de terminar con **run;quit;** Con HBAR realizamos un grafico de barras horizontales, nos incluye una tabla de frecuencias, con NAME=’nombre’ asignamos un nombre al gráfico que por defecto se almacena en el catálogo Gseg de work, los nombres nunca podrán exceder de 8 caracteres. VBAR hace el habitual histograma, con midponits podemos especificar los puntos que tendrá nuestro grafico. PIE y PIE3D nos permiten hacer gráficos de tarta bastante espartanos. Para realizar gráficos de dispersión o de líneas emplearemos el PROC GPLOT:

```r
symbol i=join;

proc gplot data=datos;

plot seno*i/overlay name='sencos';

plot2 coseno*i/overlay;

run;quit;
```

En este ejemplo comenzamos a trabajar con las opciones gráficas. SYMBOL nos permite especificar el formato de los puntos de un gráfico de dispersion, con i=JOIN indicamos que deseamos unir esos puntos con una línea. GPLOT requiere la sentencia PLOT y*x, con OVERLAY le hacemos que el grafico será superpuesto, para ello el _eje x será el mismo_ en los dos gráficos, empleamos NAME para asignar un nombre al gráfico generado. Ahora estos 4 gráficos que hemos creado tenemos que juntarlos en uno solo. El PROC GREPLAY nos permite realizar esta tarea:

```r
proc greplay igout=work.gseg tc=sashelp.templt template=L2r2 NOFS ;

treplay 1:normal 2:exp 3:poisson 4:sencos;

run; quit;
```

Este procedimiento necesita que le indiquemos donde guardamos el grafico resultante en IGOUT=, tambien ponemos la librería de templares con TC= y el template a emplear con TEMPLATE= en este caso son 4 gráficos luego será 2×2. Con NOFS nos evitamos que nos salga la ventana del PROC GREPLAY. Ejecutadlo sin esta opción y entenderéis mejor.

Un rápido acercamiento a GRAPH de SAS. En sucesivas entregas iremos complicando la cosa.