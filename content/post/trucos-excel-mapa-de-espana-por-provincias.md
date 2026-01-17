---
author: rvaquerizo
categories:
- Business Intelligence
- Excel
- Formación
- Trucos
date: '2010-11-15T11:06:40-05:00'
lastmod: '2025-07-13T16:09:04.420042'
related:
- nuevo-y-muy-mejorado-mapa-de-espana-por-provincias-con-excel.md
- trucos-excel-mapa-de-mexico-por-estados.md
- mapa-excel-de-europa.md
- trucos-excel-mapa-de-espana-por-provincias-mejorado.md
- nuevo-mapa-por-provincias-en-excel-de-espana-actualiza-los-colores-en-rgb.md
slug: trucos-excel-mapa-de-espana-por-provincias
tags:
- mapas
- mapas excel
title: Trucos Excel. Mapa de España por provincias
url: /blog/trucos-excel-mapa-de-espana-por-provincias/
---

Pongo a vuestra disposición un archivo Excel que nos permite la realización del siguiente gráfico:

![mapa-espana-provincias-excel.PNG](/images/2010/11/mapa-espana-provincias-excel.PNG)

[En este link podéis descargaros el archivo](/images/2010/11/provincias.xls "provincias.xls"). He elegido formato Excel 2003 para el archivo, de este modo lo podréis utilizar muchos de vosotros. Si alguien desea el formato 2007 que lo diga. De momento es una primera versión a la que iré añadiendo un mayor número de funcionalidades. Se trata de un gráfico en el que podemos variar el color de cada una de las provincias mediante la siguiente macro:

```r
Sub prov()

For i = 4 To 53
```

```r
ca = Cells(i, 12)

colorin = Cells(i, 13)

ActiveSheet.Shapes(ca).Select

  Selection.ShapeRange.Fill.ForeColor.SchemeColor = colorin

Next i

End Sub
```

Cada objeto tiene un nombre que tenéis en las celdas ocultas, tenéis visibles los nombres de las provincias y el color que le vincula a cada objeto. De momento es lo más simple, los colores tenéis que especificarlos vosotros y no hay leyenda. Hay que añadir una paleta de colores, crear rangos de valores y la leyenda. En sucesivas entregas iremos mejorando este gráfico. Espero que os ayude en vuestro trabajo diario. Saludos.