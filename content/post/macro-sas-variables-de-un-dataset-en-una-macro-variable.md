---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
  - trucos
date: '2012-09-06'
lastmod: '2025-07-13'
related:
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset.md
  - trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
  - macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
  - trucos-sas-macrovariable-a-dataset.md
tags:
  - formación
  - monográficos
  - sas
  - trucos
title: Macro SAS. Variables de un dataset en una macrovariable
url: /blog/macro-sas-variables-de-un-dataset-en-una-macro-variable/
---

Hoy os presento una macro de SAS que nos permite recoger en una macrovariable las variables de un conjunto de datos SAS. Tiene como particularidad que nos sirve para seleccionar aquellas variables que tienen un determinado patrón, del tipo `consumo2010`, `consumo2011`… Es un código un poco más complejo de lo habitual pero tiene aspectos interesantes:

```sas
%macro lista_variables(ds=, nombre_mv=, patron=);
    * ES NECESARIO QUE LA MACROVARIABLE FINAL SEA GLOBAL;
    %global &nombre_mv.;
    
    * DETERMINAMOS LIBRERÍA Y TABLA;
    data _null_;
        length lib tab $255.;
        if index("&ds.", ".") = 0 then do;
            lib = "WORK";
            tab = "&ds.";
        end;
        else do;
            lib = scan("&ds.", 1, ".");
            tab = scan("&ds.", 2, ".");
        end;
        call symput('libreria', upcase(lib));
        call symput('tabla', upcase(tab));
    run;

    * BUSCAMOS EN DICTIONARY DE SAS (VCOLUMN);
    proc sql noprint;
        select compress(name) into :&nombre_mv. separated by " "
        from sashelp.vcolumn
        where libname = "&libreria." 
          and memname = "&tabla."
          and upcase(name) like "%" || "%upcase(&patron.)" || "%";
    quit;
%mend;
```

El elemento principal de esta macro es una consulta a una de las tablas `DICTIONARY` de SAS, o mejor dicho, a una de las vistas que tenemos en `SASHELP`. Siempre he preferido consultar las vistas de `SASHELP`. La vista consultada es `VCOLUMN`, de donde extraemos la columna `NAME`, y como condicionantes pasamos la librería en `LIBNAME` y el nombre de la tabla en `MEMNAME`. Como particularidad, podemos filtrar por patrones de nombre.

### Ejemplos de uso

```sas
data sasuser.importes;
    drop i j;
    array importe(30);
    do i = 1 to 20000;
        do j = 1 to 30;
            importe(j) = ranuni(8) * 1000;
        end;
        grupo = ranpoi(4, 5);
        output;
    end;
run;

data importes;
    set sasuser.importes;
run;

%lista_variables(ds=sasuser.importes, nombre_mv=lista_var1, patron=);
%lista_variables(ds=importes, nombre_mv=lista_var2, patron=importe);

%put Variables de sasuser.importes: &lista_var1.;
%put Variables que contienen "importe": &lista_var2.;
```

Creo que esta macro es muy práctica y puede automatizaros mucho código. Saludos.