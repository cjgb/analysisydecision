---
author: rvaquerizo
categories:
  - business intelligence
  - formación
  - sas
  - trucos
date: '2011-10-25'
lastmod: '2026-01-26'
related:
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - truco-sas-categorizar-variables-continuas.md
  - trucos-sas-trasponer-con-sql-para-torpes.md
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - macros-sas-agrupando-variables-categoricas.md
tags:
  - array
  - data warehouse
title: Trucos SAS. Operaciones con tablas de dimensiones con SAS
url: /blog/trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas/
---

Algunos llaman a las tablas de dimensiones tablas de lookup, yo me niego. Con SAS ya hemos visto como crear cruces de tablas de dimensiones con tablas de hechos a través de formatos, bajo mi punto de vista el método más eficiente. Pero hoy quería traeros un ejemplo de cruce de tabla pequeña con tabla grande a través de arrays multidimensionales con SAS. Se trata de guardar los valores de la tabla pequeña en un array temporal multidimensional cuando leemos la tabla grande. Para ilustrar esta tarea he preparado un ejemplo:

```sas
data aleatorio;
  do i =1 to 2000;
    grupo = round(1+3*ranuni(4));
    importe=ranuni(34)*grupo*1000;
    output;
  end;
run;
```

```sas
proc summary data=aleatorio nway;
  class grupo;
  output out=medias (keep=grupo importe) mean(importe)=;
quit;
```

Generamos un conjunto de datos SAS aleatorio con una variable `grupo` y una variable `importe`, calculamos la media del importe por grupo y deseamos medir registro a registro la diferencia con respecto a la media del grupo. Para estos casos podemos trabajar con formatos o, por ejemplo, con macro variables:

```sas
data _null_;
  set medias;
  if grupo = 1 then call symput('med1',importe);
  if grupo = 2 then call symput('med2',importe);
  if grupo = 3 then call symput('med3',importe);
  if grupo = 4 then call symput('med4',importe);
run;
```

```sas
data aleatorio;
  set aleatorio;
  if grupo = 1 then dif = importe/&med1.-1;
  if grupo = 2 then dif = importe/&med2.-1;
  if grupo = 3 then dif = importe/&med3.-1;
  if grupo = 4 then dif = importe/&med4.-1;
run;
```

Estoy de acuerdo en que este código se puede hacer más eficiente pero sigue siendo algo engorroso. Bien, hoy quería plantearos otra forma de hacerlo a través de arrays multidimensionales. Planteo el código, lo ejecutáis y comentamos:

```sas
data aleatorio;
  array med(4) _temporary_;
  if _n_ = 1 then do i=1 to 4;
    set medias;
    med(grupo) = importe;
  end;
  set aleatorio;
  dif = importe/med(grupo)-1;
run;
```

Se trata de recorrer nuestra tabla de dimensiones, en este caso la tabla con las medias y meter su contenido en un array temporal que denomino `med`. Posteriormente leo la tabla de hechos y empleo el campo `grupo` para seleccionar el elemento del array que deseo. Es un código sencillo de replicar sobre todo si nuestras variables índices (en este caso la variable `grupo`) son números, en otro caso el código se complica ligeramente pero sigue siendo sencillo de interpretar. Estoy seguro de que este `truco SAS` puede resultaros útil (sobre todo a algún pésimo jugador de golf).

Saludos.
