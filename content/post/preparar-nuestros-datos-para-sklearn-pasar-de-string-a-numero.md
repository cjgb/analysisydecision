---
author: rvaquerizo
categories:
  - modelos
  - python
  - trucos
date: '2017-10-24'
lastmod: '2025-07-13'
related:
  - leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
  - truco-python-reemplazar-una-cadena-de-caracteres-en-los-nombres-de-las-columnas-de-un-data-frame.md
  - transformar-todos-los-factores-a-caracter-de-mi-data-frame-de-r.md
  - trucos-r-de-string-a-dataframe-de-palabras.md
  - analisis-de-textos-con-r.md
tags:
  - sklearn
title: Preparar nuestros datos para sklearn. Pasar de string a número
url: /blog/preparar-nuestros-datos-para-sklearn-pasar-de-string-a-numero/
---

Cuando trabajamos con `Python` y `scikit-learn` necesitamos que todos los datos que vamos a modelizar sean numéricos; si tenemos variables carácter, necesitamos previamente transformarlas a números. La forma más rápida para realizar esta tarea es emplear `preprocessing` de `scikit-learn`:

```python
import pandas as pd
dias_dict = {'dia': ['lunes', 'martes', 'viernes', 'miercoles', 'jueves', 'martes', 'miercoles', 'jueves', 'lunes']}
dias_df = pd.DataFrame(dias_dict)
dias_df
```

Creamos un *data frame* a partir de un diccionario que se compone de los días de la semana; ahora vamos a codificar las etiquetas con el `LabelEncoder` de `scikit-learn`:

```python
from sklearn import preprocessing
le = preprocessing.LabelEncoder()
le.fit(dias_df['dia'])
```

Podemos listar las clases:

```python
list(le.classes_)
```

Me gustaría destacar que hay que tener especial cuidado con el orden de las codificaciones porque es un orden lexicográfico, no va por orden de aparición:

```python
dias_codificados = le.transform(dias_df['dia'])
dias_codificados
```

Ahora ya estamos en disposición de poder emplear `scikit-learn` para entrenar nuestro modelo. Saludos.