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

Para mejorar la capacidad predictiva de nuestros modelos binomiales, es recomendable transformar las variables independientes. Existen técnicas que lo hacen de modo automático, pero hoy os quería mostrar en un vídeo un método "casero" para agrupar una variable cuantitativa con respecto a una variable respuesta, todo muy orientado a que la transformación tenga un sentido de negocio.

El código empleado para hacer el vídeo es el siguiente:

```python
from urllib.request import urlretrieve
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

link = 'https://raw.githubusercontent.com/yhat/demo-churn-pred/master/model/churn.csv'
urlretrieve(link, "churn.csv")

df = pd.read_csv("churn.csv")
df.head(5)

# Visualización de la variable objetivo
pd.crosstab(df['Churn?'], columns='count').plot(kind='bar')
plt.show()

# Creación de la variable target numérica
df['churn_num'] = np.where(df['Churn?'] == 'True.', 1, 0)

# Análisis de la variable 'Day Mins'
print(df['Day Mins'].describe())
plt.hist(df['Day Mins'], bins=20)
plt.show()

# Transformación casera: agrupamiento por tramos de 10 minutos con límites
df['minutos_cat'] = np.where(df['Day Mins'] >= 270, 270, (df['Day Mins'] // 10) * 10)
df['minutos_cat'] = np.where(df['minutos_cat'] <= 70, 70, df['minutos_cat'])

# Cálculo de tasa de churn por tramo
churn_rate = df.groupby('minutos_cat')['churn_num'].mean()
counts = df.groupby('minutos_cat')['churn_num'].count()

# Gráfico de doble eje: volumen de clientes y tasa de churn
fig, ax1 = plt.subplots()

ax1.bar(counts.index.astype(str), counts.values, color='skyblue', label='Clientes')
ax1.set_xlabel('Tramos de Minutos')
ax1.set_ylabel('Número de Clientes')
ax1.grid(True, axis='y')

ax2 = ax1.twinx()
ax2.plot(churn_rate.values, linestyle='-', linewidth=2.0, color='red', label='Tasa de Churn')
ax2.set_ylabel('Tasa de Churn')

plt.title('Transformación de variable Day Mins')
plt.show()
```