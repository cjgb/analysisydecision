---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2017-03-14'
lastmod: '2025-07-13'
related:
  - trucos-excel-unir-varios-excel-en-uno.md
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
  - truco-sas-unir-todos-los-excel-en-uno-solo.md
  - truco-sas-unir-todas-las-hojas-de-un-excel-en-una.md
  - truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
tags:
  - visual basic
title: Truco Excel. Unir todos los libros en una hoja
url: /blog/truco-excel-unir-todos-los-libros-en-una-hoja/
---

![unir_excel1](/images/2017/03/unir_excel1.png)

Los trucos de `Excel` referentes a la unión de varios libros en uno tienen mucho éxito en esta web; además, era necesario crear una versión que uniera de forma vertical. No es una unión como la que pueda hacer `Power Query` de anexar tablas con cierto sentido teniendo en cuenta el nombre de las columnas y demás; se trata de unir todas las celdas de un conjunto de libros de forma vertical en otro libro resultante, como ilustra la figura de arriba. Se unirán todos los campos unos encima de otros, independientemente de si se llaman igual o no; si queremos anexar tablas de forma rigurosa, es recomendable usar herramientas más específicas.

El funcionamiento es muy sencillo, pero lo vamos a ilustrar con imágenes. El primer paso es pulsar directamente el botón y seleccionar los archivos a unir:

![unir_excel2](/images/2017/03/unir_excel21.png)

Ahora sólo tenemos que especificar el archivo de destino; puede existir o no, el proceso lo sustituye:

![unir_excel3](/images/2017/03/unir_excel31.png)

Y *et voilà*! Ya tenemos nuestro archivo resultante. Un funcionamiento sencillo, pero el código `Visual Basic` empleado tiene algunas particularidades que pueden interesaros para otros procesos; por eso os resumo su funcionamiento:

```vba
Sub Abrir()
    Dim Hoja As Object, rango As String
    Dim X As Variant
    Dim Final As String, resultado As String, nombre As String, celda As String
    Dim largo As Long, i As Long

    Application.ScreenUpdating = False
    
    ' Seleccionar archivos a abrir
    X = Application.GetOpenFilename(FileFilter:="Archivo Excel (*.xls*), *.xls*", _
            Title:="Seleccionar Excel a unir", MultiSelect:=True)

    ' Se ejecuta si se seleccionan archivos
    If IsArray(X) Then
        ' Se va a generar un nuevo Excel
        Workbooks.Add
        ' Seleccionar el archivo a guardar
        Final = Application.GetSaveAsFilename(InitialFileName:="*.xlsx", _
                FileFilter:="Archivo Excel (*.xlsx), *.xlsx", Title:="Guardar como")
        
        If Final <> "Falso" Then
            ActiveWorkbook.SaveAs (Final)
            resultado = ActiveWorkbook.Name

            largo = 0
            For i = LBound(X) To UBound(X)
                Workbooks.Open X(i)
                nombre = ActiveWorkbook.Name
                If i = LBound(X) Then celda = "A1" Else celda = "A2"

                ' Esta parte es interesante porque nos permite copiar y pegar aunque haya celdas en blanco
                With Range(celda)
                    .Resize(Cells(Rows.Count, "A").End(xlUp).Row - (.Row - 1), _
                            Cells(5, Columns.Count).End(xlToLeft).Column - (.Column - 1)).Copy
                End With

                ' Nos ubicamos en el punto que tiene valores más uno
                Windows(resultado).Activate
                Cells(largo + 1, 1).Select
                ActiveSheet.Paste
                largo = Cells(Rows.Count, 1).End(xlUp).Row

                Workbooks(nombre).Close SaveChanges:=False
            Next i
        End If
    End If
    
    Windows(resultado).Activate
    ActiveWorkbook.Save
    Application.ScreenUpdating = True
End Sub
```

Abrimos un `array` de libros de `Excel` y seleccionamos dónde guardar. Bajo mi punto de vista, la parte más interesante del código es ésta:

```vba
With Range(celda)
   .Resize(Cells(Rows.Count, "A").End(xlUp).Row - (.Row - 1), _
           Cells(5, Columns.Count).End(xlToLeft).Column - (.Column - 1)).Copy
End With
```

Nos permite seleccionar el rango a copiar aunque haya registros sin datos o celdas en blanco (el método que usaba habitualmente tenía este problema). El último paso del proceso lo que hace es situar la celda seleccionada en el último registro y lo hace midiendo la longitud del rango seleccionado con `largo = Cells(Rows.Count, 1).End(xlUp).Row`; la primera celda sin datos será el `largo` más uno y ahí pegará los datos copiados del siguiente libro, y de este modo realiza el proceso iterativo. Al final de todo se guarda el resultado y ya tenemos nuestros datos anexados.

Para descargaros directamente el `Excel` que realiza la tarea, pulsad en el siguiente enlace:

[Unir verticalmente libros de Excel (ZIP)](/images/2017/03/Unificar_libros_Excel.zip)

Espero que sea de utilidad; yo creo que sí. Saludos.