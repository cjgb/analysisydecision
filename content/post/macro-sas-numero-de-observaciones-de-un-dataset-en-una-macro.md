---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
- WPS
date: '2016-01-22T04:13:44-05:00'
slug: macro-sas-numero-de-observaciones-de-un-dataset-en-una-macro
tags:
- ATTRN
title: Macro SAS. Número de variables de un dataset en una macro
url: /macro-sas-numero-de-observaciones-de-un-dataset-en-una-macro/
---

Una macro que nos permite saber el número de variables que tiene un conjunto de datos SAS. Es una petición de una lectora y la macro es [análoga a otra que ya pusimos en el blog allá por 2010](https://analisisydecision.es/macros-faciles-de-sas-numero-de-obsevaciones-de-un-dataset/). Veamos cómo funciona:

```r
%macro numvars(datos);
 %global numvars;
 /*ABRIMOS EL CONJUNTO DE DATOS PARA VER SUS CARACTERISTICAS*/
 %let datosid = %sysfunc(open(&datos));
 /*SI ESTA ABIERTO ENTONCES LA FUNCION ATTRN NOS DA EL NUMERO DE VARIABLES*/
 %if &datosid %then %do;
 %let numvars =%sysfunc(attrn(&datosid,nvars));
 /*CERRAMOS EL CONJUNTO DE DATOS*/
 %let rc = %sysfunc(close(&datosid));%end;
 %mend;
```
 
```r
data ejemplo;
 a=1;
 b=2;
 c=3;
 d=4;
 f=5;
 g=6;
 run;
```
 
```r
%numvars(ejemplo);
 %put _user_;
```
 

Utilizamos las funciones I/O de SAS, en concreto ATTRN que unido a NVARS nos permite saber el número de variables que tiene un dataset, el número de variables lo ponemos en la macrovariable global &numvars..

Saludos.