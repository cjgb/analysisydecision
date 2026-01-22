---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2014-10-28'
lastmod: '2025-07-13'
related:
  - macros-faciles-de-sas-dias-de-un-mes-en-una-fecha.md
  - trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
  - macros-sas-transformar-un-numerico-a-fecha.md
  - trucos-sas-numero-de-dias-de-un-mes.md
  - trabajo-con-fechas-sas-funciones-fecha.md
tags:
  - proc fcmp
  - sas procs
title: PROC FCMP para crear funciones en SAS
url: /blog/proc-fcmp-para-crear-funciones-en-sas/
---

Unas pinceladas del `PROC FCMP` para `SAS`. Este procedimiento nos permite crear nuestras propias funciones que posteriormente podremos utilizar en nuestras sesiones de `SAS`. yo he programado mucho en `SAS` y tengo que decir que no utilizo mucho este procedimiento por la propia filosofía de `SAS`. Al final siempre se tiende a crear una `macro` antes que una función, pero hay que reconocer que el lenguaje macro de `SAS` en ocasiones no es sencillo y muchos olvidamos el `PROC FCMP`. En mi caso concreto hago unas `macros` muy enrevesadas antes que programarme una función. Para ilustrar el ejemplo de uso vamos a crear una función `dif_anios` para determinar la diferencia en años entre dos fechas `SAS`. El código es:

```sas
proc fcmp outlib=sasuser.fun.pru;
function dif_anios(ini_date, fin_date);
n1 = year(fin_date)-year(ini_date);
if month(fin_date)
```

El `PROC FCMP` guarda las funciones en una librería, en este caso se recomienda guardar en `SASUSER` y es necesario usar un nombre de 3 niveles aunque el resultado final de esta ejecución será un conjunto de datos `SAS` llamado `FUN` creado en la librería `SASUSER` que contiene las instrucciones necesarias para la función. La función necesita dos parámetros `ini` y `fin date`, dentro de ella empleamos código `SAS`, el mismo que si no usáramos la función. Por último retornamos un valor como resultado de nuestra función.

Para poder emplear la función sólo tenemos que hacer:

```sas
options cmplib=sasuser.fun;

  data _null_;
   start = '15Feb2007'd;
   today = '27Mar2008'd;
   sd = dif_anios(start, today);
     put sd=;
  run;
```

Con la opción `cmplib` compilamos rutinas en la librería especificada, ya os digo que lo recomendable es `SASUSER` o bien una librería común en la que se guarden todas las funciones. Una vez hagáis eso ya estáis en disposición de poder utilizar vuestra función. Saludos.
