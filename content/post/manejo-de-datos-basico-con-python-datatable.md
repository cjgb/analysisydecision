---
author: rvaquerizo
categories:
  - formación
  - machine learning
  - python
date: '2020-10-08'
lastmod: '2025-07-13'
related:
  - data-management-basico-con-pandas.md
  - data-management-con-dplyr.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
  - truco-python-seleccionar-o-eliminar-variables-de-un-data-frame-en-base-a-un-prefijo-sufijo-o-si-contienen-un-caracter.md
tags:
  - datatable
  - pandas
title: Manejo de datos básico con Python datatable
url: /blog/manejo-de-datos-basico-con-python-datatable/
---

Nueva entrada dedicada al **data management con Python** , esta vez con **datatable**. No voy a justificar el uso de datatable antes que pandas, en un vistazo rápido por la web encontráis numerosas ocasiones en las que datatable es más eficiente que pandas en el manejo de datos con Python. En cuanto a la complejidad en el uso de uno u otro mi opinión no es objetiva porque me cuesta mucho trabajar con Pandas.

Asumo que habéis instalado datatable en vuestro entorno de Python (siempre por encima de la versión 3.5) y una vez está instalado os propongo obtener un conjunto de datos del [repositorio de analisisydecision](https://github.com/analisisydecision). Por supuesto la carga de este csv de ejemplo la realizamos con datatable y la función fread:

```r
import datatable as dt
path = 'https://raw.githubusercontent.com/analisisydecision/intro_python_data_science/master/'
dt_df = dt.fread(path + 'index.csv')
dt_df.head()

dt_df.shape
```

Hemos creado un data frame con datatable, podremos pasarlo a lista o a data frame en pandas con `.to_pandas()`. En la línea de siempre las tareas que vamos a revisar con datatable en Python son:

- Seleccionar columnas
- Eliminar columnas
- Seleccionar registros
- Crear nuevas variables
- Sumarizar datos
- Renombrar variables
- Ordenar datos

### Seleccionar columnas

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

Siempre sugiero usar listas:

```r
seleccionadas =['Occupation','No of dependents']
df2 = dt_df[:, seleccionadas]
df2.head(5)
```

### Eliminar columnas

```r
elimina = ['Creditability','Account Balance']
del dt_df[:, elimina]
dt_df.head()
```

### Seleccionar registros

Primer ejemplo en el que usamos la variable de datatable f que nos permite referenciar elementos del data frame, veamos algunos ejemplos:

```r
df4 = dt_df[dt.f['Duration of Credit (month)'] == 12, :]
df4.view()
```

```r
df4 = dt_df[dt.f['Duration of Credit (month)'] != 12, :]
df4.head(5)
```

Empleamos paréntesis para condiciones más complejas:

```r
df5 = dt_df[(dt.f['Duration of Credit (month)'] == 12) & (dt.f['Credit Amount']<=1500), :]
df5.head(5)
```

Podemos referenciar variables con la notación punto:

```r
df5 = dt_df[(dt.f['Duration of Credit (month)'] != 12) & (dt.f.Occupation == 3), :]
df5.head(5)
```

```r
df6 = dt_df[(dt.f.Purpose != 0) | (dt.f.Occupation == 3), :]
df6.head(5)
```

### Creación de nuevas variables

```r
media = dt_df['Credit Amount'].mean()
dt_df['dist_media'] = dt_df[:,  dt.f['Credit Amount']/media]
dt_df.head(5)
```

En datatable disponemos de la función ifelse para crear variables en base a condiciones:

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

0

### Sumarizar datos

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

1

Sumarizamos múltiples columnas:

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

2

### Renombrar una columna

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

3

### Ordenar datos

Orden ascendente:

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

4

Orden descendente:

```r
df2 = dt_df[:,['Occupation','No of dependents']]
df2.head(5)
```

5

En pocas líneas resumidas las principales tareas con datos con Python datatable. Saludos.
