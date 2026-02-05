---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-06-15'
lastmod: '2025-07-13'
related:
  - muestreo-de-datos-con-r.md
  - trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento.md
  - truco-sas-categorizar-variables-continuas.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - las-cuentas-claras.md
tags:
  - muestreo con sas
  - proc surveyselect
  - sas procs
title: Trucos SAS. Muestreo con PROC SURVEYSELECT
url: /blog/trucos-sas-muestreo-con-proc-surveyselect/
---

Hace varios días planteamos algún truco SAS para la realización de muestras aleatorias. Hoy planteo otro truco para lo mismo, pero empleando el procedimiento `PROC SURVEYSELECT`. Este procedimiento lo tenemos en el módulo `STAT` y tiene una sintaxis muy sencilla. Además, nos permite realizar [muestreos estratificados](http://www.bioestadistica.uma.es/libro/node89.htm) de forma muy sencilla; mediante pasos `DATA`, el muestreo estratificado se complica. Como es habitual, vemos varios ejemplos partiendo de una tabla SAS aleatoria:

```sas
data ejemplo;
    do id = 1 to 10000;
        oficina = ranpoi(5, 1);
        oficina = min(oficina, 3);
        importe = ranuni(8) * 1000;
        output;
    end;
run;

proc freq data=ejemplo;
    tables oficina;
run;
```

Tenemos un *dataset* con 10.000 observaciones que tiene un `id`, un `importe` y una `oficina`. El primer paso es crear una muestra aleatoria simple de tamaño 300; las sentencias adecuadas con el `PROC SURVEYSELECT` son:

```sas
* MUESTRA ALEATORIA SIMPLE;
proc surveyselect data=ejemplo
    out=work.aleat1 method=srs n=300;
run;
```

Vemos que en `METHOD` especificamos qué tipo de muestreo deseamos: `SRS`. Si deseamos muestreo aleatorio simple con reemplazamiento, el código a ejecutar sería:

```sas
* MUESTRA ALEATORIA CON REEMPLAZAMIENTO;
proc surveyselect data=ejemplo
    out=work.aleat2 method=urs n=300
    outhits;
run;
```

El método es `URS`; indicamos con `OUTHITS` que cree una variable en el *dataset* de salida que nos indique el número de veces que aparece esa observación en la muestra, interesante opción para asignar pesos. Por otro lado, si necesitamos realizar un muestreo estratificado por alguna variable discreta, tenemos que emplear el siguiente código:

```sas
* MUESTREO ESTRATIFICADO ALEATORIO SIMPLE SIN REEMPLAZAMIENTO;
proc sort data=work.ejemplo out=aleat3_prep;
    by oficina;
run;

proc surveyselect data=aleat3_prep
    out=work.aleat3 method=srs n=50;
    strata oficina;
run;
```

Realizamos una ordenación previa por la variable que hace de estrato, indicamos el método y, en el número de observaciones, ponemos el número que deseamos por estrato; con esto tendremos nº estratos * $N$ observaciones en el *dataset* de salida. Para indicarle cuál es la variable por la que se realiza el muestreo estratificado, tenemos la instrucción `STRATA`.

Si deseamos muestreo estratificado con reemplazamiento, podemos hacer:

```sas
* MUESTREO ESTRATIFICADO CON REEMPLAZAMIENTO;
proc sort data=work.ejemplo out=aleat4_prep;
    by oficina;
run;

proc surveyselect data=aleat4_prep
    out=work.aleat4 method=urs n=(100 70 80 20)
    outhits;
    strata oficina;
run;
```

Modificamos el método y, en este ejemplo, hacemos que los cuatro grupos formados tomen los tamaños que nosotros deseamos en la opción `N`; con esto tenemos 100 + 70 + 80 + 20 = 270 observaciones en el *dataset* de salida. De nuevo empleamos `OUTHITS` y `STRATA`. Espero que este ejemplo sea de utilidad para vuestro trabajo diario. Cualquier duda o sugerencia… `rvaquerizo@analisisydecision.es`.