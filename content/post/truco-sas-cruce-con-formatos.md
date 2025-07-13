---
author: svalle
categories:
- SAS
- Trucos
date: '2008-03-04T06:18:48-05:00'
slug: truco-sas-cruce-con-formatos
tags: []
title: Truco SAS. Cruce con proc format
url: /truco-sas-cruce-con-formatos/
---

Veremos un ejemplo de ahorro de tiempo haciendo un cruce con formatos.  
Parece curioso que los formatos ahorren tiempo frente al sort/merge y sql, ya que basicamente no están hecho para esa finalidad, pero realmente podemos ahorrarnos más del 50% del tiempo.  
Además lo más costoso de este método es la carga del formato, pero una vez que lo tenemos cargado podemos hacer las selecciones de todos los grandes volumenes de datos que necesitemos, con el sort/merge, tendríamos que ordenar el conjunto de datos sas ‘grande’ otra vez si no lo teniamos ordenado.  
Este método es realmente efectivo al cruzar tablas grandes frente a pequeñas.

Ejemplo:

Nuestro conjunto SAS de ejemplo es una base de datos de los clientes de una compañía, que contiene el número de contrato y gasto que han tenido en un periodo.  
Tenemos otro conjunto de datos SAS con 100.000 contratos, queremos seleccionar el gasto que han tenido estos contratos.

Para ello tenemos que cruzar nuestra «SUPER TABLA» con nuestra «TABLA PEQUEÑA».

Tabla de ejemplo:

```r
data conjunto_LARGE;
do i=1 to 50000000;
contrato=input(left(i), $10.);
gasto=ranuni(12345)*100;
output;
end;
drop i;
run;
```
 
```r
data conjunto_SMALL;
set conjunto_LARGE (keep=contrato);
if _n_<=100000;
run;
```
 

Procedimiento 1. SORT / MERGE.

Con el Sort/ Merge tenemos que ordenar los dos conjuntos de datos.

```r
PROC SORT DATA=conjunto_LARGE;
BY CONTRATO;
RUN;
```
 
```r
NOTA: Se han leído 10000000 observaciones del conj. datos WORK.CONJUNTO_LARGE.
NOTA: El conj. datos WORK.CONJUNTO_LARGE tiene 10000000 observaciones
NOTA: PROCEDIMIENTO SORT utilizado (Tiempo de proceso total):
tiempo real 35.82 segundos
tiempo de cpu 13.07 segundos
```
 
```r
PROC SORT DATA=conjunto_SMALL;
BY CONTRATO;
RUN;
```
 
```r
NOTA: Se han leído 100000 observaciones del conj. datos WORK.CONJUNTO_SMALL.
NOTA: El conj. datos WORK.CONJUNTO_SMALL tiene 100000 observaciones .
NOTA: PROCEDIMIENTO SORT utilizado (Tiempo de proceso total):
tiempo real 0.25 segundos
tiempo de cpu 0.06 segundos
```
 
```r
DATA SELECCION;
MERGE CONJUNTO_LARGE CONJUNTO_SMALL (IN=B);
BY CONTRATO;
IF B;
RUN;
NOTA: Se han leído 10000000 observaciones del conj. datos WORK.CONJUNTO_LARGE.
NOTA: Se han leído 100000 observaciones del conj. datos WORK.CONJUNTO_SMALL.
NOTA: El conj. datos WORK.SELECCION tiene 100000 observaciones y 2 variables.
NOTA: Sentencia DATA utilizado (Tiempo de proceso total):
tiempo real 11.06 segundos
tiempo de cpu 10.07 segundos
Total del proceso:
```
 

Ordenar conjunto grande: 35.82 segundos  
Ordenar conjunto pequeño: 0.25 segundos  
Merge: 11.06 segundos  
Total: 47.13  
Con Formatos

1\. En primer lugar tengo que cargar los contratos de mi conjunto de datos pequeños a un formato.

```r
DATA CRUZO;
SET CONJUNTO_SMALL;
RENAME CONTRATO=START;
LABEL='*';
FMTNAME='$CONTRATO';
RUN;
NOTA: Se han leído 100000 observaciones del conj. datos WORK.CONJUNTO_SMALL.
NOTA: El conj. datos WORK.CRUZO tiene 100000 observaciones y 3 variables.
NOTA: Sentencia DATA utilizado (Tiempo de proceso total):
tiempo real 0.17 segundos
tiempo de cpu 0.04 segundos
```
 
```r

```
 

La variable clave con la que vamos a cruzar la tenemos

que renombrar a «START» como «LABEL» podemos poner la etiqueta que queramos,

y por último tenemos que dar un nombre al formato con «FMTNAME».

A continuación ordenamos el conjunto de datos y utilizamos la opción de proc sort nodupkey para asegurarnos de que en el caso de que haya duplicados los eliminaremos.

```r
PROC SORT DATA=CRUZO NODUPKEY;
BY START;
RUN;
NOTA: Se han leído 100000 observaciones del conj. datos WORK.CRUZO.
NOTA: 0 Se han borrado observaciones con valores de teclas duplicadas.
NOTA: El conj. datos WORK.CRUZO tiene 100000 observaciones y 3 variables.
NOTA: PROCEDIMIENTO SORT utilizado (Tiempo de proceso total):
tiempo real 0.06 segundos
tiempo de cpu 0.09 segundos
```
 

Por último cargamos el conjunto de datos.

```r
data conjunto_SMALL;
set conjunto_LARGE (keep=contrato);
if _n_<=100000;
run;
```
0 
```r
data conjunto_SMALL;
set conjunto_LARGE (keep=contrato);
if _n_<=100000;
run;
```
1 
```r
data conjunto_SMALL;
set conjunto_LARGE (keep=contrato);
if _n_<=100000;
run;
```
2 
```r
data conjunto_SMALL;
set conjunto_LARGE (keep=contrato);
if _n_<=100000;
run;
```
3 
```r
data conjunto_SMALL;
set conjunto_LARGE (keep=contrato);
if _n_<=100000;
run;
```
4 

Carga del formato:  
0.26 segundos  
Cruce con formato:  
8.53 segundos  
TOTAL PROCESO:

8.79 SEGUNDOS

frente a los 47.13 segundos.

Probad este metodo , contadnos el ahorro de tiempo y si teneís alguna otra duda.