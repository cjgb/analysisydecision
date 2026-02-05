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

Recopilación de las uniones más habituales con `Python Pandas` en una sola entrada. No se realizan equivalencias con `SQL join`, la intención es tener de forma resumida los códigos para realizar `left join`, `inner join` y concatenación de *data frames* de `Pandas`. [Hay amplia documentación; esto es una síntesis](https://pandas.pydata.org/pandas-docs/stable/user_guide/merging.html).

Los *data frames* empleados para ilustrar el ejemplo son:

```python
import pandas as pd
import numpy as np

ejemplo1 = { "variable1": [10, 20, 30, 40],
             "variable2": [100, 200, 300, 400]
}
anio1 = ["2011", "2012", "2013", "2014"]
df1 = pd.DataFrame(ejemplo1, index=anio1)

ejemplo2 = { "variable1": [50, 60, 70, 80],
             "variable3": [5000, 6000, 7000, 8000]
}
anio2 = ["2013", "2014", "2015", "2016"]
df2 = pd.DataFrame(ejemplo2, index=anio2)
```

# Uniones de *data frames* con índices

La estructura de una *join* con `Pandas` es:

```python
pd.merge(left, right, how='inner', on=None, left_on=None, right_on=None,
         left_index=False, right_index=False, sort=True,
         suffixes=('_x', '_y'), copy=True, indicator=False,
         validate=None)
```

## Left Join

```python
left_join = pd.merge(df1, df2, how='left', left_index=True, right_index=True, sort=True)
left_join
```

## Outer Join

```python
outer_join = pd.merge(df1, df2, how='outer', left_index=True, right_index=True, sort=True)
outer_join
```

## Right Join

```python
right_join = pd.merge(df1, df2, how='right', left_index=True, right_index=True, sort=True)
right_join
```

## Inner Join

```python
inner_join = pd.merge(df1, df2, how='inner', left_index=True, right_index=True, sort=True)
inner_join
```

## Concatenar

### Concatenación simple

```python
concatenar = pd.concat([df1, df2])
concatenar
```

### Concatenación inner

```python
concatenar_inner = pd.concat([df1, df2], join="inner")
concatenar_inner
```

### Concatenación outer

```python
concatenar_outer = pd.concat([df1, df2], join="outer")
concatenar_outer
```

# Uniones sin índices

*Data frames* de ejemplo análogos a los anteriores pero sin usar el año como índice:

```python
df1_ni = df1.reset_index().rename(columns={'index': 'anio'})
df2_ni = df2.reset_index().rename(columns={'index': 'anio'})
```

Si no tenemos índices, es importante especificar en el `on=` la variable con la que hacemos la unión de las tablas.

## Left, outer, right con campo de unión común

```python
# Ejemplo de Left Join por la columna 'anio'
merge_comun = pd.merge(df1_ni, df2_ni, how='left', on='anio')
merge_comun
```

## Inner join con campo de unión de distinto nombre

```python
# Cambiamos el nombre de la columna en df2 para el ejemplo
df2_ni_alt = df2_ni.rename(columns={'anio': 'year'})

# Inner join especificando left_on y right_on
merge_distinto = pd.merge(df1_ni, df2_ni_alt, how='inner', left_on='anio', right_on='year')
merge_distinto
```

Uniones más habituales en una sola entrada y en pocas líneas de código. Saludos.