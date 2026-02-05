---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
date: '2010-07-06'
lastmod: '2025-07-13'
related:
  - trabajo-con-fechas-sas-funciones-fecha.md
  - curso-de-lenguaje-sas-con-wps-funciones-fecha.md
  - trucos-sas-numero-de-dias-de-un-mes.md
  - macros-sas-primer-y-ultimo-dia-del-mes-de-una-fecha-sas.md
  - trucos-sas-operar-con-fechas-yyyymm-tipicas-de-particiones-oracle.md
tags:
  - fechas sas
  - sas
  - intck
  - intnx
title: Monográfico. Funciones INTNX e INTCK para fechas en SAS
url: /blog/monografico-funciones-intnx-e-intck-para-fechas-en-sas/
---

Las funciones `INTNX` e `INTCK` de SAS atraen muchas visitas a esta web. Aunque ya hay algún mensaje en el que muestro cómo funcionan, creo que algunos trabajadores me agradecerán este monográfico.

`INTNX` e `INTCK` son funciones para trabajar con fechas en SAS. `INTNX` sirve para trabajar con **periodos**, por lo que el resultado que ofrece será una **fecha**; e `INTCK` sirve para trabajar con **intervalos**, por lo que el resultado que nos ofrece será un **número entero**. Ésta es la premisa fundamental. Entonces:

- Si queremos calcular el número de meses entre el 01-01-2002 y el 02-04-2003, empleamos `INTCK`, porque el resultado será un número de meses (como por ejemplo 15 meses).
- Si queremos añadir 5 meses al 01-01-2002, empleamos `INTNX`, porque el resultado será una fecha.

Creo que así queda más claro: `INTCK` nos devuelve un valor entero e `INTNX` nos devuelve una fecha. Quedando claro ésto, veamos ejemplos:

### Ejemplos de uso de `INTNX`

Sumamos 2 años a una fecha:

```sas
data _null_;
    f1 = "03MAY2005"d;
    f2 = intnx("year", f1, 2);
    format f2 ddmmyy10.;
    put f2 = ;
run;
```

**IMPORTANTE**: `INTNX` en este caso no ha funcionado como cabía esperar. El resultado es `01/01/2007`; inicia a 1 de enero siempre. Siempre me gusta empezar con este ejemplo para justificar que, en la medida de lo posible, controlemos bien esta función. ¡Vaya "castaña" de monográfico! Al contrario: os alerto y os justifico los peligros que entraña utilizar estas funciones sin controlarlas bien. Cuando se trata de programar en SAS, sumar días directamente no es "poco profesional".

De todos modos, la sintaxis tipo de `INTNX` es `INTNX("BASE", fecha, valor)`, donde `BASE` puede ser `DAY`, `WEEK`, `DTWEEK`, `MONTH`, `QTR` o `YEAR`:

```sas
data _null_;
    f1 = "03MAY2005"d;
    
    f2 = intnx("day", f1, 20);   put "Suma 20 días:   " f2 ddmmyy10.;
    f2 = intnx("week", f1, 10);  put "Suma 10 semanas:" f2 ddmmyy10.;
    f2 = intnx("month", f1, -3); put "Resta 3 meses:  " f2 ddmmyy10.;
    f2 = intnx("year", f1, 5);   put "Suma 5 años:    " f2 ddmmyy10.;
run;
```

Especial cuidado hemos de tener cuando trabajamos con semanas, meses y años. Ya estáis alertados. Ahora viene la solución al problema: la función `INTNX` tiene otro parámetro más: el **ajuste**. `INTNX("BASE", fecha, incremento, "alineación")`. Necesitamos este parámetro para evitar cometer el error habitual:

```sas
data _null_;
    f1 = "03MAY2005"d;
    
    f2 = intnx("day", f1, 20, "same");   put "Día (same):   " f2 ddmmyy10.;
    f2 = intnx("week", f1, 10, "same");  put "Semana (same):" f2 ddmmyy10.;
    f2 = intnx("month", f1, -3, "same"); put "Mes (same):   " f2 ddmmyy10.;
    f2 = intnx("year", f1, 5, "same");   put "Año (same):   " f2 ddmmyy10.;
run;
```

**IMPORTANTE**: Sin el `"same"`, hay que tener mucho cuidado a la hora de trabajar con esta función. No utilizar sin `"same"` (o `"beginning"`, `"middle"`, `"end"`) porque podemos encontrarnos con sorpresas. Creo que he encendido la bombilla a muchas visitas.

### Ejemplos de uso de `INTCK`

Calculamos el número de años entre dos fechas:

```sas
data _null_;
    f1 = "03MAY2005"d;
    f2 = "24FEB2008"d;
    dif = intck("year", f1, f2);
    put "Diferencia años (INTCK): " dif;
run;
```

Obtenemos una diferencia de 3 años (pasa de 2005 a 2008). ¿Es justo ésto lo que necesitamos? También podemos considerar que 1027 días de diferencia no son 3 años completos:

```sas
data _null_;
    f1 = "03MAY2005"d;
    f2 = "24FEB2008"d;
    dif = floor((f2 - f1) / 365.25);
    put "Diferencia años (aritmética): " dif;
run;
```

De nuevo, alertando sobre el uso de esta función porque puede producir resultados que no nos gusten (cuenta cruces de frontera de intervalo). La sintaxis es `INTCK("BASE", fecha_inicio, fecha_fin)`. Veamos la secuencia de ejemplos:

```sas
data _null_;
    dif = intck("day", "03MAY2005"d, "13MAY2005"d);   put "Días:   " dif;
    dif = intck("week", "03MAY2005"d, "03MAY2006"d);  put "Semanas:" dif;
    dif = intck("month", "01JAN2005"d, "03JAN2005"d); put "Meses:  " dif;
    dif = intck("year", "03MAY2005"d, "03MAY2006"d);  put "Años:   " dif;
run;
```

Bueno, pues hasta aquí un monográfico que espero ayude a todas esas visitas que buscan estas dos funciones de SAS. Mi opinión: hay que conocerlas, pero siempre que se puedan usar operaciones aritméticas, las usaremos. `INTCK` da menos guerra; `INTNX` es más delicada pero muy práctica para operar con meses típicos de fechas de partición de tablas. Para utilizarlas, siempre nos plantearemos ejemplos y estudiaremos los resultados obtenidos. Saludos.