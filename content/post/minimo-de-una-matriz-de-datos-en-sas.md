---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2015-04-27T02:29:43-05:00'
slug: minimo-de-una-matriz-de-datos-en-sas
tags: []
title: Mínimo de una matriz de datos en SAS
url: /minimo-de-una-matriz-de-datos-en-sas/
---

[El otro día una lectora del blog me preguntaba como obtener el mínimo de una matriz de datos de 100×1000 con SAS](https://analisisydecision.es/monografico-datos-agrupados-en-sas/#comment-76186). El ejercicio es muy práctico para ayudar a que se entienda mejor como “piensa” SAS. Probablemente esta lectora estaba pensando en complicados bucles que recorren, que almacenan, que arrastran,… con SAS las cosas no son así. El paso data es un bucle en si mismo y SAS no tiene pereza en crear tablas intermedias. Así que la mejor solución para encontrar ese mínimo sería:

```r
data matriz;
do j=1 to 1000;
array varib(100);
do i=1 to 100;
varib(i) = ranuni(56)*1000;
end;output;
end;
drop i j;
run;

proc summary data=matriz;
var varib:;
output out=minimos min=;
quit;

data _null_;
set minimos;
minimo_total = min(of varib:);
put minimo_total=;
run;
```
 

Se crea una matriz de datos aleatorios con un paso data de 100×1000 las variables se llaman varib ya que se generan con ese array. La mejor solución es hacer una tabla SAS con todos los mínimos por variable y meterlo en un conjunto de datos SAS. Por último el mínimo de los mínimos será el mínimo total o el más mínimo como diría alguno. Si programáis con SAS pensad en SAS. Saludos.