---
author: rvaquerizo
categories:
- Formación
- Monográficos
- SAS
date: '2010-11-15T05:47:21-05:00'
lastmod: '2025-07-13T15:59:16.143113'
related:
- objetos-hash-para-ordenar-tablas-sas.md
- la-importancia-del-parametro-hashexp.md
- trucos-sas-porque-hay-que-usar-objetos-hash.md
- truco-sas-cruce-con-formatos.md
- laboratorio-de-codigo-sas-comparativa-entre-if-y-where.md
slug: laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort
tags:
- Objetos HASH
- proc sort
title: Laboratorio de código SAS. Ordenaciones con HASH vs. PROC SORT
url: /laboratorio-de-codigo-sas-ordenaciones-con-hash-vs-proc-sort/
---

[Hace pocas fechas vimos el código SAS empleado para la realización de ordenaciones de conjuntos de datos SAS mediante algoritmos de hash](https://analisisydecision.es/objetos-hash-para-ordenar-tablas-sas/). Ya os comuniqué que era una forma más eficiente y hoy quería demostraros tal eficiencia con un laboratorio de código SAS. La situación es la siguiente, creamos un dataset con 1.000.000 de registros, 13 variables y comparamos un PROC SORT con una ordenación mediante hash, medimos tiempos y podemos determinar qué forma de ordenación es más eficiente.

Si disponéis de una versión de SAS superior al 9.1 me gustaría que ejecutarais las siguientes líneas. No es un código muy complejo pero si alguien tiene dudas en su funcionamiento o le gustaría profundizar más en lo que hace que comente el mensaje, no lo hagáis vía correo electrónico porque tengo muchos mensajes en cola y poco tiempo para responder. El código para la realización de este experimento ya lo hemos visto en mensajes anteriores y es el siguiente:

```r
*DS DE PRUEBA PARA COMPARACION DE TIEMPOS;

data uno;

array v(10);

do i=1 to 1000000;

importe=ranuni(mod(time(),1)*1000)*10000;

do j=1 to 5;

v(j)=ranuni(34)*100;

end;output;end;

run;

*MACROS QUE REALIZAN LA PRUEBA;

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

*TENEMOS 2 FORMAS DE REALIZAR EL PROCESO;

%macro test(ejecuciones);

%do i=1 %to &ejecuciones.;

%let inicio=%sysfunc(time());

*PROC SORT;

proc sort data=uno out=dos ;

by importe;

run;

%if &i=1 %then %do;

data test;

ejecucion=&i.;

length metodo $20.;

metodo="PROC SORT";

tiempo=time()-&inicio.;

output;

%end; %else %do;

%aniade(PROC SORT);

%end;

%let inicio=%sysfunc(time());

*OBJETOS HASH;

data _null_;

  if 0 then set uno;

  declare hash obj (dataset:'uno',hashexp:20, ordered:'a') ;

  obj.definekey ('importe');

  obj.definedata(all:'YES');

  obj.definedone () ;

  obj.output(dataset:'dos');

  stop;

run;

%aniade(HASH);

%end;

%mend;

*LANZAMOS 10 EJECUCIONES;

%test(10);

*ORDENAMOS POR TIEMPO;

proc sort data=test; by tiempo; run;
```

Para los que me seguís habitualmente este código os resultará familiar. El código empleado para la ordenación con hash ya lo vimos en anteriores entradas, es el mismo. Pero me gustaría recalcar el uso de la opción HASHEXP en este caso 20 (2**20 = 1.048.576 tablas que se reparten el objeto). Veamos el resultado:

![ejecucion-hash-1.PNG](/images/2010/11/ejecucion-hash-1.PNG)

Las ordenaciones empleando este tipo de objetos son más rápidas. Sin embargo replico el experimento modificando el exponente hashexp:5, relanzo el código y me encuentro lo siguiente:

![ejecucion-hash-2.PNG](/images/2010/11/ejecucion-hash-2.PNG)

Mejoramos mucho el tiempo empleado para la ordenación, esto implica que un exponente muy alto no garantiza una mayor velocidad. Así pues hemos de jugar con esta opción, si me da tiempo en estos dos días que me quedan con SAS 9.2 analizaremos como modificar los exponentes. En determinadas circunstancias incluso un PROC SORT puede ser más eficiente que HASH si no empleamos un exponente correcto. Espero que estas líneas despierten vuestra curiosidad sobre estos algoritmos y, sobre todo, permitan que vuestro trabajo diario sea más eficiente. Saludos.