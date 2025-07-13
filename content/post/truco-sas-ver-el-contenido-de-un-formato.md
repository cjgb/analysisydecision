---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
- WPS
date: '2013-02-06T09:17:26-05:00'
slug: truco-sas-ver-el-contenido-de-un-formato
tags: []
title: Truco SAS. Ver el contenido de un formato
url: /truco-sas-ver-el-contenido-de-un-formato/
---

Para ver los valores que toma un formato con SAS tenemos que emplear el PROC FORMAT. La sintaxis es muy sencilla:

```r
proc format
library = work.formats fmtlib;
select &formato.
run;
```
 

Tenéis que poner el nombre del formato sin punto. Sintaxis sencilla, pero difícil de recordar (por lo menos a mi me ha pasado). Saludos.