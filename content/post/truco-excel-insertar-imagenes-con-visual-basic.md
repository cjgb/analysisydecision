---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2015-09-15'
lastmod: '2025-07-13'
related:
  - trucos-excel-crear-un-borrador-de-correo-con-excel.md
  - truco-excel-unir-todos-los-libros-en-una-hoja.md
  - truco-excel-abrir-multiples-libros-de-excel-en-distintas-hojas-de-un-nuevo-libro.md
  - truco-excel-pasar-un-rango-de-varias-columnas-a-una.md
  - trucos-excel-archivos-de-un-directorio-con-una-macro.md
tags:
  - excel
  - formación
  - trucos
title: Truco Excel. Insertar imágenes con Visual Basic
url: /blog/truco-excel-insertar-imagenes-con-visual-basic/
---

Si deseáis insertar una imagen en Excel desde Visual Basic mediante una macro tenéis que ejecutar un código similar a este:

```r
Sub inserta_imagen(hoja)

Sheets(hoja).Select

ActiveSheet.Pictures.Insert("C:\grafico.png").Select

With Selection.ShapeRange

.Top = Range("B5").Top

.Left = Range("B5").Left

End With

End Sub
```

En una hoja de vuestro libro de Excel insertáis el archivo especificado. Luego lo ubicáis donde sea necesario. En el ejemplo que os he puesto en la celda B5. Truco sencillo, saludos.
