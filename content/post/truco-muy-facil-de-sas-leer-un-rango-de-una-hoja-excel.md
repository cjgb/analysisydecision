---
author: rvaquerizo
categories:
  - excel
  - modelos
  - sas
  - trucos
date: '2013-10-10'
lastmod: '2025-07-13'
related:
  - truco-sas-leer-datos-de-excel-con-sas-con-dde.md
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - truco-sas-unir-todos-los-excel-en-uno-solo.md
tags:
  - excel
  - modelos
  - sas
  - trucos
title: Truco (muy fácil) de SAS. Leer un rango de una hoja Excel
url: /blog/truco-muy-facil-de-sas-leer-un-rango-de-una-hoja-excel/
---

Cuando tenemos rangos en nuestras hojas Excel y deseamos que se conviertan en tabla SAS podemos emplear la sentencia libname de este modo:

````r
```sas
libname selec "C:\TEMP\rangos.xlsx";
data rango;
set selec.rango;
run;
libname selec clear;
````

Asisgnamos la librería al archivo Excel que deseamos leer y tan simple como referenciar al rango en nuestro paso data. Se interactúa fácil entre Excel y SAS. Saludos.
