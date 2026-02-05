---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-08-17'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
  - macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
tags:
  - formación
  - sas
  - trucos
title: Trucos SAS. Eliminar etiquetas en los conjunto de datos SAS
url: /blog/trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas/
---

Hoy planteo un ejemplo de uso de las vistas de `SASHELP` con los nombres de las columnas de una tabla SAS. Además, sirve para conocer mejor el `PROC DATASETS` y la creación de macrovariables con el `PROC SQL`. Una macro que no es de mucha utilidad, pero con la que podemos empezar a aproximarnos al lenguaje macro de SAS:

```sas
%macro sinetiquetas(conj);
    data _null_;
        if index("&conj.", ".") = 0 then x = "WORK";
        else x = scan("&conj.", 1, ".");
        call symput('libreria', upcase(x));
        
        if index("&conj.", ".") = 0 then y = "&conj.";
        else y = scan("&conj.", 2, ".");
        call symput('tabla', upcase(y));
    run;

    proc sql noprint;
        select compress(name || "=''") into :l1 separated by " "
        from sashelp.vcolumn
        where libname = "&libreria." and memname = "&tabla.";
    quit;

    proc datasets lib=&libreria. nolist;
        modify &tabla.;
        label &l1.;
    run;
    quit;
%mend;
```

Primero buscamos con un paso `DATA` si es una tabla temporal o permanente. Creamos una macrovariable con los nombres de las variables preparadas para eliminar etiquetas (`var1=''`). Las etiquetas las quitamos con `DATASETS` y `MODIFY`. La macro sólo necesita como parámetro la tabla sobre la que deseamos eliminar las etiquetas. A pesar de ser un truco fácil, seguro que más de uno se precompila esta macro en sus sesiones SAS. Saludos.