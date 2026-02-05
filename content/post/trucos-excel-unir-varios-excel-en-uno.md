---
author: rvaquerizo
categories:
  - excel
  - formación
  - monográficos
  - trucos
  - vba
date: '2011-09-21'
lastmod: '2025-07-13'
related:
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
  - truco-sas-unir-todos-los-excel-en-uno-solo.md
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
  - truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
  - trucos-excel-unir-todos-los-excel-en-uno-version-muy-mejorada.md
tags:
  - macros
  - unir excel
  - visual basic
title: Trucos Excel. Unir varios Excel en uno
url: /blog/trucos-excel-unir-varios-excel-en-uno/
---

Tenía pendiente revisar [una de las entradas más visitadas del blog](https://analisisydecision.es/truco-sas-unir-todos-los-excel-en-uno-solo/). Trata la problemática de **unir varios `Excel` en uno solo**. En el caso concreto, servía para unir varios `Excel` generados por SAS a través de una macro en SAS. En la entrada de hoy, quiero trabajar con un ejemplo que os podéis [descargar aquí en formato RAR](/images/2011/09/unir_excel1.rar "unir_excel1.rar").

De los archivos que comparto, el más interesante es el que llamamos [unir_varios_excel.xlsm](/images/2011/09/unir_varios_excel1.xlsm "unir_varios_excel1.xlsm"): se trata de un archivo `Excel` para macros que contiene un par de macros más que interesantes. Un pantallazo de este libro de `Excel`:

![unir_excel.png](/images/2011/09/unir_excel.png)

Tiene una macro `limpia` para limpiar la columna de archivos. Una macro `ficheros` que se llama con el botón **Listar Libros** y nos permite listar los ficheros de un determinado directorio con una determinada extensión. Estos parámetros los podemos modificar en las casillas `C1` y `C2`. Se trata de una macro que [ya hemos visto con anterioridad](https://analisisydecision.es/trucos-excel-archivos-de-un-directorio-con-una-macro/), por lo que no entraremos en profundidad con ella.

La macro más interesante es la que he llamado `Une`, y será la que nos permita **unir la primera hoja de todos los `Excel` de un directorio en un libro final** cuyo `nombre_final` le indicamos en la celda `C3`. Este libro final se guardará en el mismo directorio donde están todos los archivos `Excel` que deseamos unir. Por supuesto, es importante tener todos los `Excel` en el mismo directorio; el archivo `unir_varios_excel.xlsm` no es necesario que esté en ese directorio. El contenido de esta macro os lo muestro y resumo a continuación:

```vba
Sub Une()
    ' Macro realizada por www.analisisydecision.es
    Dim nombre As String, libro As String, nombre_final As String, libro_final As String
    Dim XL As Object
    Dim para As Integer, i As Integer

    ' Objeto Excel
    Set XL = CreateObject("Excel.Application")
    XL.Visible = True

    para = 0
    i = 0

    ' Creamos el libro resultante
    nombre_final = Cells(3, 3).Value & "." & Cells(2, 3).Value
    libro_final = Cells(1, 3).Value & "\" & nombre_final

    While (para = 0)
        nombre = Cells(5 + i, 1).Value
        libro = Cells(1, 3).Value & "\" & nombre

        If nombre <> "" Then
            If i = 0 Then
                XL.Workbooks.Open libro
                XL.ActiveWorkbook.SaveAs libro_final, -4143
            Else
                XL.Workbooks.Open libro
                ' Pegamos la primera hoja del libro i al libro final
                XL.Workbooks(nombre).Sheets(1).Copy After:=XL.Workbooks(nombre_final).Sheets(XL.Workbooks(nombre_final).Sheets.Count)
                XL.Workbooks(nombre).Close SaveChanges:=False
            End If
            i = i + 1
        Else
            para = 1
            XL.Workbooks(nombre_final).Close SaveChanges:=True
        End If
    Wend

    XL.Quit
    Set XL = Nothing
End Sub
```

Creamos un objeto `XL` como **aplicación de `Excel`**. Y sobre un `Excel` que llamamos como `nombre_final` vamos a hacer un bucle donde la primera iteración será crear ese archivo `nombre_final` a partir del primero de los `Excel` que deseamos unir. En las sucesivas iteraciones del bucle, seleccionaremos la primera hoja de los libros que queremos unir y se la pegamos a las hojas de nuestro archivo resultante. Tampoco es un bucle complicado o especialmente talentoso; si os plantea alguna duda, escribid un comentario. Al final se cierra nuestro resultado y el objeto `Excel` con el que trabajamos.

Al ser ésta una primera versión, que espero vaya mejorando por mi parte y por parte de las personas que deseen colaborar, tiene algunas limitaciones:

- Sólo une la **primera hoja** de los libros que deseamos unir.
- Cuando el **`Excel` resultante ya está creado**, nos pide si deseamos sobreescribirlo.
- He detectado un **problema en `Excel` 2010** con el resultado cuando tratamos de guardarlo como `.xlsx`.

Poco a poco iremos puliendo estos defectos y seguramente podamos crear una aplicación en `Visual Basic` para unir archivos `Excel` más completa. Espero que os sea de utilidad. Saludos.