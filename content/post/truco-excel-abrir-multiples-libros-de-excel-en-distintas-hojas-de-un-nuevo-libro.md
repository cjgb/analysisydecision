---
author: rvaquerizo
categories:
  - excel
  - formación
  - monográficos
  - trucos
date: '2016-03-17'
lastmod: '2025-07-13'
related:
  - trucos-excel-unir-varios-excel-en-uno.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
  - truco-excel-application-getopenfilename-el-explorador-de-archivos-sencillo-en-macro.md
  - truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
  - truco-sas-unir-todos-los-excel-en-uno-solo.md
tags:
  - getopenfilename
title: Truco Excel. Abrir múltiples libros de Excel en distintas hojas de un nuevo libro
url: /blog/truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro/
---

Hace tiempo escribí sobre el método de `Excel` `GetOpenFilename` para abrir archivos desde `Excel` a través del explorador de archivos ahora le damos una nueva vuelta de tuerca a aquella entrada y de forma simple podemos abrir múltiples libros de `Excel` que además se añadirán de forma sucesiva en un nuevo libro. [En este link podéis descargaros el archivo](/images/2016/03/abrir_excel1.xlsm) y como veréis no tiene nada. Un botón `Abrir Excel` realiza el proceso, se abre el explorador de `Windows` y podéis seleccionar múltiples archivos `Excel` que se almacenan en un `array`. La macro a ejecutar es la siguiente:

```vba
Sub abre_libros()
Dim Hoja As Object, rango As String
Dim libros As Variant

'Ventana con archivos
libros = Application.GetOpenFilename _
("Archivos Excel (*.xls*), *.xls*", 2, "Abrir archivos", , True)
'Es necesario seleccionar archivos
If IsArray(libros) Then
'Creamos un libro nuevo
Workbooks.Add
libro_actual = ActiveWorkbook.Name
'Ahora pegamos las hojas
For i = LBound(libros) To UBound(libros)
Workbooks.Open libros(i)
libro_nuevo = ActiveWorkbook.Name
For Each Hoja In ActiveWorkbook.Sheets
Hoja.Copy after:=Workbooks(libro_actual).Sheets(Workbooks(libro_actual).Sheets.Count)
Next
Workbooks(libro_nuevo).Close False
Next
End If
End Sub
```

No se me ocurrió como hacer el código más sencillo y al final lo que hace es recorrer el `array` de libros que abre y añadir las hojas sobre un libro nuevo. Tiene algunas limitaciones en la forma en la que pega las nuevas hojas pero nada que pueda ser muy complicado de solucionar. Ahora tenéis que mejorar [la entrada más visitada de este blog](https://analisisydecision.es/trucos-excel-unir-todos-los-excel-en-uno-version-muy-mejorada/) para que pueda unir en uno los `Excel` que se abren.
