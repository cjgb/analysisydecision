---
author: rvaquerizo
categories:
- Data Mining
- Formación
- Modelos
- R
date: '2015-06-28T15:44:25-05:00'
lastmod: '2025-07-13T15:59:09.209009'
related:
- resolucion-del-juego-de-modelos-con-r.md
- manual-curso-introduccion-de-r-capitulo-10-funciones-graficas-en-regresion-lineal.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
- regresion-con-redes-neuronales-en-r.md
- machine-learnig-analisis-grafico-del-funcionamiento-de-algunos-algoritmos-de-clasificacion.md
slug: juego-de-modelos-de-regresion-con-r
tags:
- knn
- LOESS
- SVM
title: Juego de modelos de regresión con R
url: /juego-de-modelos-de-regresion-con-r/
---

[![Rplot](/images/2015/06/Rplot.png)](/images/2015/06/Rplot.png)

Os propongo un juego con R. El juego parte de unos datos aleatorios que he generado con R (los que veis arriba) que dividimos en entrenamiento y test. Sobre el conjunto de datos de entrenamiento he realizado varios modelos y valoro las predicciones gráficamente sobre los datos de test. El juego consiste en asociar cada resultado gráfico de test a cada código de R correspondiente y justificar brevemente la respuesta.

Los gráficos de los datos de test son:

**Figura A:**  
[![Rplot01](/images/2015/06/Rplot01.png)](/images/2015/06/Rplot01.png)

**Figura B:**  
[![Rplot02](/images/2015/06/Rplot02.png)](/images/2015/06/Rplot02.png)

**Figura C:**  
[![Rplot03](/images/2015/06/Rplot03.png)](/images/2015/06/Rplot03.png)

**Figura D:**  
[![Rplot05](/images/2015/06/Rplot05.png)](/images/2015/06/Rplot05.png)

**Figura E:**  
[![Rplot07](/images/2015/06/Rplot07.png)](/images/2015/06/Rplot07.png)

**Figura F:**  
[![Rplot08](/images/2015/06/Rplot08.png)](/images/2015/06/Rplot08.png)

**Figura G:**  
[![Rplot06](/images/2015/06/Rplot06.png)](/images/2015/06/Rplot06.png)

Los códigos R que tenéis que asociar a cada figura son:

**Código 1:** Red neuronal con una sólo capa y 2 nodos:  
mejor.red {  
mejor.rss for(i in 1:50){  
modelo.rn linout=T, trace=F,decay=0.1)  
if(modelo.rn$value < mejor.rss){  
mejor.modelo mejor.rss

return(mejor.modelo)  
}}  
}

mejor.red(2)

**Código 2:** Regresión lineal  
lm(dep ~ indep,entrenamiento)

**Código 3** : Máquina de vector de soporte con un margen muy alto  
svm(dep ~ indep ,entrenamiento, method=»C-classification»,  
kernel=»radial»,cost=100,gamma=100)

**Código 4:** Árbol de regresión  
rpart(dep~indep,entrenamiento)

**Código 5:** Regresión LOESS  
loess (dep ~ indep, data = entrenamiento)

**Código 6:** Máquina de vector de soporte con un margen bajo  
svm(dep ~ indep ,entrenamiento, method=»C-classification»,  
kernel=»radial»,cost=10,gamma=10)

**Código 7:** K vecinos más cercanos K-nn  
train.kknn(dep ~ indep, data = entrenamiento,  
k = 4, kernel = c(«rectangular»))

**Por ejemplo** la figura A irá con el código 2 porque se trata de una estimación lineal. Y ahora os toca a vosotros asociar figuras a modelos de R.