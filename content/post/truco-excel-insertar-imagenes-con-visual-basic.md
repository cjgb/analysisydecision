---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2015-09-15T07:26:18-05:00'
slug: truco-excel-insertar-imagenes-con-visual-basic
tags: []
title: Truco Excel. Insertar imágenes con Visual Basic
url: /truco-excel-insertar-imagenes-con-visual-basic/
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