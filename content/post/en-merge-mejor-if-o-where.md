---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2009-08-11'
lastmod: '2025-07-13'
related:
  - laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
  - proc-sql-merge-set.md
  - truco-sas-cruce-con-formatos.md
  - trucos-sas-porque-hay-que-usar-objetos-hash.md
  - curso-de-lenguaje-sas-con-wps-sentencias-condicionales-if-then.md
tags:
  - formación
  - sas
title: En MERGE, ¿mejor IF o WHERE?
url: /blog/en-merge-c2bfmejor-if-o-where/
---

Cuando programo en SAS algún paso `DATA` como unión con `MERGE`, a modo de filtro empleo habitualmente `IF` en vez de `WHERE`. ¿El motivo? Mejor lo vemos con ejemplos. Voy a generar dos *datasets* aleatorios de dos millones de registros cada uno. Tendrán un campo autonumérico y un campo aleatorio que toma valores entre 0 y 1:

```sas
options fullstimer;

data uno;
    do i = 1 to 2000000;
        aleatorio1 = ranuni(9);
        output;
    end;
run;

data dos;
    do i = 1 to 2000000;
        aleatorio2 = ranuni(2);
        output;
    end;
run;
```

Empleamos la opción `FULLSTIMER` de SAS, que nos ofrece unas estadísticas más detalladas de cada ejecución en el *log*; fundamentalmente nos interesa el tiempo real de ejecución. Los *datasets* aleatorios tienen las mismas observaciones y una estructura muy parecida. 

La idea es comparar el uso de `IF` frente a `WHERE` en un `MERGE`. Realizamos uniones horizontales entre ambas tablas y filtraremos sólo las observaciones con un valor del autonumérico `i` par; lo haremos de tres formas posibles y analizaremos el *log*:

```sas
* MÉTODO 1: IF;
data tres;
    merge uno dos;
    by i;
    if mod(i, 2) = 0;
run;

* MÉTODO 2: WHERE COMO INSTRUCCIÓN;
data cuatro;
    merge uno dos;
    by i;
    where mod(i, 2) = 0;
run;

* MÉTODO 3: WHERE COMO OPCIÓN DE LECTURA;
data cinco;
    merge uno (where=(mod(i, 2) = 0))
          dos (where=(mod(i, 2) = 0));
    by i;
run;
```

En la primera ejecución (`tres`), empleamos `IF`; el tiempo real de la ejecución (en mi caso) es de 5,58 s. Para el `WHERE` como instrucción (`cuatro`) es de 11,9 s., y si empleamos `WHERE` como opción de lectura (`cinco`), tenemos un tiempo de 14,41 s. Es evidente que el `IF` tiene un comportamiento más óptimo en este contexto de unificación de tablas.

Por otro lado, si deseamos los pares y que además tengan el valor de la variable `aleatorio1` > 0,5, no podremos emplear en el `MERGE` el `WHERE` global porque esa variable no está en ambos *datasets*:

```sas
* PRODUCE UN ERROR PORQUE ALEATORIO1 NO ESTA EN DOS;
/*
data seis_err;
    merge uno dos;
    by i;
    where mod(i, 2) = 0 and aleatorio1 > 0.5;
run;
*/

* FUNCIONA CORRECTAMENTE CON IF;
data seis;
    merge uno dos;
    by i;
    if mod(i, 2) = 0 and aleatorio1 > 0.5;
run;

* OTRA FORMA ÓPTIMA;
data siete;
    merge uno (where=(aleatorio1 > 0.5)) dos;
    by i;
    if mod(i, 2) = 0;
run;
```

Es evidente que la forma más óptima de realizar esta operación es la utilización del `IF`. Sin embargo, el uso de `IF` puede acarrearnos algún problema de depuración. Veamos el siguiente ejemplo:

```sas
data ocho;
    merge uno dos;
    by i;
    if mod(i, 2) = 0 and aleatorido1 > 0.5; /* Error tipográfico en nombre de variable */
run;
```

Si repasamos rápidamente el *log* de nuestra sesión SAS, el código parece perfecto: no aparece ningún error en rojo. Sin embargo, analizando el *log* más en detalle tenemos: `NOTE: Variable aleatorido1 is uninitialized.`. Si una variable no existe, no tenemos nota roja con `IF` (simplemente se asume como *missing*), mientras que con `WHERE` nos aparecería un error explícito. Es un inconveniente mínimo, pero que en muchas líneas de código puede resultar peligroso.

Por supuesto, si tenéis alguna duda o sugerencia… `rvaquerizo@analisisydecision.es`. Saludos.