---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2013-11-27T09:48:38-05:00'
lastmod: '2025-07-13T16:07:17.860276'
related:
- truco-excel-funcion-para-identificar-el-color-de-una-celda.md
- truco-excel-formatos-condicionales-para-crear-rango-de-colores.md
- truco-excel-grafico-de-puntos-con-colores.md
- truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
- trucos-excel-mapa-de-espana-por-provincias.md
slug: truco-excel-identificar-el-color-de-una-celda
tags: []
title: Truco Excel. Identificar el color de una celda
url: /blog/truco-excel-identificar-el-color-de-una-celda/
---

[![](/images/2013/11/color_celda_excel.png)](/images/2013/11/color_celda_excel.png)

Para identificar el color de una celda en Excel podemos emplear Interior.Color del siguiente modo:

```r
Sub Macro1()

For i = 3 To 6

dato = Cells(i, 2).Interior.Color
Cells(i, 3) = dato
Next i

End Sub
```


No funciona con formatos condicionales, si deseáis utilizar los colores de los formatos condicionales habréis de idear cómo hacerlo o bien esperar a que tenga tiempo a redactar como lo hago yo, pero que nadie se espere un programa en VB brillante, que no fui capaz de hacerlo. Saludos.