---
author: rvaquerizo
categories:
- Data Mining
- Formación
- R
date: '2012-07-16T02:08:32-05:00'
lastmod: '2025-07-13T16:11:04.370707'
related:
- analisis-cluster-con-sas-la-importancia-de-las-semillas-en-las-k-medias.md
- cluster-svm.md
- knn-con-sas-mejorando-k-means.md
- manual-curso-introduccion-de-r-capitulo-17-analisis-cluster-con-r-y-iii.md
- manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii.md
slug: un-peligro-del-analisis-cluster
tags:
- ''
- Cluster
title: Un peligro del análisis cluster
url: /un-peligro-del-analisis-cluster/
---

![](/images/2009/04/cluster1.JPG)

Quería plantearos un ejemplo de análisis cluster para observar **el peligro que tiene agrupar observaciones en base a grupos homogéneos creados con distancias multivariantes**. Para ilustrar el ejemplo trabajamos con R, creamos grupos en base a 2 variables, esto nos facilita los análisis gráficos. Simulamos el conjunto de datos con el que trabajamos:

```r
#GRUPO 1

x = runif(500,70,90)

y = runif(500,70,90)

grupo1 = data.frame(cbind(x,y))

grupo1$grupo = 1
```

```r
#GRUPO 2

x = runif(1000,10,40)

y = runif(1000,10,40)

grupo2 = data.frame(cbind(x,y))

grupo2$grupo = 2
```

```r
#GRUPO 3

x = runif(3000,0,100)

y = runif(3000,0,100)

grupo3.1 = data.frame(cbind(x,y))

grupo3.1separacion=(x+y)

grupo3.1 = subset(grupo3.1,separacion>=80&separacion <=140,select=-separacion)

grupo3.1 = subset(grupo3.1,y>0)

grupo3.1grupo = 3
```

```r
#UNIMOS TODOS LOS GRUPOS

total=rbind(grupo1,grupo2,grupo3.1)

plot(totalx,totaly,col=c(1,2,3)[total$grupo])
```

Los grupos parecen claros:

![linealidad_cluster1.png](/images/2012/07/linealidad_cluster1.png)

Cabe preguntarse: ¿qué sucede si segmentamos en base a centroides? Para responder a esta pregunta hacemos un análisis no jerárquico, empleamos el algoritmos de las k-medias del que[ ya se ha hablado en este blog en alguna ocasión](https://analisisydecision.es/manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i/):

```r
distancias = dist(total)

clus = kmeans(distancias,3)

totalgrupo_nuevo = cluscluster

plot(totalx,totaly,col=c(1,2,3)[total$grupo_nuevo])
```

![linealidad_cluster2.png](/images/2012/07/linealidad_cluster2.png)  
Necesitamos un objeto con las distancias y sobre él utilizamos la función _kmeans_ que es la más popular y sencilla. El objeto resultante de la realización del modelo tiene una variable cluster que añadimos a nuestros datos y tras graficar vemos que es evidente que no ha funcionado muy correctamente, nos ha creado los 3 grupos homogéneos en base a la distancia entre observaciones, pero no son los segmentos deseados… **Mucho cuidado cuando utilicemos este tipo de técnicas**.

¿Cómo podemos realizar una segmentación más apropiada para estos datos? ¿Qué técnica podemos utilizar? La respuesta en breve. Espero que esto sirva para desordenar alguna conciencia.