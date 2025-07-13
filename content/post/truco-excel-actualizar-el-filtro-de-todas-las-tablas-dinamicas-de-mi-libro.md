---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2017-03-10T02:42:18-05:00'
lastmod: '2025-07-13T16:07:02.701895'
related:
- truco-excel-actualizar-los-filtros-de-una-tabla-dinamica-con-visual-basic.md
- trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica.md
- truco-excel-unir-todos-los-libros-en-una-hoja.md
- truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
- truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
slug: truco-excel-actualizar-el-filtro-de-todas-las-tablas-dinamicas-de-mi-libro
tags: []
title: Truco Excel. Actualizar el filtro de todas las tablas dinámicas de mi libro
url: /truco-excel-actualizar-el-filtro-de-todas-las-tablas-dinamicas-de-mi-libro/
---

Traigo hoy al blog una macro de Excel que nos permite recorrer todas las hojas de un libro y dentro de las hojas nos permite recorrer todas las tablas dinámicas y actualizar un campo. Cuando tenemos un informe que se basa en tablas dinámicas y tiene una actualización mensual nos podemos encontrar con la necesidad de cambiar sólo un elemento de la tabla dinámica para actualizar el informe. Este era el caso de mi compañera, [hay una entrada en el blog que ya trataba el tema pero esta nueva macro supone otra vuelta de tuerca sobre ella](https://analisisydecision.es/truco-excel-actualizar-los-filtros-de-una-tabla-dinamica-con-visual-basic/), no sólo recorre y actualiza todas las tablas dinámicas de una hoja, además lo hace de todo el libro. El código de Visual Basic para Excel es:

[sourcecode language=»vb»]  
Sub filtros()  
‘Macro creada por www.analisisydecision.es

Dim pt As PivotTable  
Dim actual, nuevo As String  
actual = 201701  
nuevo = 201702

For i = 1 To Worksheets.Count

Sheets(i).Activate  
For Each pt In ActiveSheet.PivotTables  
pt.PivotFields("mes").EnableMultiplePageItems = True  
With pt.PivotFields("mes")  
.PivotItems(nuevo).Visible = True  
.PivotItems(actual).Visible = False  
End With  
Next pt  
Next i  
[/sourcecode]

En PivotFields ponemos el nombre del campo que deseamos actualizar. Evidentemente necesitamos esconder el valor actual y poner el valor nuevo recorriendo todas las hojas con el bucle _For i = 1 To Worksheets.Count_ y recorriendo todas las tablas dinámicas de cada hoja con _For Each pt In ActiveSheet.PivotTables_. Lo que si necesitó estar activo es seleccionar varios elementos del campo que deseamos actualizar y por ello fue necesario poner _EnableMultiplePageItems = True_ no llegamos a entender el motivo pero es importante que “Seleccionar varios elementos” esté activo en la tabla dinámica. Espero que estas pocas líneas de código os sean de utilidad, por aquí han automatizado mucho trabajo manual. Saludos.