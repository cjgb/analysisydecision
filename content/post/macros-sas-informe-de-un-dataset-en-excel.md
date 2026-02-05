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
  - sas procs
title: Macros SAS. Informe de un dataset en Excel
url: /blog/macros-sas-informe-de-un-dataset-en-excel/
---

![Informe dataset](/images/2010/04/salida.JPG "Informe dataset")

Tengo por ahí este programa SAS interesante. Es una macro que realiza un pequeño informe sobre un *dataset*. Nos ofrece la librería, las variables y el tipo, longitud, posición y formato de éstas y, por último, el número de observaciones. Si el *dataset* que deseamos explorar es una tabla `Oracle`, `Informix` o `DB2`, hace un `COUNT(*)` para determinar el número de observaciones. 

Este breve resumen lo vuelca en una tabla temporal SAS que nos llevaremos a `Excel`. Con ésto, los parámetros que recibe la macro son el *dataset* sobre el que realizamos el resumen y la ubicación del `Excel` de salida. Aquí os pongo el código:

```sas
* MACRO QUE EXPLORA UN CONJUNTO DE DATOS Y CREA UN EXCEL EN UN DIRECTORIO;
%macro explora_datos(datos, salida);
    * SEPARAMOS LA LIBRERIA DE LA TABLA;
    data _null_;
        a1 = upcase(scan("&datos.", 1, '.'));
        a2 = upcase(scan("&datos.", 2, '.'));
        if a2 = " " then do;
            a2 = a1;
            a1 = "WORK";
        end;
        call symput('libreria', compress(a1));
        call symput('tabla', compress(a2));
    run;

    * VOLCAMOS LOS CONTENIDOS DE LA TABLA EN OTRA AUXILIAR;
    proc datasets lib=&libreria. nolist nodetails;
        contents data=&tabla. 
                 out=work.AAA&tabla. (keep=LIBNAME MEMNAME NAME TYPE LENGTH VARNUM INFORMAT NPOS NOBS) 
                 noprint;
    run;
    quit;

    * SI ES UNA LIBRERÍA DINÁMICA, PARA SABER EL NUMERO DE OBSERVACIONES CONTAMOS;
    data _null_;
        set work.AAA&tabla. (obs=1);
        call symput('ejecuta', compress(put(nobs, 12.)));
    run;

    %if %superq(ejecuta) = %str(.) or %superq(ejecuta) = %str() %then %do;
        proc sql noprint;
            select count(*) into :nob from &datos.;
        quit;
        data work.AAA&tabla.;
            set work.AAA&tabla.;
            nobs = &nob.;
        run;
    %end;

    * CREAMOS UN EXCEL EN UNA UBICACIÓN DETERMINADA CON EL NOMBRE DE LA TABLA;
    title;
    filename out_xls "&salida.\&tabla..xls";
    ods noresults;
    ods listing close;
    ods html file=out_xls rs=none style=minimal;
    
    proc print data=work.AAA&tabla. noobs;
    run;
    
    ods html close;
    ods results;
    ods listing;
    
    proc delete data=work.AAA&tabla.; 
    run;
%mend explora_datos;

* EJEMPLO DE USO;
/* %explora_datos(work.prueba, C:\temp); */
```

Si alguien tiene SAS 8 o una versión más antigua, que me indique si funciona. Con este programa documenté un *datamart* en una tarde; además, me sirvió para construir los metadatos y las tablas de dimensiones de ese *datamart*. Hay una versión más sofisticada que realiza el informe sobre todas las tablas de una librería. 

Como siempre, si tenéis dudas, sugerencias o deseáis que ayude a vuestro equipo: `rvaquerizo@analisisydecision.es`. Saludos.