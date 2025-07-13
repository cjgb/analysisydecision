---
author: rvaquerizo
categories:
- Data Mining
- Formación
- Modelos
- Monográficos
- R
date: '2011-11-06T11:43:36-05:00'
slug: el-sobremuestreo-%c2%bfmejora-mi-estimacion
tags:
- árboles de decisión
- curva ROC
- muestreo
- regresión logística
- ROCR
- sample
title: El sobremuestreo ¿mejora mi estimación?
url: /el-sobremuestreo-c2bfmejora-mi-estimacion/
---

El **sobremuestreo**(oversampling) es una técnica de muestreo que se emplea habitualmente cuando tenemos una baja proporción de casos positivos en clasificaciones binomiales. Los modelos pueden “despreciar” los casos positivos por ser muy pocos y nuestro modelo no funcionaría. Para **incrementar el número de casos positivos** se emplea el sobremuestreo. Ejemplos habituales pueden ser los modelos de fraude, un 99% de las compras son correctas, un 1% son fraudulentas. Si realizo un modelo puedo estar seguro al 99% de que todas mis compras son correctas, en este caso hemos de realizar un sobremuestreo para incrementar nuestros casos de fraude y poder detectar los patrones.

Personalmente no sabría deciros el porcentaje de casos positivos a partir del cual sería necesario llevar a cabo un proceso de remuestreo. A mi particularmente me gusta hacerlo siempre. Por lo menos realizar algunas pruebas para identificar aquellas variables que son más influyentes y comenzar a eliminar aquellas que no van a funcionar. Busco exagerar. Tampoco me quiero mojar mucho sobre la proporción de casos positivos y negativos, pero si estamos realizando un nuevo muestreo podemos emplear perfectamente un 50% para ambos, aquí si que dependemos del número de registros con el que estemos trabajando ya que al final el sobremuestreo será la repetición de los casos positivos sobre la tabla de entrada del modelo.

Sin embargo, cuando ya tengo decidido como va a ser mi modelo no me gusta realizar sobremuestreo. Lo considero un paso previo (algún lector del blog considerará estas palabras incoherentes). Después de toda esta exposición teórico-práctica de malos usos de un dinosaurio en realidad lo que cabepreguntarse es**¿mejora la estimación un modelo con sobremuestreo?**

Abrimos**R y Tinn-R** y manos a la obra. Datos simulados de una entidad bancaria que desea realizar un modelo para realizar una campaña comercial sobre renta o Pensión Vitalicia Inmediata (PVI) conocidos por todos:

```r
clientes=20000
saldo_vista=runif(clientes,0,1)*10000
saldo_ppi=(runif(clientes,0.1,0.6)*rpois(clientes,2))*60000
saldo_fondos=(runif(clientes,0.1,0.9)*(rpois(clientes,1)-0.5>0))*30000
edad=rpois(clientes,60)
datos_ini<-data.frame(cbind(saldo_vista,saldo_ppi,saldo_fondos,edad))
datos_inisaldo_ppi=(edad<65)*datos_inisaldo_ppi
#Creamos la variable objetivo a partir de un potencial
datos_inipotencial= runif(clientes,0,1)
datos_inipotencial= datos_inipotencial + log(edad)/2 + runif(1,0,0.03)*(saldo_vista>5000)+runif(1,0,0.09)*(saldo_fondos>5000)+runif(1,0,0.07)*(saldo_ppi>10000)

summary(datos_ini)
datos_inipvi=as.factor((datos_inipotencial>=quantile(datos_inipotencial,
0.98))*1)
#Eliminamos la columna que genera nuestra variable dependiente
datos_ini = subset(datos_ini, select = -c(potencial))
#Realizamos una tabla de frecuencias
table(datos_ini$pvi)
```
 

Sólo encontramos un 2% de casos positivos de los 20.000 clientes analizados. Para nuestro pequeño estudio vamos a emplear **regresión logística y árboles de decisión** , pero lo primero que vamos a hacer es seleccionar una parte de las observaciones para validar los modelos realizados:

```r
#Subconjunto de validacion
validacion <- sample(1:clientes,5000)
```
 

Estos 5.000 clientes no entrenarán ningún modelo sólo validarán los modelos, con y sin sobremuestreo, que realicemos. Vamos a generar la muestra con un porcentaje del 50% de casos positivos mediante la librería de R _sample_ :

```r
#install.packages("sampling")
library( sampling )
#Muestra estratificada aleatoria con reemplazamiento de tamaño 10000
selec1 <- strata( datos_ini[-validacion,], stratanames = c("pvi"),
size = c(5000,5000), method = "srswr" )
```
 

