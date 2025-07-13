---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2009-11-06T09:18:58-05:00'
slug: monografico-datos-agrupados-en-sas
tags:
- by
- first
- last
- retain
title: Monográfico. Datos agrupados en SAS
url: /monografico-datos-agrupados-en-sas/
---

A continuación os planteo un monográfico más orientado a principiantes con SAS. Vamos a realizar un acercamiento a los conjuntos de datos SAS agrupados por variables. La premisa fundamental es: **un conjunto de datos SAS está agrupado por una variable si está ordenado por ella**. Para ordenar variables empleamos el PROC SORT:

PROC SORT DATA= ;  
BY (DESCENDING) ;  
RUN;

**Repetimos un conjunto de datos SAS puede agruparse por una o varias variables si está ordenado por ellas**. Algunas de las posibilidades que nos ofrecen este tipo de conjuntos de datos son:

• Buscar máximos y mínimos por grupos  
• Crear ranking por grupos  
• Realizar sumarizaciones  
• Unir conjuntos de datos

Para ilustrar esto ejemplos vamos a emplear un conjunto de datos SAS de la librería SASHELP llamado SHOES que todos tenemos en nuestra sesión y que contiene las siguientes variables:

# Variable  
1 Region  
2 Product  
3 Subsidiary  
4 Stores  
5 Sales  
6 Inventory  
7 Returns

La primera tarea encomendada es encontrar el mínimo y el máximo número de tiendas por producto en el total de las regiones:

```r
data ejemplo;

set sashelp.shoes;

proc sort data=ejemplo; by product stores; quit;

proc freq; tables product; quit;
```

Trabajamos con una copia del dataset de SASHELP y lo primero es realizar la ordenación por la variable que nos agrupa nuestra tabla y después por la variable que deseamos estudiar. Con FREQ realizamos una tabla de frecuencias y observamos que tenemos 8 grupos, 8 tipos de productos. Una vez realizada la ordenación a la hora de leer el dataset hemos de emplear la instrucción BY:

```r
data minimos_maximos;

set ejemplo;

by product;

if first.product then minimo=stores;

if last.product then maximo=stores;

if minimo ne . or maximo ne .; drop stores--Returns;

run;

proc print; quit;
```

Al emplear la instrucción BY disponemos de dos nuevas variables de sistema que sólo aparecen durante la ejecución del paso data: FIRST. y LAST.. Estas dos variables no producen salida alguna. Como es evidente FIRST toma valor 1 (verdadero) cuando estamos ante el primer registro del grupo y LAST toma el valor 1 cuando estamos ante el último registro del grupo. Como hemos limitado la salida a datos con mínimos o máximo obtenemos 2 registros por cada uno de los 8 grupos de productos.

Otra de las tareas habituales con conjuntos de datos agrupados es la realización de ranking por grupo. Si, por ejemplo, deseamos realizar un ranking de ventas por región tendremos que hacer:

```r
proc sort data=ejemplo; by region sales; quit;

data ranking;

set ejemplo;

by region;

retain posicion ;

if first.region then posicion=1;

else posicion=posicion+1;

run;
```

Lo primero es ordenar por región y descendentemente por ventas. En este ejemplo empleamos una nueva instrucción RETAIN . Esta instrucción guarda el valor de la variable indicada para la siguiente iteración del paso data. Con BY hemos activado FIRST y LAST. De esta manera si estamos ante el primer registro por region la posición del ranking será 1, en caso contrario sumamos 1 a la variable retenida posicion.

Si deseamos crear sumarizaciones la metodología será igual que la anterior:

```r
proc sort data=ejemplo; by region sales; quit;

data suma_region;

set ejemplo;

by region;

retain total_ventas;

if first.region then total_ventas=sales;

else total_ventas=sum(total_ventas,sales);

if last.region then output;

keep region total_ventas;

run;
```
``La unión de conjuntos de datos SAS tendremos que analizarla en capítulos posteriores, pero es imprescindible recordar que, para unir conjuntos de datos SAS éstos han de estar agrupados por la variable que realiza la unión. Como siempre si tenéis cualquier duda, sugerencia o trabajo a tiempo parcial que me permita jugar más tiempo con mis hijos podéis contactar conmigo en rvaquerizo@analisisydecsision.es``