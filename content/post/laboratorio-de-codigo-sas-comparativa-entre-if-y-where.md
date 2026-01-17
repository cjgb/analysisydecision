---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2009-11-03T08:57:27-05:00'
lastmod: '2025-07-13T15:59:14.734327'
related:
- en-merge-mejor-if-o-where.md
- laboratorio-de-codigo-sas-vistas-proc-means-vs-proc-sql.md
- truco-sas-cruce-con-formatos.md
- laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort.md
- curso-de-lenguaje-sas-con-wps-sentencias-condicionales-if-then.md
slug: laboratorio-de-codigo-sas-comparativa-entre-if-y-where
tags: []
title: Laboratorio de código SAS. Comparativa entre IF y WHERE
url: /blog/laboratorio-de-codigo-sas-comparativa-entre-if-y-where/
---

Inicio hoy otra serie de mensajes para analizar el uso óptimo del código SAS. La intención es comparar distintas ejecuciones y obtener un pequeño reporte con la metodología y el tiempo empleado en su ejecución. Para evitar el efecto que pueda causar la concurrencia en un servidor con SAS se realizarán múltiples ejecuciones. He intentado que el código que utilizo para comparar las ejecuciones sea lo más sencillo posible. Soy consciente que se puede usar un código más «profesional» o un código más «sencillo» pero lo que planteo a continuación me parece la mejor solución. La idea es hacer una macro que haga N ejecuciones para evitar el efecto concurrencia. Cada método tendrá una ejecución, esta ejecución se controlará con una macrovariable con la hora del sistema. Esta mv se guardará en una tabla SAS junto con un nombre que le damos al método y la ejecución realizada. Al final lo más sencillo es ordenar por el tiempo de ejecución e imprimir el resultado.

Para iniciar esta serie comenzamos con la comparativa entre IF y WHERE, ya hicimos algo parecido dentro de un MERGE, pero ahora vamos a hacerlo con y sin índices. Los métodos a emplear serán:

Método 1: IF
Método 1 BIS: IF + DELETE
Método 2: WHERE como instrucción
Método 3: WHERE como opción de escritura
Método 4: WHERE como opción de lectura

Partimos de una tabla SAS aleatoria con los registros que deseemos:

```r
data uno /*(INDEX=(importe))*/;

do i=1 to 1000000;

importe=rand("uniform")*10000;

output;

end;

run;
```

En el bucle podemos indicar el número de observaciones, yo pruebo con 1 millón. A continuación os planteo las macros que he creado para realizar el experimento:

```r
*ESTA MACRO HACE EL FICHERO TEST;

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
```

```r
*TENEMOS 4 FORMAS DE REALIZAR EL PROCESO;

%macro test(ejecuciones);

%do i=1 %to &ejecuciones.;

%let inicio=%sysfunc(time());

*EMPLEO DE IF;

data dos;

set uno;

if importe<5000;

run;

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

*EMPLEO DE IF + DELETE;

data dos_prima;

set uno;

if importe>=5000 then delete;

run;

%aniade(METODO 1 BIS);

%let inicio=%sysfunc(time());

*EMPLEO DE WHERE COMO INSTRUCCION;

data tres;

set uno;

where importe<5000;

run;

%aniade(METODO 2);;

%let inicio=%sysfunc(time());

*EMPLEO DE WHERE COMO ESCRITURA;

data cuatro(where=(importe<5000));

set uno;

run;

%aniade (METODO 3);

%let inicio=%sysfunc(time());

*EMPLEO DE WHERE COMO LECTURA;

data cinco;

set uno (where=(importe<5000));

run;

%aniade(METODO 4);;

%end;

proc delete data=dos dos_prima tres cuatro cinco; run;

%mend;

%test(4);
```
`Ya sólo ordeno el dataset test y hago un PROC PRINT:`

```r
proc sort data=test; by tiempo; run;

proc print noobs; run;
```

Los resultados obtenidos son:

ejecucion | metodo | tiempo | 3 | METODO 1 | 0.46669
---|---|---
2 | METODO 1 BIS | 0.47193
1 | METODO 1 | 0.48187
1 | METODO 1 BIS | 0.48938
2 | METODO 1 | 0.49601
3 | METODO 1 BIS | 0.50882
2 | METODO 4 | 0.52143
4 | METODO 1 | 0.53394
3 | METODO 2 | 0.54146
4 | METODO 1 BIS | 0.54989
1 | METODO 2 | 0.57792
1 | METODO 4 | 0.61899
2 | METODO 2 | 0.64726
3 | METODO 4 | 0.65905
4 | METODO 2 | 0.70540
4 | METODO 4 | 0.75455
4 | METODO 3 | 1.01269
1 | METODO 3 | 1.08197
3 | METODO 3 | 1.19255
2 | METODO 3 | 1.20838

Se observa que el método 3 WHERE como opción de escritura es el peor de todos. Los dos métodos con IF son los que mejores resultados han obtenido. WHERE como instrucción o como opción de lectura han obtenido resultados muy parecidos. Si realizamos la ejecución con índices:

ejecucion | metodo | tiempo | 4 | METODO 1 | 0.47086
---|---|---
4 | METODO 1 BIS | 0.48211
3 | METODO 1 | 0.49148
1 | METODO 1 | 0.50192
2 | METODO 1 | 0.51209
1 | METODO 1 BIS | 0.52227
2 | METODO 1 BIS | 0.52323
4 | METODO 2 | 0.53204
3 | METODO 1 BIS | 0.53216
3 | METODO 2 | 0.57371
1 | METODO 2 | 0.57886
4 | METODO 4 | 0.58222
3 | METODO 4 | 0.59596
2 | METODO 4 | 0.59631
2 | METODO 2 | 0.59716
1 | METODO 4 | 0.61539
3 | METODO 3 | 0.97408
4 | METODO 3 | 0.99680
1 | METODO 3 | 1.01555
2 | METODO 3 | 1.03185

Los resultados son muy parecidos pero el método 2 parece que mejora ligeramente al método 4. Seguiremos empleando estos códigos para comparar distintas formas de ejecutar código SAS y por supuesto si tenéis dudas, sugerencias o un trabajo interesante para que no me sienta perezoso por las mañanas [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)