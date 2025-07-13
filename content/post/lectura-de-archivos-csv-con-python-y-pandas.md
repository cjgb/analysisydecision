---
author: rvaquerizo
categories:
- Formación
- Monográficos
- Python
date: '2019-04-30T10:21:21-05:00'
slug: lectura-de-archivos-csv-con-python-y-pandas
tags:
- csv
- importar csv
- Pandas
title: Lectura de archivos csv con Python y Pandas
url: /lectura-de-archivos-csv-con-python-y-pandas/
---

A continuación os planteo un acercamiento básico a la lectura de archivos csv con Python y algunos trucos para facilitar la vida cuando realizamos importaciones basados en la experiencia como son leer los primeros registros del csv o realizar una lectura de observaciones aleatoria por si el archivo es muy voluminoso. Para realizar las importaciones vamos a emplear Pandas y la función read_csv con sus infititas opciones:

```r
pd.read_csv(filepath_or_buffer, sep=', ', delimiter=None, header='infer', names=None, index_col=None, usecols=None, squeeze=False, prefix=None, mangle_dupe_cols=True, dtype=None, engine=None, converters=None, true_values=None, false_values=None, skipinitialspace=False, skiprows=None, nrows=None, na_values=None, keep_default_na=True, na_filter=True, verbose=False, skip_blank_lines=True, parse_dates=False, infer_datetime_format=False, keep_date_col=False, date_parser=None, dayfirst=False, iterator=False, chunksize=None, compression='infer', thousands=None, decimal=b'.', lineterminator=None, quotechar='"', quoting=0, escapechar=None, comment=None, encoding=None, dialect=None, tupleize_cols=None, error_bad_lines=True, warn_bad_lines=True, skipfooter=0, doublequote=True, delim_whitespace=False, low_memory=True, memory_map=False, float_precision=None)
```
 

Para trabajar la entrada vamos a necesitar dos archivos de texto:

  * [bank-additional-full](/images/2019/04/bank-additional-full.csv)
  * [index](/images/2019/04/index.csv)

Como costumbre poner la ubicación del archivo y después la lectura:

```r
path = 'C:/temp/'

import pandas as pd
df = pd.read_csv (path + 'index.csv')
df.head()
```
 

En este caso la vida es maravillosa y ha salido todo a la primera pero sabemos que eso no pasa siempre, ejecutáis:

```r
df = pd.read_csv (path + 'bank-additional-full.csv')
df.head()
```
 

El separador es distinto:

```r
df = pd.read_csv (path + 'bank-additional-full.csv', sep = ';')
df.head()
```
 

La vida sigue sin ser muy complicada porque el archivo de ejemplo tiene pocos registros, pero imaginad que leéis unas docenas de GB por ello previamente es mejor ejecutar:

```r
df = pd.read_csv (path + 'bank-additional-full.csv', nrows= 200)
df.shape
```
 

con nrows = 200 leemos las primeras 200 líneas y podemos comprobar si lo estamos leyendo correctamente y podemos ahorrarnos disgustos, tiempo y trabajo. E incluso estaría bien no leer las docenas de GB porque no tenemos suficiente memoria o porque no necesitamos leer entero el archivo podemos leer por trozos:

```r
meses = ['may', 'jul']
df = pd.DataFrame()
for trozo in pd.read_csv(path + 'bank-additional-full.csv', sep=';',
                             chunksize=1000):
    df = pd.concat([df,trozo[trozo['month'].isin(meses)]])

df.month.value_counts()
```
 

Con chunksize estamos leyendo el archivo csv en trozos (chunks) de 1000 en 1000 y nos quedamos sólo con aquellos que cumplan un determinado requisito, en este caso que el campo month sea may o jul. E incluso podéis leer el csv extrayendo una muestra aleatoria mientras leéis el fichero por partes y no sobre pasar la memoria:

```r
df2 = pd.DataFrame()
for trozo in pd.read_csv(path + 'bank-additional-full.csv', sep=';',
                             chunksize=1000):
    df2 = pd.concat([df2,trozo.sample(frac=0.25)])
df2.shape
```
 

Este último truco puede servir para leer csv extremadamente grandes y realizar los primeros análisis aproximativos a nuestro problema porque como dice un buen amigo «si en 200.000 registros no encuentras una señal no hace falta que cargues millones».