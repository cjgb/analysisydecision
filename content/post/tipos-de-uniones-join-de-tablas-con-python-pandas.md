---
author: rvaquerizo
categories:
- formación
- monográficos
- python
date: '2020-05-16'
lastmod: '2025-07-13'
related:
- capitulo-4-uniones-de-tablas-con-r.md
- proc-sql-merge-set.md
- data-management-basico-con-pandas.md
- monografico-paquete-sqldf-si-sabes-sql-sabes-r.md
- creando-archivos-excel-desde-python-con-pandas-y-excelwriter.md
tags:
- join
- pandas
title: Tipos de uniones (join) de tablas con Python Pandas
url: /blog/tipos-de-uniones-join-de-tablas-con-python-pandas/
---
Recopilación de las uniones más habituales con Python Pandas en una sola entrada. No se realiza equivalencias con sql join, la intención es tener de forma resumida los códigos para realizar left join inner join y concatenación de data frames de Pandas. [Hay amplia documentación esto es una síntesis](https://pandas.pydata.org/pandas-docs/stable/user_guide/merging.html).

Los data frames empleados para ilustrar el ejemplo son:

```r
import pandas as pd
import numpy as np
ejemplo = { "variable1": [10, 20, 30, 40],
            "variable2": [100, 200, 300, 400]
}
anio=["2011", "2012", "2013", "2014"]
df1 = pd.DataFrame(ejemplo,index=anio)
df1
```

```r
ejemplo = { "variable1": [50, 60, 70, 80],
            "variable3": [5000, 6000, 7000, 8000]
}
anio=["2013", "2014", "2015", "2016"]
df2 = pd.DataFrame(ejemplo,index=anio)
df2
```


# Uniones de data frames con índices

La estructura de una join con Pandas es:

```r
pd.merge(left, right, how='inner', on=None, left_on=None, right_on=None,
     left_index=False, right_index=False, sort=True,
     suffixes=('_x', '_y'), copy=True, indicator=False,
     validate=None)
```


## Left Join

```r
left_join = pd.merge(df1, df2, how='left', on=None, left_on=None, right_on=None,
         left_index=True, right_index=True, sort=True)
left_join
```


## Outer Join

```r
outer_join = pd.merge(df1, df2, how='outer', on=None, left_on=None, right_on=None,
         left_index=True, right_index=True, sort=True)
outer_join
```


## Right Join

```r
right_join = pd.merge(df1, df2, how='right', on=None, left_on=None, right_on=None,
         left_index=True, right_index=True, sort=True)
right_join
```


## Inner Join

```r
inner_join = pd.merge(df1, df2, how='inner', on=None, left_on=None, right_on=None,
         left_index=True, right_index=True, sort=True)
inner_join
```


## Concatenar

### Concatenación simple

```r
concatenar = pd.concat([df1,df2])
concatenar
```


### Concatenación inner

```r
concatenar_inner = pd.concat([df1,df2],join="inner")
concatenar_inner
```


### Concatenación outer

```r
concatenar_outer = pd.concat([df1,df2],join="outer")
concatenar_outer
```


# Uniones sin índices

Data frames de ejemplo análogos a los anteriores.

```r
ejemplo = { "variable1": [50, 60, 70, 80],
            "variable3": [5000, 6000, 7000, 8000]
}
anio=["2013", "2014", "2015", "2016"]
df2 = pd.DataFrame(ejemplo,index=anio)
df2
```
0

Si no tenemos índices es importante especificar en el parámetro on= la variable con la que hacemos la unión de las tablas. En este caso ponemos todas las uniones:

## Left, outer, right con campo de unión común

```r
ejemplo = { "variable1": [50, 60, 70, 80],
            "variable3": [5000, 6000, 7000, 8000]
}
anio=["2013", "2014", "2015", "2016"]
df2 = pd.DataFrame(ejemplo,index=anio)
df2
```
1

## Inner join con campo de unión de distinto nombre

```r
ejemplo = { "variable1": [50, 60, 70, 80],
            "variable3": [5000, 6000, 7000, 8000]
}
anio=["2013", "2014", "2015", "2016"]
df2 = pd.DataFrame(ejemplo,index=anio)
df2
```
2

Uniones más habituales en una sola entrada y en pocas líneas de código.