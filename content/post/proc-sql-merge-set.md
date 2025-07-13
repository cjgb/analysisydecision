---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2009-08-12T02:57:08-05:00'
lastmod: '2025-07-13T16:04:43.614641'
related:
- capitulo-4-uniones-de-tablas-con-r.md
- tipos-de-uniones-join-de-tablas-con-python-pandas.md
- truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql.md
- truco-sas-cruce-con-formatos.md
- en-merge-mejor-if-o-where.md
slug: proc-sql-merge-set
tags: []
title: Equivalencias entre PROC SQL y DATA en las uniones de tablas SAS
url: /proc-sql-merge-set/
---

Muchos de los que llegan a programar con SAS son grandes expertos en SQL. Cuando dominas perfectamente un lenguaje es difícil acostumbrarse a otro. Por ello quiero plantear un artículo que estudie los tipos de uniones mediante pasos DATA y su análogo con el PROC SQL. Con ello espero que los profesionales que manejan el lenguaje SQL entiendan mejor el paso DATA. En mi línea habitual creo dos dataset y manejo ejemplos.

```r
data uno;

input anio importe;

cards;

2000 100

2001 200

2002 300

2003 350

2004 375

2005 450

; run;

data dos;

input anio importe2;

cards;

2003 550

2004 775

2005 650

2006 900

2007 450

; run;
```

Las formas de unir conjuntos de datos SAS son:

**Uniones verticales:**

_Concatenación:_  

```r
data tresA;

set uno dos;

run;

proc sql;

create table tresB as

select * from uno

outer union corr

select * from dos;

quit;
```

_Intercalación:_  

```r
data cuatroA;

set uno dos;

by anio;

run;

proc sql;

create table cuatroB as

select * from uno

outer union corr

select * from dos

order by anio;

quit;
```

**Uniones horizontales:**

_Total:  
_
```r
data cincoA;

merge uno dos;

by anio;

run;

proc sql;

create table cincoB as select

case

when a.anio is null then b.anio

else a.anio end as anio,

*

from uno a full join dos b

on a.anio = b.anio;

quit;
```

_Excluyentes:_

Están en ambas tablas:  

```r
data seisA;

merge uno (in=en_uno) dos (in=en_dos);

by anio;

if en_uno and en_dos;

run;

proc sql;

create table seisB as select

*

from uno a, dos b

where a.anio = b.anio;

quit;

proc sql;

create table seisC as select

*

from uno a inner join dos b

on a.anio = b.anio;

quit;
```

Están en la tabla de la izquierda:  

```r
data sieteA;

merge uno (in=en_uno) dos (in=en_dos);

by anio;

if en_uno;

run;

proc sql;

create table sieteB as select

*

from uno a left join dos b

on a.anio = b.anio;

quit;
```

Están en la tabla de la derecha:

```r
data ochoA;

merge uno (in=en_uno) dos (in=en_dos);

by anio;

if en_dos;

run;

proc sql;

create table ochoB as select

case

when a.anio is null then b.anio

else a.anio end as anio,

*

from uno a right join dos b

on a.anio = b.anio;

quit;
```

No he comentado los ejemplos porque son bastante claros. Como véis en SQL es muy importante el orden en el que se nombran las variables por eso para algunos ejemplos empleamos el CASE, si él el resultado no sería el esperado ya que nos tomaría la variable anio del primer dataset que aparece en la select, para el resto nos pondría valores perdidos, probad los ejemplos sin el case y entenderéis porque lo empleo. En el terreno profesional comentaros que se emplea mucho la INNER JOIN y la LEFT JOIN fundamentalmente cuando unimos 2 datasets con índices y deseamos prescindir de ordenaciones previas por ser muy costosas. Si trabajamos con uniones de más de 2 datasets recomiendo trabajar con MERGE. Es habitual partir de una tabla base y añadirla información de otras en un paso DATA final. Por supuesto si tenéis dudas, más sugerencias o un empleo que me permita estar más tiempo con mi familia que pronto pasará a ser numerosa estoy en rvaquerizo@analisisydecision.es