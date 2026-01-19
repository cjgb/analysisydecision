---
author: rvaquerizo
categories:
  - formación
  - machine learning
date: '2020-10-02'
lastmod: '2025-07-13'
related:
  - macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
  - monografico-un-poco-de-proc-logistic.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
  - grafico-de-barras-y-lineas-con-python.md
  - el-analisis-de-supervivencia-para-segmentar-el-churn.md
tags:
  - formación
  - machine learning
title: Transformaciones de variables cuantitativas en modelos binomiales
url: /blog/transformaciones-de-variables-cuantitativas-en-modelos-binomiales/
---

Para mejorar la capacidad predictiva de nuestros modelos binomiales es recomendable transformar las variables independientes. Existen técnicas que lo hacen de modo automático pero hoy os quería mostrar en un video un método «casero» para agrupar una variable cuantitativa con respecto a una variable respuesta, todo muy orientado a que la transformación tenga un sentido de negocio.

El código empleado para hacer el video es el siguiente:

```r
from urllib import urlretrieve
link = 'https://raw.githubusercontent.com/yhat/demo-churn-pred/master/model/churn.csv'
urlretrieve(link, "churn.txt")

import pandas as pd
import numpy as np
df = pd.read_csv("churn.txt")
df.head(5)

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

pd.crosstab(df['Churn?'], columns='count').plot(kind='bar')
plt.show();

df['churn'] = np.where(df['Churn?'] == 'True.', 1, 0)

pd.crosstab(df['churn'], columns='count')

df['Day Mins'].isnull().sum()
df['Day Mins'].describe()
plt.hist(df['Day Mins'], bins=20); plt.show();

df['minutos'] = np.where(df['Day Mins'] >= 270, 270, (df['Day Mins']//10)*10)
df['minutos'] = np.where(df['minutos'] <= 70, 70, df['minutos'])

pd.crosstab(df['minutos'], columns='count')
plt.hist(df['minutos']); plt.show();

churn =  pd.DataFrame((df['churn']).groupby(df['minutos']).mean())
clientes = pd.DataFrame((df['churn']).groupby(df['minutos']).count())

fig = plt.figure()
ax = clientes['churn'].plot(kind='bar', grid=True)
ax2 = ax.twinx()
ax2.plot(churn['churn'].values, linestyle='-', linewidth=2.0,color='red')
plt.show();
```
