---
author: rvaquerizo
categories:
- Formación
- Python
date: '2017-05-27T12:33:54-05:00'
slug: mosaic-plot-con-python
tags: []
title: Mosaic plot con python
url: /mosaic-plot-con-python/
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