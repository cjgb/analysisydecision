---
author: rvaquerizo
categories:
- Python
- Trucos
date: '2017-07-22T15:51:01-05:00'
slug: truco-python-reemplazar-una-cadena-de-caracteres-en-los-nombres-de-las-columnas-de-un-data-frame
tags:
- Pandas
title: Truco Python. Reemplazar una cadena de caracteres en los nombres de las columnas
  de un data frame
url: /truco-python-reemplazar-una-cadena-de-caracteres-en-los-nombres-de-las-columnas-de-un-data-frame/
---

Más largo el título de la entrada que la entrada en si misma. Tenemos un conjunto de datos que os podéis descargar [de este link que ya es conocido](http://archive.ics.uci.edu/ml/machine-learning-databases/00197/AU.zip). Os descargáis los datos y creamos un data frame que tiene 10.000 registros y 251 columnas, casi todas se llaman attx y queremos cambiar el nombre a columna_x. Mi sugerencia para hacerlo vía pandas es:

```r
import pandas as pd
df = pd.read_csv('C:\temp\wordpress\au2_10000.csv')
df.head()

df.columns = df.columns.str.replace('att','columna_')
df.head()
```
 

Espero que sea de utilidad. Saludos.