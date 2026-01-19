---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2010-07-19'
lastmod: '2025-07-13'
related:
  - laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
  - truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql.md
  - truco-sas-cruce-con-formatos.md
  - trucos-sas-porque-hay-que-usar-objetos-hash.md
  - trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
tags:
  - vistas
  - sas
  - sql
title: Laboratorio de código SAS. Vistas + PROC MEANS vs. PROC SQL
url: /blog/laboratorio-de-codigo-sas-vistas-proc-means-vs-proc-sql/
---

Las vistas son muy importantes cuando trabajamos con SAS. El problema del espacio en disco se acentúa cuando trabajamos con SAS. Este problema podemos minimizarlo empleando vistas. También hay otras situaciones en las que se recomienda usar vistas, cuando realizamos agregaciones sobre campos de una tabla y a la vez realizamos una operación sobre estos campos es muy habitual emplear el PROC SQL. Ejemplo de lo que cuento:

```r
data importes;

do idcliente=1 to 2000000;

importe=ranuni(34)*1000;

output;

end;

run;

*FORMA 1: SQL;

proc sql;

select var(sqrt(importe)), var(importe)

from importes;

quit;
```

Sobre una tabla con 2.000.000 de registros hacemos la varianza de un campo importe y de la raiz cuadrada de ese mismo campo importe. Es decir, hacemos la varianza sobre la operación aritmética de un campo. Para hacer este trabajo con PROC MEANS sin tener que crear un nuevo campo en la tabla haríamos una vista y un MEANS posteriormente:

```r
*FORMA 2: VISTA + MEANS;

data cuadrado/view=cuadrado;

set importes;

imp=sqrt(importe);

run;

proc means data=cuadrado var;

var importe imp;

quit;
```

El código es más farragoso. ¿De verdad compensa en tiempo de ejecución la creación de vistas? Vamos a dar respuesta con la famosa macro que lanza ejecuciones y guarda tiempos. El método 1 es vista+means y el método 2 es SQL, he cambiado el orden:

```r
%macro aniade(descripcion);

data borra;

ejecucion=&i.;

metodo="&descripcion.";

tiempo=time()-&inicio.;

output;

run;

data test;

set test borra;

proc delete data=borra; run;

%mend;

*TENEMOS 4 FORMAS DE REALIZAR EL PROCESO;

%macro test(ejecuciones);

%do i=1 %to &ejecuciones.;

%let inicio=%sysfunc(time());

*VISTA + PROC MEANS;

data cuadrado/view=cuadrado;

set importes;

imp=sqrt(importe);

run;

proc means data=cuadrado var;

var importe imp;

quit;

%if &i=1 %then %do;

data test;

ejecucion=&i.;

length metodo $20.;

metodo="METODO 1 ";

tiempo=time()-&inicio.;

output;

%end; %else %do;

%aniade(METODO 1);

%end;

%let inicio=%sysfunc(time());

*PROC SQL;

proc sql;

select var(sqrt(importe)), var(importe)

from importes;

quit;

%aniade(METODO 2);

%end;

%mend;

*LANZAMOS 10 EJECUCIONES;

%test(10);

*ORDENAMOS POR TIEMPO;

proc sort data=test; by tiempo; run;
```

Ejecutadlo. El método 1 vista + means es mucho más rápido en ejecución. Aunque con 2 millones de registros los tiempos no son destacables si trabajamos con un volumen mayor un 20% más de tiempo de ejecución puede ser mucho. **Hay que trabajar más con vistas** , incluso en SAS.
