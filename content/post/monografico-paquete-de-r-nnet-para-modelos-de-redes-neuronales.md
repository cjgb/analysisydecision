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

Quiero introduciros a los **modelos de redes neuronales con R**, más concretamente quiero acercaros al módulo `nnet` de R. Tenemos extensa literatura al respecto de las redes neuronales; personalmente considero de lectura obligatoria [este enlace](http://halweb.uc3m.es/esp/Personal/personas/jmmarin/esp/DM/tema3dm.pdf) (y prácticamente toda la documentación de este profesor).

El paquete `nnet` nos permite crear redes neuronales de clasificación monocapa. Las redes neuronales clasifican mediante algoritmos o métodos de entrenamiento; en función de estos métodos podemos tener redes supervisadas y redes no supervisadas. Las primeras buscan un límite de decisión lineal a través de un entrenamiento. Las segundas parten de unos parámetros (pesos) fijos y no requieren entrenamiento porque realizan mecanismos de aprendizaje en función de experiencias anteriores.

Como ya os he indicado, hay mucha bibliografía al respecto y muchas entradas en Google que pueden ayudaros a conocer mejor estos modelos. En el caso que nos ocupa, y como viene siendo tónica habitual de la bitácora, vamos a darle una visión más práctica (tampoco soy yo el más adecuado para dar esa visión teórica). Trabajamos en una gran caja española y nuestro responsable nos pide realizar una selección de clientes para un *mailing*. Tenemos que "colocar" planes de pensiones vitalicios inmediatos. A nosotros se nos ocurre realizar un modelo de redes neuronales para seleccionar aquellos clientes con una puntuación más alta y, por tanto, más propensos a comprar el producto.

Como en anteriores ejemplos, partimos de un objeto con datos aleatorios que simula la cartera de una entidad bancaria. Queremos determinar qué clientes son más propensos a la contratación de un plan vitalicio de pensión inmediata para seleccionarlos y lanzar una comunicación comercial sobre ellos. Simulamos una cartera de 20.000 clientes:

```r
clientes = 20000

saldo_vista = runif(clientes, 0, 1) * 10000
saldo_ppi = (runif(clientes, 0.1, 0.2) * rpois(clientes, 1)) * 100000
saldo_fondos = (runif(clientes, 0.1, 0.9) * (rpois(clientes, 1) - 1 > 0)) * 100000
edad = rpois(clientes, 60)

datos_ini <- data.frame(saldo_vista, saldo_ppi, saldo_fondos, edad)

datos_ini$saldo_ppi = (edad <= 68) * datos_ini$saldo_ppi

# Creamos la variable objetivo a partir de un potencial
datos_ini$potencial = runif(1, 0, 1) +
  (log(edad) / (log(68)) / 100) +
  runif(1, 0, 0.001) * (saldo_vista > 5000) +
  runif(1, 0, 0.001) * (saldo_fondos > 10000) +
  runif(1, 0, 0.007) * (saldo_ppi > 10000) -
  runif(1, 0, 0.2)

datos_ini$pvi = as.factor((datos_ini$potencial >= quantile(datos_ini$potencial, 0.90)) * 1)
```

Código más que conocido por todos porque lo hemos utilizado en más de un monográfico. El paquete de R que vamos a emplear será `nnet`. Veamos una propuesta de estructura para el análisis:

```r
# Carga del paquete:
library(nnet)

# Matriz de predictores:
pred = cbind(datos_ini$saldo_vista, datos_ini$saldo_ppi,
             datos_ini$saldo_fondos, datos_ini$edad)

summary(pred)

# Matriz de target:
target = as.matrix(datos_ini$pvi)

# Muestra aleatoria del 90% de los clientes para el aprendizaje
select = sample(1:clientes, clientes * 0.9)
```

Para "enseñar" a nuestra red vamos a trabajar con una muestra del 90% de los registros. El 10% restante nos servirá para validar el comportamiento predictor de nuestro modelo de redes neuronales. En realidad sería más adecuado quedarnos con tres conjuntos de datos: entrenamiento, test y validación; pero los dos últimos en nuestro ejemplo serán uno. Pasamos a realizar el modelo:

```r
redn = nnet(pred[select,], as.numeric(target[select,]), size = 2,
            rang = 0.1, decay = 5e-4, maxit = 500)
```

Los parámetros fundamentales son las matrices predictoras y target, y de estos sólo seleccionamos una muestra `select` del 90%. No asignamos pesos con la función `weights`, así que por defecto serán 1 para todos. Con `size` asignamos el número de unidades en la capa oculta, en este caso 2; podemos poner de 0 a $n$ capas ocultas entre la neurona de entrada y la neurona de salida. Con `rang` asignamos los pesos iniciales; con `decay` establecemos los "*weight decay*" (pesos decadentes), que es una medida para limitar el efecto de los pesos altos. Con `maxit` limitamos el número máximo de iteraciones del modelo; como no tenemos un gran número de observaciones, paramos en 500 (por defecto está en 100).

Tras ejecutarlo vemos que no han hecho falta las 500 iteraciones para llegar a la convergencia del modelo. En este punto tenemos que estudiar su comportamiento predictor con las observaciones reservadas a test. Empleamos la función `predict` para añadir el potencial a todo el conjunto de datos inicial:

```r
prediccion = predict(redn, datos_ini)
datos_ini$prediccion = prediccion

summary(datos_ini$prediccion)

tapply(datos_ini$prediccion, list(pvi = datos_ini$pvi), mean, na.rm = TRUE)
```

Ahora analizamos cómo funcionan las predicciones en el 10% de las observaciones reservadas para el testeo:

```r
datos_ini.test = datos_ini[-select,]

library(reshape)
datos_ini.test = sort_df(datos_ini.test, vars = 'prediccion')

tapply(datos_ini.test$prediccion, list(pvi = datos_ini.test$pvi), mean)
```

El conjunto de datos de testeo tiene una media de potencial mucho más alta para aquellos que tienen contratado el producto; parece que tiene un comportamiento correcto. Es interesante realizar un pequeño análisis del comportamiento de las variables que han participado en el estudio. Planteo algo muy sencillo: voy a tramificar las variables cuantitativas en 10 tramos (percentiles) y calcular la media del potencial que hemos obtenido con el modelo en cada tramo.

```r
# Potenciales por percentil de edad:
edad_df = data.frame(acum = 1, edad = datos_ini$edad, prediccion = datos_ini$prediccion)
edad_df = sort_df(edad_df, vars = "edad")
edad_df$tramo = as.factor(ceiling((cumsum(edad_df$acum) / nrow(edad_df)) * 10))

rbind(
  tapply(edad_df$edad, list(edad = edad_df$tramo), min, na.rm = TRUE),
  tapply(edad_df$edad, list(edad = edad_df$tramo), max, na.rm = TRUE),
  tapply(edad_df$prediccion, list(edad = edad_df$tramo), mean, na.rm = TRUE)
)
```

Vemos que para edades más altas el potencial es mayor. Este programa habría de parametrizarse y convertirse en una función, pero ese ejercicio os lo dejo a vosotros (vamos, que lo he intentado, no he sido capaz y no he insistido…). Igualmente debemos hacerlo para todas las variables, por ejemplo:

```r
# Potenciales por percentil de saldo_vista:
saldo_vista_df = data.frame(acum = 1, saldo_vista = datos_ini$saldo_vista, 
                            prediccion = datos_ini$prediccion)
saldo_vista_df = sort_df(saldo_vista_df, vars = "saldo_vista")
saldo_vista_df$tramo = as.factor(ceiling((cumsum(saldo_vista_df$acum) / nrow(saldo_vista_df)) * 10))

rbind(
  tapply(saldo_vista_df$saldo_vista, list(saldo_vista = saldo_vista_df$tramo), min, na.rm = TRUE),
  tapply(saldo_vista_df$saldo_vista, list(saldo_vista = saldo_vista_df$tramo), max, na.rm = TRUE),
  tapply(saldo_vista_df$prediccion, list(saldo_vista = saldo_vista_df$tramo), mean, na.rm = TRUE)
)
```

Con esta metodología podemos dar un carácter explicativo a nuestro modelo de redes neuronales, si bien es cierto que puede resultar más complicado encontrar interacciones entre las variables. Creo que tenéis un buen ejemplo de uso del `nnet`. Comentaros que no soy ningún experto en redes neuronales y si he cometido algún error o creéis interesante aportar algo estoy en `rvaquerizo@analisisydecision.es`.