---
author: rvaquerizo
categories:
  - excel
  - formación
  - sas
  - trucos
date: '2011-12-12'
lastmod: '2025-07-13'
related:
  - truco-sas-crear-ficheros-excel-sin-proc-export-ii.md
  - truco-sas-sas-y-dde-aliados-de-excel.md
  - trucos-sas-macrovariable-a-dataset.md
  - macros-sas-informe-de-un-dataset-en-excel.md
  - trucos-sas-ejecutar-un-codigo-si-existe-una-tabla-o-un-fichero.md
tags:
  - initstmt
title: Truco Excel y SAS. Ejecutar SAS desde macro en Excel
url: /blog/truco-excel-y-sas-ejecutar-sas-desde-macro-en-excel/
---

Un truco muy malo hoy. Se trata de crear una macro de Excel que llame a un programa SAS y que además podamos pasar un parámetro. Es un código en Visual Basic que no tiene complejidad pero que puede ser útil. El código es:

```r
Sub ejecuta_SAS()

'

'Ponemos la ubicación del ejecutable de SAS

ubicacion_SAS = "C:\SAS\sas.exe"

'

'Programa que deseamos ejecutar de SAS

programa_SAS = "'C:\ejecucion_excel.sas'"

'

'Podemos pasar parámetros como macros por ejemplo que aparecen en una celda de Excel

'Podemos poner todo el código SAS que queramos

parametro = "'%let nobs = " & Cells(1, 1) & " ;'"

'

'En una cadena ponemos toda la ejecución

ejecucion = ubicacion_SAS & " " & programa_SAS & " -initstmt " & parametro

'

'Shell ejecuta la cadena anterior

ejecuta = Shell(ejecucion, 1)

'

End Sub
```

Poca cosa y poco talento y bastante claro. Pero si me gustaría destacar el uso de la opción de SAS **-initstmt** que nos permite ejecutar SAS poniendo un código previamente (_init statement_). Esta opción nos permite pasar una macro como parámetro que es leída en una celda de Excel. Es una opción habitual cuando hacemos archivos ejecutables para SAS. Espero que sea de utilidad. Saludos.
