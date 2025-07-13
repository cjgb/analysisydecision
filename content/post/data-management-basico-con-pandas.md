---
author: rvaquerizo
categories:
- Formación
- Python
date: '2019-04-26T10:25:17-05:00'
lastmod: '2025-07-13T15:56:03.257093'
related:
- manejo-de-datos-basico-con-python-datatable.md
- data-management-con-dplyr.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
- primeros-pasos-con-julia-importar-un-csv-y-basicos-con-un-data-frame.md
- truco-python-seleccionar-o-eliminar-variables-de-un-data-frame-en-base-a-un-prefijo-sufijo-o-si-contienen-un-caracter.md
slug: data-management-basico-con-pandas
tags:
- Pandas
title: Data Management básico con Pandas
url: /data-management-basico-con-pandas/
---

Entrada dedicada al manejo de datos más básico con Python y Pandas, [es análoga a otra ya realizada con dplyr para R](https://analisisydecision.es/data-management-con-dplyr/). Sirve para tener en un vistazo las tareas más habituales que realizamos en el día a día con Pandas. Para aquel que se esté introduciendo al uso de Python puede ser de utilidad tener todo junto y más claro, a mi personalmente me sirve para no olvidar cosas que ya no uso. En una sola entrada recogemos las dudas más básicas cuando nos estamos iniciando con Python. Las tareas más comunes son:

  * Seleccionar columnas con python pandas
  * Eliminar columnas con python pandas
  * Seleccionar registros con python pandas
  * Crear nuevas variables con python pandas
  * Sumarizar datos con python pandas
  * Ordenar datos con python pandas
  * Renombrar variables con python pandas

Para variar vamos a emplear el conjunto de datos iris y que nos descargamos directamente de una url para ello las primeras sentencias que hemos de ejecutar son las siguientes:

```r
import pandas as pd
import io
import requests
url='https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv'
s=requests.get(url).content
df=pd.read_csv(io.StringIO(s.decode('utf-8')))
```
 

Este código es un buen ejemplo de como obtener un csv directamente de una url porque en ocasiones pueden surgir problemas.

**Seleccionar columnas con Pandas Python:**  
Directamente

```r
df2 = df[['sepal_length','sepal_width']]
df2.head()
```
 

Mediante una lista, parece más claro.

```r
seleccionadas = ['sepal_length','sepal_width']
df2 = df[seleccionadas]
df2.head()
```
 

**Eliminar columnas:**

```r
df3 = df.drop(columns=['sepal_length','sepal_width'])
df3.head()
```
 

**Seleccionar registros con Pandas Python:**

Con condiciones simples, los operadores se pueden consultar pero no son «extraños». También se presenta la función value_counts() que es una sumarización muy habitual.

```r
df['species'].value_counts()
df4 = df[df['species']=="setosa"]
df4['species'].value_counts()
```
 

Algo que tiene especial relevancia (desde mi punto de vista) son los paréntesis en condiciones complejas o múltiples cuando usamos Pandas.

```r
df5 = df.loc[(df.sepal_length<5) & (df.species=="setosa")]
df6 = df[(df['sepal_length']<5) & (df['species'] != "setosa")]
```
 

Particularmente la función isin para hacer condiciones del tipo in en listas la encuentro de mucha utilidad.

```r
lista = ['setosa', 'virginica']
df7 = df[df['species'].isin(lista)]
df7['species'].value_counts()
```
 

**Crear nuevas variables con Pandas Python:**

```r
df['sepal_length_tipi'] = df['sepal_length']/df['sepal_length'].mean()
df['sepal_length_tipi'].describe()
```
 

En este sentido destacaría el uso de la función de numpy where, el famoso np.where que trabaja igual que el ifelse de R.

```r
import numpy as np

df['sepal_length_altas'] = np.where(df['sepal_length'] > np.mean(df['sepal_length']),
                                    "Por encima de la media", "Por debajo de la media")
df['sepal_length_altas'].value_counts()
```
 

**Sumarizar datos con Pandas Python:**

```r
df[['sepal_length','species']].groupby('species').mean()
df[['sepal_length','species']].groupby('species').count()
```
 

Sumarizar por múltiples columnas tienes que listar variables.

```r
df2 = df[['sepal_length','sepal_width']]
df2.head()
```
0 

**Ordenar data frames con Pandas Python:**

```r
df2 = df[['sepal_length','sepal_width']]
df2.head()
```
1 

Si queremos ordenar por múltiples campos del data frame con distintos órdenes:

```r
df2 = df[['sepal_length','sepal_width']]
df2.head()
```
2 

Pero en pocas líneas quedan recogidas las principales tareas con registros y columnas que se pueden hacer en un data frame con Pandas. La siguiente entrada irá encaminada a la unión de data frames con Python y Pandas.

**Renombrar variables con python pandas**

```r
df2 = df[['sepal_length','sepal_width']]
df2.head()
```
3