---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2010-11-10'
lastmod: '2025-07-13'
related:
- macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset.md
- trucos-sas-macrovariable-a-dataset.md
- macros-sas-informe-de-un-dataset-en-excel.md
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- macros-sas-dataset-a-data-frame-r.md
tags:
- sin etiqueta
title: Trucos SAS. Ejecutar un código si existe una tabla o un fichero
url: /blog/trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero/
---
Esta duda me llegó hace unos días. Se trataba de ejecutar un código si existía determinado fichero o determinada tabla. Para hacer esto os planteo una posible metodología que yo utilizaba cuando programaba SAS en una gran entidad bancaria con Enterprise Guide 1, por aquellos entonces hacía maravillas con la castaña del Guide v1. Entre ellas unas macros que contenían una sentencia condicional que ejecutaba un código en función de la función (bonita expresión) EXIST o FILEEXIST. Lo que yo hacía era algo parecido a esto:

**Macro que ejecuta un código SAS si existe una tabla:**

```r
data uno;

do i = 1 to 100;

output;

end;

run;

*MACRO QUE SE EJECUTA SI EXISTE UNA TABLA SAS;

%macro proceso(tabla);

%if %sysfunc(exist(&tabla.)) %then %do;

data dos;

set uno;

i=i**2;

run;

%end;

%mend;

*;

%proceso(work.uno);
```

¡Que sencillo! Pero si alguien ha programado con EGuide 1 entenderá porque era tan útil esta macro. Además es un perfecto ejemplo de uso de la función EXIST. Por otro lado me encontraba con la situación de que las cadenas de carga de diversos JOB en mi compañía generaban ficheros DB2 a determinadas horas y esta hora nunca era la misma y por supuesto no coincidía con la hora prevista de finalización. Para ello hacía algo parecido a lo que os planteo a continuación:

```r
*EXPORTO UN FICHERO PARA QUE TENGÁIS EL EJEMPLO;

PROC EXPORT DATA= WORK.Dos

OUTFILE= "C:\temp\borra.csv"

DBMS=CSV REPLACE;

PUTNAMES=YES;

RUN;

*MACRO QUE SE EJECUTA SI EXISTE UN FICHERO;

%macro proceso2(arch);

%if %sysfunc(fileexist(&arch.)) %then %do;

data WORK.DOS ;

infile 'C:\temp\borra.csv' delimiter = ','

MISSOVER DSD lrecl=32767 firstobs=2 ;

informat i best32. ;

format i best12. ;

input i;

run;

%end;

%mend;

*;

%proceso2("C:\temp\borra.csv");
```

Realizaba un bucle que, cada 5 minutos, rastreaba la existencia de un determinado fichero en el servidor y si aparecia ejecutaba el código. Para ello empleaba la función FILEEXIST de una forma análoga a la que os planteo en el ejemplo. Este bucle dará lugar a otro truco SAS en breve. Este truco si que es útil para todos aquellos que esperáis que os generen ficheros desde TI para ejecutar vuestros procesos. Saludos.