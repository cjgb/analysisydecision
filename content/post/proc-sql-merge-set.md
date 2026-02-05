---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2009-08-12'
lastmod: '2025-07-13'
related:
  - capitulo-4-uniones-de-tablas-con-r.md
  - tipos-de-uniones-join-de-tablas-con-python-pandas.md
  - truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql.md
  - truco-sas-cruce-con-formatos.md
  - en-merge-mejor-if-o-where.md
tags:
  - formación
  - sas
title: Equivalencias entre PROC SQL y DATA en las uniones de tablas SAS
url: /blog/proc-sql-merge-set/
---

Muchos de los que llegan a programar con SAS son grandes expertos en `SQL`. Cuando dominas perfectamente un lenguaje, es difícil acostumbrarse a otro. Por ello, quiero plantear un artículo que estudie los tipos de uniones mediante pasos `DATA` y su análogo con el `PROC SQL`. Con ello espero que los profesionales que manejan el lenguaje `SQL` entiendan mejor el paso `DATA`. En mi línea habitual, creo dos *datasets* y manejo ejemplos.

```sas
data uno;
    input anio importe;
    cards;
2000 100
2001 200
2002 300
2003 350
2004 375
2005 450
;
run;

data dos;
    input anio importe2;
    cards;
2003 550
2004 775
2005 650
2006 900
2007 450
;
run;
```

Las formas de unir conjuntos de datos SAS son:

### Uniones verticales

**Concatenación:**

```sas
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

**Intercalación:**

```sas
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

### Uniones horizontales

**Total (Full Join):**

```sas
data cincoA;
    merge uno dos;
    by anio;
run;

proc sql;
    create table cincoB as 
    select coalesce(a.anio, b.anio) as anio,
           a.importe,
           b.importe2
    from uno a full join dos b
    on a.anio = b.anio;
quit;
```

**Excluyentes:**

*Están en ambas tablas (Inner Join):*

```sas
data seisA;
    merge uno (in=en_uno) dos (in=en_dos);
    by anio;
    if en_uno and en_dos;
run;

proc sql;
    create table seisB as 
    select a.anio, a.importe, b.importe2
    from uno a inner join dos b
    on a.anio = b.anio;
quit;
```

*Están en la tabla de la izquierda (Left Join):*

```sas
data sieteA;
    merge uno (in=en_uno) dos (in=en_dos);
    by anio;
    if en_uno;
run;

proc sql;
    create table sieteB as 
    select a.anio, a.importe, b.importe2
    from uno a left join dos b
    on a.anio = b.anio;
quit;
```

*Están en la tabla de la derecha (Right Join):*

```sas
data ochoA;
    merge uno (in=en_uno) dos (in=en_dos);
    by anio;
    if en_dos;
run;

proc sql;
    create table ochoB as 
    select coalesce(a.anio, b.anio) as anio,
           a.importe,
           b.importe2
    from uno a right join dos b
    on a.anio = b.anio;
quit;
```

No he comentado los ejemplos porque son bastante claros. Como veis, en `SQL` es muy importante el orden en el que se nombran las variables; por eso para algunos ejemplos empleamos `COALESCE` o `CASE`. Sin ello, el resultado no sería el esperado, ya que nos tomaría la variable `anio` del primer *dataset* que aparece en la `SELECT`; para el resto, nos pondría valores perdidos.

En el terreno profesional, se emplea mucho la `INNER JOIN` y la `LEFT JOIN`, fundamentalmente cuando unimos dos *datasets* con índices y deseamos prescindir de ordenaciones previas por ser muy costosas. Si trabajamos con uniones de más de dos *datasets*, recomiendo trabajar con `MERGE`. Es habitual partir de una tabla base y añadirle información de otras en un paso `DATA` final. 

Por supuesto, si tenéis dudas o más sugerencias… `rvaquerizo@analisisydecision.es`. Saludos.