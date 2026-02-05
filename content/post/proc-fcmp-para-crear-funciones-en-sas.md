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

Unas pinceladas del **`PROC FCMP`** para SAS. Este procedimiento nos permite crear nuestras propias funciones que posteriormente podremos utilizar en nuestras sesiones. He programado mucho en SAS y tengo que decir que no utilizo mucho este procedimiento por la propia filosofía de la herramienta: al final siempre se tiende a crear una **macro** antes que una función. Pero hay que reconocer que el lenguaje macro de SAS en ocasiones no es sencillo y muchos olvidamos que existe el `PROC FCMP`.

Para ilustrar un ejemplo de uso, vamos a crear una función `dif_anios` para determinar la diferencia en años entre dos fechas SAS:

```sas
proc fcmp outlib=sasuser.funcs.matem;
    function dif_anios(ini_date, fin_date);
        n1 = year(fin_date) - year(ini_date);
        if month(fin_date) < month(ini_date) or 
           (month(fin_date) = month(ini_date) and day(fin_date) < day(ini_date)) 
        then n1 = n1 - 1;
        return(n1);
    endfunc;
run;
```

El `PROC FCMP` guarda las funciones en una librería; en este caso se recomienda guardar en `SASUSER`. Es necesario usar un nombre de tres niveles (`libreria.tabla.paquete`). El resultado final será un conjunto de datos SAS que contiene las instrucciones de la función. La función necesita dos parámetros (`ini_date` y `fin_date`); dentro de ella empleamos código SAS estándar. Por último, retornamos un valor con `return`.

Para poder emplear la función en nuestra sesión, tenemos que especificar a SAS dónde buscarla:

```sas
options cmplib=sasuser.funcs;

data _null_;
    start = '15FEB2007'd;
    today = '27MAR2008'd;
    sd = dif_anios(start, today);
    put sd=;
run;
```

Con la opción `CMPLIB` indicamos a SAS las librerías que contienen las funciones personalizadas. Lo recomendable es `SASUSER` o una librería común compartida. Una vez hecho ésto, ya estáis en disposición de utilizar vuestra propia función en cualquier paso `DATA`. Saludos.