---
author: rvaquerizo
categories:
- formación
- gráficos
- python
date: '2021-08-09'
lastmod: '2025-07-13'
related:
- capitulo-5-representacion-basica-con-ggplot.md
- graficos-basicos-con-julia.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-7-descripcion-grafica-de-variables.md
- un-acercamiento-a-graph-ods-graphs-proc-sgplot.md
- graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
tags:
- sin etiqueta
title: Gráficos descriptivos básicos con Seaborn Python
url: /blog/graficos-descriptivos-basicos-con-seaborn-python/
---
Revisión de los gráficos más habituales que realizaremos en labores descriptivas de variables con Python, se emplea seaborn para ilustrar estos ejemplos. El tipo de gráfico dependerá del tipo de variable que deseamos describir e incluso del número de variables que deseamos describir Como aproximación inicial describiremos variables cuantitativas o variables cualitativas análisis univariables o análisis bivariables. Se trabaja con el conjunto de datos iris:

```r
import seaborn as sns
import pandas as pd
import numpy as np
import io
import requests

url='https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv'
s=requests.get(url).content
df=pd.read_csv(io.StringIO(s.decode('utf-8')))
df.head()
```


## Análisis univariables

### Variables cuantitativas

Cuando describimos variables cuantitativas lo principal es conocer su forma, sobre que valores se hayan los datos y como son de dispersos y para ello el gráfico estrella es el histograma:

```r
sns.histplot(data=df, x="sepal_width")
```


[![](/images/2021/07/histograma-seaborn.png)](/images/2021/07/histograma-seaborn.png)

Si queremos ver la distribución como una línea continua disponemos de los gráficos de densidad:

```r
sns.kdeplot(df['sepal_width'], bw=0.5)
```


[![](/images/2021/07/densidad-seaborn.png)](/images/2021/07/densidad-seaborn.png)

Como sugerencia unir ambos gráficos con distplot:

```r
sns.distplot(df['sepal_width'])
```


[![](/images/2021/07/histograma-densidad.png)](/images/2021/07/histograma-densidad.png)

El otro gráfico que destacaría sería el gráfico de cajas y bigotes que llamaremos boxplot y que es así de sencillo con seaborn:

```r
sns.boxplot(x="sepal_length", data=df)
```


Este gráfico nos dice mucho de una variable, esa caja nos indica donde están el 75% que es lo que definimos como rango intercuartílico, hay una línea que nos indica la mediana y esos «bigotes» nos dan una medida de lo dispersos que se encuentran los datos, e incluso si hay observaciones que están 1,5 veces por encima del rango intercuartílico las da más importancia marcándolas con puntos y que se pueden denominar datos extremos.

### Variables cualitativas

Para describir variables cualitativas el gráfico más habitual es el gráfico de barras donde contamos observaciones, en seaborn tenemos countplot:

```r
sns.countplot(x='species', data=df)
```


[![](/images/2021/07/grafico-barras-seaborn.png)](/images/2021/07/grafico-barras-seaborn.png)

Sin embargo, se sugiere que este tipo de gráficos se haga después de realizar una tabla de agregación, en este caso con **pandas** , los tiempos de ejecución siempre son menores:

```r
agr = df[['sepal_length','species']].groupby('species').count()
agr = agr.reset_index()
sns.barplot(x='species', y='sepal_length', data=agr)
```


[![](/images/2021/07/grafico-barras-seaborn-pandas.png)](/images/2021/07/grafico-barras-seaborn-pandas.png)

Con seaborn no se pueden hacer gráficos de tarta, así que no describiremos variables cualitativas de ese modo.

## Análisis bivariable

Disponemos de los gráficos básicos para describir una variable, pero habitualmente necesitaremos describir una variable en función de otra y así tenemos gráficos bivariables con las posibles combinaciones entre los tipos de las variables a describir.

**Dos variables cuantitativas**

En este caso tenemos el el habitual gráfico de puntos.

```r
sns.scatterplot(data=df, x="sepal_length", y="sepal_width")
```


[![](/images/2021/07/grafico-puntos-seaborn.png)](/images/2021/07/grafico-puntos-seaborn.png)

Al que podemos añadir una variable cualitativa para identificar segmentos:

```r
sns.scatterplot(data=df, x="sepal_length", y="sepal_width", hue="species")
```


[![](/images/2021/07/grafico-puntos-segmentos-seaborn.png)](/images/2021/07/grafico-puntos-segmentos-seaborn.png)

Se aprecia como **hue** sirve para generar ese segmento. En otros gráficos que hemos trabajado, como los gráficos de densidades, en vez de hue directamente se trabaja con data frames separados, como en el ejemplo siguiente, que compara los gráficos de densidades de una variable en función de otra cuantitativa:

```r
df1 = df[df['species']=="setosa"]
df2 = df[df['species']=="versicolor"]

sns.kdeplot(df1['sepal_length'], bw=0.5)
sns.kdeplot(df2['sepal_length'], bw=0.5)
```


[![](/images/2021/07/compara-densidades-seaborn.png)](/images/2021/07/compara-densidades-seaborn.png)

También se pueden realizar gráficos de densidades bivariables:

```r
sns.histplot(data=df, x="sepal_width")
```
0

[![](/images/2021/07/dendidad-bivariable-kde-seaborn.png)](/images/2021/07/dendidad-bivariable-kde-seaborn.png)

**Dos variables cualitativas**

En este caso es necesario emplear otras posibilidades de los gráficos de barras como añadir una nueva barra:

```r
sns.histplot(data=df, x="sepal_width")
```
1

[![](/images/2021/07/grafico-barras-seaborn-2.png)](/images/2021/07/grafico-barras-seaborn-2.png)

Para columnas agrupadas no se recomienda el uso de seaborn, se complica el código. Pero se puede realizar con Pandas:

```r
sns.histplot(data=df, x="sepal_width")
```
2

[![](/images/2021/07/seaborn-columnas-apiladas.png)](/images/2021/07/seaborn-columnas-apiladas.png)

**Una variable cuantitativa frente a una variable cualitativa**

Por último una mezcla entre ambos tipos de variables, con anterioridad se vio algún ejemplo, pero son imprescindibles los gráficos de densidades frente a variables cualitativas:

```r
sns.histplot(data=df, x="sepal_width")
```
3
```r
sns.histplot(data=df, x="sepal_width")
```
4

Una entrada sencilla que sirve para ilustrar en pocas líneas el 80% de los gráficos que realiza un científico de datos en su vida profesional. Se ha querido emplear seaborn por tener un factor diferenciador, esta librería destaca en sus gráficos de densidades, hay otros análisis donde matplotlib es más habitual.