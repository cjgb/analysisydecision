---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2012-02-26T14:15:30-05:00'
lastmod: '2025-07-13T16:07:07.245141'
related:
- truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
- trucos-excel-archivos-de-un-directorio-con-una-macro.md
- trucos-excel-unir-varios-excel-en-uno.md
- proyecto-text-mining-con-excel-iv.md
- trucos-excel-crear-un-borrador-de-correo-con-excel.md
slug: truco-excel-application-getopenfilename-el-explorador-de-archivos-sencillo-en-macro
tags:
- Application
- explorador de windows
- GetOpenFilename
- macro
title: Truco Excel. Application GetOpenFilename el explorador de archivos sencillo
  en macro
url: /truco-excel-application-getopenfilename-el-explorador-de-archivos-sencillo-en-macro/
---

Application.GetOpenFilename y como parámetros el texto y el tipo de archivo. Un truco excel para meter en una macro el explorador de archivos más sencillo. Por ejemplo para obtener los archivos de Word de un directorio podremos hacer:

```r
Sub obtiene_documento()

Dim documento As String

documento = Application.GetOpenFilename("Archivos Word (*.doc*), *.doc*")

Cells(1, 1) = documento

End Sub
```

Si ejecutamos esta macro se abrirá un explorador de windows y podremos seleccionar archivos del tipo *.doc*. Nuestra selección la escribimos en la celda (1,1). Para múltiples selecciones… Otro día haremos un «importador masivo» de datos en excel. El más sencillo explorador de windows en una macro de Excel. Saludos.