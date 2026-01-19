---
author: rvaquerizo
categories:
  - formación
  - machine learning
  - python
  - trucos
date: '2018-05-22'
lastmod: '2025-07-13'
related:
  - data-management-basico-con-pandas.md
  - manejo-de-datos-basico-con-python-datatable.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - curso-de-lenguaje-sas-con-wps-subconjuntos-de-variables-con-drop-y-keep.md
  - truco-python-reemplazar-una-cadena-de-caracteres-en-los-nombres-de-las-columnas-de-un-data-frame.md
tags:
  - sin etiqueta
title: Truco Python. Seleccionar o eliminar variables de un data frame en base a un prefijo, sufijo o si contienen un caracter
url: /blog/truco-python-seleccionar-o-eliminar-variables-de-un-data-frame-en-base-a-un-prefijo-sufijo-o-si-contienen-un-caracter/
---

A la hora de seleccionar las características de un data frame es posible que nos encontremos con la necesidad de seleccionar o eliminar características del data frame y que el nombre de esas características tenga un determinado patrón. Esta labor la podemos realizar mediante selección de elementos en listas, en esta entrada del blog vamos a tener 3 tipos de selecciones:

1\. Seleccionar o eliminar aquellas variables que empiezan por un determinado prefijo
2\. Seleccionar o eliminar aquellas variables que contienen una cadena de caracteres
3\. Seleccionar o eliminar aquellas variables que finalizan con un sufijo

Para ilustrar este trabajo generamos un data frame con datos aleatorios y 10 columnas:

```r
import numpy as np
import pandas as pd
df = pd.DataFrame(np.random.randint(0,100,size=(100, 10)),
columns=['A1','A2','A3','B1','B2','B3','C1','C2','C3','DA'])
```

El primero de los filtros a realizar es identificar que variables de nuestro data frame contienen el string ‘A’:

```r
col = list(df.columns)
#Filtro 1: Columnas que tienen una A
filtro1 = [col for col in df if col.find('A')>=0]
#Eliminar
df1_drop = df.drop(columns=filtro1)
#Seleccionar
df1_keep = df[filtro1]
```

Siempre vamos a hacer el mismo proceso, las características de nuestro data frame irán en una lista, después recorremos la lista y seleccionamos aquellos donde el método .find(‘A’) sea mayor o igual a 0, con esto hemos creado una sublista con aquellas características que tienen el string ‘A’ mediante .drop(columns=) eliminamos del data frame los elementos contenidos en una lista.

El siguiente filtro se queda con las variables que empiezan por ‘A’ o bien las elimina:

```r
col = list(df.columns)
#Filtro 2: Columnas que empiezan por una A
filtro2 = [col for col in df if col.startswith('A')]
#Eliminar
df2_drop = df.drop(columns=filtro2)
#Seleccionar
df2_keep = df[filtro2]
```

En este caso empleamos el método .startswith para seleccionar sólo las variables que empiecen por A. Y por último realizamos un filtro en base a un sufijo, si terminan por ‘1’:

```r
col = list(df.columns)
#Filtro 3: Columnas que finalizan por un 1
filtro3 = [col for col in df if col.endswith('1')]
#Eliminar
df3_drop = df.drop(columns=filtro3)
#Seleccionar
df3_keep = df[filtro3]
```

Desde mi prisma es un código muy útil ya que tengo la costumbre de incluir en los modelos sólo variables con un determinado prefijo y como perro viejo estoy haciendo lo mismo con mis modelos de Machine Learning, así siempre tengo claro que variables y en que paso las ha incluido el proceso por muy automático que sea. Saludos.
