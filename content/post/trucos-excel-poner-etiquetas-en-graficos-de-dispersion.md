---
author: rvaquerizo
categories:
- Excel
- Formación
- Monográficos
- Trucos
date: '2011-04-11T05:47:32-05:00'
slug: trucos-excel-poner-etiquetas-en-graficos-de-dispersion
tags:
- ''
- etiquetas
- grafico dispersion
title: Trucos Excel. Poner etiquetas en gráficos de dispersión
url: /trucos-excel-poner-etiquetas-en-graficos-de-dispersion/
---

Una macro de Visual Basic muy sencilla es la única forma de etiquetar gráficos de dispersión que me he encontrado. Si alguien encuentra otro modo más sencillo de hacerlo que lo comente en estas líneas. La intencion es llegar a este gráfico:

![etiquetas-grafico-dispersion-excel-1.png](/images/2011/04/etiquetas-grafico-dispersion-excel-1.png)

No es que sea un gran gráfico, recordad que está hecho en Excel, pero nos permite ver como se distribuyen los paises en función de la renta per cápita y el número de horas trabajadas al año. Además podemos identificarlos perfectamente, como es el caso de Luxemburgo, como siempre. Los datos para realizar este gráfico están en la [web de la OCDE](http://stats.oecd.org/Index.aspx?DataSetCode=DECOMP). Nos los descargamos en Excel y tenemos una tabla de esta forma:

![etiquetas-grafico-dispersion-excel-2.png](/images/2011/04/etiquetas-grafico-dispersion-excel-2.png)

En este punto realizamos el gráfico de dispersión y a la hora de introducir las etiquetas nos encontraríamos con este cuadro de diálogo:

![etiquetas-grafico-dispersion-excel-3.png](/images/2011/04/etiquetas-grafico-dispersion-excel-3.png)

Por más vueltas que le he dado al tema no he encontrado la forma de añadir las etiquetas en la forma que deseo. Sin embargo, en menos de 5 minutos, mediante una macro he llegado al gráfico que os pongo arriba. Lo primero que he hecho es cambiar las cabeceras para no perderme, es que no hay mucho donde rascar:

![etiquetas-grafico-dispersion-excel-4.png](/images/2011/04/etiquetas-grafico-dispersion-excel-4.png)

Ahora hay **dos puntos importantes** :

  * Excel respeta el orden de las series en el gráfico
  * Podemos poner lo que necesitemos en la propiedad _DataLabel.Text  
_

Con esto hacemos la siguiente macro de Excel:

```r
Sub etiquetas()

'

' Macro realizada por www.analisisydecision.es

'

Dim texto As String

ActiveSheet.ChartObjects("1 Gráfico").Activate

ActiveChart.SeriesCollection(1).Select

ActiveChart.SeriesCollection(1).ApplyDataLabels

i = 2

para = 0

While para = 0

texto = Cells(i, 2)

punto = Cells(i, 1)

If texto <> "" Then

ActiveChart.SeriesCollection(1).Points(punto).DataLabel.Select

ActiveChart.SeriesCollection(1).Points(punto).DataLabel.Text = texto

Else

para = 1

End If

i = i + 1

Wend

End Sub
```

No es una macro muy compleja y que podéis adaptar perfectamente a otros usos. Recordad los puntos más importantes que os indiqué con anterioridad.