---
author: rvaquerizo
categories:
  - data mining
  - formación
  - monográficos
  - r
date: '2010-01-26'
lastmod: '2025-07-13'
related:
  - regresion-con-redes-neuronales-en-r.md
  - monografico-arboles-de-clasificacion-con-rpart.md
  - monografico-un-poco-de-proc-logistic.md
  - como-salva-la-linealidad-una-red-neuronal.md
  - representacion-de-redes-neuronales-con-r.md
tags:
  - nnet
  - r
  - redes neuronales
title: Monográfico. Paquete de R NNET para modelos de redes neuronales
url: /blog/monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales/
---

Quiero introduciros a los **modelos de redes neuronales** **con R** , mas concretamente quiero acercaros al módulo `nnet` de R. Tenemos extensa literatura al respecto de las redes neuronales, personalmente considero de lectura obligatoria [este link](http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/DM/tema3dm.pdf) (y prácticamente toda la documentación de este profesor) El paquete `nnet` nos permite crear redes neuronales de clasificación monocapa. Las redes neuronales clasifican mediante algoritmos o métodos de entrenamiento, en función de estos métodos podemos tener redes supervisadas y redes no supervisadas. Las primeras buscan un límite de decisión lineal a través de un entrenamiento. Las segundas parten de unos parámetros (pesos) fijos y no requieren entrenamiento porque realizan mecanismos de aprendizaje en función de experiencias anteriores. Como ya os he indicado hay mucha bibliografía al respecto y muchas entradas en Google que pueden ayudaros a conocer mejor estos modelos. En el caso que nos ocupa, y como viene siendo tónica habitual de la bitácora, vamos a darle una visión más práctica (tampoco soy yo el más adecuado para dar esa visión teórica). Trabajamos en una gran Caja española y nuestro responsable nos pide realizar una selección de clientes para un mailing. Tenemos que «colocar» planes de pensiones vitalicios inmediatos. A nosotros se nos ocurre realizar un modelo de redes neuronales para seleccionar aquellos clientes con una puntuación más alta y, por tanto, más propensos a comprar el producto.

Como en anteriores ejemplos partimos de un objeto con datos aleatorios que simula la cartera de una entidad bancaria. Queremos determinar que clientes son mas propensos a la contratación de un plan vitalicio de pensión inmediata para seleccionarlos y lanzar una comunicación comercial sobre ellos. Simulamos una cartera de 20.000 clientes:

```r
clientes=20000

saldo_vista=runif(clientes,0,1)*10000

saldo_ppi=(runif(clientes,0.1,0.2)*rpois(clientes,1))*100000

saldo_fondos=(runif(clientes,0.1,0.9)*(rpois(clientes,1)-1>0))*100000

edad=rpois(clientes,60)

datos_ini<-data.frame(cbind(saldo_vista,saldo_ppi,saldo_fondos,edad))

datos_inisaldo_ppi=(edad<=68)*datos_inisaldo_ppi

#Creamos la variable objetivo a partir de un potencial

datos_inipotencial=runif(1,0,1)+

(log(edad)/(log(68))/100) +

runif(1,0,0.001)*(saldo_vista>5000)+

runif(1,0,0.001)*(saldo_fondos>10000)+

runif(1,0,0.007)*(saldo_ppi>10000)-

runif(1,0,0.2)

datos_inipvi=as.factor((datos_inipotencial>=quantile(datos_inipotencial,

0.90))*1)
```

Código más que conocido por todos porque le hemos utilizado en más de un monográfico. El paquete de R que vamos a emplear será `nnet`. Veamos una propuesta de estructura para el análisis:

```r
#Carga del paquete:

library(nnet)

#Matriz de predictores:

pred=cbind(datos_inisaldo_vista,datos_inisaldo_ppi,

datos_inisaldo_fondos,datos_iniedad)

summary(pred)

#Matriz de target:

target=as.matrix(datos_ini$pvi)

#Muestra aleatoria del 10% de los clientes para el aprendizaje

select=sample(1:clientes,clientes*0.9)
```

Para «enseñar» a nuestra red vamos a trabajar con una muestra del 90% de los registros. El 10% restante nos servirá para validar el comportamiento predictor de nuestro modelo de redes neuronales. En realidad sería más adecuado quedarnos con 3 conjuntos de datos: entrenamiento, test y validación; pero los dos últimos en nuestro ejemplo serán uno. Pasamos a realizar el modelo:

