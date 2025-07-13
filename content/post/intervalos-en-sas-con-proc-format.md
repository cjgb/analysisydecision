---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2012-12-21T06:02:27-05:00'
slug: intervalos-en-sas-con-proc-format
tags:
- PROC FORMAT
title: Intervalos en SAS con PROC FORMAT
url: /intervalos-en-sas-con-proc-format/
---

El uso de formatos en SAS para la creación de intervalos puede ahorrarnos tanto escritura de código como espacio en nuestros conjuntos de datos SAS. Una vez que nos familiaricemos con ellos evitaremos la creación de sentencias IF anidadas y generar nuevas variables de texto de gran longitud en nuestro dataset. Sin embargo siempre me plantean la misma cuestión, ¿por dónde están cerrados los intervalos en un formato? Hoy vamos a generar una serie de ejemplos para analizar este tema. Partimos de un conjunto de datos aleatorio con una variable de poisson con media 18:

```r
*CONJUNTO DE DATOS DE EJEMPLO;
data borra;
do i=1 to 3000;
dato=ranpoi(5,18);
output ;
end;
run;
```
 

Para crear intervalos cerrados por la derecha empleamos la sintaxis más habitual del PROC FORMAT:

```r
*INTERVALOS CERRADOS POR LA DERECHA ( ] ;
proc format;
value pep
low - 10 = "menor"
10 - 15 = "Entre 10 y 15"
15 - 30 = "Entre 15 y 30"
30 - high = "Mayor de 30";
quit;

title "Formatos con intervalo con - ";
proc sql;
select
put(dato,pep.) as pep,
max(dato) as max,
min(dato) as min
from borra
group by 1;
quit;
```
 

Si definimos el format como 10 – 15 tendremos números >10 y <=15. El intervalo quedará cerrado por la derecha. Si deseamos cerrar el intervalo por la izquierda tendremos que hacerlo de la forma 10 - < 15, los espacios son importantes: 
```r
*INTERVALOS CERRADOS POR LA IZQUIERDA [ ) ;
proc format;
value pep
low – < 10 = "menor"
10 -  < 15 = "Entre 10 y 15"
15 -  < 30 = "Entre 15 y 30"
30 - high = "Mayor de 30";
quit;

title "Formatos con intervalo con - <";
proc sql;
select
put(dato,pep.) as pep,
max(dato) as max,
min(dato) as min
from borra
group by 1;
quit;
```
 

En este caso si definimos el format como 10 – < 15 y se traduce en >=10 y <15\. Programación básica con SAS que da respuesta a una duda recurrente. Saludos.