---
author: rvaquerizo
categories:
  - formación
  - sas
  - trucos
date: '2008-08-26'
lastmod: '2025-07-13'
related:
  - truco-sas-tablas-de-una-libreria-en-una-macro-variable.md
  - el-ods-de-sas-ii-dataset-desde-output.md
  - trucos-sas-macrovariable-a-dataset.md
  - trucos-sas-lista-de-datasets-en-macro-variable.md
  - macros-sas-informe-de-un-dataset-en-excel.md
tags:
  - ods
  - output
  - sas
  - trucos
title: Truco SAS. Proc contents que genera un dataset
url: /blog/truco-sas-proc-contents/
---

Vamos a introducir los nombres de las variables SAS de un dataset en otro dataset. Esto puede sernos muy útil para realizar documentación, validaciones de los conjuntos de datos generados, automatización de instrucciones,… Es un truco muy sencillo y tan sólo es necesario comprender el funcionamiento del ODS de SAS explicado en otro de los mensajes de este blog. Simplemente empleamos el proc contents de SAS y almacenamos con ODS en un dataset el resultado del listado de las variables:

````r
```sas
*DATASET DE PARTIDA. GENERAMOS UNO ALEATORIAMENTE;

data uno;

 do i=1 to 20;

 aleat1=ranuni(9);

 aleat2=ranuni(2);

 output;

 end;

run;
````

```sas
%let dt=uno;
```

````r
```sas
*NO QUEREMOS SALIDA OUTPUT;

ods noresults;
````

```sas
*CON ODS ESPECIFICAMOS EL DATASET CON LA SALIDA;
ods output Variables=contenido (keep=variable);

*HACEMOS UN PROC CONTENTS SIN MAS;
proc contents data=&dt.;
quit;

*VOLVEMOS A TENER SALIDAS DE RESULTADOS;
ods results;

*EL DATASET CONTENIDO TIENE LAS VARIABLES;
```

Truco muy sencillo y que retomaremos en próximas entregas para introduciros en una metodología que nos permite automatizar códigos con macros de SAS.

Para cualquier duda o cuestión `rvaquerizo@analisisydecision.es`
