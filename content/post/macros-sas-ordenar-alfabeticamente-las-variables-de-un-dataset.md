---
author: rvaquerizo
categories:
  - sas
  - trucos
date: '2008-11-06'
lastmod: '2025-07-13'
related:
  - macro-sas-variables-de-un-dataset-en-una-macro-variable.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - trucos-sas-macrovariable-a-dataset.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
tags:
  - sas
  - trucos
title: Macros SAS. Ordenar alfabéticamente las variables de un dataset
url: /blog/macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset/
---

Si deseamos ordenar alfabéticamente las variables de un conjunto de datos SAS para facilitar la realización de sumatorios masivos (importes, saldos…) y el *dataset* está desordenado, os planteo una macro sencilla que trabaja con una de las vistas más útiles de `SASHELP`. 

La macro permite establecer qué variables deseamos que aparezcan primero, selecciona el resto de nombres, los ordena alfabéticamente y, mediante un `PROC APPEND` (más rápido que un paso `DATA`), crea el fichero SAS con las variables ordenadas:

```sas
%macro ordenavar(datos, prim=);
    * OBTENEMOS LIBRERÍA Y NOMBRE;
    data _null_;
        if index("&datos.", ".") = 0 then do;
            call symput('lib', 'WORK');
            call symput('nom', upcase("&datos."));
        end;
        else do;
            call symput('lib', upcase(scan("&datos.", 1, ".")));
            call symput('nom', upcase(scan("&datos.", 2, ".")));
        end;
    run;

    * CREAMOS UNA LISTA DE VARIABLES CON LA SASHELP;
    proc sql noprint;
        select name into :lista_ordenada separated by " " 
        from sashelp.vcolumn
        where upcase(libname) = "&lib." 
          and upcase(memname) = "&nom."
        order by name;
    quit;

    * RENOMBRAMOS EL FICHERO PARA REALIZAR LOS CAMBIOS;
    proc datasets library=&lib. nolist;
        change &nom. = aux_ordena;
    quit;

    * CREAMOS LA ESTRUCTURA ORDENADA (RETAIN ANTES DE SET);
    data &datos.;
        retain &prim. &lista_ordenada.;
        set &lib..aux_ordena (obs=0);
    run;

    * CON EL PROC APPEND ANEXAMOS LOS DATOS;
    proc append base=&datos. data=&lib..aux_ordena force; 
    run;

    proc delete data=&lib..aux_ordena; 
    run;
%mend;
```

Esta macro es un buen ejemplo de uso de las vistas de `SASHELP` y además plantea cómo emplear el `PROC APPEND` para anexar datos con mayor rapidez.

### Ejemplo de uso

```sas
data uno;
    do id = 1 to 20;
        y = ranpoi(34, 3);
        a = ranpoi(34, 7);
        v = ranpoi(34, 1);
        s = ranpoi(34, 89);
        output;
    end;
run;

%ordenavar(work.uno, prim=id);
```

En el parámetro `PRIM` podemos especificar aquellas variables que deseamos que aparezcan primero. Para cualquier duda o problema sobre el funcionamiento: `rvaquerizo@analisisydecision.es`. Saludos.