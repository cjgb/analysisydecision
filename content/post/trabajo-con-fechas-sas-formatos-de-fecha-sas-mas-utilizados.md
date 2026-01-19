---
author: rvaquerizo
categories:
- formación
- monográficos
- sas
date: '2008-11-10'
lastmod: '2025-07-13'
related:
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- trabajo-con-fechas-sas-introduccion.md
- trabajo-con-fechas-sas-funciones-fecha.md
- macros-sas-transformar-un-numerico-a-fecha.md
- curso-de-lenguaje-sas-con-wps-variables.md
tags:
- fechas sas
- formatos sas
title: Trabajo con fechas SAS. Formatos de fecha SAS más utilizados
url: /blog/trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados/
---
En esta nueva entrega del monografico de fechas SAS vamos a estudiar algunos formatos. Un formato es la forma en la que vemos una variable. 17327 es un valor sin significado, pero el 20 de junio de 2007 es una fecha. En la anterior entrega estudiamos como SAS guardaba las fechas como variables numéricas, como el número de días transcurridos desde el 1 de enero de 1960. Las fechas/horas se guardaban como el número de segundos transcurridos. Con los distintos formatos fecha/hora nosotros podremos visualizar estas variables numéricas de SAS. Por ejemplo:

```r
data borrar;

x=1; y=1; z=1; m=1;

format x date9. y ddmmyy10. z datetime20. m time10.;
```
`proc print noobs; run;`

x y z m

02JAN1960 02/01/1960 01JAN1960:00:00:01 0:00:01

Vemos como internamente el valor 1 toma por un lado el 02/01/1960 para fechas y 1 segundo del 01/01/1960 para fechas/hora y 1 segundo para variables numéricas tipo hora. Disponemos de la ayuda de SAS para conocer todos los formatos, en este capítulo del monográfico se trabajará con algunos ejemplos de los formatos fecha más habituales, los formatos fecha/hora se representan habitualmente como datetimeN. y timeN. y no es normal emplear otros; por ello nos centraremos en las fechas. Veamos algunos ejemplos que recogen los formatos de fecha más utilizados en SAS:

```r
data borrar;

x="01JAN2008"d;

y=x+10;

z=y+100;

m=z-12;

format x ddmmyy8. y ddmmyy10. z yymmddn8. m date7.;
```
`proc print noobs; run;`

x y z m

01/01/08 11/01/2008 20080420 08APR08

El formato ddmmyyN. es «la estrella», los formatos dateN. no son tan usados si trabajamos con el idioma español pero puede ser interesante trabajar con él si deseamos calcular fechas de referencia que puedan ser parámetros macro. En este ejemplo también vemos el YYMMDDN8 usado como numérico en muchas BBDD. En función de la longitud podemos modificar estos formatos, pero hay que tener cuidado con poner una longitud no valida como por ejemplo ddmmyy11. esto nos llevaría a tener un error. Como ya se ha comentado en la ayuda de SAS tenemos todos los formatos disponibles y debe ser nuestro material de consulta imprescindible. Otros ejemplos interesantes son:

```r
data borrar;

x="01JAN2008"d;

y=x+10;

z=y+100;

m=z-12;

format x julian7. y EURDFDD10. z yymmn6. m worddate20.;
```
`proc print noobs; run;`

x y z m

2008001 11.01.2008 200804 April 8, 2008

Los formatos julianos son habituales en máquinas antiguas. El formato DD.MM.YYYY también es habitual y, particularmente, yo lo empleo bastante. El YYYYMM puede sernos muy útil cuando queramos trabajar con meses y por último el WORDDATEN. que junto con el idioma español no queda muy «elegante».

A través de los formatos podremos «transformar» nuestras variables fecha en otras variables SAS, para ello podemos emplear la función **PUT**. PUT transforma una variable numérica a caracter, veamos un par de ejemplos de uso:

```r
data _null_;

x="01JAN2008"d;

y=x-12;

referencia=quote(put(y,date7.))||"d";

put referencia;
```

```r
z=x+19;

mes=put(z,yymmn6.)*1;

put mes;

run;
```

La variable referencia de nuestro paso data será la cadena alfanumérica «20DEC07″d y mes será numérica de valor 200801, dos formas muy prácticas en SAS de representar fechas. Por otro lado hay ocasiones en las que valores numéricos o caracter han de pasar a ser valores fecha, por ejemplo:

```r
data _null_;

y=20080501;

z=20070501;
```

```r
x=y-z; put x=;

run;
```

Es evidente que trabajamos con 2 fechas y el resultado de esa diferencia no puede ser 10000. Luego necesitamos transformar una variable numérica en una variable fecha:

```r
data _null_;

y=20080501;

z=20070501;

y1=input(compress(put(mod(y,100),z2.)||put(mod(int(y/100),100),z2.)||int(y/10000)),ddmmyy8.);

z1=input(compress(put(mod(z,100),z2.)||put(mod(int(z/100),100),z2.)||int(z/10000)),ddmmyy8.);

x=y1-z1; put x=;

run;
```

¡Da miedo la transformación de variables! Se ha empleado la función **INPUT** que transforma variables alfanuméricas en variables numéricas. Pero no hay que asustarse (mucho) con la transformación de variables numéricas a fecha ya que en la siguiente entrega trabajaremos con funciones que nos facilitan mucho esta labor. Aun así es importante conocer la metodología para pasar de numéricas a fecha. Tanto la función PUT como INPUT tendrán un monográfico sobre su uso, sirvan estos casos a modo de introducción.

Como siempre para cualquier duda o sugerencia… rvaquerizo@analisisydecision.es