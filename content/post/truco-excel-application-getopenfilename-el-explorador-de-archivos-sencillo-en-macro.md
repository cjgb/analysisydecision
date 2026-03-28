---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2012-02-26'
lastmod: '2025-07-13'
noindex: true
related:
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
  - trucos-excel-archivos-de-un-directorio-con-una-macro.md
  - trucos-excel-unir-varios-excel-en-uno.md
  - proyecto-text-mining-con-excel-iv.md
  - trucos-excel-crear-un-borrador-de-correo-con-excel.md
tags:
  - application
  - explorador de windows
  - getopenfilename
  - macro
title: Truco Excel. Application GetOpenFilename el explorador de archivos sencillo en macro
url: /blog/truco-excel-application-getopenfilename-el-explorador-de-archivos-sencillo-en-macro/
---

`Application.GetOpenFilename` y como parámetros el texto y el tipo de archivo. Un truco de `Excel` para meter en una macro el explorador de archivos más sencillo. Por ejemplo, para obtener los archivos de `Word` de un directorio podremos hacer:

```vba
Sub obtiene_documento()
    Dim documento As Variant

    documento = Application.GetOpenFilename("Archivos Word (*.doc*), *.doc*")

    If documento <> False Then
        Cells(1, 1).Value = documento
    End If
End Sub
```

Si ejecutamos esta macro, se abrirá un explorador de `Windows` y podremos seleccionar archivos del tipo `.doc`. Nuestra selección la escribimos en la celda `(1,1)`. Para múltiples selecciones… Otro día haremos un "importador masivo" de datos en `Excel`. El más sencillo explorador de `Windows` en una macro de `Excel`. Saludos.