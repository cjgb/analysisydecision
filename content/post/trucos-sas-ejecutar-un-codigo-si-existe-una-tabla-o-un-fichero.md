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
  - formación
  - sas
  - trucos
title: Trucos SAS. Ejecutar un código si existe una tabla o un fichero
url: /blog/trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero/
---

Esta duda me llegó hace unos días. Se trataba de ejecutar un código si existía determinado fichero o determinada tabla. Para hacer esto, os planteo una posible metodología que yo utilizaba cuando programaba SAS en una gran entidad bancaria con `Enterprise Guide 1`; por aquel entonces hacía maravillas con la "castaña" del `Guide v1`. Entre ellas, unas macros que contenían una sentencia condicional que ejecutaba un código en función de la función (bonita expresión) `EXIST` o `FILEEXIST`. Lo que yo hacía era algo parecido a esto:

**Macro que ejecuta un código SAS si existe una tabla:**

```sas
data uno;
    do i = 1 to 100;
        output;
    end;
run;

* MACRO QUE SE EJECUTA SI EXISTE UNA TABLA SAS;
%macro proceso(tabla);
    %if %sysfunc(exist(&tabla.)) %then %do;
        data dos;
            set &tabla.;
            i = i**2;
        run;
    %end;
%mend;

%proceso(work.uno);
```

¡Qué sencillo! Pero si alguien ha programado con `EGuide 1`, entenderá por qué era tan útil esta macro. Además, es un perfecto ejemplo de uso de la función `EXIST`. Por otro lado, me encontraba con la situación de que las cadenas de carga de diversos `JOB` en mi compañía generaban ficheros `DB2` a determinadas horas, y esta hora nunca era la misma y, por supuesto, no coincidía con la hora prevista de finalización. Para ello hacía algo parecido a lo que os planteo a continuación:

```sas
* EXPORTO UN FICHERO PARA QUE TENGÁIS EL EJEMPLO;
proc export data=work.dos
    outfile="C:\temp\borra.csv"
    dbms=csv replace;
run;

* MACRO QUE SE EJECUTA SI EXISTE UN FICHERO;
%macro proceso2(arch);
    %if %sysfunc(fileexist(&arch.)) %then %do;
        data work.dos_leido;
            infile &arch. delimiter = ',' missover dsd lrecl=32767 firstobs=2;
            input i;
        run;
    %end;
%mend;

%proceso2("C:\temp\borra.csv");
```

Realizaba un bucle que, cada cinco minutos, rastreaba la existencia de un determinado fichero en el servidor y, si aparecía, ejecutaba el código. Para ello empleaba la función `FILEEXIST` de una forma análoga a la que os planteo en el ejemplo. Este bucle dará lugar a otro truco SAS en breve. Este truco sí que es útil para todos aquellos que esperáis que os generen ficheros desde TI para ejecutar vuestros procesos. Saludos.