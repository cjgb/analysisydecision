---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2015-01-21'
lastmod: '2025-07-13'
related:
  - truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
  - trucos-excel-poner-etiquetas-en-graficos-de-dispersion.md
  - truco-excel-formatos-condicionales-para-crear-rango-de-colores.md
  - truco-excel-identificar-el-color-de-una-celda.md
  - trucos-excel-mapa-de-espana-por-provincias.md
tags:
  - excel
  - formación
  - trucos
title: Truco Excel. Gráfico de puntos con colores
url: /blog/truco-excel-grafico-de-puntos-con-colores/
---

![](/images/2015/01/dispersion-con-colores-de-grupos-excel-300x237.png)

Un gráfico de dispersión en `Excel` en el que los puntos puedan ser identificados si pertenecen a un grupo. [Es una duda que plantearon hace unos días en el blog](https://analisisydecision.es/trucos-excel-poner-etiquetas-en-graficos-de-dispersion/#comment-72700). Con otras herramientas es bastante sencillo, pero en el caso de `Excel`, la tarea no es tan evidente.

Para poder hacer gráficos de este tipo, he construido una macro que podéis utilizar si previamente la adaptáis a vuestros datos. El código que podéis adaptar una vez hayáis creado vuestro gráfico de dispersión es:

```vba
Sub ColoreaPuntosPorGrupo()
    ' Macro realizada por www.analisisydecision.es
    Dim vec As Variant
    Dim numpuntos As Long
    Dim i As Long
    Dim grupo As Integer

    ' Activamos el gráfico (asegúrate de que el nombre sea correcto)
    ActiveSheet.ChartObjects(1).Activate
    ActiveChart.SeriesCollection(1).Select
    
    ' Obtenemos los valores para contar el número de puntos
    vec = ActiveChart.SeriesCollection(1).Values
    numpuntos = UBound(vec)

    For i = 1 To numpuntos
        ' Suponemos que el grupo está en la columna 3, a partir de la fila 3
        grupo = Cells(i + 2, 3).Value

        ' Seleccionamos el punto i de la serie 1
        With ActiveChart.SeriesCollection(1).Points(i)
            If grupo = 1 Then .Format.Fill.ForeColor.RGB = 3969653
            If grupo = 2 Then .Format.Fill.ForeColor.RGB = 255
            If grupo = 3 Then .Format.Fill.ForeColor.RGB = 14922893
        End With
    Next i
End Sub
```

Lo primero: tenemos una variable tipo `Variant` que nos permitirá obtener el número de puntos que deseamos colorear. Seleccionamos el gráfico de dispersión y la única serie de datos es la 1 (no hay más). Buscamos el número de puntos que tiene nuestra serie y hacemos un bucle que recorre cada uno de los puntos de la serie que queremos colorear. Evidentemente, necesitamos saber a qué grupo pertenece cada punto. Después seleccionamos punto por punto y, si pertenece a un grupo, le ponemos un color con `.Format.Fill.ForeColor.RGB`; el color lo podéis buscar o elegir de la paleta de colores; [en este blog ya se ha escrito sobre cómo saber el número de color](https://analisisydecision.es/truco-excel-identificar-el-color-de-una-celda/).

Si en vez de grupos usáis formatos condicionales y otras cosas, pueden quedar resultados muy buenos. Pero esto me lo guardo para otro día. Espero que os sea útil el truco. Saludos.