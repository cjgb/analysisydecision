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
title: Trucos SAS. Muestreo con PROC SURVEYSELECT
url: /blog/trucos-sas-muestreo-con-proc-surveyselect/
---
Hace varios días planteamos algún truco SAS para la realización de muestras aleatorias. Hoy planteo otro truco para lo mismo pero empleando el procedimiento de SAS SURVEYSELECT. Este procedimiento lo tenemos en el módulo STAT y tiene una sintaxis muy sencilla. Además nos permite realizar [muestreos estratificados ](http://www.bioestadistica.uma.es/libro/node89.htm)de forma muy sencilla, mediante pasos data el muestreo estratificado se complica. Como es habitual vemos varios ejemplos partiendo de una tabla SAS aleatoria:

```r
data ejemplo;

 do id=1 to 10000;

 oficina=ranpoi(5,1);

 oficina=min(oficina,3);

 importe=ranuni(8)*1000;

 output;

 end;

run;

proc freq data=ejemplo;

tables oficina;

quit;
```

Tenemos un datasets con 10.000 observaciones que tiene un id, un importe y una oficina. El primer paso es crear una muestra aleatoria simple de tamaño 300, las sentencias adecuadas con el PROC SURVEYSELECT son:

```r
*MUESTRA ALEATORIA SIMPLE;

PROC SURVEYSELECT DATA=EJEMPLO

 OUT=WORK.ALEAT1 METHOD=SRS N=300;

RUN;
```

Vemos que en method especificamos que tipo de muestreo deseamos, SRS es aleatorio simple sin reemplazamiento. Si deseamos muestreo aleatorio simple con reemplazamiento el código a ejecutar sería:

```r
*MUESTRA ALEATORIA CON REEMPLAZAMIENTO;

PROC SURVEYSELECT DATA=EJEMPLO

 OUT=WORK.ALEAT2 METHOD=URS N=300

 OUTHITS ;

RUN;
```

El método es URS y con la opción OUTHITS indicamos que cree una variable en el dataset de salida que nos indique el número de veces que aparece esa observación en la muestra, interesante opción para asignar pesos. Por otro lado si necesitamos realizar un muestreo estratificado por alguna variable discreta tenemos que emplear el siguiente código:

```r
*MUESTREO ESTRATIFICADO ALEATORIO SIMPLE

 SIN REEMPLAZAMIENTO;

PROC SORT DATA=WORK.EJEMPLO

 OUT=WORK.aleat3; BY oficina;

RUN;

PROC SURVEYSELECT DATA=aleat3

 OUT=WORK.aleat3 METHOD=SRS N=50;

 STRATA oficina;

RUN;
```

Realizamos una ordenación previa por la variable que hace de estrato, indicamos el método y en el número de observaciones ponemos el número que deseamos por estrato, con esto tendremos nº estratos*N observaciones en el dataset de salida. Para indicarle cual es la variable por la que se realiza el muestreo estratificado tenemos la instrucción STRATA. De especial interés pueden ser las variables que se añaden al dataset de salida _SelectionProb_ y _SamplingWeight_ que nos indican la probabilidad de obtención de la observación y el peso que ésta tiene. Si deseamos muestreo estratificado con reemplazamiento podemos hacer:

```r
*MUESTREO ESTRATIFICADO CON REEMPLAZAMIENTO;

PROC SORT DATA=WORK.EJEMPLO

 OUT=WORK.aleat4; BY oficina;

RUN;

PROC SURVEYSELECT DATA=aleat4

 OUT=WORK.aleat4 METHOD=URS N=(100 70 80 20)

 OUTHITS;

 STRATA oficina;

RUN;
```

Modificamos el método y en este ejemplo hacemos que los 4 grupos formados tomen los tamaños que nosotros deseamos en la opción N, con esto tenemos 100+70+80+20=270 observaciones en el dataset de salida. De nuevo empleamos OUTHITS y STRATA. Espero que este ejemplo sea de utilidad para vuestro trabajo diario. Cualquier duda o sugerencia… [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)