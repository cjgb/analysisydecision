---
author: rvaquerizo
categories:
- data mining
- formación
- modelos
- monográficos
- r
date: '2014-09-07'
lastmod: '2025-07-13'
related:
- representacion-de-redes-neuronales-con-r.md
- monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
- resolucion-del-juego-de-modelos-con-r.md
- como-salva-la-linealidad-una-red-neuronal.md
- primeros-pasos-con-regresion-no-lineal-nls-con-r.md
tags:
- nnet
- redes neuronales
title: Regresión con redes neuronales en R
url: /blog/regresion-con-redes-neuronales-en-r/
---
La última técnica que me estoy estudiando este verano es la regresión con redes neuronales. El ejemplo que os voy a poner es completamente análogo a este: http://heuristically.wordpress.com/2011/11/17/using-neural-network-for-regression/ Vamos a trabajar con el paquete nnet, si dispusiera de tiempo replicaría este ejemplo en otra entrada con neuranet. Para realizar el ejemplo tenemos el conjunto de datos housing que contiene el censo de 1970 de 506 hogares de Boston. Empecemos a trabajar con la consola de RStudio (¡!)

_#install.packages(«mlbench»)_
_library(mlbench)_
_data(BostonHousing)_
_summary(BostonHousing$medv)_

Como variable dependiente vamos a emplear el valor mediano de las vivendas ocupadas en dólares. El primer paso será realizar un modelo de regresión lineal:

_lm.fit <\- lm(medv ~ ., data=BostonHousing)
lm.predict <\- predict(lm.fit)
mean((lm.predict – BostonHousing$medv)^2)_

_plot(BostonHousing$medv, lm.predict,_
_main=»Regresión lineal»,_
_xlab=»Actual»)_

El ajuste ofrece una suma de cuadrados de 21.9 Vamos a realizar este modelo con redes neuronales:

_library(nnet)_
_#Vamos a construir un conjunto de datos con las variables_
_#independientes centradas_
_Boston.escalado=subset(BostonHousing,selec=-c(chas,medv))_
_Boston.escalado=scale(Boston.escalado)_
_summary(Boston.escalado)_
_#Dividimos por 50 para tener una respuesta entre 0 y 1_
_nnet.fit <\- nnet(BostonHousing$medv/50 ~ Boston.escalado,_
_size=2, linout=T,trace=F)_

_nnet.predict <\- predict(nnet.fit)*50_
_mean((nnet.predict – BostonHousing$medv)^2)_

_plot(BostonHousing$medv, nnet.predict,_
_main=»Neural network predictions vs actual»,_
_xlab=»Actual»)_

Para realizar el modelo vamos a emplear la librería nnet, nuestro modelo tiene como variable dependiente medv dividida por 50 para que sea un valor entre 0 y 1 Como variables independientes tendremos las mismas pero centradas por su media para evitar que nuestra red tenga pesos 0. En la función nnet especificamos que deseamos 2 nodos en la única capa oculta (size=2) y con linout=T la salida habrá de ser lineal y no binomial. Con trace=F evitamos que R nos presente todas las iteraciones necesarias para llegar a la convergencia del modelo. Para estudiar el comportamiento predictivo vemos la media de la suma de cuadrados con respecto a las predicciones y obtenemos un valor de 11.17 que mejora mucho la estimación realizada con el modelo.

Podríamos buscar un mejor modelo con un proceso iterativo y añadiendo más nodos a nuestra capa oculta:

_#Mejor solución con proceso iterativo_
_bestrss <\- 10000_
_for(i in 1:100){_
_nnmdl <\- nnet(BostonHousing$medv/50 ~ Boston.escalado,_
_size=4, linout=T,trace=F,decay=0.00001)_
_cat(nnmdl$value,»\n»)_
_if(nnmdl$value < bestrss){_
_bestnn <\- nnmdl_
_bestrss <\- nnmdl$value_
_}}_
_bestnn$value_
_summary(bestnn)_

Partimos de una suma de cuadrados subabsurda y si nuestro modelo lo mejora pues será nuestro mejor modelo posible, así hasta 100 veces y el mejor modelo será el objeto bestnn:

_nnet.predict <\- predict(bestnn)*50_
_mean((nnet.predict – BostonHousing$medv)^2)_

Ahora la media del cuadrado de los errores es 5,4. Hay que destacar que en la función nnet del proceso iterativo hemos añadido la opción decay evitamos el problema de los pesos más altos, algo que ya se mitiga empleando datos centrados. Nuestra red tiene 12 nodos de entrada, 4 nodos en la capa oculta y un sólo nodo en la salida, sólo uno porque estamos realizando un modelo de regresión, no de clasificación.

Si deseamos analizar el comportamiento de nuestras variables independientes en la red neuronal hemos de analizar los pesos de los nodos. Esta tarea es complicada si lo hacemos a través de la salida de texto de R, sin embargo existe un código que nos permite visualizar objetos nnet:

> [Visualizing neural networks from the nnet package](https://beckmw.wordpress.com/2013/03/04/visualizing-neural-networks-from-the-nnet-package/)

Simplemente asombroso eso si que es una entrada interesante . En la siguiente entrada del blog visualizaremos la red creada y estudiaremos el comportamiento de las variables regresoras.