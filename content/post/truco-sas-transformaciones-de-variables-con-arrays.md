---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
date: '2008-09-18T08:24:33-05:00'
slug: truco-sas-transformaciones-de-variables-con-arrays
tags: []
title: Truco SAS. Transformaciones de variables con arrays
url: /truco-sas-transformaciones-de-variables-con-arrays/
---

Hacer ceros los missing en un dataset. Crear una etiqueta «NO DISPONIBLE» en campos carácter sin valores. Cuando trabajamos con SAS es una situación más que habitual. A continuación voy a plantear un par de ejemplos de como podemos usar arrays de variables en SAS para realizar una transformación «masiva» de variables de nuestro conjunto de datos.

Poner missing numéricos a 0:

Lo primero es destacar que no siempre un valor perdido equivale a 0. Cuando realizamos modelos es necesario tener en cuenta que hacemos con los missing, el siguiente ejemplo transforma todos los . de un dataset a 0:

```r
*DATASET DE EJEMPLO QUE GENERA DIVISIONES POR 0;

data uno;

 do id=1 to 200;

 importe1=ranuni(2)/ranpoi(9,2) * 10000;

 importe2=ranuni(1)/ranpoi(12,2) * 1000;

 venta1=ranuni(3)/ranpoi(5,1) * 1000;

 venta4=ranuni(6)/ranpoi(7,4) * 10000;

 output;

 end;

run;
```

Partimos de un dataset aleatorio que genera divisiones por 0, que genera valores perdidos. Necesitamos tranformar estos valores perdidos en ceros:

```r
data uno;

 set uno;

*ARRAY DE DIMENSION TOTAL DE NUMERICAS;

 array c (*) _numeric_;
```

```r
*BUCLE QUE RECORRE EL ARRAY;

 do i = 1 to dim(c);

  if c(i)=. then c(i)=0;

 end;

 drop i;
```

run;

Creamos un array c que recoge todas las variables numéricas lo recorremos y transformamos las variables.

Valores de texto «NO DISPONIBLE»:

En este caso se trata de recorrer una tabla y poner los valores missing de caracteres con el valor «NO DISPONIBLE».

``
```r
data dos;

infile datalines delimiter=",";

format nombre apellido1 apellido2 15.;

input nombre apellido1 apellido2;

datalines;

RAUL,VAQUERIZO,

MARIA JOSE,FERNANDEZ,LOPEZ,

LUCAS,EXPOSITO,DAZA,

 ,MIER,DAZA

RICARDO,ENRIQUEZ,

;

run;
```

Generamos un dataset con nombres. Algunos de estos nombres no tienen valores para el segundo apellido o el nombre. Hemos de recorrer la tabla y sustituir valores:

```r
data dos;

 set dos;

 array c (*) _character_;

 do i=1 to dim(c);

  if missing(c(i)) then c(i)="NO DISPONIBLE";

 end;

 drop i;

run;
```

Metodología completamente análoga a la anterior. Además podemos emplearla para buscar registros dentro de tablas. Imaginemos que deseamos identificar todas las personas que se apellidan Daza:

data tres;  
set dos;  
array c (*) _character_;  
do i=1 to dim(c);  
if index(upcase(c(i)),»DAZA»)>0 then output tres;  
end;  
drop i;  
run;

Este truco es muy útil para recorrer tablas de dimensiones en busca de valores. Por supuesto cualquier duda… rvaquerizo@analisisydecision.es