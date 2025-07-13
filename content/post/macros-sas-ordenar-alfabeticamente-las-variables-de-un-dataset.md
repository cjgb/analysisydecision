---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-11-06T06:55:12-05:00'
slug: macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset
tags: []
title: Macros SAS. Ordenar alfabéticamente las variables de un dataset
url: /macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset/
---

Si deseamos ordenar alfabéticamente las variables de un conjunto de datos SAS porque puede falitarnos la realización de sumatorios de importes, saldos,… y el conjunto de datos SAS está desordenado os planteo una macro bien sencilla y que trabaja con una de las vistas más útiles de la SASHELP. La macro es bien sencilla y nos permite establecer que variables deseamos que aparezcan primero, selecciona los nombres de las variables, los ordena alfabéticamente y mediante un proc append (más rápido que un paso data) crea el fichero SAS con las variables ordenadas:

```r
%macro ordenavar(datos,prim=);

*OBTENEMOS LIBRERIA;

%let lib=%scan("&datos.",1,".");

*OBTENEMOS NOMBRE;

%let nom=%scan("&datos.",2,".");
```

*CREAMOS UNA LISTA DE VARIABLES CON LA SASHELP;  
proc sql noprint;  
select name into: lista_ordenada separated by " " from sashelp.vcolumn  
where upcase(libname) = upcase("&lib.") and  
upcase(memname) = upcase("&nom.")  
order by name;  
quit;

*RENOMBRAMOS EL FICHERO PARA REALIZAR LOS CAMBIOS;  
ods noresults;  
proc datasets library=&lib.  
change &nom.=aux1;  
quit;  
ods results;

*ORDENAMOS EL AUXILIAR Y ANEXAMOS SOBRE EL FICHERO BASE  
RETAIN ANTES DE SET NOS ORDENA LAS VARIABLES;  
data uno;retain &prim. &lista_ordenada.;set aux1(obs=0);

*CON EL PROC APPEND ANEXAMOS LOS DATOS CON MAYOR RAPIDEZ;  
proc append base=&datos. data=aux1; quit;

proc delete data=aux1;run;  
%mend;  

Creamos un fichero auxiliar con la estructura anterior y posteriormente lo borramos. Esta macro es un buen ejemplo de uso de las vistas de la SASHELP y además plantea como emplear el proc append para modificar anexar datos con mayor rapidez. Ejemplo de uso:

```r
data uno;

do id=1 to 20;

y=ranpoi(34,3);

a=ranpoi(34,7);

v=ranpoi(34,1);

s=ranpoi(34,89);

output;

end;

run;
```

%ordenavar(work.uno,prim=id);  

En el parámetro PRIM podemos especificar aquellas variables que desamos que aparezcan primero. Para cualquier duda o problema sobre el funcionamiento: rvaquerizo@analisisydecision.es