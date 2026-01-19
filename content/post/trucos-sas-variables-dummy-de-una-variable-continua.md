---
author: rvaquerizo
categories:
- formación
- sas
- trucos
date: '2009-04-06'
lastmod: '2025-07-13'
related:
- macro-sas-crear-variables-dummy-desde-una-variable-categorica.md
- trucos-sas-variables-dicotomicas-desde-factores.md
- macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
- truco-sas-categorizar-variables-continuas.md
- macros-sas-agrupando-variables-categoricas.md
tags:
- dummy
- variables de entrada
title: Trucos SAS. Variables dummy de una variable continua
url: /blog/trucos-sas-variables-dummy-de-una-variable-continua/
---
Dumificar es crear variables dummy. Un verbo completamente inventado pero que todos los que os habéis enfrentado a la creación de una tabla de entrada para realizar modelos estadísticos vais a entender perfectamente en que consiste. Dumificar es transformar una variable continua en N variables dicotómicas. Lo entenderemos mejor con un ejemplo gráfico:

[![dumificar.JPG](/images/2009/04/dumificar.JPG)](/images/2009/04/dumificar.JPG "dumificar.JPG")

[](/images/2009/04/dumificar.JPG "dumificar.JPG")

En el ejemplo partimos de 8 registros y creamos 4 variables dicotómicas en función de una variable importe. Hemos dumificado la variable importe en 4. Parece fácil de entender el concepto. Bien, pues esto es lo que planteo hacer con SAS. La metodología que voy a emplear es la de siempre, parto de un dataset aleatorio con un identificador y un campo importe que pretendemos transformar en 5 variables (0,1). Para realizar este proceso necesitamos una macro que cuenta las observaciones de un dataset, ya la planteé con anterioridad en otro artículo del blog. De todos modos os dejo completo el código que empieza:

``
```r
*MACRO PARA EL NUMERO DE OBSERVACIONES SIN RECORRER;

%macro numobs(ds,mv);

%global &mv.;

data _null_;

datossid=open("&ds.");

no=attrn(datossid,'nobs');

call symput ("&mv.",compress(no));

datossid=close(datossid);

run;

%mend;
```

```r
*DATASET ALEATORIO QUE HAY QUE AGRUPAR EN

FUNCION DE LA VARIABLE IMPORTE;

data uno;

do i=1 to 334560;

importe=ranuni(0)*1000;

if rand("uniform")<.04 then resp=1;

else resp=0;

if resp=0 and 200 if resp=0 and 800 output;

end;

run;
```
Vemos la macro que obtiene el número de observaciones y generamos un dataset aleatorio con 334.560 observaciones que tiene un campo importe aleatorio y un campo resp “menos aleatorio”. Al ejecutar la macro %numobs(uno,obs) tenemos la macrovariable obs y además especificamos que el número de variables de agrupación que deseamos para dumificar el campo importe será de 5. Ahora necesitaremos ordenar y categorizar las variable importe, la técnica que vamos a utilizar ya la vimos en otro artículo:

```r
*ORDENAMOS POR LA VARIABLE QUE DESEAMOS CATEGORIZAR;

proc sort data=uno; by importe; run;
```

`%numobs(uno,obs);`%let numero_de_grupos=5;``

```r
*CREAMOS 5 GRUPOS INICIALES EN FUNCION DE LA VARIABLE A

TRAMIFICAR;

data uno;

set uno;

*CREAMOS N GRUPOS;

rango=ceil((_n_/&obs.)*&numero_de_grupos.);

run;
```

Disponemos de la variable importe y una variable que tramifica este importe en 5 grupos. Ahora hemos de transformarlo en variables (0,1) para ello vamos a crear una sentencia “GR_1=0; IF RANGO= 1 THEN GR_1=1”,…,” GR_5=0; IF RANGO= 5 THEN GR_5=1”. Esto se puede hacerse manualmente o bien podemos hacer una macro variable que la contenga. Lo hacemos con un proceso que pueda ser automático y podemos hacer tantos grupos como deseemos. Esta metodología puede resultaros interesante

```r
*VARIABLES DICOTOMICAS EN FUNCION DEL NUMERO DE GRUPOS INICIALES;

data instruccion;

do i=1 to &numero_de_grupos.;

instruccion="GR_"||compress(put(i,3.))||"=0; IF RANGO="||put(i,3.)||" THEN GR_"||compress(put(i,3.))||"=1";

output;

end;

run;

proc sql noprint ;

select instruccion into:instr separated by ";"

from instruccion;

quit;

proc delete data=instruccion;
```

```r
data uno;

set uno;

&instr.;

run;
```

Muy útil, hemos construido un código reiterativo con el PROC SQL, además nos servirá para cada ocasión en la que nos enfrentemos a códigos parecidos. Ahora nuestro dataset uno aleatorio tiene unas variables grupo llamadas GR_ que agrupan una variable cuantitativa, ahora lo interesante es agrupar esa variable cuantitativa en función de una variable respuesta; pero eso será en próximas entregas. Estoy diseñando un bucle que realice una agrupación en función de una respuesta y este proceso que hoy os muestro será el primer paso.`Por supuesto, si tenéis dudas o un trabajo bien remunerado rvaquerizo@analisisydecision.es`