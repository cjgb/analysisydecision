---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2015-07-24'
lastmod: '2025-07-13'
related:
  - truco-excel-actualizar-el-filtro-de-todas-las-tablas-dinamicas-de-mi-libro.md
  - trucos-excel-eliminar-referencias-del-tipo-importardatosdinamicos.md
  - trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica.md
  - trucos-excel-tranformar-un-caracter-a-fecha.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
tags:
  - excel
  - formación
  - trucos
title: Truco Excel. Actualizar los filtros de una tabla dinámica con Visual basic
url: /blog/truco-excel-actualizar-los-filtros-de-una-tabla-dinamica-con-visual-basic/
---

Imaginad que tenéis que cambiar uno o varios filtros de todas las tablas dinámicas de una hoja y cada una de las tablas dinámicas tiene un nombre distinto o hay un número distinto de tablas dinámicas en cada hoja. Eso dificulta a la hora de crear un bucle para la modificación de filtros. Pues este truco de Excel os permitirá actualizar un filtro de una fecha (o cualquier otro) para todas las tablas dinámicas de una hoja. El código es muy sencillo y no creo necesario subiros a la web algún ejemplo:

```visual-basic
Sub filtros()
‘Macro creada por www.analisisydecision.es
Dim pt As PivotTable

For Each pt In ActiveSheet.PivotTables

With pt.PivotFields("fecha")
.PivotItems("Dec-10").Visible = False
.PivotItems("Mar-10").Visible = True
End With
Next pt

End Sub
```
Para cada tabla dinámica (pivot table) actualiza el campo fecha, quita diciembre de 2010 y pone marzo de 2010. Es importante destacar que el filtro emplea fechas en lengua inglesa aunque vosotros en la tabla dinámica la veáis en lengua española. Esto es importante porque más de uno se ha vuelto loco con ese problema en las macros que modifican tablas dinámicas. También se puede plantear una versión que actualice todas las hojas de un libro. Espero que sea de utilidad. Saludos.
