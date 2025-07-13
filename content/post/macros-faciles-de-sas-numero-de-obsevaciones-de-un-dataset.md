---
author: rvaquerizo
categories:
- Formación
- SAS
date: '2010-11-24T12:45:03-05:00'
lastmod: '2025-07-13T16:00:52.680514'
related:
- truco-sas-observaciones-de-un-dataset-en-una-macro-variable.md
- macro-sas-numero-de-observaciones-de-un-dataset-en-una-macro.md
- macros-sas-informe-de-un-dataset-en-excel.md
- macros-sas-macro-split-para-partir-un-conjunto-de-datos.md
- truco-sas-proc-contents.md
slug: macros-faciles-de-sas-numero-de-obsevaciones-de-un-dataset
tags:
- ATTRN
- CLOSE
- Funciones SAS I/O
- OPEN
title: Macros (fáciles) de SAS. Número de obsevaciones de un dataset
url: /macros-faciles-de-sas-numero-de-obsevaciones-de-un-dataset/
---

Con esta macro podréis identificar el número de observaciones de UN CONJUNTO DE DATOS SAS. No funciona con tablas Oracle, Informix, DB2,… me gustaría dejarlo claro. Al emplear la función de**I/O** OPEN junto con ATTRN y CLOSE no realizamos un conteo de observaciones. Al final el proceso crea una macro variable que se llama _NOBS_ y que podremos usar en nuestra sesión SAS.  

```r
%macro observaciones(datos);

/*EL NUMERO DE OBS LO VAMOS A METER EN UNA MV GLOBAL*/

%global nobs;

/*ABRIMOS EL CONJUNTO DE DATOS PARA VER SUS CARACTERISTICAS*/

%let datosid = %sysfunc(open(&datos));

/*SI ESTA ABIERTO ENTONCES LA FUNCION ATTRN NOS DA LA NOBS*/

%if &datosid %then %do;

%let nobs =%sysfunc(attrn(&datosid,NOBS));

/*CERRAMOS EL CONJUNTO DE DATOS*/

%let rc = %sysfunc(close(&datosid));%end;

%mend ;
```
  
Fácil y rápida. Si alguien tiene problemas con su uso que lo comunique en el blog. Seguro que es de gran utilidad. Saludos.