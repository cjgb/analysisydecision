---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2009-03-16'
lastmod: '2025-07-13'
related:
  - macros-sas-hacer-0-los-valores-missing-de-un-dataset.md
  - macros-sas-agrupando-variables-categoricas.md
  - trucos-sas-lista-de-variables-missing.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - macros-sas-informe-de-un-dataset-en-excel.md
tags:
  - automatizar código
  - proc sql
  - sas
  - missing values
  - sas procs
title: Trucos SAS. Informes de valores missing
url: /blog/trucos-sas-informes-de-valores-missing/
---

A continuación, os planteo como truco SAS una duda que nos mandaba Liliana. Ella necesitaba estudiar los valores perdidos de las tablas de una librería determinada. En este caso, vamos a estudiar los *missing* de las variables numéricas de una librería; de forma análoga se puede hacer con las alfanuméricas. Como siempre, vamos a trabajar con un ejemplo que parte de tablas generadas aleatoriamente. Comenzamos generando estas tablas:

```sas
libname datos "C:\temp\datos";

%macro aleatorios;
    %do i = 1 %to 5;
        data datos.proyecto_&i.;
            do id = 1 to 200;
                if int(ranuni(0) * 10) = 2 then importe1 = .;
                else importe1 = round(rand("uniform") * 1000, .1);
                
                if int(ranuni(0) * 10) > 8 then importe2 = .;
                else importe2 = round(rand("uniform") * 130, .1);
                
                length zona $15;
                if ranuni(0) <= .32 then zona = "España";
                else if ranuni(1) <= .32 then zona = "Cataluña";
                else zona = "Resto";
                
                output;
            end;
        run;
    %end;
%mend aleatorios;

%aleatorios;
```

Con este programa generamos cinco *datasets* aleatorios con cuatro variables; dos de ellas son importes que tendrán valores *missing* en determinados casos. En este punto, hemos de crear un proceso que cuente valores perdidos; podemos emplear el `PROC SQL` o bien el `PROC FREQ` definiendo primero un formato. Empleamos `FREQ` para crear una macro:

```sas
proc format;
    value per
        . = "perdido"
        low-high = "informado";
run;

%macro nulos(datos, var);
    title "Valores perdidos de &var. en la tabla &datos.";
    proc freq data=&datos.;
        format &var. per.;
        tables &var. / missing;
    run;
    title;
%mend nulos;
```

Si ejecutamos: `%nulos(datos.proyecto_1, importe1);`, obtenemos una tabla de frecuencias donde vemos cuántos valores están informados y cuántos perdidos.

Ahora necesitamos automatizar el proceso para hacerlo sobre todas las tablas de una librería. Para ésto empleamos las vistas de `SASHELP` y el `PROC SQL`. La idea es generar una instrucción que, alojada en una macrovariable, ejecute todo el código automáticamente. Por ello, recorremos todas las variables numéricas de los *datasets* que deseamos estudiar y generamos automáticamente las llamadas a la macro `%nulos`:

```sas
proc sql noprint;
    select '%nulos(datos.' || trim(memname) || ',' || trim(name) || ');'
    into :instruccion separated by " "
    from sashelp.vcolumn
    where libname = "DATOS" and type = "num" and upcase(name) ne "ID";
quit;

* EJECUTAMOS EL CODIGO GENERADO;
&instruccion.;
```

Un código muy simple nos puede ahorrar escribir mucho. Ahora sólo hemos de referenciar a la macrovariable `&instruccion` en nuestro código y automáticamente tenemos un informe de valores *missing* para cada variable numérica de la librería `datos` (a excepción de `ID`). Estas pocas líneas de `PROC SQL` pueden ayudaros a automatizar una gran cantidad de procesos.

Por supuesto, si tenéis dudas o sugerencias… `rvaquerizo@analisisydecision.es`. Saludos.