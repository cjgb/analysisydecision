---
author: rvaquerizo
categories:
- data mining
- formación
- modelos
- r
date: '2011-01-08'
lastmod: '2025-07-13'
related:
- trucos-sas-medir-la-importancia-de-las-variables-en-nuestro-modelo-de-regresion-logistica.md
- variables-categoricas-en-cajas-treemap-con-r.md
- macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
- medir-la-importancia-de-las-variables-en-una-red-neuronal-con-r.md
- monografico-arboles-de-decision-con-party.md
tags:
- clasificacion
- random forest
title: Medir la importancia de las variables con Random Forest
url: /blog/medir-la-importancia-de-las-variables-con-random-forest/
---
¿**Qué variables son las más importantes para nuestro modelo de clasificación**? Yo creo que muchos de vosotros os habréis encontrado con esta problemática. Hay muchas formas de solventarla, habitualmente empleamos aquellas variables que mejor pueden entender nuestras áreas de negocio. Es decir, hacemos segmentaciones en base al sexo y la edad sólo por no tener que explicar como hemos construido una variable artificial a alguien que no entiende lo que es una variable y mucho menos variable artificial. Pero hoy os quería plantear la utilización de métodos de _[random forest](http://en.wikipedia.org/wiki/Random_forest)_ con R para medir la importancia de las variables cuantitativas, para variables cualitativas recomiendo otras formas que plantearé más adelante. El _random forest_ es un **método de clasificación** basado en la realización de **múltiples árboles de decisión** sobre muestras de un conjunto de datos. Hacemos muchas clasificaciones con menos variables y menos observaciones y al final nos quedamos con un promedio de estas clasificaciones, esa sería la idea a grandes rasgos. La característica que hace de este método muy interesante es la posibilidad de incluir un gran número de variables _input_ en nuestro modelo ya que no encontraremos relaciones lineales entre ellas y tampoco aparecerán relaciones debidas al azar.

Para ilustrar nuestro ejemplo con R vamos a emplear un conjunto de datos que podéis obtener obtener en [este link](http://archive.ics.uci.edu/ml/machine-learning-databases/00197/AU.zip). Es una serie de datos y modelos, nos quedaremos con el conjunto de datos _au2_10000.csv_ que tiene 251 variables y 10.000 registros. Son una [serie de datos preparados para el estudio de modelos de clasificación](http://sites.google.com/site/autouniv/). En nuestro caso nos servirá para determinar las **variables cuantitativas** más influyentes sobre la variable dependiente. Como variables explicativas tenemos aquellas que comienzan con _att_ y como variable dependiente tendremos _class_. En mi caso concreto he subido los datos a la BBDD con la ayuda de Kettle por lo que mi trabajo con R comienza con la lectura de estos datos:

```r
#ACCESO A BBDD

library(RODBC)

con = odbcConnect("PostgreSQL30",case="postgresql")

datos = sqlQuery (con,"SELECT * FROM MODELOS.AU_TABLE")

summary(datos)

str(datos)
```

Recordamos que para conectarnos con R a Postgres empleamos la libería RODBC como ya hicimos mención en [anteriores mensajes](https://analisisydecision.es/montemos-un-sistema-de-informacion-en-nuestro-equipo-iii/). Ya disponemos del objeto datos con sus 251 variables y 10.000 registros, si deseáis disponer de él podéis descargaros el archivo [aquí](/images/2010/12/RF.RData). La intención es crear un ranking con las variables cuantitativas más relevantes en el modelo de clasificación. Lo primero que tenemos que hacer es crear un objeto con las variables cuantitativas que deseamos analizar:

```r
#Eliminamos los factores de nuestro objeto

eliminados=NULL

for (i in 1:length(datos)-1){

if (class(datos[,i]) == "factor" ){eliminados<-rbind(eliminados,i)} }

datos2 = datos[,-eliminados]

head(datos2)
```

Recorremos las clases del objeto datos y eliminamos aquellas que son factores a excepción de class que será nuestra variable dependiente. Con este objeto realizamos nuestro proceso. Uno de los paquetes que podemos emplear es _randomForest_ y un ejemplo de su uso podría ser:

```r
#install.packages("randomForest")

library(randomForest)

modelo1 <- randomForest(class~.,data=datos2,

ntree=500,importance=TRUE,maxnodes=10,mtry=25)

#Creamos un objeto con las "importancias" de las variables

importancia=data.frame(importance(modelo1))

library(reshape)

importancia<-sort_df(importancia,vars='MeanDecreaseGini')

importancia
```

Creamos el objeto _modelo1_ con la función _randomForest_ , nuestra variable dependiente es _class_ y el resto son nuestras variables independientes. Comentamos las opciones empleadas. _**ntree**_ nos permite especificar el número de árboles a realizar, _**importance**_ incluye en el objeto las «medidas de importancia», **maxnodes** indica el número máximo de nodos en nuestros árboles y _**mtry**_ indica el número máximo de variables en los modelos creados. Estas dos últimas opciones encaminadas a que los tiempos de ejecución no se alarguen, ya que es un proceso que puede alargarse. En este caso para medir la importancia de las variables empleamos la función _**importance**_ sobre el modelo creado. Ordenamos ascendentemente con _**sort_df**_ de la librería _**reshape**_ por la medida **MeanDecreaseGini**. El [índice de Gini](http://es.wikipedia.org/wiki/Coeficiente_de_Gini) es una «medida de desorden» en este caso **MeanDecreaseGini** tiene el siguiente sentido, a mayor medida mayor importancia en los modelos creados ya que valores próximos a 0 para el índice de Gini implican un mayor desorden y valores próximos a 1 implican un menor desorden. Si computamos una medida del «decrecimiento» del índice de Gini cuanto mayor sea esta medida más variabilidad aporta a la variable dependiente.

También podemos graficar las medidas de importancia:

`varImpPlot(modelo1)`

[![importancia-variables.png](/images/2011/01/importancia-variables.thumbnail.png)](/images/2011/01/importancia-variables.png "importancia-variables.png")

Otro paquete que podemos emplear para medir la importancia es el _party_ , por ejemplo:

```r
library(party)

set.seed(5)

def = cforest_classical(ntree=500, mtry=25)

modelo2 = cforest(class~., data = datos2, controls=def)

importancias = varimp(modelo2, conditional = TRUE)
```

Un comentario, en los modelos realizados el paquete party el tiempo de ejecución se ha alargado mucho, no me está gustando. Otro paquete disponible es el varSelRF:

```r
#install.packages("varSelRF")

library(varSelRF)

modelo3 <- randomForest(class~.,data=datos2,

ntree=500,importance=TRUE,maxnodes=10,mtry=25)

importancia3 <- randomVarImpsRF(xdata=datos2[,-177],Class=datos2$class,

forest=modelo3,usingCluster = FALSE)
```

La función _randomVarImpsRF_ nos permite determinar la importancia de las variables empleadas en los modelos. También este paquete ha implicado unos mayores tiempos de ejecución. Tres formas de obtener «bosques» y emplearlos para medir como influyen las variables cuantitativas en modelos de clasificación. Yo en mi trabajo he empleado siempre el _ramdomForest_ con la función _importance_ pero me gusta mostraros distintos métodos. Espero que os sirva de ayuda en vuestros análisis. Saludos.