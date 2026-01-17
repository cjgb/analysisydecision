---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2010-04-07T15:40:40-05:00'
lastmod: '2025-07-13T16:10:50.709366'
related:
- un-acercamiento-a-graph-annotate-macros.md
- un-acercamiento-a-graph-sentencias-graficas.md
- un-acercamiento-a-graph-primeros-graficos-con-sas.md
- un-acercamiento-a-graph-proc-gchart.md
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
slug: un-acercamiento-a-graph-proc-ganno
tags:
- ''
- ANNOTATE
- GRAPH
- PROC GANNO
title: Un acercamiento a GRAPH. PROC GANNO
url: /blog/un-acercamiento-a-graph-proc-ganno/
---

Uso del PROC GANNO de SAS:

El procedimiento SAS GANNO crea gráficos a partir de conjuntos de datos SAS ANNOTATE. Estos conjuntos de datos SAS ANNOTATE recogen las distintas formas o cuadros de texto que tu quieres representar. Estos conjuntos de datos han de tener unas variables que son las que recogen las formas a pintar, imprescindibles son:

```r
length function style color 8 text 25;

retain hsys xsys ysys '3';
```

  * FUNCTION: En esta variable recogemos la forma a pintar o la acción a realizar.
  * STYLE: fuente del texto.
  * COLOR: color de la forma o el texto.
  * TEXT: texto.
  * HSYS XSYS YSYS: Son variables del sistema donde indicas el área donde dibujas.

Con estas variables hemos de formar el ANNOTATE que será el que posteriormente nos sacará en la ventana gráfica el proc ganno.Veamos un ejemplo de annotate:

```r
goptions reset=global

cback='red'

colors=(blcack);

data dibujo;

length function style color 8 text 25;

retain hsys xsys ysys '3';

*LINEA VERTICAL IZQUIERDA;

function='move';x=33;y=33;output;

function='draw';x=33;y=67;color='black';output;

*LINEA SUPERIOR;

function='move';x=67;y=67;output;

function='draw';x=33;y=67;color='black';output;

*LINEA DERECHA;

function='move';x=67;y=67;output;

function='draw';x=67;y=33;color='black';output;

*LINEA INFERIOR;

function='move';x=33;y=33;output;

function='draw';x=67;y=33;color='black';output;

proc ganno anno=dibujo;

run;quit;
```

Ejecutando este código en SAS obtenemos un cuadrado. En GOPTIONS especificamos las opciones gráficas, en este caso combinación de colores en negro y fondo rojo. Posteriormente creamos el ANNOTATE. Como se puede ver empleamos las funciones move y draw con coordenadas x e y, estas coordenadas son el resultado de dividir la cuadrícula del dibujo en 100 partes, así pues trabajamos con porcentajes. Con move nos movemos a lo largo de la cuadrícula del dibujo y con draw dibujamos una línea desde el punto donde nos ubicamos con move hasta el punto que indicamos con las coordenadas de draw. Para pintar la línea izquierda: move (33%,33%) y draw (33%,67%). SAS traza una línea desde el punto (33,33) al (33,67). Hay que observar que siempre indicamos con output la salida de cada línea y movimiento.

Si queremos añadir texto al dibujo hemos de emplear function=’text’ que en combinación con la función move nos puede servir para ver las coordenadas del dibujo:

```r
goptions reset=global

cback='blue'

colors=(blcack);

data dibujo;

length function style color 8 text 25;

retain hsys xsys ysys '3';

function='move';x=33;y=33;output;

function='text';text="(33,33)";output;

function='move';x=33;y=67;output;

function='text';text="(33,67)";output;

function='move';x=67;y=33;output;

function='text';text="(67,33)";output;

function='move';x=67;y=67;output;

function='text';text="(67,67)";output;

proc ganno anno=dibujo;

run;quit;
```

Tenemos 4 cuadros de texto que contienen las coordenadas de los puntos indicados. Podemos combinarlo con la función draw y hacer un dibujo:

```r
data dibujo;

length function style color 8 text 25;

retain hsys xsys ysys '3';

function='move';x=33;y=33;output;

function='text';text="(33,33)";output;

function='draw';x=33;y=67;output;

function='move';x=33;y=67;output;

function='text';text="(33,67)";output;

function='draw';x=67;y=67;output;

function='move';x=67;y=33;output;

function='text';text="(67,33)";output;

function='draw';x=33;y=33;output;

function='move';x=67;y=67;output;

function='text';text="(67,67)";output;

function='draw';x=67;y=33;output;

proc ganno anno=dibujo;

run;quit;
```

Observamos que las líneas se solapan con los textos, deberíamos mover los textos o lo que es lo mismo añadir de nuevo otra instrucción con la función move. Pero tendríamos un programa con mucho código. Podemos ahorrar código empleando las macrovariables de SAS/GRAPH para los ANNOTATE:

```r
%annomac;

data dibujo;

length function style color 8 text 25;

retain hsys xsys ysys '3';

%move(35,32);function='text';text="(33,33)";output;

%move(33,33);function='draw';x=33;y=67;output;

%move(35,69);function='text';text="(33,67)";output;

%move(33,67);function='draw';x=67;y=67;output;

%move(69,32);function='text';text="(67,33)";output;

%move(67,33);function='draw';x=33;y=33;output;

%move(69,69);function='text';text="(67,67)";output;

%move(67,67);function='draw';x=67;y=33;output;

run;
```

Ejecutando la macro annomac ya tenemos disponibles todas estas macrovariables, en este caso empleamos %move. Las macrovariables de ANNOTATE son muchas más, imaginemos que queremos un cuadrado metido en un círculo:

```r
data dibujo;

length function style color 8 text 25;

retain hsys xsys ysys '3';

%move(50,50);

%circle(50,50,50);

%rect(50-sqrt((50**2)/2),50-sqrt((50**2)/2),50+sqrt((50**2)/2),50+sqrt((50**2)/2), black,1,1);

run;
```

En este caso no nos ha salido lo que queríamos porque el tamaño del dibujo no es cuadrado y el eje y es mayor que el eje x, esto se puede solucionar con goptions:

```r
goptions reset=global

cback='blue'

colors=(blcack)

device=gif

xpixels=500 ypixels=500;

data dibujo;

length function style color 8 text 25;

retain hsys xsys ysys '3';

%move(50,50);

%circle(50,50,50);

%rect(50-sqrt((50**2)/2),50-sqrt((50**2)/2),50+sqrt((50**2)/2),50+sqrt((50**2)/2), black,1,1);

run;

proc ganno anno=dibujo;

run;quit;
```

En la parte device de goptions hemos indicado gif de este modo podemos crear archivos gif y en xzpixels ypixels hemos indicado que queremos que sea cuadrado. Podemos especificar a SAS que nos ponga el gif creado en un archivo externo:

```r
filename a "C:\prueba.gif";

goptions reset=global

cback='blue'

colors=(blcack)

device=gif

gsfname=a

xpixels=500 ypixels=500;
```

Si queremos ver todos los device que tiene SAS:

```r
proc gdevice nofs c=sashelp.devices;

list _all_;

run;

quit;
```

Vamos aprendiendo poco a poco a manejar el motor gráfico de SAS. Como siempre, dudas, sugerencias, proyecto en Madrid,.. rvaquerizo@analisisydecision.es