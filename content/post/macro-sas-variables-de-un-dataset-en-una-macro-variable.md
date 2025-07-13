---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
- Trucos
date: '2012-09-06T01:25:06-05:00'
lastmod: '2025-07-13T16:00:44.535096'
related:
- trucos-sas-lista-de-datasets-en-macro-variable.md
- macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset.md
- trucos-sas-eliminar-etiquetas-en-los-conjunto-de-datos-sas.md
- macros-sas-ordenar-alfabeticamente-las-variables-de-un-dataset.md
- trucos-sas-macrovariable-a-dataset.md
slug: macro-sas-variables-de-un-dataset-en-una-macro-variable
tags: []
title: Macro SAS. Variables de un dataset en una macro variable
url: /macro-sas-variables-de-un-dataset-en-una-macro-variable/
---

Hoy os presento una macro de SAS que nos permite recoger en una macro variable las variables de un conjunto de datos SAS. Tiene como particularidad que nos sirve para seleccionar aquellas variables que tienen un determinado patrón, del tipo consumo2010, consumo2011,… Es un código un poco más complejo de lo habitual pero tiene aspectos interesantes:

```r
options mlogic mprint;
%macro lista_variables (ds= , nombre_mv= , patron=);
*ES NECESARIO QUE LA MACROV FINAL SEA GLOBAL;
%global &nombre_mv.;
*PUEDE SER QUE LA LIBRERIA SEA WORK O PERMANENTE;
	data _null_;
	length lib tab $255.;
	if index("&ds.",".")=0 then lib="WORK";
	else lib=scan("&ds.",1,".") ; put lib=;
	call symput('libreria',lib);
	tab=scan("&ds.",2,".") ;
	call symput('tabla',tab);
	run;
*BUSCAMOS EN DICTIONARY DE SAS;
	proc sql noprint;
	select compress(name) into:&nombre_mv. separated by " "
	from sashelp.vcolumn
where libname=upcase("&libreria.") and memname=upcase("&tabla.") and
/*PODEMOS APLICAR UN PATRON*/
	upcase(name) like '%'||"%upcase(&patron.)"||'%';
	quit;
%mend;
```
 

El elemento principal de esta macro es una consulta a una de las tablas DICTIONARY de SAS. O mejor dicho, a una de las vistas que tenemos en SASHELP. Siempre he prefererido consultar las vistas de SASHELP. La vista consultada es VCOLUMN de donde extraemos la columna NAME y como condicionantes pasamos la librería en LIBNAME y el nombre de la tabla de la que deseamos obtener las variables en MEMNAME. Como particularidad podemos aplicar patrones.

Ejemplos de uso:

```r
data importes sasuser.importes;
drop i j;
array importe(30) ;
do i=1 to 20000;
do j=1 to 30;
importe(j)=ranuni(8)*1000;
end;
grupo=ranpoi(4,5);
output;
end;
run;
*;
%lista_variables(ds=sasuser.importes , nombre_mv=lista_var1 , patron=);
%lista_variables(ds=importes , nombre_mv=lista_var2 , patron=importe);
*;
%put _user_;
```
 

Creo que esta macro es muy práctica y puede automatizaros mucho código. Saludos.