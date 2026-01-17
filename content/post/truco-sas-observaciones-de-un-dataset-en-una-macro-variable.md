---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2008-06-04T07:58:33-05:00'
lastmod: '2025-07-13T16:08:26.869986'
related:
- macros-faciles-de-sas-numero-de-obsevaciones-de-un-dataset.md
- macro-sas-numero-de-observaciones-de-un-dataset-en-una-macro.md
- macros-sas-informe-de-un-dataset-en-excel.md
- trucos-sas-macrovariable-a-dataset.md
- truco-sas-proc-contents.md
slug: truco-sas-observaciones-de-un-dataset-en-una-macro-variable
tags: []
title: Truco SAS. Observaciones de un dataset en una macro variable
url: /blog/truco-sas-observaciones-de-un-dataset-en-una-macro-variable/
---

SAS tip sencillo para el uso de las funciones de Input Output de SAS y que puede ahorrarnos más de un paso data. Se trata de una macro que pone el número de observaciones de un dataset en una macrovariable global. Al emplear funciones de I/O su ejecución es inmediata:

```r
*MACRO PARA IDENTIFICAR EL NUMERO DE OBSERVACIONES DE UN DS;

%macro numobs(ds,mv);

*CREAMOS UNA MACRO VARIABLE GLOBAL;

 %global &mv.;	data _null_;

*ABRIMOS EL FICHERO;

 	datossid=open("&ds.");

*OBTENEMOS EL ATRIBUTO NOBS QUE CONTIENE

EL NÚMERO DE OBSERVACIONES;

 	no=attrn(datossid,'nobs');

*ASIGNAMOS EL VALOR A LA MV;

 	call symput ("&mv.",compress(no));

*CERRAMOS EL FICHERO;

 	datossid=close(datossid);

 run;

%mend;

*EJEMPLO DE USO;

data uno;

 do i=1 to 100;

 output;

 end;

run;

%numobs(uno,obs_uno);

%put Observaciones de uno =&obs_uno.;
```


Como vemos es un código sencillo pero muy práctico ya que nos permite obtener el número de observaciones de forma instantánea. Con él podemos validar procesos, realizar cálculos,…

Como siempre para cualquier duda o cuestión rvaquerizo@analisisydecision.es