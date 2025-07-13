---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2009-08-17T06:17:50-05:00'
lastmod: '2025-07-13T16:09:55.112856'
related:
- macro-sas-variables-de-un-dataset-en-una-macro-variable.md
- trucos-sas-lista-de-datasets-en-macro-variable.md
- trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
- macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
- truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
slug: trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas
tags: []
title: Trucos SAS. Eliminar etiquetas en los conjunto de datos SAS
url: /trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas/
---

Hoy planteo un ejemplo de uso de las vistas de SASHELP con los nombres de las columnas de una tabla SAS. Además sirve para conocer mejor el PROC DATASETS y la creación de macro variables con el PROC SQL. Una macro que no es de mucha utilidad pero con la que podemos empezar a aproximarnos al lenguage macro de SAS:  

```r
%macro sinetiquetas(conj);

data _null_;

if index("&conj.",".")=0 then x="WORK";

else x=substr("&conj.",1,index("&conj.",".")+1) ;

call symput('libreria',x);

y=substr("&conj.",index("&conj.",".")+1,length("&conj.")) ;

call symput('tabla',y);

proc sql noprint;

select compress(name||"=''") into:l1 separated by " "

from sashelp.vcolumn

where libname=upcase("&libreria.") and memname=upcase("&tabla.") ;

quit;

proc datasets lib=&libreria. nolist;

modify &tabla.;

label &l1.;

quit;

%mend;
```

Primero buscamos con un paso data si es una tabla temporal o permanente. Creamos una macro variable con los nombres de las variables preparadas para eliminar etiquetas (var1=»). Las etiquetas las quitamos con DATASETS y MODIFY. La macro sólo necesita como parámetro la tabla sobre la que deseamos eliminar las etiquetas. A pesar de ser un truco fácil seguro que más de uno se precompila esta macro en sus sesiones SAS.