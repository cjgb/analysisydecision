---
author: rvaquerizo
categories:
- formación
- python
date: '2017-05-27'
lastmod: '2025-07-13'
related:
- mosaic-plot-con-r.md
- grafico-de-barras-y-lineas-con-python.md
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
- grafico-de-correlaciones-entre-variables.md
- truco-r-paletas-de-colores-en-r.md
tags:
- sin etiqueta
title: Mosaic plot con python
url: /blog/mosaic-plot-con-python/
---
Entrada análoga [a otra realizada con R hace mucho tiempo](https://analisisydecision.es/mosaic-plot-con-r/) empleando R, ahora realizo esta tarea con pytho. Estos gráficos van a ser necesarios para un fregado en el que ando metido ahora y como podéis ver es una tarea muy sencilla:

```r
import pandas as pd
df = pd.read_csv('http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data/claimslong.csv')

from statsmodels.graphics.mosaicplot import mosaic
mosaic(df, ['agecat', 'valuecat'])
show()
```


Y da como resultado:

[![mosaic_plot_python](/images/2017/05/mosaic_plot_python.png)](/images/2017/05/mosaic_plot_python.png)

Saludos.

~~¿Si hacemos modelos de riesgo con python?~~
~~~~