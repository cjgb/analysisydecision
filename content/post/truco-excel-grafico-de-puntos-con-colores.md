---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2015-01-21T10:40:29-05:00'
lastmod: '2025-07-13T16:07:14.830927'
related:
- truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
- trucos-excel-poner-etiquetas-en-graficos-de-dispersion.md
- truco-excel-formatos-condicionales-para-crear-rango-de-colores.md
- truco-excel-identificar-el-color-de-una-celda.md
- trucos-excel-mapa-de-espana-por-provincias.md
slug: truco-excel-grafico-de-puntos-con-colores
tags: []
title: Truco Excel. Gráfico de puntos con colores
url: /blog/truco-excel-grafico-de-puntos-con-colores/
---

[![](/images/2015/01/dispersion-con-colores-de-grupos-excel-300x237.png)](/images/2015/01/dispersion-con-colores-de-grupos-excel.png)

Un gráfico de dispersión en Excel en el que los puntos puedan ser identificados si pertenecen a un grupo. [Es una duda que plantearon hace unos días en el blog](https://analisisydecision.es/trucos-excel-poner-etiquetas-en-graficos-de-dispersion/#comment-72700). Con otras herramientas es bastante sencillo, pero en el caso de Excel la tarea no es tan evidente. Para poder hacer gráficos de este tipo he construido una macro que podéis utilizar si previamente la adaptáis a vuestros datos. El código que podéis adaptar una vez halláis creado vuestro gráfico de dispersión es:

```r
Sub Macro2()
'
' Macro realizada por analisisydecision.es
'
Dim vec As Variant

'
    ActiveSheet.ChartObjects("grafico").Activate
    ActiveChart.SeriesCollection(1).Select
    vec = ActiveChart.SeriesCollection(1).Values
    numpuntos = UBound(vec)

    For i = 1 To numpuntos
    grupo = Cells(i + 2, 3)

    ActiveChart.SeriesCollection(1).Points(i).Select

    If grupo = 1 Then Selection.Format.Fill.ForeColor.RGB = 3969653
    If grupo = 2 Then Selection.Format.Fill.ForeColor.RGB = 255
    If grupo = 3 Then Selection.Format.Fill.ForeColor.RGB = 14922893
    Next i

    ActiveSheet.ChartObjects("grafico").Activate

End Sub
```


Lo primero tenemos una variable tipo variant que nos permitirá obtener el número de puntos que deseamos colorear. Seleccionamos el gráfico de dispersión y la única serie de datos es la 1, no hay más. Buscamos el número de puntos que tiene nuestra serie y hacemos un bucle que se recorre cada uno de los puntos de la serie que queremos colorear. Evidentemente necesitamos saber a que grupo pertenece cada punto. Después seleccionamos punto por punto y si pertenece a un grupo le ponemos un color con Selection.Format.Fill.ForeColor.RGB, el color le podéis buscar o elegir de la paleta de colores, [en este blog ya se ha escrito sobre saber el número de color](https://analisisydecision.es/truco-excel-identificar-el-color-de-una-celda/). Si en vez de grupos usáis formatos condicionales y otras cosas pueden quedar resultados muy buenos. Pero esto me lo guardo para otro día. Espero que os sea útil el truco. Saludos.