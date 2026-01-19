---
author: rvaquerizo
categories:
- excel
- formación
- sas
- trucos
date: '2013-09-20'
lastmod: '2025-07-13'
related:
- truco-sas-unir-todos-los-excel-en-uno-solo.md
- trucos-excel-unir-varios-excel-en-uno.md
- truco-excel-unir-todos-los-libros-en-una-hoja.md
- truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
- trucos-sas-union-de-multiples-tablas-sas-con-un-nombre-parecido.md
tags:
- dictionary
- libname
title: Truco SAS. Unir todas las hojas de un Excel en una
url: /blog/truco-sas-unir-todas-las-hojas-de-un-excel-en-una/
---
Empleamos LIBNAME con SAS para acceder a Excel. Es un truco con limitaciones y que se tiene que ir mejorando a futuro. Se trata de leer todas las hojas de un libro Excel y pegarlas horizontalmente en otra hoja QUE NO DEBE EXISTIR PREVIAMENTE. La macro es la siguiente, no se acompaña de un ejemplo de uso debido a su sencillez:

```r
%macro une_excel(ubicacion, nombre_union);
libname selec &ubicacion.

proc sql noprint;
select "SELEC.'"||memname||"'n" into:lista_excel separated by " "
from dictionary.members
where libname = "SELEC";
quit;

data SELEC.&nombre_union.;
set &lista_excel.;
run;

libname selec clear;
%mend;

%une_excel("C:\TEMP\unir_excel2\unidos.xlsx", todas);
```


Creamos una librería SAS a un libro Excel determinado. Leemos con DICTIONARY las hojas que tiene dicho libro y las unimos en una hoja de ese libro al que será la última. Como buena costumbre el desasignamos la librería con LIBNAME CLEAR. Como se ha indicado antes tiene limitaciones, por ejemplo no debe existir la hoja final con la unión. Pero es un buen ejemplo de uso de LIBNAME + EXCEL y DISTIONARY. Saludos.