Con _strata_ realizamos el muestreo estratificado, el estrato es nuestra variable dependiente y así lo indicamos en _stratanames_ , como tenemos 2 estratos en _size_ indicamos 5000 observaciones para cada uno de ellos y el método _srswr señala_ que es muestreo con reemplazamiento (with replacement).

_Modelo de regresión logística:_

```r
#Modelo sin sobremuestreo
modelo.1 = glm(pvi~.,data=datos_ini[-validacion,],family=binomial)
summary(modelo.1)

#Modelo con sobremuestreo
#Nos quedamos con el elemento ID_unit
selec1 <- selec1$ID_unit
modelo.2 = glm(pvi~.,data=datos_ini[selec1,],family=binomial)
summary(modelo.2)
```
 

Ambos modelos convergen, tienen parámetros similares y las inferencias sobre ellos son iguales. ¿Qué modelo funciona mejor? La librería ROCR nos permite realizar curvas ROC muy empleadas para medir el comportamiento de los modelos realizados. No entramos en detalle sobre el código para no alargar esta entrada:

```r
#Realizamos la curva ROC para ambos modelos y comparamos
#install.packages("ROCR")
library(ROCR)

#Objeto que contiene la validación del modelo sin sobremuestreo
valida.1 <- datos_ini[validacion,]
valida.1pred <- predict(modelo.1,newdata=valida.1,type="response")
pred.1 <- prediction(valida.1pred,valida.1pvi)
perf.1 <- performance(pred.1,"tpr", "fpr")
#Validación con sobremuestreo
valida.2 <- datos_ini[validacion,]
valida.2pred <- predict(modelo.2,newdata=valida.2,type="response")

pred.2 <- prediction(valida.2pred,valida.2pvi)
perf.2 <- performance(pred.2,"tpr", "fpr")
#Pintamos ambas curvas ROC
plot(perf.2,colorize = FALSE)
par(new=TRUE)
plot(c(0,1),c(0,1),type='l',col = "red",
lwd=2, ann=FALSE)
par(new=TRUE)
plot(perf.1,colorize = TRUE)
```
 

![roc-logistica-sobremuestreo.png](/images/2011/11/roc-logistica-sobremuestreo.png)

La línea negra es el modelo con sobremuestreo y presenta una ligera (muy ligera mejora con respecto al modelo sin sobremuestreo). Para la regresión logística y en este ejemplo el modelo con sobremuestreo no mejora al modelo sin sobremuestreo.

_Modelos con árboles de decisión:_

```r
library(rpart)
#Modelo sin sobremuestreo
arbol.1=rpart(as.factor(pvi)~edad+saldo_ppi+saldo_fondos,
data=datos_ini[-validacion,],method="anova",
control=rpart.control(minsplit=20, cp=0.001) )

#Modelo con sobremuestreo
arbol.2=rpart(as.factor(pvi)~edad+saldo_ppi+saldo_fondos,
data=datos_ini[selec1,],method="anova",
control=rpart.control(minsplit=20, cp=0.001) )

#Validacion  sin sobremuestreo
valida.arbol.1 <- datos_ini[validacion,]
valida.arbol.1pred <- predict(arbol.1,newdata=valida.arbol.1)
pred.1 <- prediction(valida.arbol.1pred,valida.arbol.1pvi)
perf.1 <- performance(pred.1,"tpr", "fpr")

#Validacion con sobremuestreo
valida.arbol.2 <- datos_ini[validacion,]
valida.arbol.2pred <- predict(arbol.2,newdata=valida.arbol.2)
pred.2 <- prediction(valida.arbol.2pred,valida.arbol.2pvi)
perf.2 <- performance(pred.2,"tpr", "fpr")
#Pintamos ambas curvas ROC
plot(perf.2,colorize = FALSE)
par(new=TRUE)
plot(c(0,1),c(0,1),type='l',col = "red",
lwd=2,ann=FALSE)
par(new=TRUE)
plot(perf.1,colorize = TRUE)
```
 

Analizamos el gráfico resultante:

![roc-arboles-rpart-sobremuestreo.png](/images/2011/11/roc-arboles-rpart-sobremuestreo.png)

En este caso las curvas ROC son distintas y os dejo que saquéis vuestras propias conclusiones y las comentéis en el blog. Para evitarós problemas os dejo en [este enlace](/images/2011/11/sobremuestreo-2.r "sobremuestreo-2.r") el código empleado para este experimento. Ejecutadlo para analizar los resultados.