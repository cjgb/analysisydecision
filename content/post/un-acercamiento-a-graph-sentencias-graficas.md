---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
date: '2010-04-02'
lastmod: '2025-07-13'
related:
  - un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
  - un-acercamiento-a-graph-proc-gchart.md
  - un-acercamiento-a-graph-primeros-graficos-con-sas.md
  - un-acercamiento-a-graph-proc-ganno.md
  - un-acercamiento-a-graph-annotate-macros.md
tags:
  - gráficos
  - sas
  - graph
title: Un acercamiento a `GRAPH`. Sentencias gráficas
url: /blog/un-acercamiento-a-graph-sentencias-graficas/
---

A la hora de trabajar con `SAS/GRAPH`, lo primero que vamos a escribir es:

Después tenemos que conocer las sentencias de `GRAPH` para dar forma a nuestros gráficos. Estas sentencias no van dentro de ningún procedimiento ni paso `DATA`, siempre van precedidas de distintas palabras clave que nos definen los elementos de un gráfico o nos indican las opciones necesarias para su representación. Estas sentencias nos permitirán definir los ejes, patrones y opciones más globales; comenzarán por:

- `AXIS`
- `GOPTIONS`
- `LEGEND`
- `PATTERN`
- `SYMBOL`
- `TITLE`, `FOOTNOTE` y `NOTE`

In la ayuda y en el soporte de `SAS` tendréis más información sobre ellas. Pero, como es habitual, en estas líneas vais a ver algunos ejemplos con la sintaxis más común. El *dataset* inicial con datos aleatorios contiene datos de altura, peso y sexo, y se genera mediante el siguiente código:

```sas
data uno;
  do i = 1 to 300;
    altura = 10 * rannor(5) + 172 + (ranuni(7) * 10);
    peso = (6 * rannor(5) + 27) * ((altura / 100)**2);
    sexo = put((ranuni(7) <= 0.6) + 1, z2.);
    output;
  end;
run;
```

`AXIS` nos permite definir el eje y se usa in todos aquellos procedimientos que tienen un gráfico de ejes:

```sas
goptions reset=all;

axis1 value=(t=1 'Mujer' t=2 'Hombre')
      length=90 offset=(20,20);

proc gplot data=uno;
  plot altura*sexo / haxis=axis1;
run;
quit;
```

Siempre reseteamos las opciones gráficas. In este caso, etiquetamos los valores con `VALUE=(t=1 'Mujer' t=2 'Hombre')`. Con `LENGTH` damos longitud al eje y `OFFSET` nos permite ajustar la posición de los valores (dejamos 20 unidades por un lado y por el otro). El gráfico resultante no parece ser muy representativo. Vamos a trabajar con `SYMBOL` para analizar la distribución de la altura por el sexo:

```sas
goptions reset=all;

axis1 value=(t=1 'Mujer' t=2 'Hombre')
      length=90 offset=(20,20);

symbol1 interpol=boxt co=red bwidth=25;

proc gplot data=uno;
  plot altura*sexo / haxis=axis1;
run;
quit;
```

In la sentencia `SYMBOL` podemos mejorar la apariencia de nuestros gráficos. Podemos poner líneas, símbolos, escalones… aconsejo el estudio de la ayuda de `SAS` para ver qué es lo que mejor se adecua a nuestras necesidades. In este caso empleamos `BOXT`, que nos realiza un gráfico de cajas. In `CO` damos el color de las líneas y con `BWIDTH` damos el ancho a las cajas. De momento desconocemos qué unidad de medida empleamos para dar tamaños. Con `GOPTIONS` la podemos especificar:

```sas
goptions reset=all;

axis1 value=(t=1 'Mujer' t=2 'Hombre')
      length=80 offset=(20,20);

symbol1 interpol=boxt co=red bwidth=25;

goptions gunit=pct
         htitle=4.0 htext=2.5
         device=win target=winprtg
         ftext=swiss
         cback=grey;

title 'Estudio de la altura';

proc gplot data=uno;
  plot altura*sexo / haxis=axis1;
run;
quit;

title;
```

In `GOPTIONS` especificamos la unidad con la que trabajamos nuestro gráfico (in el caso de `GUNIT=pct`, el porcentaje total del gráfico). In `HTITLE` damos tamaño al título y in `HTEXT` al texto. Después ponemos dos opciones que le indican al sistema que trabajamos in Windows; tened in cuenta esto para dar un tamaño adecuado a las representaciones. In `ftext=swiss` especificamos la familia de fuentes y `cback=grey` da color al fondo. Poco a poco damos más funcionalidades y nuestros gráficos toman mejor aspecto, aunque en el caso que nos ocupa no sea un gráfico muy profesional precisamente. De dejamos `LEGEND` y `PATTERN` para siguientes mensajes porque me interesa crear algún programa más complejo que os sirva de referencia para el uso de `PATTERN`, fundamentalmente. Ya os digo que paso de puntillas por la mayoría de las posibilidades de `SAS`, pero me gustaría que se perdiera el miedo a usar su motor de gráficos. Es cierto que el motor de `R` es mejor y que `Excel` es más sencillo. También tendréis ejemplos. Saludos.