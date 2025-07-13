---
author: rvaquerizo
categories:
- Excel
- Modelos
- SAS
- Trucos
date: '2013-10-10T09:20:10-05:00'
slug: truco-muy-facil-de-sas-leer-un-rango-de-una-hoja-excel
tags: []
title: Truco (muy fácil) de SAS. Leer un rango de una hoja Excel
url: /truco-muy-facil-de-sas-leer-un-rango-de-una-hoja-excel/
---

Cuando tenemos rangos en nuestras hojas Excel y deseamos que se conviertan en tabla SAS podemos emplear la sentencia libname de este modo:

```r
libname selec "C:\TEMP\rangos.xlsx";
data rango;
set selec.rango;
run;
libname selec clear;
```
 

Asisgnamos la librería al archivo Excel que deseamos leer y tan simple como referenciar al rango en nuestro paso data. Se interactúa fácil entre Excel y SAS. Saludos.