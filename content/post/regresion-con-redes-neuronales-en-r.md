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

La última técnica que me estoy estudiando este verano es la regresión con redes neuronales. El ejemplo que os voy a poner es completamente análogo a este: [http://heuristically.wordpress.com/2011/11/17/using-neural-network-for-regression/](http://heuristically.wordpress.com/2011/11/17/using-neural-network-for-regression/). Vamos a trabajar con el paquete `nnet`; si dispusiera de tiempo, replicaría este ejemplo en otra entrada con `neuralnet`. Para realizar el ejemplo tenemos el conjunto de datos `BostonHousing`, que contiene el censo de 1970 de 506 hogares de Boston. Empecemos a trabajar con la consola de RStudio:

```r
# install.packages("mlbench")
library(mlbench)
data(BostonHousing)
summary(BostonHousing$medv)
```

Como variable dependiente vamos a emplear `medv`, el valor mediano de las viviendas ocupadas en dólares. El primer paso será realizar un modelo de regresión lineal:

```r
lm.fit <- lm(medv ~ ., data = BostonHousing)
lm.predict <- predict(lm.fit)
mean((lm.predict - BostonHousing$medv)^2)

plot(BostonHousing$medv, lm.predict,
     main = "Regresión lineal",
     xlab = "Actual", ylab = "Predicción")
```

El ajuste ofrece una media de la suma de cuadrados de 21.9. Vamos a realizar este modelo con redes neuronales:

```r
library(nnet)
# Vamos a construir un conjunto de datos con las variables independientes centradas
Boston.escalado <- subset(BostonHousing, select = -c(chas, medv))
Boston.escalado <- scale(Boston.escalado)
summary(Boston.escalado)

# Dividimos por 50 para tener una respuesta entre 0 y 1
net.fit <- nnet(BostonHousing$medv/50 ~ Boston.escalado,
                size = 2, linout = TRUE, trace = FALSE)

net.predict <- predict(net.fit) * 50
mean((net.predict - BostonHousing$medv)^2)

plot(BostonHousing$medv, net.predict,
     main = "Neural network predictions vs actual",
     xlab = "Actual", ylab = "Predicción")
```

Para realizar el modelo vamos a emplear la librería `nnet`. Nuestro modelo tiene como variable dependiente `medv` dividida por 50 para que sea un valor entre 0 y 1. Como variables independientes tendremos las mismas, pero centradas por su media para evitar que nuestra red tenga pesos 0. En la función `nnet` especificamos que deseamos 2 nodos en la única capa oculta (`size = 2`) y con `linout = TRUE` la salida habrá de ser lineal y no binomial. Con `trace = FALSE` evitamos que R nos presente todas las iteraciones necesarias para llegar a la convergencia del modelo. Para estudiar el comportamiento predictivo, vemos la media de la suma de cuadrados con respecto a las predicciones y obtenemos un valor de 11.17, que mejora mucho la estimación realizada con el modelo lineal.

Podríamos buscar un mejor modelo con un proceso iterativo y añadiendo más nodos a nuestra capa oculta:

```r
# Mejor solución con proceso iterativo
bestrss <- 10000
for (i in 1:100) {
  nnmdl <- nnet(BostonHousing$medv/50 ~ Boston.escalado,
                size = 4, linout = TRUE, trace = FALSE, decay = 0.00001)
  if (nnmdl$value < bestrss) {
    bestnn <- nnmdl
    bestrss <- nnmdl$value
  }
}
bestnn$value
summary(bestnn)

net.predict_best <- predict(bestnn) * 50
mean((net.predict_best - BostonHousing$medv)^2)
```

Partimos de una suma de cuadrados muy alta y, si nuestro modelo lo mejora, pues será nuestro mejor modelo posible; así hasta 100 veces, y el mejor modelo será el objeto `bestnn`. Ahora la media del cuadrado de los errores es considerablemente menor (en torno a 5.4). Hay que destacar que en la función `nnet` del proceso iterativo hemos añadido la opción `decay`: evitamos el problema de los pesos más altos, algo que ya se mitiga empleando datos centrados. Nuestra red tiene 12 nodos de entrada, 4 nodos en la capa oculta y un solo nodo en la salida; solo uno porque estamos realizando un modelo de regresión, no de clasificación.

Si deseamos analizar el comportamiento de nuestras variables independientes en la red neuronal, hemos de analizar los pesos de los nodos. Esta tarea es complicada si lo hacemos a través de la salida de texto de R; sin embargo, existe un código que nos permite visualizar objetos `nnet`:

> [Visualizing neural networks from the nnet package](https://beckmw.wordpress.com/2013/03/04/visualizing-neural-networks-from-the-nnet-package/)

Simplemente asombroso; eso sí que es una entrada interesante. En la siguiente entrada del blog visualizaremos la red creada y estudiaremos el comportamiento de las variables regresoras.