---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2013-12-03T10:33:03-05:00'
slug: truco-malo-de-r-leer-datos-desde-excel
tags: []
title: Truco (malo) de R. Leer datos desde Excel
url: /truco-malo-de-r-leer-datos-desde-excel/
---

Tenemos unos datos en Excel y deseamos crear un objeto en R con ellos. La forma más sencilla es seleccionar y copiar los datos y ejecutar el siguiente código:

```r
datos = read.delim("clipboard")

str(datos)
```

Muy sencillo, pero necesitaba «fustigarme». Si deseamos llevar los datos de R a Excel (el camino contrario) hacemos:

`write.table(datos,"clipboard", sep="\t",row.names=FALSE)`

Igual de sencillo. No hagáis como yo, no olvidéis este código. Saludos.