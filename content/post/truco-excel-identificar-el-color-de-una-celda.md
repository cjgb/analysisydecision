---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2013-11-27'
lastmod: '2025-07-13'
related:
  - truco-excel-funcion-para-identificar-el-color-de-una-celda.md
  - truco-excel-formatos-condicionales-para-crear-rango-de-colores.md
  - truco-excel-grafico-de-puntos-con-colores.md
  - truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
  - trucos-excel-mapa-de-espana-por-provincias.md
tags:
  - excel
  - formación
  - trucos
title: Truco Excel. Identificar el color de una celda
url: /blog/truco-excel-identificar-el-color-de-una-celda/
---

![color_celda_excel](/images/2013/11/color_celda_excel.png)

Para identificar el color de una celda en `Excel`, podemos emplear `Interior.Color` del siguiente modo:

```vba
Sub Macro1()
    Dim i As Long
    Dim dato As Long

    For i = 3 To 6
        dato = Cells(i, 2).Interior.Color
        Cells(i, 3).Value = dato
    Next i
End Sub
```

No funciona con formatos condicionales; si deseáis utilizar los colores de los formatos condicionales, habréis de idear cómo hacerlo o bien esperar a que tenga tiempo a redactar cómo lo hago yo; pero que nadie se espere un programa en `Visual Basic` brillante, que no fui capaz de hacerlo. Saludos.