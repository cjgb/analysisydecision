---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2010-04-02T14:27:51-05:00'
slug: un-acercamiento-a-graph-sentencias-graficas
tags:
- graficos SAS
- GRAPH
title: Un acercamiento a GRAPH. Sentencias gráficas
url: /un-acercamiento-a-graph-sentencias-graficas/
---

A la hora de trabajar con SAS/GRAPH lo primero que vamos a escribir es:

Después tenemos que conocer las sentencias de GRAPH para dar forma a nuestros gráficos. Estas sentencias no van dentro de ningún procedimiento ni paso data, siempre van precedidas de distintas palabras clave que nos definen los elementos de un grafico o nos indican las opciones necesarias para su representación. Estas sentencias nos permitirán definir los ejes, patrones y opciones más globales, comenzaran por:

AXIS  
GOPTIONS  
LEGEND  
PATTERN  
SYMBOL  
TITLE, FOOTNOTE y NOTE

En la ayuda y en el support de SAS tendréis mas información sobre ellas. Pero, como es habitual, en estas líneas vais a ver algunos ejemplos con la sintaxis más común. El dataset inicial con datos aleatorios contiene datos de altura, peso y sexo y se genera mediante el siguiente código:

```r
data uno;

do i=1 to 300;

altura=10*rannor(5)+172+(ranuni(7)*10);

peso=(6*rannor(5)+27)*((altura/100)**2);

sexo=put((ranuni(7)<=0.6)+1,z2.);

output;

end;

run;
```

AXIS nos permite definir el eje y se usa en todos aquellos procedimientos que tienen un grafico de ejes:

```r
goptions reset=all;

axis value=(t=1 'Mujer' t=2 'Hombre')

length=90 offset=(20,20);

proc gplot data=uno;

plot altura*sexo/haxis=axis1;

run;quit;
```

Siempre reseteamos las opciones graficas. En este caso etiquetamos los valores con VALUE=(t1= tn=). Con LENGTH damos longitud al eje y offset nos permite ajustar la posición de los valores, dejamos 20 unidades por un lado y por el otro. El grafico resultante no parece ser muy representativo. Vamos a trabajar con SYMBOL para analizar las distribución de la altura por el sexo:

```r
goptions reset=all;

axis value=(t=1 'Mujer' t=2 'Hombre')

length=90 offset=(20,20);

symbol interpol=boxt co=red bwidth=25;

proc gplot data=uno;

plot altura*sexo/haxis=axis1;

run;quit;
```

En la sentencia SYMBOL podemos mejorar la apariencia de nuestros gráficos. Podemos poner líneas, símbolos, escalones,… aconsejo el estudio de la ayuda de SAS para ver que es lo que mejor se adecua a nuestras necesidades. En este caso empleamos BOXT que nos realiza un grafico de cajas. En CO damos el color de las líneas y con BWIDTH damos el acho a las cajas. De momento desconocemos que unidad de medida empleamos para dar tamaños. Con GOPTIONS la podemos especificar:

```r
goptions reset=all;

axis value=(t=1 'Mujer' t=2 'Hombre')

length=80 offset=(20,20);

symbol interpol=boxt co=red bwidth=25;

goptions gunit=pct

htitle=4.0 htext=2.5

device=win target=winprtg

ftext=swiss

cback=grey ;

title 'Estudio de la altura';

proc gplot data=uno;

plot altura*sexo/haxis=axis1;

run;quit;

title;
```

En GOPTIONS especificamos la unidad con la que trabajamos nuestro grafico, en el caso ce GUNIT=pct el porcentaje total del grafico. En HTITLE damos tamaño al titulo y en HTEXT al texto. Después ponemos dos opciones que le indican al sistema que trabajamos en Windows, tened en cuenta esto para dar un tamaño adecuado a las representaciones. En FTEXT especificamos la familia de fuentes y CBACK da color al fondo. Poco a poco damos mas funcionalidades y nuestros gráficos toman mejor aspecto, aunque en el caso que nos ocupa no sea un grafico muy profesional precisamente. Dejamos LEGEND y PATTERN para siguientes mensajes porque me interesa de crear algún programa más complejo que os sirva de referencia para el uso de PATTERN fundamentalmente. Ya os digo que paso de puntillas por la mayoría de las posibilidades de SAS pero me gustaría que se perdiera el miedo a usar su motor de gráficos. Es cierto que el motor de R es mejor y que Excel es más sencillo. También tendréis ejemplos. Saludos.