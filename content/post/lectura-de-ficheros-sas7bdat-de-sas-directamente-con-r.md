---
author: rvaquerizo
categories:
- R
- SAS
- Trucos
date: '2011-04-19T04:29:12-05:00'
slug: lectura-de-ficheros-sas7bdat-de-sas-directamente-con-r
tags: []
title: Lectura de ficheros SAS7BDAT de SAS directamente con R
url: /lectura-de-ficheros-sas7bdat-de-sas-directamente-con-r/
---

Un post de **BIOSTATMATT** que nos conduce a un código en R que nos permite leer datasets de SAS directamente con R sin necesidad de tener SAS. Un problema recurrente que abordaré con más detenimiento otro día [ahora me voy a pescar]. Aquí tenéis el enlace:

<http://biostatmatt.com/archives/1216>

Sólo tenéis que cargar la función**read.sas7bdat** que tenéis en [este enlace](http://biostatmatt.com/R/sas7bdat.R). Y ya podéis leer conjuntos de datos SAS. Ejemplo:

```r
source("http://biostatmatt.com/R/sas7bdat.R")

datos = read.sas7bdat("D:\\raul\\Trabajo\\salida\\p03.sas7bdat")
```

De momento lo he probado en conjuntos de datos SAS sin índices y sin comprimir, si encuentro algún problema primero se lo reporto a la gente que ha creado esta función y más tarde os lo comento.