---
author: rvaquerizo
categories:
- formación
- sas
- trucos
- wps
date: '2013-03-08'
lastmod: '2025-07-13'
related:
- trucos-sas-informes-de-valores-missing.md
- truco-sas-transformaciones-de-variables-con-arrays.md
- macros-sas-hacer-0-los-valores-missing-de-un-dataset.md
- macros-faciles-de-sas-determinar-si-existe-una-variable-en-un-dataset.md
- trucos-sas-macrovariable-a-dataset.md
tags:
- array
- missing values
- sas
title: Trucos SAS. Lista de variables missing
url: /blog/trucos-sas-lista-de-variables-missing/
---
Duda que me plantearon ayer por la tarde. Dada una serie de variables determinar que registro tiene todas esas variables nulas. El truco que planteo puede servir para determinar incluso cuantos valores perdidos tiene esa lista de variables, ese truco me le reservo para otro día. El código lo acompaño con un ejemplo para que se pueda ejecutar y analizar su funcionamiento:

```r
data aleatorio;
do i=1 to 20000;
aleat1=sqrt(rannor(45));
aleat2=sqrt(rannor(5));
aleat3=sqrt(rannor(4));
aleat4=sqrt(rannor(450));
aleat5=sqrt(rannor(40));
output;
end;
run;

data fila_nula;
set aleatorio;
nulo=0;
array varib(*) aleat1--aleat5;
do j=1 to dim(varib);
if not missing(varib(j)) then nulo=i;
end;
drop j;
if nulo=0;
run;
```


Muy sencillo el truco. Si se encuentra alguna variable que no es nula la variable nulo ya no toma valor 0. Espero que os sea de utilidad. Saludos.