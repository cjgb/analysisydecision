---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
- WPS
date: '2013-02-06T09:17:26-05:00'
lastmod: '2025-07-13T16:08:49.828261'
related:
- truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
- trucos-sas-errores-y-formatos.md
- truco-muy-facil-de-sas-leer-un-rango-de-una-hoja-excel.md
- trucos-sas-macrovariable-a-dataset.md
- truco-sas-proc-format-vs-formato-percent.md
slug: truco-sas-ver-el-contenido-de-un-formato
tags: []
title: Truco SAS. Ver el contenido de un formato
url: /blog/truco-sas-ver-el-contenido-de-un-formato/
---

Para ver los valores que toma un formato con SAS tenemos que emplear el PROC FORMAT. La sintaxis es muy sencilla:

```r
proc format
library = work.formats fmtlib;
select &formato.
run;
```


Tenéis que poner el nombre del formato sin punto. Sintaxis sencilla, pero difícil de recordar (por lo menos a mi me ha pasado). Saludos.