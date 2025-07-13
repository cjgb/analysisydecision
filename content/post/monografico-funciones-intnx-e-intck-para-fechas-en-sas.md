---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2010-07-06T05:45:19-05:00'
lastmod: '2025-07-13T16:02:51.532552'
related:
- trabajo-con-fechas-sas-funciones-fecha.md
- curso-de-lenguaje-sas-con-wps-funciones-fecha.md
- trucos-sas-numero-de-dias-de-un-mes.md
- macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas.md
- trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
slug: monografico-funciones-intnx-e-intck-para-fechas-en-sas
tags:
- funciones fecha en SAS
- INTCK
- INTNX
title: Monográfico. Funciones INTNX e INTCK para fechas en SAS
url: /monografico-funciones-intnx-e-intck-para-fechas-en-sas/
---

Las funciones **INTNX e INTCK de SAS** atraen muchas visitas a esta web. Aunque ya hay algún mensaje en el que muestro como funcionan creo que algunos trabajadores me agradecerán este monográfico. INTNX e INTCK son funciones para trabajar con fechas en SAS. INTNX sirve para trabajar con periodos luego el resultado que ofrece será una fecha e INTCK sirve para trabajar con intervalos, luego el resultado que nos ofrece será un número entero. Esta es la premisa fundamental. Entonces:

  * Si queremos calcular el número de meses entre 01-01-2002 y el 02-04-2003 empleamos INTCK porque el resultado será 3 meses.
  * Si queremos añadir 5 meses al 01-01-2002 empleamos INTNX porque el resultado será una fecha.

Creo que así queda más claro. INTCK nos devuelve un valor entero e INTNX nos devuelve una fecha. Quedando claro esto a ver ejemplos:

Sumamos 2 años a una fecha:

```r
data _null_;
f1="03MAY2005"d;
f2=intnx("year",f1,2);
format f2 ddmmyy10.;
put f2 ;
run;
```
 

**IMPORTANTE** : INTNX en este caso no ha funcionado como cabía esperar. El resultado es 01/01/2007, inicia a 1 de enero siempre. Siempre me gusta empezar con este ejemplo, motivo, para justificar que, en la medida de lo posible, no utilicemos esta función. ¡¡Pues vaya castaña de monográfico!! al contrario, porque os alerto y os justifico los peligros que entraña utilizar estas funciones sin controlarlas bien, cuando se trata de programar en SAS sumar días no es «poco profesional». De todos modos, la sintaxis tipo de INTNX es INTNX(«BASE»,fecha,valor) donde BASE puede ser DAY, WEEK, DTWEEK, MONTH y YEAR:

```r
data _null_;

f1="03MAY2005"d;

f2=intnx("day",f1,20); put f2 ddmmyy10.;

f2=intnx("week",f1,10); put f2 ddmmyy10.;

f2=intnx("month",f1,-3); put f2 ddmmyy10.;

f2=intnx("year",f1,5); put f2 ddmmyy10.;

run;
```

Especial cuidado hemos de tener cuando trabajamos con semanas, meses y años. Ya estáis alertados. Ahora viene la solución al problema, evidentemente esto no podía ser así de poco práctico, la función INTNX tiene otro parámetro más: el ajuste. INTNX(«BASE»,fecha,valor,»AJUSTE») Necesitamos este parámetro para evitar cometer el error habitual:

```r
data _null_;

f1="03MAY2005"d;

f2=intnx("day",f1,20,"same"); put f2 ddmmyy10.;

f2=intnx("week",f1,10,"same"); put f2 ddmmyy10.;

f2=intnx("month",f1,-3,"same"); put f2 ddmmyy10.;

f2=intnx("year",f1,5,"same"); put f2 ddmmyy10.;

run;
```

**IMPORTANTE** : Sin el same hay que tener mucho cuidado a la hora de trabajar con esta función. No utilizar sin _same_ porque podemos encontrarnos con alguna sorpresa. Creo que he encendido la bombilla a muchas visitas.Veamos ahora ejemplos de uso de INTCK:

Calculamos el número de años entre 2 fechas:

```r
data _null_;

f1="03MAY2005"d;

f2="24FEB2008"d;

dif=intck("year",f1,f2);

put dif;

run;
```

Obtenemos una diferencia de 3 años. ¿Es justo esto lo que necesitamos? También podemos considerar que 1027 días de diferencia no son 3 años:

```r
data _null_;

f1="03MAY2005"d;

f2="24FEB2008"d;

dif=floor((f2-f1)/365.25);

put dif;

run;
```

De nuevo alertando sobre el uso de esta función porque puede producir resultados que no nos gusten. La sintaxis es INTCK(«BASE»,fecha de inicio, fecha de fin) Veamos la secuencia de ejemplos:

```r
data _null_;

dif=intck("day","03MAY2005"d,"13MAY2005"d); put dif;

dif=intck("week","03MAY2005"d,"03MAY2006"d); put dif;

dif=intck("month","01JAN2005"d,"03JAN2005"d); put dif;

dif=intck("year","03MAY2005"d,"03MAY2006"d); put dif;

run;
```

Bueno, pues hasta aquí un monográfico que espero ayuden a todas esas visitas que buscan estas dos funciones de SAS. La opinión de alguien harto de picar código SAS, hay que conocerlas, pero siempre que se puedan usar operaciones aritméticas las usaremos. INTCK da menos guerra, INTNX es más delicada pero muy práctica para operar con meses típicos de fechas de partición de tablas. Para utilizarlas siempre nos plantearemos ejemplos y estudiaremos los resultados obtenidos.