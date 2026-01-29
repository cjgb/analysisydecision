---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2008-05-08'
lastmod: '2025-07-13'
related:
  - el-ods-de-sas-ii-dataset-desde-output.md
  - el-ods-de-sas-iii-documentos-html-y-pdf-desde-sas.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - truco-sas-proc-contents.md
  - macros-sas-informe-de-un-dataset-en-excel.md
tags:
  - formación
  - sas
title: El `ODS` de `SAS` (I). Elementos del `OUTPUT`
url: /blog/el-ods-de-sas-i-elementos-del-output/
---

Hoy comenzaré una serie de mensajes dedicados al `ODS` (`Output Delivery System`) de `SAS`. Este mecanismo de `SAS` nos permite un uso más eficiente del `OUTPUT` de nuestros pasos `PROC` además podemos crear Excel (como ya vimos), crear `dataset`, no generar salidas,… Antes `SAS` nos ofrecia un `texto plano` en la ventana `OUTPUT`, ahora generamos `documentos sofisticados`. En tres entregas veremos:
\*Trazar el `OUTPUT` de `SAS`
\*`Datasets` de salidas de `SAS`
\*Documentos con nuestras salidas de `SAS`:
-`HTML`
-`PDF`
Como complemento a estas entregas es posible que redacte un mensaje con algunos ejemplos de uso del `PROC TEMPLATE`. En esta primera capítulo dedicado al `ODS` estudiaremos algunas salidas `SAS` y con ellas, sabremos identificar la estructura del `OUTPUT`.

Si ejecutamos en `SAS` el siguiente código:

```sas
data uno; do i=1 to 20000;
importe=round(rand("normal")*1000,.1);
num_productos=min(max(1,rand("pois",4)),8);
 num_cargos=max(0,rand("pois",10)-int(rand("uniform")*10));
 output ;
 end;

run;proc univariate data=uno;

var importe;

quit;

proc freq data=uno;

tables num_productos*num_cargos/chisq;

quit;
```

Generamos un `dataset` aleatorio de muestra sobre el que hacemos un `univariante` y una `tabla de frecuencias` de `doble entrada` con un `test de independencia` de la `Ji-Cuadrado`. En total las `tablas de resultados` que obtenemos son:

\*`PROC UNIVARIATE`:
-`Moments`
-`Basic Statistical Measures`
-`Tests for Location: Mu0=0`
-`Quantiles (Definition 5)`
-`Extreme Observations`

\*`PROC FREQ`:
\*`Table of num_productos by num_cargos`
\*`Statistics for Table of num_productos by num_cargos`

En total tenemos `7 OUTPUT`. Bien, cada `OUTPUT` tiene una «`definición interna`» de `SAS`, para conocerla emplearemos el `ODS TRACE`:

```sas
ods trace on;
proc univariate data=uno;var importe;quit;

proc freq data=uno;
tables num_productos*num_cargos/chisq;
quit;

ods trace off;
```

Si ejecutamos este código y vemos el `log` tendremos:

```
24

25 ods trace on;

26 proc univariate data=uno;

27 var importe;

28 quit;
```

```
Output Added:

-------------

Name: Moments

Label: Moments

Template: base.univariate.Moments

Path: Univariate.importe.Moments
```

`-------------`

```
Output Added:

-------------

Name: BasicMeasures

Label: Basic Measures of Location and Variability

Template: base.univariate.Measures

Path: Univariate.importe.BasicMeasures

-------------
```

```
Output Added:

-------------

Name: TestsForLocation

Label: Tests For Location

Template: base.univariate.Location

Path: Univariate.importe.TestsForLocation

-------------
```

```
Output Added:

-------------

Name: Quantiles

Label: Quantiles

Template: base.univariate.Quantiles

Path: Univariate.importe.Quantiles

-------------
```

```
Output Added:

-------------

Name: ExtremeObs

Label: Extreme Observations

Template: base.univariate.ExtObs

Path: Univariate.importe.ExtremeObs

-------------

NOTE: PROCEDURE UNIVARIATE used (Total process time):

  real time 0.03 seconds

  cpu time 0.03 seconds
```

```
29

30 proc freq data=uno;

31 tables num_productos*num_cargos/chisq;

32 quit;
```

```
Output Added:

-------------

Name: CrossTabFreqs

Label: Cross-Tabular Freq Table

Data Name:

Path: Freq.Table1.CrossTabFreqs

-------------
```

```
ods trace on;
proc univariate data=uno;var importe;quit;

proc freq data=uno;
tables num_productos*num_cargos/chisq;
quit;

ods trace off;
```

0

`-------------`
`NOTE: There were 20000 observations read from the data set WORK.UNO.`
`NOTE: PROCEDURE FREQ used (Total process time):`
`real time 0.02 seconds`
`cpu time 0.02 seconds`

33 `ods trace off`;

Con `ODS TRACE ON` activamos el "`Trace Record`" de `SAS`. Nos añade `7 elementos` al `OUTPUT` y para cada `elemento` tenemos el `name`, la `label` que le asigna `SAS` y el `catalogo` donde almacena cada `elemento`. Con `TRACE` empezamos a conocer mejor una salida `SAS` y sobre todo identificamos los `names` de los `elementos` que componen una salida `SAS`. Con ello y con otras herramientas de `ODS` podemos configurar mejores y más `optim`as `tablas de resultados`.
