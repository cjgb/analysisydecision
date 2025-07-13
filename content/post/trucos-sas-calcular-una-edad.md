---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2014-05-14T10:12:07-05:00'
slug: trucos-sas-calcular-una-edad
tags:
- YRDIF
title: Trucos SAS. Calcular una edad
url: /trucos-sas-calcular-una-edad/
---

No penséis que restar dos fechas y obtener una diferencia en años entre ellas es un tema baladí. Ejecutad el siguiente código SAS para calcular la diferencia en años:

```r
data uno;
format fecha1 ddmmyy10.;
do fecha1= 9000 to today();
output;
end;
run;

data uno;
set uno;
format fecha2 ddmmyy10.;
fecha2="15MAY2014"d;

edad = int((fecha2-fecha1)/365.25);

run;

data uno;
set uno;
if month(fecha1)=5 and day(fecha1)=15;
run;
```
 

Visualizad el conjunto de datos uno, la serie de edad asusta 28,28,27,25,24,24,… Está claro que algo falla. Hace ya tiempo que hablamos de ello en este mismo blog. Los ceros y los unos con los que guardan estas máquinas las cosas a veces nos juegan estas malas pasadas. Para evitar este problema os sugiero que empleéis la función de SAS YRDIF con la base ‘AGE’. Replicamos el ejemplo:

```r
data uno;
format fecha1 ddmmyy10.;
do fecha1= 9000 to today();
output;
end;
run;

data uno;
set uno;
format fecha2 ddmmyy10.;
fecha2="15MAY2014"d;

edad = int(yrdif(fecha1,fecha2,'AGE'));

run;

data uno;
set uno;
if month(fecha1)=5 and day(fecha1)=15;
run;
```
 

Ahora nuestra serie si es 29,28,27,26,25,… Ya sabéis tened cuidado a la hora de calcular edades porque SAS parece que trabaja hasta con la hora del nacimiento para calcular edades. Saludos.