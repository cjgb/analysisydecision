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
  - formación
  - python
title: Mosaic plot con Python
url: /blog/mosaic-plot-con-python/
---

Entrada análoga [a otra realizada con R hace mucho tiempo](https://analisisydecision.es/mosaic-plot-con-r/) empleando R; ahora realizo esta tarea con Python. Estos gráficos van a ser necesarios para un fregado en el que ando metido ahora y, como podéis ver, es una tarea muy sencilla:

```python
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.graphics.mosaicplot import mosaic

url = 'http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data/claimslong.csv'
df = pd.read_csv(url)

mosaic(df, ['agecat', 'valuecat'])
plt.show()
```

Y da como resultado:

![mosaic_plot_python](/images/2017/05/mosaic_plot_python.png)

Saludos.