---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - wps
date: '2011-01-27'
lastmod: '2025-07-13'
related:
  - subconjuntos-de-variables-con-dropkeep.md
  - curso-de-lenguaje-sas-con-wps-sentencias-condicionales-if-then.md
  - curso-de-lenguaje-sas-con-wps-el-paso-data.md
  - curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data.md
  - curso-de-lenguaje-sas-con-wps-ejecuciones.md
tags:
  - drop
  - keep
title: Curso de lenguaje `SAS` con `WPS`. Subconjuntos de variables con `DROP` y `KEEP`
url: /blog/curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep/
---

En esta entrega del curso vamos a trabajar con dos palabras fundamentales en `WPS`: `DROP` y `KEEP`. `DROP` elimina variables de un conjunto de datos y `KEEP` las mantiene. Ahora bien, estos elementos del lenguaje `SAS` se pueden emplear de diversas formas. Pueden ser una sentencia o pueden ser una opción de lectura y escritura del paso `DATA`. Para ilustrar este capítulo vamos a generar un `dataset` con datos aleatorios:

```sas
data aleatorio;

input id importe1 importe2 importe3 importe4 importe5;

cards;

1 894.4 389.1 218.5 488.2 203.2

2 63.6 299.2 323.8 820.7 183.7

3 235.9 716.0 761.7 800.4 706.7

4 425.5 180.6 867.5 665.3 226.1

5 249.9 360.9 91.4 435.2 194.8

6 853.3 566.3 759.0 78.9 559.4

7 738.2 322.1 660.2 55.0 682.4

8 961.4 891.1 680.2 863.4 824.2

9 31.3 610.8 840.7 399.9 878.4

10 359.5 440.8 57.5 562.9 886.1

11 73.5 305.4 277.4 348.4 739.0

12 962.9 609.8 285.9 409.2 89.3

13 691.2 569.2 203.6 345.9 196.1

14 737.5 582.0 691.4 558.0 978.2

15 91.0 263.8 820.7 434.6 709.0

;run;
```

`KEEP`/`DROP` como sentencia:

Una sentencia en `WPS` es una línea de código y en este caso empezará por alguna de nuestras palabras clave. A ellas le acompañarán aquellas variables que deseemos eliminar con `DROP` o que deseemos mantener con `KEEP`:

```sas
data uso_keep;

set aleatorio;

keep id importe1;

run;
```

Creamos un `dataset` `uso_keep` que es resultado de leer `aleatorio`. En este caso `KEEP` “mantiene” las variables `id` e `importe1`. De forma análoga podemos emplear `DROP` como sentencia para eliminar variables:

```sas
data uso_drop;

set aleatorio;

drop importe2 importe3 importe4 importe5;

run;
```

El `dataset` `uso_drop` también es un subconjunto de `aleatorio` y hemos eliminado las variables `importe2` a `importe5`. En este punto es interesante indicaros que podemos realizar listas de variables `SAS` que nos faciliten el uso de `DROP` o `KEEP`. Imaginemos que deseamos eliminar un rango de variables (como en el ejemplo anterior). La lista de variables en `WPS` se genera con guiones de forma `VARIABLE_INICIO – VARIABLE_FIN`:

```sas
data uso_drop2;

set aleatorio;

drop importe2 -- importe5;

run;
```

Otro elemento importante para generar listas de variable son los dos puntos `:` con ellos podremos crear listas de variables en función de un sufijo, si deseamos quedarnos con aquellas variables que empiezan por `IMP` hacemos `imp:` como vemos en el ejemplo:

```sas
data uso_keep2;

set aleatorio;

keep imp:;

run;
```

Seleccionamos todas aquellas variables que empiezan por `imp:`.

`DROP` y `KEEP` como opciones de lectura y escritura:

[Como ya indicamos en una entrega anterior ](https://analisisydecision.es/curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data/) un paso `DATA` es una creación de una estructura de datos y posteriormente un bucle que lee y escribe datos en esa estructura. La fase de lectura y escritura podemos optimizarla empleando `DROP` o `KEEP`. Leer o escribir sólo aquellas variables que deseamos, no es necesario crear estructuras con más variables o leer todas las variables. Veamos los ejemplos:

```sas
data uso_keep3 (keep=id importe1);

set aleatorio;

run;

data uso_drop3 (drop=imp:);

set aleatorio;

run;
```

Estas son opciones de escritura, están dentro de la sentencia `DATA` y entre paréntesis ponemos `DROP` o `KEEP` = variables que deseamos mantener o eliminar. Del mismo modo podemos emplear opciones de lectura:

```sas
data uso_keep4 ;

set aleatorio (keep=id importe1);

run;

data uso_drop4 ;

set aleatorio (drop=imp:);

run;
```

Por supuesto podemos emplear ambas opciones. Siempre es más óptimo emplear `DROP` o `KEEP` como opciones de lectura y escritura. Como sentencia las ejecuciones pueden ser más lentas.En la siguiente entrega vamos a realizar sentencias condicionales en `SAS` con `IF THEN ELSE`. Además veremos como generar más de un conjunto de datos `WPS` en un mismo paso `DATA` con la instrucción `OUTPUT`.