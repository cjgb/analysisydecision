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

A continuación os planteo como truco `SAS` una duda que nos mandaba `LILIANA`. Ella necesitaba estudiar los valores perdidos de las tablas de una librería determinada. En este caso vamos a estudiar los `missing` de las variables numéricas de una librería, de forma análoga se puede hacer con las alfanuméricas. Como siempre vamos a trabajar con un ejemplo que parte de tablas generadas aleatoriamente. Comenzamos generando estas tablas:

```sas
libname datos "c:\temp\datos";
```

```sas
%macro aleatorios;

%do i=1 %to 5;

data datos.proyecto_&i.;

do id=1 to 200;

 if int(ranuni(0)*10) = 2 then importe1=.;

 else importe1=round(rand("uniform")*1000,.1);

 if int(ranuni(0)*10) > 0.3 then importe2=.;

 else importe2=round(rand("uniform")*130,.1);
```

```sas
length zona $15.;
if ranuni(0) <=.32 then zona="España";
else if ranuni(1) <= 0.32 then zona="Cataluña";
else zona="Resto";

output;
end;
run;
%end;
%mend aleatorios;
```

`%aleatorios;`

Con este programa generamos 5 datasets aleatorios con 4 variables, dos de ellas son importes que tendrán valores missing en determinados casos. En este punto hemos de crear un proceso que cuente valores perdidos, podemos emplear el `PROC SQL` o bien podemos emplear el `PROC FREQ` pero definiendo primero un formato. Empleamos `FREQ` para crear una macro:

```sas
proc format ;

value per

.="perdido"

low-high="informado";

quit;
```

```sas
%macro nulos (datos,var);
title "Valores perdidos de &var. en la tabla &datos.";
proc freq data=&datos.;
format &var. per.;
tables &var./missing;
quit;
title;
%mend;
```

Si ejecutamos:

`%nulos (datos.proyecto_1,importe1);`

Obtenemos:

```
Valores perdidos de importe1 en la tabla datos.proyecto_1 33
```

`Procedimiento FREQ`

| Frequencia | Porcentaje |
|---|---|
| importe1 Frecuencia | Porcentaje acumulada acumulado |
| perdido 22 | 11.00 22 11.00 |
| informado 178 | 89.00 200 100.00 |

Ahora necesitamos automatizar el proceso para hacerlo sobre todas las tablas de una librería. Para esto empleamos las vistas de `SASHELP` y el `PROC SQL`. La idea es generar una instrucción que alojada en una macrovariable genere todo el código automáticamente. Por ello recorremos todas las variables numéricas de los dataset que deseamos estudiar y generamos automáticamente el códito de la macro `%nulos`:

```sas
proc sql;

 select

 '%nulos(datos.'||memname||','||name||');'

 into: instruccion separated by " "

 from sashelp.vcolumn

 where libname="DATOS" and type="num";

quit;
```

Un código muy simple nos puede ahorrar escribir mucho. Ahora sólo hemos de referenciar a la macrovariable `&instrucción` en nuestro código y automáticamente tenemos un informe de valores missing para cada variable numérica de la librería datos a excepción de `ID` que no tiene sentido hacer esa frecuencia. Estas 4 líneas de `PROC SQL` pueden ayudaros a automatizar una gran cantidad de códigos, estoy seguro.

Por supuesto si tenéis dudas, sugerencias o un trabajo excelentemente remunerado… `rvaquerizo@analisisydecision.es`
