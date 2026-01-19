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

Cuando trabajamos con python y sklearn necesitamos que todos los datos que vamos a modelizar sean númericos, si tenemos variables carácter necesitamos previamente transformarlas a números. La forma más rápida para realizar esta tarea es emplear preprocesing de sklearn:

```r
import pandas as pd
dias = {'dia': ['lunes','martes','viernes','miercoles','jueves','martes','miercoles','jueves','lunes']}
dias = pd.DataFrame(dias)
dias
```

Creamos un data frame a partir de una diccionario que se compone de los días de la semana ahora vamos a codificar las etiquetas con el LabelEncoder de sklearn:

```r
from sklearn import preprocessing
le = preprocessing.LabelEncoder()
le.fit(dias['dia'])
```

Podemos listar las clases:

```r
list(le.classes_)
```

Me gustaría destacar que hay que tener especial cuidado con el orden de las codificaciones porque es un orden léxico-gráfico, no va por orden de aparición:

```r
dias = le.transform(dias['dia'])
dias
```

Ahora ya estamos en disposición de poder emplear sklearn para entrenar nuestro modelo.
