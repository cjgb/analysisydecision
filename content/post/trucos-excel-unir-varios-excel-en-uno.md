---
author: rvaquerizo
categories:
- Excel
- Formación
- Monográficos
- Trucos
date: '2011-09-21T14:03:15-05:00'
lastmod: '2025-07-13T16:09:27.441031'
related:
- truco-excel-unir-todos-los-libros-en-una-hoja.md
- truco-sas-unir-todos-los-excel-en-uno-solo.md
- truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
- truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
- trucos-excel-unir-todos-los-excel-en-uno-version-muy-mejorada.md
slug: trucos-excel-unir-varios-excel-en-uno
tags:
- ''
- macros
- unir excel
- visual basic
title: Trucos Excel. Unir varios Excel en uno
url: /trucos-excel-unir-varios-excel-en-uno/
---

Tenía pendiente revisar [una de las entradas más visitadas del blog](https://analisisydecision.es/truco-sas-unir-todos-los-excel-en-uno-solo/). Trata la problemática de **unir varios Excel en uno sólo**. En el caso concreto servía para unir varios Excel generados por SAS a través de una macro en SAS. En la entrada de hoy quiero trabajar con un ejemplo que os podéis [ descargar aquí en formato rar](/images/2011/09/unir_excel1.rar "unir_excel1.rar"). De los archivos que comparto el más interesante el que llamamos [unir_varios_excel.xlsm](/images/2011/09/unir_varios_excel1.xlsm "unir_varios_excel1.xlsm") se trata de un archivo Excel para macros que contiene un par de macros más que interesantes. Un pantallazo de este libro de Excel:

![unir_excel.png](/images/2011/09/unir_excel.png)

Tiene una macro _limpia_ para limpiar la colunma de archivos. Una macro _ficheros_ que se llama con el botón Listar Libros y nos permite listar los ficheros de un determinado directorio con una determinada extensión. Estos parámetros los podemos modificar en las casillas C1 y C2. Se trata de una macro que [ya hemos visto con anterioridad](https://analisisydecision.es/trucos-excel-archivos-de-un-directorio-con-una-macro/) por lo que no entraremos en profundidad con ella. La macro más interesante es la que he llamado **_Une_** y será la que nos permita **unir la primera hoja de todos los excel de un directorio en un libro final** cuyo nombre le indicamos en la celda C3. Este libro final se guardará en el mismo directorio donde están todos los archivos Excel que deseamos unir. Por supuesto es importante tener todos los Excel en el mismo directorio, el _unir_varios_excel_ no es necesario que esté en ese directorio. El contenido de esta macro os le muestro y resumo a continuación:

```r
Sub Une()

Dim nombre, libro, nombre_final, libro_final As String

'Objeto Excel

Set XL = CreateObject("Excel.Application")

XL.Visible = True

para = 0

i = 0

'Creamos el libro resultante

nombre_final = Cells(3, 3) & "." & Cells(2, 3)

libro_final = Cells(1, 3) & "\" & nombre_final
```

```r
While (para = 0)

nombre = Cells(5 + i, 1)

libro = Cells(1, 3) & "\" & nombre
```

```r
If nombre <> "" Then

XL.Workbooks.Open libro

If i = 0 Then XL.ActiveWorkbook.SaveAs libro_final, -4143

If i <> 0 Then

XL.Workbooks.Open libro

XL.Workbooks(nombre).Sheets(1).Copy , XL.Workbooks(nombre_final).Sheets(i)

XL.Workbooks(nombre).Close

End If

i = i + 1

End If

If nombre = "" Then

para = 1

XL.Workbooks(nombre_final).Close True

End If

Wend
```

``
```r
XL.Quit

End Sub
```

Creamos un objeto _XL_ como **aplicación de Excel**. Y sobre un Excel que llamamos como _nombre_final_ vamos a hacer un bucle donde la primera iteración será crear ese archivo _nombre_final_ a partir del primero de los Excel que deseamos unir. En las sucesivas iteraciones del bucle seleccionaremos la primera hoja de los libros que queremos unir y se la pegamos a las hojas de nuestro archivo resultante. Tampoco es un bucle complicado o especialmente talentoso, si os plantea alguna duda escribid un comentario. Al final se cierra nuestro resultado y el objeto Excel con el que trabajamos.

Al ser esta una primera versión que espero vaya mejorando por mi parte y por parte de las personas que deseen colaborar tiene algunas limitaciones:

  * Sólo une la **primera hoja** de los libros que deseamos unir
  * Cuando el **Excel resultante ya está creado** nos pide si deseamos sobreescribirlo
  * He detectado un **problema en Excel 2010** con el resultado cuando tratamos de guardarlo como xlsx

Poco a poco iremos puliendo estos defectos y seguramente podamos crear una aplicación en VB para unir archivos Excel más completa. Espero que os sea de utilidad, un saludo.