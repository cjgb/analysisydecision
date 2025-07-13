---
author: rvaquerizo
categories:
- Formación
- Python
date: '2017-07-09T12:04:35-05:00'
slug: grafico-de-barras-y-lineas-con-python
tags: []
title: Gráfico de barras y líneas con Python
url: /grafico-de-barras-y-lineas-con-python/
---

[![grafico de barras y lineas python](/images/2017/07/grafico-de-barras-y-lineas-python.png)](/images/2017/07/grafico-de-barras-y-lineas-python.png)

Típico gráfico de dos ejes de barras y líneas donde las barras miden una exposición y las líneas una frecuencia, en el mundo actuarial son muy habituales y son muy útiles para ver proporciones dentro de grupos a la vez que representamos el tamaño del grupo. Los datos habituales del curso de GLM for insurance data:

```r
import pandas as pd
import io
import requests
#Lectura de un data set con número de siniestros de una cartera de automóviles
url = 'http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data/claimslong.csv'
s = requests.get(url).content
df = pd.read_csv(io.StringIO(s.decode('utf-8')))

df.head()
```
 

Ya tenemos un data frame con nuestros datos leyendo directamente del csv, ahora preparamos los datos para representarlos:

```r
frecuencia =  pd.DataFrame((df['claim']).groupby(df['period']).mean())
exposicion = pd.DataFrame((df['claim']).groupby(df['period']).count())
```
 

No tenemos un campo exposición en los datos, asumo que la exposición es igual al número de registros así que la frecuencia será la media de los siniestros y la exposición el total de registros, el análisis lo hacemos por el campo period, es el campo por el que agrupamos y ahora solo tenemos que realizar el gráfico:

```r
import matplotlib.pyplot as plt

fig = plt.figure()
ax = exposicion['claim'].plot(kind='bar',grid=True)
ax2 = ax.twinx()
ax2.plot(frecuencia['claim'].values, linestyle='-', linewidth=2.0,color='red')
plt.show();
```
 

El eje principal es ax y representa la exposición en barras, con ax.twinx añadimos eje secundario, ax2 que será la línea que contiene la frecuencia. No es un código python complejo y es un tipo de gráfico que nos ofrece mucha información. En breve GLM con python (espero).