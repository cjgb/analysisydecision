---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2011-05-12'
lastmod: '2025-07-13'
related:
  - truco-excel-actualizar-el-filtro-de-todas-las-tablas-dinamicas-de-mi-libro.md
  - truco-excel-producto-cartesiano-de-dos-campos.md
  - truco-excel-agrupar-valores-en-un-campo-de-una-tabla-dinamica.md
  - truco-excel-actualizar-los-filtros-de-una-tabla-dinamica-con-visual-basic.md
  - truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
tags:
  - macro excel
  - tabla dinamica
title: Trucos Excel. Múltiples campos calculados en una tabla dinámica
url: /blog/trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica/
---

Truco Excel muy rápido y que os permite crear múltiples campos calculados en una tabla dinámica de Excel. Imaginemos que tenemos una tabla dinámica con un campo que es la suma de la exposición al riesgo y por otro lado tenemos el número de siniestros. Estos dos campos los tenemos para 30 coberturas. Si queremos crear un campo calculado que sea la frecuencia siniestral (número de siniestros/exposición) para esos 30 campos tenemos que irnos a herramientas de tabla dinámica, fórmulas, definir el nuevo campo,… O bien podemos hacer emplear la siguiente macro:

```r
```visual-basic
Sub calculados()

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

Macro sencilla y que puede ahorraros muchos pasos con las fórmulas de las tablas dinámicas. Espero que sea de utilidad. Saludos.
