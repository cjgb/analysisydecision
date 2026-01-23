---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
  - trucos
date: '2011-05-16'
lastmod: '2025-07-13'
related:
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - monograficos-call-symput-imprescindible.md
  - trucos-sas-calcular-percentiles-como-excel-o-r.md
  - trucos-sas-variables-dummy-de-una-variable-continua.md
  - trucos-sas-medir-la-importancia-de-las-variables-en-nuestro-modelo-de-regresion-logistica.md
tags:
  - outliers
  - proc univariate
  - sas procs
title: Macros (fáciles) de SAS. Eliminar outliers en una variable
url: /blog/macros-faciles-de-sas-eliminar-outliers-en-una-variable/
---

Hace tiempo ya os propuse una[ chapuza para eliminar `outliers` de forma `multivariante`](https://analisisydecision.es/trucos-sas-eliminacion-de-outliers-2/). Por supuesto quedaba**eliminar `outliers` en una `variable`**. Recortar los valores extremos en aquellas `variables cuantitativas` que deseemos. Para ello os propongo una `macro` que no considero muy compleja y que os `analisis`aré con mayor detalle, pero lo primero la `macro` al completo:

```sas
%macro elimina_outliers(

varib,  /*VARIABLE PARA ELIMINAR EL OUTLIER*/

entrada,/*DATASET DE ENTRADA*/

salida, /*DATASET DE SALIDA, PUEDE SER EL MISMO DE ENTRADA*/

corte_inferior, /*% DE CORTE INFERIOR*/

corte_superior);/*% DE CORTE SUPERIOR*/

*******************************************************************;

*CREAMOS LOS PERCENTILES;

data _null_;

call symput ("lim1",compress(0+&corte_inferior.));

call symput ("lim2",compress(100-&corte_superior.));

run;

*PREPARAMOS MV CON LOS NOMBRES QUE OBTENDREMOS DEL PROC UNIVARIATE;

data _null_;

call symput ('nom_lim1',compress("P_"||tranwrd("&lim1.",'.','_')));

call symput ('nom_lim2',compress("P_"||tranwrd("&lim2.",'.','_')));

run;

*EL UNIVARIATE GENERA UNA SALIDA SOLO CON LOS PERCENTILES DESEADOS;

proc univariate data=&entrada. noprint;

var &varib.;

output out=sal pctlpre=P_ pctlpts=&lim1.,&lim2.;

quit;

*CREAMOS MV CON LOS CORTES DESEADOS;

data _null_;

set sal;

call symput("inf",&nom_lim1.);

call symput("sup",&nom_lim2.);

run;

*REALIZAMOS EL FILTRO;

data &salida.;

set &entrada.;

if &varib.>&inf. and &varib.<&sup.;

run;

proc delete data=sal;run;

%mend;
```

Su ejemplo de uso correspondiente:

```sas
data ent;

do i=1 to 10000;

importe=rannor(2)*1000;

if ranuni(3) >= 0.95 then importe=importe * 10;

if ranuni(4) >= 0.05 then importe=importe / 10;

output;

end;

run;

*ANALIZAMOS LA VARIABLE IMPORTE;

proc univariate data=ent;

var importe;

histogram;

quit;

*RECORTAMOS UN 5% POR ARRIBA Y UN 5% POR DEBAJO;

%elimina_outliers(importe,ent,salida,5,5);

proc univariate data=salida;

var importe;

histogram;

quit;
```

Tenemos 2 histogramas, uno es imposible pero el otro nos permite conocer un poco mejor la distribución de la `variable importe` tras recortar un 5% las observaciones tanto por arriba como por abajo. `Analisis`emos brevemente el código utilizado en la `macro`:

```sas
%macro elimina_outliers(

varib,  /*VARIABLE PARA ELIMINAR EL OUTLIER*/

entrada,/*DATASET DE ENTRADA*/

salida, /*DATASET DE SALIDA, PUEDE SER EL MISMO DE ENTRADA*/

corte_inferior, /*% DE CORTE INFERIOR*/

corte_superior);/*% DE CORTE SUPERIOR*/

*******************************************************************;
```

Los parámetros de la `macro` son sencillos, la `variable` que recortamos (`VARIB`), el `dataset` de `entrada` (`ENTRADA`), el `dataset` de `salida` (`SALIDA`) que puede ser el mismo, el `corte inferior` y el `corte superior` en `porcentaje`, si no se quiere recortar ponemos 0.

```sas
*CREAMOS LOS PERCENTILES;

data _null_;

call symput ("lim1",compress(0+&corte_inferior.));

call symput ("lim2",compress(100-&corte_superior.));

run;

*PREPARAMOS MV CON LOS NOMBRES QUE OBTENDREMOS DEL PROC UNIVARIATE;

data _null_;

call symput ('nom_lim1',compress("P_"||tranwrd("&lim1.",'.','_')));

call symput ('nom_lim2',compress("P_"||tranwrd("&lim2.",'.','_')));

run;
```

En los parámetros ponemos los porcentajes y esos porcentajes se tienen que transformar en `percentiles`. Después creamos los nombres para los `percentiles` de forma que el `PROC UNIVARIATE` los “entienda”, es decir, con la forma `P_97.5` o `P_5`. Os lo pongo en 2 pasos para hacerlo lo más comprensible posible.

```sas
*EL UNIVARIATE GENERA UNA SALIDA SOLO CON LOS PERCENTILES DESEADOS;

proc univariate data=&entrada. noprint;

var &varib.;

output out=sal pctlpre=P_ pctlpts=&lim1.,&lim2.;

quit;
```

Esta es la parte más interesante de este proceso, el `PROC UNIVARIATE` va a crear un `dataset` con el valor de los `percentiles` que queremos recortar, esto se realiza en la sentencia `OUTPUT` con la instrucción `pclpre=P_` y `pctlpts=limite_infereior,limite_superior`. Los límites están en unas `macrovariables` y el conjunto de `datos SAL` contendrá los valores sobre los que recortamos la `variable`.

```sas
*CREAMOS MV CON LOS CORTES DESEADOS;

data _null_;

set sal;

call symput("inf",&nom_lim1.);

call symput("sup",&nom_lim2.);

run;

*REALIZAMOS EL FILTRO;

data &salida.;

set &entrada.;

if &varib.>&inf. and &varib.<&sup.;

run;

proc delete data=sal;run;

%mend;
```

Por último creamos 2 `macrovariables` con los valores de corte y realizamos un `paso data` donde filtramos por esos valores.

Creo que es un código con algún aspecto interesante y que puede seros práctico a la hora de `analisis`ar de forma `univariante` algunas `variables`. Saludos.