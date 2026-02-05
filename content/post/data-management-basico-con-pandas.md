---
author: rvaquerizo
categories:
  - formación
  - python
date: '2019-04-26'
lastmod: '2025-07-13'
related:
  - manejo-de-datos-basico-con-python-datatable.md
  - data-management-con-dplyr.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - primeros-pasos-con-julia-importar-un-csv-y-basicos-con-un-data-frame.md
  - truco-python-seleccionar-o-eliminar-variables-de-un-data-frame-en-base-a-un-prefijo-sufijo-o-si-contienen-un-caracter.md
tags:
  - pandas
title: Data Management básico con Pandas
url: /blog/data-management-basico-con-pandas/
---

Entrada dedicada al manejo de datos más básico con Python y Pandas; [es análoga a otra ya realizada con `dplyr` para R](https://analisisydecision.es/data-management-con-dplyr/). Sirve para tener de un vistazo las tareas más habituales que realizamos en el día a día con Pandas. Para aquel que se esté introduciendo al uso de Python, puede ser de utilidad tener todo junto y más claro; a mí personalmente me sirve para no olvidar cosas que ya no uso. En una sola entrada recogemos las dudas más básicas cuando nos estamos iniciando con Python. Las tareas más comunes son:

- Seleccionar columnas con Python Pandas
- Eliminar columnas con Python Pandas
- Seleccionar registros con Python Pandas
- Crear nuevas variables con Python Pandas
- Sumarizar datos con Python Pandas
- Ordenar datos con Python Pandas
- Renombrar variables con Python Pandas

Para variar, vamos a emplear el conjunto de datos `iris`, que nos descargamos directamente de una URL; para ello, las primeras sentencias que hemos de ejecutar son las siguientes:

```python
import pandas as pd
import io
import requests

url = 'https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv'
s = requests.get(url).content
df = pd.read_csv(io.StringIO(s.decode('utf-8')))
```

Este código es un buen ejemplo de cómo obtener un CSV directamente de una URL, porque en ocasiones pueden surgir problemas.

**Seleccionar columnas con Pandas Python**:
Directamente:

```python
df2 = df[['sepal_length', 'sepal_width']]
df2.head()
```

Mediante una lista, parece más claro:

```python
seleccionadas = ['sepal_length', 'sepal_width']
df2 = df[seleccionadas]
df2.head()
```

**Eliminar columnas**:

```python
df3 = df.drop(columns=['sepal_length', 'sepal_width'])
df3.head()
```

**Seleccionar registros con Pandas Python**:

Con condiciones simples (los operadores se pueden consultar, pero no son "extraños"). También se presenta la función `value_counts()`, que es una sumarización muy habitual.

```python
df['species'].value_counts()
df4 = df[df['species'] == "setosa"]
df4['species'].value_counts()
```

Algo que tiene especial relevancia (desde mi punto de vista) son los paréntesis en condiciones complejas o múltiples cuando usamos Pandas:

```python
df5 = df.loc[(df.sepal_length < 5) & (df.species == "setosa")]
df6 = df[(df['sepal_length'] < 5) & (df['species'] != "setosa")]
```

Particularmente, la función `isin` para hacer condiciones del tipo `IN` en listas la encuentro de mucha utilidad:

```python
lista = ['setosa', 'virginica']
df7 = df[df['species'].isin(lista)]
df7['species'].value_counts()
```

**Crear nuevas variables con Pandas Python**:

```python
df['sepal_length_tipi'] = df['sepal_length'] / df['sepal_length'].mean()
df['sepal_length_tipi'].describe()
```

En este sentido destacaría el uso de la función de NumPy `where` (el famoso `np.where`), que trabaja igual que el `ifelse` de R:

```python
import numpy as np

df['sepal_length_altas'] = np.where(df['sepal_length'] > np.mean(df['sepal_length']),
                                    "Por encima de la media", "Por debajo de la media")
df['sepal_length_altas'].value_counts()
```

**Sumarizar datos con Pandas Python**:

```python
df[['sepal_length', 'species']].groupby('species').mean()
df[['sepal_length', 'species']].groupby('species').count()
```

Para sumarizar por múltiples columnas, tienes que listar variables.

**Ordenar data frames con Pandas Python**:

```python
df.sort_values(by=['sepal_length'], ascending=False)
```

Si queremos ordenar por múltiples campos del `data.frame` con distintos órdenes:

```python
df.sort_values(by=['species', 'sepal_length'], ascending=[True, False])
```

Pero en pocas líneas quedan recogidas las principales tareas con registros y columnas que se pueden hacer en un `data.frame` con Pandas. La siguiente entrada irá encaminada a la unión de `data.frames` con Python y Pandas.

**Renombrar variables con Python Pandas**:

```python
df = df.rename(columns={'sepal_length': 'largo_sepalo', 'sepal_width': 'ancho_sepalo'})
```