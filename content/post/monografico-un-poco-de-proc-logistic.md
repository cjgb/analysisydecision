---
author: rvaquerizo
categories:
- Banca
- Data Mining
- Formación
- Modelos
- Monográficos
- SAS
date: '2010-06-24T09:24:38-05:00'
lastmod: '2025-07-13T16:02:59.493639'
related:
- arboles-de-decision-con-sas-base-con-r-por-supuesto.md
- monografico-regresion-logistica-con-r.md
- monografico-arboles-de-clasificacion-con-rpart.md
- macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
- monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
slug: monografico-un-poco-de-proc-logistic
tags:
- ''
- PROC LOGISTIC
- regresión logística
title: Monográfico. Un poco de PROC LOGISTIC
url: /blog/monografico-un-poco-de-proc-logistic/
---

El **PROC LOGISTIC** es un procedimiento de SAS que nos ha dado muchas satisfacciones a los dinosaurios como el ahora escribiente. La [regresión logística ](http://es.wikipedia.org/wiki/Regresi%C3%B3n_log%C3%ADstica)es uno de los modelos de regresión más utilizados y es bien conocido por todos mis lectores (bastante más inteligentes que yo). El problema es muy sencillo hemos de clasificar una población dividida en dos partes a partir de unas variables independientes. Su aplicación es muy extensa: patrones de fuga, propensiones a compra, salud, fraude,… Con este monográfico pretendo acercaros en 3 minutos a las sentencias básicas en **SAS** para crear un modelo de regresión logística y proponer gráficos y validaciones. En la línea habitual del blog partimos de una simulación y analizamos la sintaxis, evitamos poner las salidas para no “cargar” la entrada con tablas de poca utilidad. El ejemplo es el que sigue:

```r
data datos;

do id_cliente=1 to 20000;

edad=min(65,ranpoi(4,45));

pasivo=ranuni(4)*10000+ranuni(12)*(10000*(edad-5));

compras=round(pasivo/(ranexp(423)*1000));

vinculacion=max(1,ranpoi(2,round(pasivo/300000)+1));

recibos=ranpoi(1,2);

provincia=min(52,ranpoi(123,28));

output;

end;

run;
```

Conjunto de datos SAS con 20000 clientes de **Banca Personal** de una entidad bancaria que están en proceso de desvinculación. Otra entidad se ha puesto en contacto con rvaquerizo@analisisydecision.es y le han realizado un modelo de potencial de pasivo, un modelo de **Share of Wallet** de clientes que está funcionando a las mil maravillas y detectan que esta entidad les está provocando una reducción de pasivo y desvinculación de algunos de sus clientes. Lo detectan gracias al mecanismo de alarmas que diseñó rvaquerizo@analisisydecision.es (un poco de publicidad que todo esto sale de mi tiempo y mi bolsillo). El equipo comercial se pone en marcha y es necesario determinar aquellos clientes que tienen una mayor probabilidad de contratar un depósito a plazo que contrareste esta fuga de pasivo. Para ello hemos de “inventarnos” qué clientes tienen un alto potencial de contratación:

```r
*CREAMOS EL POTENCIAL DE COMPRA;

data sasuser.datos;

set datos;

potencial=0.3;

*MODIFICAMOS LIGERAMENTE EL POTENCIAL;

*EDAD;

if edad<30 then potencial=potencial+0.05*ranuni(13);

else if edad<40 then potencial=potencial+0.03*ranuni(13);

else if edad<45 then potencial=potencial+0.04*ranuni(13);

else if edad<55 then potencial=potencial+0.05*ranuni(13);

else potencial=potencial+0.02*ranuni(13);

*RECIBOS;

if recibos<=2 then potencial=potencial+0.01*ranuni(13);

else if recibos<=4 then potencial=potencial+0.03*ranuni(13);

else potencial=potencial+0.05*ranuni(13);

*VINCULACION;

if vinculacion<=5 then potencial=potencial-0.01*ranuni(13);

else if vinculacion<=8 then potencial=potencial+0.05*ranuni(13);

else if vinculacion<=12 then potencial=potencial+0.2*ranuni(13);

else potencial=potencial+0.4*ranuni(13);

*COMPRAS;

if compras<100 then potencial=potencial-0.01*ranuni(13);

else if compras<250 then potencial=potencial+0.03*ranuni(13);

else if compras<700 then potencial=potencial+0.05*ranuni(13);

else if compras<2000 then potencial=potencial+0.06*ranuni(13);

else potencial=potencial+0.07*ranuni(13);

*PASIVO;

if pasivo<50000 then potencial=potencial-0.02*ranuni(13);

else if pasivo<100000 then potencial=potencial-0.01*ranuni(13);

else if pasivo<200000 then potencial=potencial+0.01*ranuni(13);

else if pasivo<300000 then potencial=potencial+0.03*ranuni(13);

else if pasivo<500000 then potencial=potencial+0.1*ranuni(13);

else potencial=potencial+.1;

*PROVINCIA;

if mod(provincia,5)=0 then potencial=potencial-0.02*ranuni(13);

if potencial>0.35 then contrata=1;

else contrata=0;

run;
```

Ahí los tenemos. _Contrata=1_ determina el cliente que adquiere ese producto. Luego determina nuestro **target**. Hemos de realizar un modelo que nos clasifique a los clientes en función de su propensión a la compra del producto. El primer paso es crear un conjunto de datos de entrenamiento y otro de validación:

```r
*MUESTRA ALEATORIA;

data entreno validacion;

set sasuser.datos;

if ranuni(46)>=0.6 then output validacion;

else output entreno;

run;
```

Lo dejamos en 60-40 mas o menos. Ahora nuestro trabajo se ha de centrar en el PROC LOGISTIC:

```r
proc logistic data=entreno outmodel=model1;

class provincia;

model contrata=edad provincia pasivo vinculacion recibos compras/

SELECTION=FORWARD ctable ;

quit;
```

Esta puede ser la sintaxis más sencilla. Especificamos que variable(s) son grupos con CLASS, en nuestro caso la provincia, SAS automáticamente genera variables artificiales. Para hacer el modelo siempre hemos de emplear la sentencia MODEL var. Dependiente = var. Independientes, separado por / ponemos las opciones, en este caso selección hacia delante y CTABLE para ver la tabla de **sensibilidad** y **especificidad** en función del score. Con OUTMODEL creamos un conjunto de datos SAS que nos permite scorear otros datasets. En el caso que nos ocupa veamos las probabilidades asignadas al conjunto de datos de validación:

```r
proc logistic inmodel=pepin ;

score data=validacion out=validacion;

quit;
```

En este caso hemos scoreado la tabla de validación. Otra forma de realizar esta tarea es emplear la sentencia SCORE a la vez que realizamos el modelo:

```r
proc logistic data=entreno noprint;

class provincia;

model contrata=edad provincia pasivo vinculacion recibos compras/

SELECTION=FORWARD ctable ;

score data=validacion out=validacion;

quit;
```

Para la validación me gusta realizar la siguiente tabla de frecuencias. Atención porque esto es código “dinosáurico”:

```r
proc sql noprint;

 create table resumen as select

 case

 when P_1 is null then 0

 else round(P_1,0.1) end as prob_contrata,

 sum(contrata) as contrata,

 count(*) as clientes

 from validacion

 group by 1

 order by 1 desc;

 select sum(clientes) into: total

 from resumen;

quit;

*AGREGAMOS PARA ESTUDIAR CANTIDADES;

data resumen;

 set resumen;

 retain clientes_agr contrata_agr;

 clientes_agr=sum(clientes,clientes_agr);

 contrata_agr=sum(contrata,contrata_agr);

 pct_clientes=clientes_agr/&total.;

 prob_teorica=contrata_agr/clientes_agr;

run;
```

Esto es “nivel”, mis probabilidades teóricas de contratación frente al % clientes, me emociono. Cuando tenemos que hacer un contacto comercial las cantidades de clientes seleccionadas nos producen importantes quebraderos de cabeza, por este motivo realizo esta consulta. Una vez seleccionado el universo de clientes al que hemos de llegar empleo esta forma de buscar el número de clientes con mayor propensión a la compra. Además los modelos es mejor entrenarlos con una «sobremuestra» de eventos y luego tenemos que generalizar este resultado. Con esa tabla podemos cerrar cantidades. En fin, curiosidades a parte y malas costumbres más a parte unas opciones interesantes que ofrece el PROC LOGISTIC son las gráficas:

```r
ods graphics on;

proc logistic data=entreno plots(only)=all;

class provincia;

model contrata=edad provincia pasivo vinculacion recibos compras/

SELECTION=backward;

roc "Pasivo" pasivo ;

roc "Compras" compras ;

roc "Vinculación" vinculacion;

quit;

ods graphics off;
```

Se han añadido a nuestra salida todos los gráficos posibles, diagnósticos de influencia, de leverage, de ajuste y las curvas ROC, además para las curvas trabajamos con la sentencia ROC que nos permite ver variable a variable como es su comportamiento predictor y luego podemos compararlas todas. En este ejemplo todas tienen buen comportamiento y además están muy correlacionadas porque es así como las hemos construido. Si deseamos ver diagnósticos de influencia variable a variable:

```r
ods graphics on;

proc logistic data=entreno;

class provincia;

model contrata=edad provincia pasivo vinculacion recibos compras/ iplots;

quit;

ods graphics off;
```

Para aquellas variables que no participan en nuestro modelo recomiendo analizar como funciona el ajuste a la variable dependiente:

```r
ods graphics on;

proc logistic data=entreno plots(only)=roc;

class provincia;

model contrata= compras/rsquare ;

effectplot ;

quit;

ods graphics off;
```

La verdad es que las posibilidades gráficas son muy extensas e interesantes, en ese sentido este procedimiento destaca. Si deseamos analizar el comportamiento del modelo a modo de sugerencia podríamos crear el siguiente código:

```r
*CREAMOS EL POTENCIAL DE COMPRA;

data sasuser.datos;

set datos;

potencial=0.3;

*MODIFICAMOS LIGERAMENTE EL POTENCIAL;

*EDAD;

if edad<30 then potencial=potencial+0.05*ranuni(13);

else if edad<40 then potencial=potencial+0.03*ranuni(13);

else if edad<45 then potencial=potencial+0.04*ranuni(13);

else if edad<55 then potencial=potencial+0.05*ranuni(13);

else potencial=potencial+0.02*ranuni(13);

*RECIBOS;

if recibos<=2 then potencial=potencial+0.01*ranuni(13);

else if recibos<=4 then potencial=potencial+0.03*ranuni(13);

else potencial=potencial+0.05*ranuni(13);

*VINCULACION;

if vinculacion<=5 then potencial=potencial-0.01*ranuni(13);

else if vinculacion<=8 then potencial=potencial+0.05*ranuni(13);

else if vinculacion<=12 then potencial=potencial+0.2*ranuni(13);

else potencial=potencial+0.4*ranuni(13);

*COMPRAS;

if compras<100 then potencial=potencial-0.01*ranuni(13);

else if compras<250 then potencial=potencial+0.03*ranuni(13);

else if compras<700 then potencial=potencial+0.05*ranuni(13);

else if compras<2000 then potencial=potencial+0.06*ranuni(13);

else potencial=potencial+0.07*ranuni(13);

*PASIVO;

if pasivo<50000 then potencial=potencial-0.02*ranuni(13);

else if pasivo<100000 then potencial=potencial-0.01*ranuni(13);

else if pasivo<200000 then potencial=potencial+0.01*ranuni(13);

else if pasivo<300000 then potencial=potencial+0.03*ranuni(13);

else if pasivo<500000 then potencial=potencial+0.1*ranuni(13);

else potencial=potencial+.1;

*PROVINCIA;

if mod(provincia,5)=0 then potencial=potencial-0.02*ranuni(13);

if potencial>0.35 then contrata=1;

else contrata=0;

run;
```
0

Vemos que se generan dos tablas con las estimaciones de los parámetros y con los ODDS ratios. El signo de las estimaciones nos permiten ver si la relación con la variable dependiente es positiva o negativa, además la Chi-Cuadrado de Wald nos identifica la variable con mayor relevancia, la que tenga el valor más alto. Por último la tabla de ODDS ratios que nos mide la probabilidad de que ocurra el evento contrata si está o no presente la variable. A menor ODDS Ratio mayor importancia tiene la variable. Esto puede ayudarnos a encontrar casuísticas de negocio.

Bueno, pues hasta aquí este “pequeño” esbozo sobre el PROC LOGISTIC creo que me he extendido demasiado pero me acerco a las características de mayor relevancia. Es evidente que paso por alto la temática del muestreo y que _entreno logísticas_ demasiado a la ligera, a futuro es necesario meterse en temas de muestreo, básicos en fraude (por ejemplo).