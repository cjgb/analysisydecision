---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2010-03-30'
lastmod: '2025-07-13'
related:
  - un-acercamiento-a-graph-proc-gchart.md
  - un-acercamiento-a-graph-sentencias-graficas.md
  - un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
  - un-acercamiento-a-graph-proc-ganno.md
  - graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
tags:
  - gráficos
  - sas
  - graph
title: Un acercamiento a GRAPH. Primeros gráficos con SAS
url: /blog/un-acercamiento-a-graph-primeros-graficos-con-sas/
---

SAS tiene muchas limitaciones en su motor gráfico. Por ello, quiero dedicarle una serie de monográficos de acercamiento e intentar analizar las (pocas) posibilidades gráficas de SAS. Los monográficos van a estar orientados a personas con algo de nivel de programación. Nos centraremos en el módulo `GRAPH`. Antes de empezar, quiero recomendaros una web donde podréis ver mejor todas las posibilidades que nos ofrece SAS a la hora de graficar: [http://robslink.com/SAS/Home.htm](http://robslink.com/SAS/Home.htm). 

Para comenzar esta serie, vamos a trabajar con los procedimientos `GCHART`, `GPLOT` y `GREPLAY`. Como es habitual, el primer paso es generar un *dataset* con datos aleatorios:

```sas
data datos;
    do i = 1 to 100;
        normal = rannor(4);
        exponencial = ranexp(5);
        seno = sin(i);
        coseno = cos(i);
        poisson = ranpoi(40, 3);
        output;
    end;
run;
```

La idea es realizar cuatro gráficos: dos diagramas de barras para las variables `normal` y `exponencial`, un gráfico de tarta en 3D para la variable `poisson` y un gráfico de líneas donde veamos el `seno` y el `coseno` juntos. Veamos el procedimiento para realizar los diagramas de barras y el gráfico de tarta:

```sas
proc gchart data=datos;
    hbar normal / name='normal';
    vbar exponencial / name='exp' midpoints=0 to 4 by 0.2;
    pie3d poisson / name='poisson';
run;
quit;
```

Empezamos a conocer las rarezas de `GRAPH`. Siempre hemos de terminar con `run; quit;`. Con `HBAR` realizamos un gráfico de barras horizontales; nos incluye una tabla de frecuencias. Con `NAME='nombre'` asignamos un nombre al gráfico, que por defecto se almacena en el catálogo `work.gseg`; los nombres nunca podrán exceder de ocho caracteres. `VBAR` hace el habitual histograma; con `midpoints` podemos especificar los puntos que tendrá nuestro gráfico. `PIE` y `PIE3D` nos permiten hacer gráficos de tarta.

Para realizar gráficos de dispersión o de líneas, emplearemos el `PROC GPLOT`:

```sas
symbol i=join;
proc gplot data=datos;
    plot seno*i / overlay name='sencos';
    plot2 coseno*i / overlay;
run;
quit;
```

En este ejemplo comenzamos a trabajar con las opciones gráficas. `SYMBOL` nos permite especificar el formato de los puntos; con `i=join` indicamos que deseamos unir esos puntos con una línea. `GPLOT` requiere la sentencia `PLOT y*x`; con `OVERLAY` hacemos que el gráfico sea superpuesto (el eje $X$ será el mismo en los dos gráficos).

Ahora estos cuatro gráficos que hemos creado tenemos que juntarlos en uno solo. El `PROC GREPLAY` nos permite realizar esta tarea:

```sas
proc greplay igout=work.gseg tc=sashelp.templt template=L2R2 nofs;
    treplay 1:normal 2:exp 3:poisson 4:sencos;
run;
quit;
```

Este procedimiento necesita que le indiquemos dónde guardamos el gráfico resultante en `IGOUT=`; también ponemos la librería de *templates* con `TC=` y el *template* a emplear con `TEMPLATE=` (en este caso son cuatro gráficos, luego será `L2R2`, es decir, 2x2). Con `NOFS` nos evitamos que nos salga la ventana interactiva del `PROC GREPLAY`.

Un rápido acercamiento a `GRAPH` de SAS. En sucesivas entregas iremos complicando la cosa. Saludos.