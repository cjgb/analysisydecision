---
author: rvaquerizo
categories:
  - formación
  - sas
date: '2008-05-19'
lastmod: '2025-07-13'
related:
  - el-ods-de-sas-i-elementos-del-output.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-i.md
  - el-ods-de-sas-iii-documentos-html-y-pdf-desde-sas.md
  - truco-sas-proc-contents.md
  - macros-sas-informe-de-un-dataset-en-excel.md
tags:
  - sin etiqueta
title: El ODS de SAS (II). Dataset desde OUTPUT
url: /blog/el-ods-de-sas-ii-dataset-desde-output/
---

Ya vimos el funcionamiento de ODS TRACE ON/OFF. Ahora crearemos datasets a partir del OUTPUT que genera un paso PROC de SAS con ODS. Lo principal es conocer como se denomina cada parte del OUTPUT, esto lo conseguimos con TRACE y analizando el LOG. Una vez conocemos la salida empleamos ODS OUTPUT <nombre de la salida> = libreria.dataset. En el ejemplo que teníamos:

```
_*DATASET ALEATORIO DE 200000 OBSERVACIONES;_
_data uno;_
_do i=1 to 20000;_
_importe=round(rand(«normal»)*1000,.1);_
_num_productos=min(max(1,rand(«pois»,4)),8);_
_num_cargos=max(0,rand(«pois»,10)-int(rand(«uniform»)*10));_
_output ;_
_end;_
_run;_

_ods noresults;_
_ods output Quantiles=cuant;_
_proc univariate data=uno;_
_var importe;_
_quit;_

_ods output Chisq=testchi;_
_proc freq data=uno;_
_tables num_productos*num_cargos/chisq;_
_quit;_
_ods results;_
```

Para evitar la salida en la ventana output o en formato HTML se emplea ODS NORESULTS. Con ODS OUTPUT hemos creado dos datasets. Veamos el log:

```r
272 ods noresults;

273 ods output Quantiles=cuant;

274 proc univariate data=uno;

275 var importe;

276 quit;

NOTA: Escribiendo HTML Cuerpo del fichero: sashtml4.htm

NOTA: El conj. datos WORK.CUANT tiene 11 observaciones y 3 variables.

NOTA: Comprimiendo el tamaño aumentado del conj datos WORK.CUANT en un 100.00 por ciento.

Comprimido ocupa 2 páginas; sin comprimir ocuparía 1.

NOTA: PROCEDIMIENTO UNIVARIATE utilizado (Tiempo de proceso total):

tiempo real 0.42 segundos

tiempo de cpu del usuario 0.04 segundos

tiempo de cpu del sistema 0.03 segundos

Memoria 585k
```

```r
277

278 ods output Chisq=testchi;

279 proc freq data=uno;

280 tables num_productos*num_cargos/chisq;

281 quit;
```

```r
NOTA: Escribiendo HTML Cuerpo del fichero: sashtml5.htm

NOTA: El conj. datos WORK.TESTCHI tiene 6 observaciones y 5 variables.

NOTA: Comprimiendo el tamaño aumentado del conj datos WORK.TESTCHI en un 100.00 por ciento.

Comprimido ocupa 2 páginas; sin comprimir ocuparía 1.

NOTA: Se han leído 20000 observaciones del conj. datos WORK.UNO.

NOTA: PROCEDIMIENTO FREQ utilizado (Tiempo de proceso total):

tiempo real 0.23 segundos

tiempo de cpu del usuario 0.04 segundos

tiempo de cpu del sistema 0.00 segundos

Memoria 162k
```

En cuant hemos guardado los cuantiles resultantes del PROC UNIVARIATE y en testchi el resultado del test de independencia que calculabamos en el PROC FREQ. Mediante NORESULTS no obtenemos salida. Las tablas obtenidas son «réplicas» del resultado que nos ofrece SAS pero con peculiaridades:

[![ods_output.JPG](/images/2008/05/ods_output.JPG)](/images/2008/05/ods_output.JPG "ods_output.JPG")

Siempre nos añade una variable que nos describe la salida. En el caso del UNIVARIATE un VarName y en el caso del FREQ un Table. Con TRACE y OUTPUT podemos crear cualquier dataset a partir de un resultado. Evidentemente también podemos emplear las opciones de OUTPUT OUT= que llevan todos los procedimientos de SAS pero esta opción es muy interesante si no se desea llevar el proyecto de SAS de resultados. Especialmente práctica esta metodología para crear un conjunto de datos SAS con las variables de otro conjuntos de datos:

```r
ods noresults;

ods output Variables=tabla_variables (keep=variable);

proc contents data=uno; quit;

ods results;
```

Como ejercicio recomendaría probar el ODS OUTPUT con muchos procedimientos para recordar bien esta metodología. Esto puede permitirnos ahorrar mucho tiempo y automatizar mucho código. Por supuesto para cualquier duda estoy a vuestra disposición.
