---
author: rvaquerizo
categories:
- Formación
- Machine Learning
- Monográficos
- Python
date: '2017-06-19T01:32:43-05:00'
lastmod: '2025-07-13T16:00:39.125833'
related:
- machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion.md
- el-parametro-gamma-el-coste-la-complejidad-de-un-svm.md
- resolucion-del-juego-de-modelos-con-r.md
- monografico-clasificacion-con-svm-en-r.md
- juego-de-modelos-de-regresion-con-r.md
slug: machine-learning-elegir-el-mejor-gradient-boost-de-forma-iterativa-con-gridseacrchcv
tags:
- GradientBoostingClassifier
- GridSearchCV
title: Machine learning. Elegir el mejor Gradient Boost de forma iterativa con GridSearchCV
url: /machine-learning-elegir-el-mejor-gradient-boost-de-forma-iterativa-con-gridseacrchcv/
---

Carlos [aka «el tete»] me está enseñando python y una de las cosas que me ha enseñado es seleccionar de forma iterativa el mejor modelo con GridSearchCV y por si fuera poco vamos a emplear el método de clasificación «gradient boosting» para que no caiga en desuso sobre todo porque es una técnica que, bajo mi punto de vista, ofrece modelos muy estables. El ejemplo para ilustrar el proceso ya es conocido ya que vamos a estimar la letra O, mi talento no da para mucho más. Recordamos los primeros pasos:

```r
import numpy as np
import pandas as pd
from pylab import *

largo = 10000

df = pd.DataFrame(np.random.uniform(0,100,size=(largo, 2)), columns=list('XY'))

dependiente1 = np.where(((df.X-50)**2/20**2 + (df.Y-50)**2/40**2>1) ,1,0)
dependiente2 = np.where(((df.X-50)**2/30**2 + (df.Y-50)**2/50**2>1) ,1,0)
dependiente = dependiente1 - dependiente2

plt.scatter(df.X, df.Y,c=dependiente,marker=".")
show()
```
 

Tenemos una letra O fruto de jugar con la ecuación de la elipse y ahora creamos el conjunto de datos con el que entrenamos el modelo y el conjunto de datos de test para comprobar posteriormente como funciona:

```r
#Dividimos en validacion y test
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(df,dependiente,stratify=dependiente,
test_size = 0.5, random_state=123)
```
 

Nada nuevo bajo el sol pero me gusta poner los ejemplos al completo para que sean reproducibles. Ahora vienen las enseñanzas «del tete»:

```r
# GradientBoostingClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import GridSearchCV
np.random.seed(40)

#Parámetros para iterar
fun_perdida = ('deviance', 'exponential')
profundidad = range(5,15)
minimo_split =range(5,10,1)
learning_rate = [ 0.01, 0.1, 0.2, 0.3]

modeloGBM = GradientBoostingClassifier(random_state=1,n_estimators =100)

param_grid = dict(max_depth = profundidad, min_samples_split=minimo_split,
loss = fun_perdida, learning_rate=learning_rate)

grid = GridSearchCV(modeloGBM, param_grid, cv=10,scoring= 'roc_auc')
grid.fit(X_train,y_train)

mejor_modelo = modeloGBM.fit(X_train,y_train)
```
 

Los protragonistas de la entrada son GradientBoostingClassifier que nos permite ajustar un [modelo de clasificación de «gradient boosting»](https://en.wikipedia.org/wiki/Gradient_boosting) y GridSearchCV que nos permiter jugar con los parámetros de nuestros modelos y en este caso vamos a jugar con la función de pérdida, la profundidad del árbol, los cortes mínimos del árbol de clasificación y el ratio de aprendizaje. Una vez fijados los rangos hacemos la «tabla» de parámetros de entrenamiento de modelos con la función dict que recogerá todos los rangos de parámetros que vamos a iterar. Definido esto y definido el modelo GBM lo entrenamos y mediante validación cruzada el proceso se quedará con el mejor modelo de todos los que proponemos en la tabla de parámetros. Ahora sólo tenemos que ver como funciona este modelo:

```r
import matplotlib.pyplot as plt

proba = mejor_modelo.predict_proba(X_test)
proba=pd.DataFrame(proba)[1]

plt.scatter(X_test.X, X_test.Y,c=proba, cmap=plt.cm.Blues)
plt.colorbar()
plt.show()
```
 

[![GBM1](/images/2017/06/GBM1.png)](/images/2017/06/GBM1.png)

Resultado muy interesante porque es conservador, por eso me gusta, delimita bien los extremos laterales y tiene mucho cuidado con los extremos superiores y es que un algoritmo que minimiza el error tiene mayor cuidado a la hora de clasificar y procura que estas clasificaciones sean más homogéneas.