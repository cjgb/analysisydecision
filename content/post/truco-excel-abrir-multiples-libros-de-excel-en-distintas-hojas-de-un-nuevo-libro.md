---
author: rvaquerizo
categories:
- Excel
- Formación
- Monográficos
- Trucos
date: '2016-03-17T10:59:03-05:00'
lastmod: '2025-07-13T16:07:01.241764'
related:
- trucos-excel-unir-varios-excel-en-uno.md
- truco-excel-unir-todos-los-libros-en-una-hoja.md
- truco-excel-application-getopenfilename-el-explorador-de-archivos-sencillo-en-macro.md
- truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
- truco-sas-unir-todos-los-excel-en-uno-solo.md
slug: truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro
tags:
- GetOpenFilename
title: Truco Excel. Abrir múltiples libros de Excel en distintas hojas de un nuevo
  libro
url: /truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro/
---

Hace tiempo escribí sobre el método de Excel GetOpenFilename para abrir archivos desde Excel a través del explorador de archivos ahora le damos una nueva vuelta de tuerca a aquella entrada y de forma simple podemos abrir múltiples libros de Excel que además se añadirán de forma sucesiva en un nuevo libro. [En este link podéis descargaros el archivo](/images/2016/03/abrir_excel1.xlsm) y como veréis no tiene nada. Un botón Abrir Excel realiza el proceso, se abre el explorador de Windows y podéis seleccionar múltiples archivos Excel que se almacenan en un array. La macro a ejecutar es la siguiente:

_Sub abre_libros()_  
_Dim Hoja As Object, rango As String_  
_Dim libros As Variant_

_‘Ventana con archivos_  
_libros = Application.GetOpenFilename __  
_(«Archivos Excel (*.xls*), *.xls*», 2, «Abrir archivos», , True)_  
_‘Es necesario seleccionar archivos_  
_If IsArray(libros) Then_  
_‘Creamos un libro nuevo_  
_Workbooks.Add_  
_libro_actual = ActiveWorkbook.Name_  
_‘Ahora pegamos las hojas_  
_For i = LBound(libros) To UBound(libros)_  
_Workbooks.Open libros(i)_  
_libro_nuevo = ActiveWorkbook.Name_  
_For Each Hoja In ActiveWorkbook.Sheets_  
_Hoja.Copy after:=Workbooks(libro_actual).Sheets(Workbooks(libro_actual).Sheets.Count)_  
_Next_  
_Workbooks(libro_nuevo).Close False_  
_Next_  
_End If_  
_End Sub_

No se me ocurrió como hacer el código más sencillo y al final lo que hace es recorrer el array de libros que abre y añadir las hojas sobre un libro nuevo. Tiene algunas limitaciones en la forma en la que pega las nuevas hojas pero nada que pueda ser muy complicado de solucionar. Ahora tenéis que mejorar [la entrada más visitada de este blog](https://analisisydecision.es/trucos-excel-unir-todos-los-excel-en-uno-version-muy-mejorada/) para que pueda unir en uno los Excel que se abren.