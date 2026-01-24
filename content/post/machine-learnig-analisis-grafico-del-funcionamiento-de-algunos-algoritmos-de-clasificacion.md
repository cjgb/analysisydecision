---
author: rvaquerizo
categories:
  - formación
  - machine learning
  - modelos
  - monográficos
  - python
date: '2017-05-03'
lastmod: '2025-07-13'
related:
  - resolucion-del-juego-de-modelos-con-r.md
  - monografico-clasificacion-con-svm-en-r.md
  - cluster-svm.md
  - knn-con-sas-mejorando-k-means.md
  - machine-learning-elegir-el-mejor-gradient-boost-de-forma-iterativa-con-gridseacrchcv.md
tags:
  - arboles de clasificacion
  - knn
  - machine learning
  - perceptrón
  - random forest
  - svm
  - redes neuronales
title: Machine learning. Análisis gráfico del funcionamiento de algunos algoritmos de clasificacion
url: /blog/machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion/
---

![Letra_O](/images/2017/05/Letra_O.png)

De forma gráfica os voy a presentar algunas técnicas de clasificación supervisada de las más empleadas en Machine Learning y podremos ver cómo se comportan de forma gráfica en el plano. Como siempre prefiero ilustrarlo a entrar en temas teóricos y para esta tarea se me ha ocurrido pintar una letra O y comenzar a trabajar con Python, así de simple. Lo primero es tener los datos, evidentemente serán puntos aleatorios en el plano donde pintamos una variable dependiente con forma de O:

```python
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

Se crea un data frame con 10.000 registros y dos variables aleatorias con valores entre 0 y 100 X e Y. Soy consciente de la forma en la que se obtiene la variable dependiente, no entiendo como funciona `np.where` con condiciones múltiples y por ello toman valor 1 aquellas observaciones del plano que están entre las dos eclipses que pinto dentro del plano. Con todo esto tenemos unos datos como ilustran el scatter plot con el que se inicia esta entrada. El siguiente paso será dividir los datos en validación y test mediante `train_test_split`:

```python
#Dividimos en validacion y test
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(df,dependiente,stratify=dependiente,
test_size = 0.5, random_state=123)
```

Ahora vamos a estudiar gráficamente como se comportan algunos algoritmos de machine learning para clasificar la letra O en el espacio. Empezamos por los árboles de decisión:

```python
from sklearn.tree import DecisionTreeClassifier

arbol_1 = DecisionTreeClassifier(random_state=0,max_depth = 7,min_samples_leaf =50)
arbol_1.fit(X_train, y_train)
predichos = arbol_1.predict(X_test)
plt.scatter(X_test.X, X_test.Y,c=predichos,marker=".",cmap=plt.cm.Blues)
show()
```

![arbol_clasificacion_python](/images/2017/05/arbol_clasificacion_python.png)

No se selecciona un árbol muy complejo, sólo 7 nodos y con un mínimo de 50 observaciones por nodo, con estas consideraciones el árbol lo que hace es crear 4 bloques en el plano, al algoritmo le cuesta trazar las zonas no lineales. Con unas características parecidas empleamos clasificación por random forest, donde antes había un árbol ahora tenemos un bosque:

```python
from sklearn.ensemble import RandomForestClassifier

bosque_1 = RandomForestClassifier(random_state=0,max_depth = 7,min_samples_leaf =50)
bosque_1.fit(X_train, y_train)
predichos = bosque_1.predict(X_test)
plt.scatter(X_test.X, X_test.Y,c=predichos,marker=".",cmap=plt.cm.Blues)
show()
```

![random_forest_clasificacion](/images/2017/05/random_forest_clasificacion.png)

Con una complejidad parecida ya no hay bloques ahora tenemos “pequeños cuadrados” que son capaces de trazar las zonas no lineales, pero no todas, necesita una mayor complejidad para poder clasificar mejor la letra O. Una técnica de clasificación que nos va a funcionar muy bien son los k vecinos más cercanos, AKA knn, donde los puntos en el espacio no van a suponer problema para esta técnica:

```python
from sklearn.neighbors import KNeighborsClassifier
vecinos_1 = KNeighborsClassifier(n_neighbors=3,algorithm ="auto").fit(X_train,y_train)
predichos = vecinos_1.predict(X_test)
plt.scatter(X_test.X, X_test.Y,c=predichos,marker=".",cmap=plt.cm.Blues)
show()
```

![knn_clasificacion_python](/images/2017/05/knn_clasificacion_python.png)

Ahí lo tenemos, lo clava sólo con 3 vecinos y eligiendo de forma automática el algoritmo de clasificación, los datos de test quedan perfectamente clasificados, punto a punto el algoritmo lo clava a excepción de algún punto en el borde. Una situación parecida debemos encontrarnos para las máquinas de vectores de soporte, conocidas como `SVM`, una técnica de clasificación que me gusta:

```python
from sklearn.svm import SVC
svm_1 = SVC(C=1,tol=0.1)
svm_1.fit(X_train, y_train)
predichos = svm_1.predict(X_test)
plt.scatter(X_test.X, X_test.Y,c=predichos,marker=".",cmap=plt.cm.Blues)
show()
```

![svm_clasificacion_python](/images/2017/05/svm_clasificacion_python.png)

Excepcional comportamiento clasificatorio; comentar que python sorprende gratamente a la hora de emplear este tipo de algoritmo, va más deprisa que R. Por último tenemos la clasificación con perceptrón multicapa a la que no le auguro un buen funcionamiento debido a la complejidad que presenta la letra O:

```python
from sklearn.neural_network import MLPClassifier
mlp_1 = MLPClassifier(solver='lbfgs', alpha=1e-5,hidden_layer_sizes=(30,30, 30), random_state=1,
learning_rate_init=0.001,max_iter=200)
mlp_1.fit(X_train, y_train)
predichos = mlp_1.predict(X_test)
plt.scatter(X_test.X, X_test.Y,c=predichos,marker=".",cmap=plt.cm.Blues)
show()
```

![perceptron_python](/images/2017/05/perceptron_python.png)

Observamos como una red neuronal con 3 capas con 30 unidades ocultas, un perceptrón muy complejo, no puede clasificar con precisión la letra O. En este caso es muy interesante hacer el scatter plot con colores donde graduamos la probabilidad que asigna el modelo no sólo graficar la predicción:

```python
import matplotlib.pyplot as plt

proba = mlp_1.predict_proba(X_test)
proba=pd.DataFrame(proba)[1]

plt.scatter(X_test.X, X_test.Y,c=proba, cmap=plt.cm.Blues)
plt.colorbar()
plt.show()
```

![perceptron_probabilidades_python](/images/2017/05/perceptron_probabilidades_python.png)

El resultado es interesante puesto que las probabilidades que arroja la predicción son muy conservadoras a excepción de aquellos lugares en el plano donde tiene una alta certeza de encontrar un 1. Hasta aquí no os he contado nada que no se pueda encontrar navegando un poco por la red, sin embargo en una sola entrada tenemos un pequeño manual de `sklearn` donde analizamos:

- `DecisionTreeClassifier`
- `RandomForestClassifier`
- `KNeighborsClassifier`
- `SVC`
- `MLPClassifier`

Espero que os pueda ser de utilidad. Saludos.
