---
author: rvaquerizo
categories:
  - business intelligence
  - sas
  - trucos
date: '2016-12-20'
lastmod: '2025-07-13'
related:
  - trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
  - macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas.md
  - trucos-sas-numero-de-dias-de-un-mes.md
  - macros-sas-transformar-un-numerico-a-fecha.md
  - trabajo-con-fechas-sas-funciones-fecha.md
tags:
  - fechas sas
title: Bucle de fechas con SAS para tablas particionadas
url: /blog/bucle-de-fechas-con-sas-para-tablas-particionadas/
---

Partimos de un mes inicial hasta un mes final es necesario crear una tabla `SAS` con dos variables, el inicio del mes y el final del mes. Trabajo con fechas en `SAS` que todos sabemos es una tarea un «poco ardua». El título de la entrada también es un poco peculiar pero es la respuesta a la duda que planteaba un lector:

```text
Cogemos dos fechas en formato `yyyymmaa`
Ej: `20150101` a `2016131`

Necesito una salida como la siguiente
`20150101 20150131`
`20150201 20150228`
`20150301 20150331`
`20150401 20150430`
.

`20161101 20161130`
`20161201 20161231`

Pero para que los datos pedidos en este periodo salgan en una tabla por mes con un `proc sql` ya diseñado que funciona pero sin particionarlo en una tabla por mes en el log
```

Se me han ocurrido varias formas de hacerlo pero a continuación os planteo la siguiente. [Como referencia hemos de irnos a una entrada anterior del blog](https://analisisydecision.es/macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas/), una entrada del 2008 cuando puse en marcha analisisydecision.es

```sas
\*IDENTIFICA EL ULTIMO DIA DE UN MES;
\*IDENTIFICA EL ULTIMO DIA DE UN MES;
%macro `finmes`(fec);
`intnx("month",&fec.,1)-1`
%mend;

`data bucle` ;
`do i=201501 to 201612`;
`if mod(i,100)=13 then i = i + 88`;
`inicio = i * 100 + 1`;
\*PRIMERO TRANSFORMAMOS EN FECHA SAS;
`fin = mdy(mod(i,100),1,int(i/100))`;
\*DESPUES OBTENEMOS EL ULTIMO DIA DEL MES;
`fin = %finmes(fin)`;
\*POR ULTIMO LO TRANSFORMAMOS A NUMERICO;
`fin = year(fin)*10000+month(fin)*100+day(fin)`;
`output`;
`end`;`run`;
```

Lo he hecho de una forma sencilla, se trata de un `bucle DO` desde el mes inicial a el mes final, en realidad son unos 90 números sin embargo si el `módulo` del número, el mes, está entre 1 y 12 entonces identifica el primer día del mes e identifica el último día del mes transformando el número a fecha `SAS` primero, obteniendo el último día después y por último lo transforma del modo más sencillo a un número que pueda entender la partición. Es un bucle `SAS` susceptible de ser parametrizado. Saludos.
