---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2010-04-11'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - macro-sas-numero-de-observaciones-de-un-dataset-en-una-macro.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
tags:
  - excel
  - ods
  - proc datasets
title: Macros SAS. Informe de un dataset en Excel
url: /blog/macros-sas-informe-de-un-dataset-en-excel/
---

[](/images/2010/04/salida.JPG "Informe dataset")

[![Informe dataset](/images/2010/04/salida.JPG)](/images/2010/04/salida.JPG "Informe dataset")

Tengo por ahí este programa SAS interesante. Es una macro que realiza un pequeño informe sobre un dataset. Nos ofrece la librería, las variables y el tipo, longitud, posición y formato de estas y por ultimo el numero de observaciones. Si el dataset que deseamos explorar es una tabla oracle, informix o db2 hace un count(\*) para determinar el numero de observaciones. Este breve resumen lo vuelca en una tabla temporal SAS que nos llevaremos a Excel. Con esto los parámetros que recibe la macro son el dataset sobre el que realizamos el resumen y la ubicación del Excel de salida. Hache os pongo el código:

```r
*MACRO QUE EXPLORA UN CONJUNTO DE DATOS Y CREA UN EXCEL EN UN DIRECTORIO CON EL

NOMBRE DE LAS VARIABLES;

%macro explora_datos(datos,salida);

*SEPARAMOS LA LIBRERIA DE LA TABLA;

data _null_;

a1=scan("&datos.",1,'.');

if a1=" " then a1="WORK";

a2=scan("&datos.",2,'.');

call symput ('libreria',a1);

call symput ('tabla',a2);

*VOLCAMOS LOS CONTENIDOS DE LA TABLA EN OTRA AUXILIAR;

proc datasets lib=&libreria. nolist nodetails;

contents data=&&tabla.

out=work.AAA&tabla. (keep=LIBNAME MEMNAME NAME TYPE LENGTH VARNUM INFORMAT NPOS NOBS)

nodetails noprint;

run; quit;

*SI ES UNA LIBRERIA DINAMICA PARA SABER EL NUM DE OBSERVACIONES CONTAMOS;

data _null_;

set AAA&&tabla. (obs=1);

call symput('ejecuta',nobs);

run;

%if (&&ejecuta = .) %then %do;

proc sql noprint;

select count(*) into: nob

from &&datos.;

quit;

data AAA&&tabla;

set AAA&&tabla;

nobs=&nob;

run;

%end;

%let tabla=%cmpres(&&tabla.);

*CREAMOS UN EXCEL EN UNA UBICACION DETERMINADA CON EL NOMBRE DE LA TABLA

DE LA QUE QUEREMOS SABER EL CONTENIDO;

%macro creaexcel(datos_sas,ubicacion);

title;

filename temp "&ubicacion.";

ods noresults;

ods listing close;

ods html file=temp rs=none style=minimal;

proc print data=&datos_sas. noobs;

run;

ods html close;

ods results;

ods listing;

%mend;

%creaexcel(AAA&&tabla.,&salida\&tabla..xls);

proc delete data=AAA&tabla.; run;

%mend explora_datos;

*EJEMPLO DE USO;

%explora_datos(work.prueba,c:\);
```

Si alguien tiene SAS 8 o una versión mas antigua que me indique si funciona. Con este programa documente un datamart en una tarde, además me sirvió para construir los metadatos y las tablas de dimensiones de ese datamart. Hay una version mas sofisticada que realiza el informe sobre todas las tablas de una libreria. En futuras entregas. Como siempre si tenéis dudas, sugerencias o deseáis que ayude a vuestro equipo 6 horas al día rvaquerizo@analisisydecision.es Saludos
