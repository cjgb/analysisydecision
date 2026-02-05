---
author: rvaquerizo
categories:
  - excel
  - formación
  - monográficos
  - trucos
date: '2011-04-11'
lastmod: '2025-07-13'
related:
  - truco-excel-grafico-de-puntos-con-colores.md
  - truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
  - trucos-excel-graficos-dot-plot-representando-un-ranking-graficamente.md
  - chart-tools-un-add-in-imprescindible-para-excel.md
  - trucos-excel-mapa-de-espana-por-provincias.md
tags:
  - etiquetas
  - grafico dispersion
title: Trucos Excel. Poner etiquetas en gráficos de dispersión
url: /blog/trucos-excel-poner-etiquetas-en-graficos-de-dispersion/
---

Una macro de `Visual Basic` muy sencilla es la única forma de etiquetar gráficos de dispersión que me he encontrado. Si alguien encuentra otro modo más sencillo de hacerlo, que lo comente en estas líneas. La intención es llegar a este gráfico:

![etiquetas-grafico-dispersion-excel-1.png](/images/2011/04/etiquetas-grafico-dispersion-excel-1.png)

No es que sea un gran gráfico (recordad que está hecho en `Excel`), pero nos permite ver cómo se distribuyen los países en función de la renta per cápita y el número de horas trabajadas al año. Además podemos identificarlos perfectamente, como es el caso de Luxemburgo, como siempre.

Los datos para realizar este gráfico están en la [web de la OCDE](http://stats.oecd.org/Index.aspx?DataSetCode=DECOMP). Nos los descargamos en `Excel` y tenemos una tabla de esta forma:

![etiquetas-grafico-dispersion-excel-2.png](/images/2011/04/etiquetas-grafico-dispersion-excel-2.png)

En este punto realizamos el gráfico de dispersión y, a la hora de introducir las etiquetas, nos encontraríamos con este cuadro de diálogo:

![etiquetas-grafico-dispersion-excel-3.png](/images/2011/04/etiquetas-grafico-dispersion-excel-3.png)

Por más vueltas que le he dado al tema, no he encontrado la forma de añadir las etiquetas en la forma que deseo. Sin embargo, en menos de cinco minutos, mediante una macro he llegado al gráfico que os pongo arriba. Lo primero que he hecho es cambiar las cabeceras para no perderme (es que no hay mucho donde rascar):

![etiquetas-grafico-dispersion-excel-4.png](/images/2011/04/etiquetas-grafico-dispersion-excel-4.png)

Ahora hay **dos puntos importantes**:

- `Excel` respeta el orden de las series en el gráfico.
- Podemos poner lo que necesitemos en la propiedad `.DataLabel.Text`.

Con esto hacemos la siguiente macro de `Excel`:

```vba
Sub etiquetas()
    ' Macro realizada por www.analisisydecision.es
    Dim texto As String
    Dim punto As Integer
    Dim i As Integer
    Dim para As Integer

    ActiveSheet.ChartObjects(1).Activate
    ActiveChart.SeriesCollection(1).ApplyDataLabels

    i = 2
    para = 0

    While para = 0
        texto = Cells(i, 2).Value
        punto = Cells(i, 1).Value

        If texto <> "" Then
            With ActiveChart.SeriesCollection(1).Points(punto)
                .HasDataLabel = True
                .DataLabel.Text = texto
            End With
        Else
            para = 1
        End If
        i = i + 1
    Wend
End Sub
```

No es una macro muy compleja y la podéis adaptar perfectamente a otros usos. Recordad los puntos más importantes que os indiqué con anterioridad. Saludos.