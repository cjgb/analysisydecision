---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2009-08-11T02:48:57-05:00'
slug: en-merge-%c2%bfmejor-if-o-where
tags: []
title: En MERGE, ¿mejor IF o WHERE?
url: /en-merge-c2bfmejor-if-o-where/
---

Cuando programo en SAS algún paso data como unión con MERGE a modo de filtro empleo habitualmente IF en vez de WHERE. ¿El motivo? Mejor lo vemos en ejemplos. Voy a generar dos datasets aleatorios de 2 millones de registros cada uno. Tendrán un campo autonumérico y un campo aleatorio que toma valores entre 0 y 1:

```r
options fullstimer;

data uno;

do i = 1 to 2000000;

aleatorio1=ranuni(9);

output;

end;

run;

data dos;

do i = 1 to 2000000;

aleatorio2=ranuni(2);

output;

end;

run;
```

Empleamos la opción _fullstimer_ de SAS que nos ofrece unas estadísticas más detalladas de cada ejecución en el log, fundamentalmente nos interesa el tiempo real de ejecución. Los datasets aleatorios tienen las mismas observaciones y una estructura muy parecida. La idea es comparar el uso de IF frente a WHERE en un MERGE. Realizamos uniones horizontales entre ambas tablas y filtraremos sólo las observaciones con un valor del autonumérico i par, lo haremos de 3 formas pofibles y analizaremos el log:

```r
data tres;

merge uno dos;

by i;

if mod(i,2)=0;

run;

data cuatro;

merge uno dos;

by i;

where mod(i,2)=0;

run;

data cinco;

merge uno (where=(mod(i,2)=0))

dos (where=(mod(i,2)=0));

by i;

run;
```

En la primera ejecución, la que genera el dataset _tres_ , empleamos IF, el tiempo real de la ejecución (en mi caso) es 5,58 s. para el WHERE como instrucción que genera el dataset _cuatro_ es de 11,9 s. y si empleamos WHERE como opción de lectura de los dataset para crear _cinco_ tenemos un tiempo de 14,41 s. Es evidente que el IF tiene un comportamiento más óptimo. Por otro lado si en tu trabajo es necesario «picar» mucho código el IF puede ahorrarnos tiempo. Con estos mismos ejemplos, si deseamos los pares y que además tengan el valor de la variable _aleatorio1_ > 0,5 no podremos emplear en el MERGE el WHERE porque no está en ambos datasets:

```r
*PRODUCE UN ERROR PORQUE ALEATORIO1 NO ESTA EN DOS;

data seis;

merge uno dos;

by i;

where mod(i,2)=0 and aleatorio1>0.5;

run;

data seis;

merge uno dos;

by i;

if mod(i,2)=0 and aleatorio1>0.5;

run;

data siete;

merge uno (where=(aleatorio1>0.5)) dos;

by i;

if mod(i,2)=0;

run;
```

Es evidente que la forma más óptima de realizar esta operación es la utilización el IF. Sin embargo el uso de IF puede acarrearnos algún problema. Veamos el siguiente ejemplo:

```r
data ocho;

merge uno dos;

by i;

if mod(i,2)=0 and aleatorido1>0.5;

run;
```

Si repasamos rápidamente el log de nuestra sesión SAS el código es perfecto, no aparece ningún error en rojo, sin embargo analizando el log más en detalle tenemos «NOTE: Variable aleatorido1 is uninitialized» Si una variable no existe no tenemos nota roja con IF, sin embargo con WHERE nos aparecerá el error. Es un inconveniente mínimo pero que en muchas líneas de código puede resultar peligroso. Por supuesto si tenéis alguna duda o un trabajo que me permita pasar más tiempo con mi familia no dudéis en contactar en [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)

Saludos.