```r
redn=nnet(pred[select,],as.numeric(target[select,]), size = 2,

rang =0.1,decay = 5e-4, maxit = 500)
```

Los parámetros fundamentales son las matrices predictoras y target y de éstos solo seleccionamos una muestra `select` del 90%. No asignamos pesos con la función `weights` así que por defecto serán 1 para todos. Con `size` asignamos el número de capas ocultas de la neurona, en este caso 2, podemos poner de 0 a n capas ocultas entre la neurona de entrada y la neurona de salida. Con `rang` asignamos los pesos iniciales, con `decay` establecemos los « _weight decay_ » (pesos decadentes), es una medida para limitar el efecto de los pesos altos. Con `maxit` limitamos el número máximo de iteraciones del modelo, como no tenemos un gran número de observaciones paramos en 500, por defecto está en 100.

Tras ejecutarlo vemos que no han hecho falta las 500 iteracciones para llegar a la convergencia del modelo. En este punto tenemos que estudiar su comportamiento predictor con las observaciones reservadas a test. Empleamos la función `predict` para añadir el potencial a todo el conjunto de datos inicial:

```r
prediccion=predict(redn,datos_ini)

names(prediccion)=c("prediccion")

datos_ini.pred=cbind(datos_ini,prediccion)

summary(datos_ini.pred)

tapply(datos_ini.predprediccion, list(pvi=datos_ini.predpvi),

mean, na.rm=TRUE)
```

Ahora analizamos como funcionan las predicciones en el 10% de las observaciones reservadas para el testeo:

```r
datos_ini.test=datos_ini.pred[-select,]

library(reshape)

datos_ini.test=sort_df(datos_ini.test,vars='prediccion')

tapply(datos_ini.testprediccion, list(pvi=datos_ini.testpvi), mean)
```

El conjunto de datos de testeo tiene una media de potencial mucho más alta para aquellos que tienen contratado el producto, parece que tiene un comportamiento correcto. Es interesante realizar un pequeño analisis del comportamiento de las variables que han participado en el estudio. Planteo algo muy sencillo. Voy a tramificar las variables cuantitativas en 10 tramos (percentiles) y calcular la media del potencial que hemos obtenido con el modelo en cada tramo.

```r
#Potenciales por percentil de edad:

edad=data.frame(cbind(1,datos_ini.prededad,datos_ini.predprediccion))

names(edad)=c("acum","edad","prediccion")

edad=sort_df(edad,vars="edad")

edadtramo=as.factor(ceiling((cumsum(edad[,1])/nrow(edad))*10))

rbind(

tapply(edadedad, list(edad=edadtramo), min, na.rm=TRUE),

tapply(edadedad, list(edad=edadtramo), max, na.rm=TRUE),

tapply(edadprediccion, list(edad=edad$tramo), mean, na.rm=TRUE))
```

Vemos que para edades más alta el potencial es mayor. Este programa habría de parametrizarse y convertirse en una función, pero ese ejercicio os lo dejo a vosotros, vamos que lo he intentado, no he sido capaz y no he insistido… Igualmente debemos hacerlo para todas las variables, por ejemplo:

```r
#Potenciales por percentil de saldo_vista:

saldo_vista=data.frame(cbind(1,datos_ini.predsaldo_vista,datos_ini.predprediccion))

names(saldo_vista)=c("acum","saldo_vista","prediccion")

saldo_vista=sort_df(saldo_vista,vars="saldo_vista")

saldo_vistatramo=as.factor(ceiling((cumsum(saldo_vista[,1])/nrow(saldo_vista))*10))

rbind(

tapply(saldo_vistasaldo_vista, list(saldo_vista=saldo_vistatramo), min, na.rm=TRUE),

tapply(saldo_vistasaldo_vista, list(saldo_vista=saldo_vistatramo), max, na.rm=TRUE),

tapply(saldo_vistaprediccion, list(saldo_vista=saldo_vista$tramo), mean, na.rm=TRUE))
```

Con esta metodología podemos dar un carácter explicativo a nuestro modelo de redes neuronales, si bien es cierto que puede resultar más complicado encontrar interacciones entre las variables. Creo que tenéis un buen ejemplo de uso del `nnet`. Comentaros que no soy ningún experto en redes neuronales y si he cometido algún error o creéis interesante aportar algo estoy en `rvaquerizo@analisisydecision.es`
