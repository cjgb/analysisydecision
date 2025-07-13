---
author: rvaquerizo
categories:
- Formación
- SAS
- WPS
date: '2013-01-22T04:36:14-05:00'
slug: macros-sas-macro-split-para-partir-un-conjunto-de-datos
tags: []
title: Macros SAS. Macro split para partir un conjunto de datos
url: /macros-sas-macro-split-para-partir-un-conjunto-de-datos/
---

Debido a problemas con un servidor hace años descubrí [la macro Split](http://www2.sas.com/proceedings/sugi27/p083-27.pdf). Básicamente lo que hace es **partir un conjunto de datos SAS en múltiples conjuntos de datos SAS** con el mismo número de observaciones, además lo hace en un solo paso data. La forma de particionar el conjunto de datos es muy simple, si alguien tiene dudas con el código que lo comente y lo analizamos mejor. La macro (mejorada) es:

```r
%macro split(in=, out=, ndsn=2);
data %do i = 1 %to &ndsn.; &out.&i. %end; ;
retain x;
set &in. nobs=nobs;
if _n_ eq 1
then do;
if mod(nobs,&ndsn.) eq 0
then x=int(nobs/&ndsn.);
else x=int(nobs/&ndsn.)+1;
end;
if _n_ le x then output &out.1;
%do i = 2 %to &ndsn.;
else if _n_ le (&i.*x)
then output &out.&i.;
%end;
run;
%mend split;
```
 

Un bucle que en función de un contador mete las observaciones donde correspondan, en mi opinión no es un código muy complejo. Como siempre un ejemplo de uso:

```r
data uno;
do i=1 to 2000000;
output;
end;
run;

%split(in=uno, out=partido, ndsn=4);
```
 

Espero que os sea de utilidad, un saludo.