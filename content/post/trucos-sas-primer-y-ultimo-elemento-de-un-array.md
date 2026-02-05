---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
  - wps
date: '2012-05-21'
lastmod: '2025-07-13'
related:
  - monografico-first-y-last-ejemplos-en-data.md
  - monografico-datos-agrupados-en-sas.md
  - pasando-de-sas-a-r-primer-y-ultimo-elemento-de-un-campo-agrupado-de-un-data-frame.md
  - trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
  - bucle-de-fechas-con-sas-para-tablas-particionadas.md
tags:
  - array
title: Trucos SAS. Primer y último elemento de un array
url: /blog/trucos-sas-primer-y-ultimo-elemento-de-un-array/
---

Breve entrada sobre el uso de `array` en SAS. Dada una tabla SAS como ésta con una variable `mes1`, `mes2`… `mesN`:

![SAS arrays example](/images/2012/05/arrays_sas.PNG)

Necesitamos identificar el primer y el último elemento no nulo de un `array` y el número de elementos no nulos de ese `array`. Veamos el ejemplo:

```sas
data datos;
    input id mes1 mes2 mes3 mes4 mes5 mes6;
    datalines;
1 . . . . . .
2 162.18 88.41 919.62 891.25 837.73 163.14
3 . 790.52 160.03 . 60.31 343.30
4 . . 482.45 755.39 . .
5 265.17 963.53 . . 392.06 .
6 . 214.95 616.17 183.01 778.48 57.42
7 191.52 . 208.50 50.55 705.72 .
8 711.76 . . . 193.20 658.45
9 782.67 172.49 539.42 663.28 4.53 358.51
10 695.12 367.74 . 573.47 366.30 951.98
;
run;
```

Para este proceso creamos un `array` que recorreremos dos veces: una hacia adelante para identificar el primer elemento y otra hacia atrás para identificar el último elemento:

```sas
data datos_procesados;
    set datos;
    array m(*) mes:;

    * PRIMER ELEMENTO;
    primer_idx = 0;
    primero = .;
    do i = 1 to dim(m);
        if m(i) ne . then do;
            primero = m(i);
            primer_idx = i;
            leave;
        end;
    end;

    * ULTIMO ELEMENTO;
    ultimo = .;
    ultimo_idx = 0;
    do i = dim(m) to 1 by -1;
        if m(i) ne . then do;
            ultimo = m(i);
            ultimo_idx = i;
            leave;
        end;
    end;

    * NUMERO DE ELEMENTOS;
    if primer_idx > 0 then num_elementos = ultimo_idx - primer_idx + 1;
    else num_elementos = 0;

    drop i primer_idx ultimo_idx;
run;
```

Como hemos indicado, el `array` se recorre dos veces: la primera vez de forma ascendente para buscar el primer elemento y la segunda de forma descendente para encontrar el último; la diferencia más uno es el número de elementos no nulos que tiene ese `array`. Ejemplo de uso de `array` en SAS. Saludos.