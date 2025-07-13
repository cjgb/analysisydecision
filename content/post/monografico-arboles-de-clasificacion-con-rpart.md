---
author: rvaquerizo
categories:
- Data Mining
- Formación
- Modelos
- Monográficos
- R
date: '2009-08-31T10:13:13-05:00'
lastmod: '2025-07-13T16:02:44.282800'
related:
- monografico-arboles-de-decision-con-party.md
- trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
- arboles-de-decision-con-sas-base-con-r-por-supuesto.md
- monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
- monografico-un-poco-de-proc-logistic.md
slug: monografico-arboles-de-clasificacion-con-rpart
tags:
- árbol decisión
- RPART
title: Monográfico. Arboles de clasificación con RPART
url: /monografico-arboles-de-clasificacion-con-rpart/
---

Con este rápido monográfico voy a acercarnos a los árboles de regresión con R. Esta metodología de predicción realiza construcciones lógicas que establecen reglas que nos permiten clasificar observaciones en función de una variable respuesta y de las relaciones existentes entre las variables dependientes. En esta primera aproximación no no voy a entrar en algoritmos ni en tipos de árboles (hay suficiente documentación en la red) intentaré en despertar la curiosidad del lector sobre este tipo de análisis y sobre todo quiero acercar a R al mundo empresarial un ámbito donde creo que R no destaca (al menos en España).

Como es habitual voy a plantear un ejemplo e iremos analizando las posibilidades del paquete rpart. También quiero que este ejemplo sirva como introducción a la generación de datos aleatorios con R. Con esto la idea es “simular” la cartera de un banco que tiene 380 clientes y quiere estudiar la propensión a la contratación de una pensión vitalicia inmediata (PVI). Para el estudio va a emplear las siguientes variables:

  * El saldo en vista
  * El máximo saldo en planes de pensiones individuales en los últimos 3 años
  * El saldo en fondos
  * La edad del cliente

Generamos aleatoriamente un data.frame con la cartera de clientes:

```r
saldo_vista=runif(380,0,1)*10000

saldo_ppi=(runif(380,0.1,0.2)*rpois(380,1))*100000

saldo_fondos=(runif(380,0.1,0.9)*(rpois(380,1)-1>0))*100000

edad=rpois(380,60)

datos_ini<-data.frame(cbind(saldo_vista,saldo_ppi,saldo_fondos,edad))

datos_inisaldo_ppi=(edad<=68)*datos_inisaldo_ppi
```

_Runif_ y _rpois_ generan vectores aleatorios, _rpois_ con distribuciones de poisson de media indicada en el segundo parámetro y _runif_ genera números aleatorios de distribución uniforme entre el segundo y el tercer parámetro de la función. Son dos funciones interesantes para generar números aleatorios enteros y reales. Estas serán nuestras variables dependientes, pero necesitamos generar nuestra variable independiente de nuestro modelo. Para ello vamos a crear un potencial de contratación de PVI para cada cliente y le vamos a aumentar este potencial ligeramente para ver como se comporta el árbol que realicemos:

```r
datos_inipotencial=runif(1,0,1)+

(log(edad)/(log(68))/100) +

runif(1,0,0.001)*(saldo_vista>5000)+

runif(1,0,0.001)*(saldo_fondos>10000)+

runif(1,0,0.007)*(saldo_ppi>10000)-

runif(1,0,0.2)

datos_inipvi=as.factor((datos_inipotencial>=quantile(datos_inipotencial,0.90))*1)
```

El potencial es un número aleatorio entre 0 y 1 que aumentamos si la edad es superior a 68 años y si los saldos son superiores a determinadas cantidades. Por último creamos la variable pvi en el _data_._frame_ _datos_ini_ que tomará valores 0 o 1 en función de si el potencial está por encima del percentil 90, así nos aseguramos que un 10% aproximadamente de las observaciones tienen un valor 1.

```r
table(datos_ini$pvi)

  0 1

340 39
```

Algo más de un 10% de las observaciones tiene valor 1 para pvi. En este punto ya podemos realizar nuestro árbol, necesitaremos disponer del paquete **RPART** :

```r
library(rpart)

> arbol=rpart(pvi~saldo_vista+saldo_ppi+saldo_fondos+edad,data=datos_ini)

> arbol

n= 380

node), split, n, loss, yval, (yprob)

  * denotes terminal node
```

```r
1) root 380 39 0 (0.8973684 0.1026316)

  2) saldo_vista< 5055.117 204 0 0 (1.0000000 0.0000000) *

  3) saldo_vista>=5055.117 176 39 0 (0.7784091 0.2215909)

  6) edad< 66.5 133 14 0 (0.8947368 0.1052632)

  12) saldo_fondos< 6146.241 88 0 0 (1.0000000 0.0000000) *

  13) saldo_fondos>=6146.241 45 14 0 (0.6888889 0.3111111)

  26) edad< 57.5 23 0 0 (1.0000000 0.0000000) *

  27) edad>=57.5 22 8 1 (0.3636364 0.6363636)

  54) saldo_ppi< 5267.955 8 0 0 (1.0000000 0.0000000) *

  55) saldo_ppi>=5267.955 14 0 1 (0.0000000 1.0000000) *

  7) edad>=66.5 43 18 1 (0.4186047 0.5813953)

  14) saldo_ppi< 6573.219 35 17 0 (0.5142857 0.4857143)

  28) edad< 75.5 25 9 0 (0.6400000 0.3600000)

  56) saldo_vista>=7725.819 18 5 0 (0.7222222 0.2777778) *

  57) saldo_vista< 7725.819 7 3 1 (0.4285714 0.5714286) *

  29) edad>=75.5 10 2 1 (0.2000000 0.8000000) *

  15) saldo_ppi>=6573.219 8 0 1 (0.0000000 1.0000000) *
```

Vemos como se compone el objeto arbol. Es evidente que lo mejor es estudiar el árbol gráficamente, para ello hemos de emplear la siguiente sintaxis:

```r
plot(arbol); text(arbol, use.n=TRUE)
```

Todos aquellos clients con un saldo en vista menor a 5.000 € no deben formar parte del modelo porque ellos mismos forman un grupo, deben ser eliminados. Empleamos subset:

```r
datos_dos=subset(datos_ini,saldo_vista>5000)

arbol=rpart(pvi~saldo_vista+saldo_ppi+saldo_fondos+edad,data=datos_dos)

plot(arbol); text(arbol, use.n=TRUE)
```

Vemos una sumarización del modelo:

```r
printcp(arbol)

Classification tree:

rpart(formula = pvi ~ saldo_vista + saldo_ppi + saldo_fondos +

  edad, data = datos_dos)

Variables actually used in tree construction:

[1] edad saldo_fondos saldo_ppi saldo_vista

Root node error: 39/181 = 0.21547

n= 181

  CP nsplit rel error xerror xstd

1 0.179487 0 1.00000 1.00000 0.14183

2 0.119658 1 0.82051 1.02564 0.14313

3 0.089744 4 0.46154 0.87179 0.13474

4 0.025641 6 0.28205 0.76923 0.12828

5 0.010000 7 0.25641 0.82051 0.13160
```

Podemos visualizar un gráfico para la validación cruzada del modelo realizado:

```r
par(mfrow=c(1,2));rsq.rpart(arbol);
```

A la vista del gráfico del R-cuadrado es evidente que estamos sobreestimando la variable dependiente. Habría que trabajar el modelo. También es posible realizar podas de las ramas de nuestro árbol con la función _prune_ :

```r
podaarbol=prune(arbol,cp= 0.119658 )

plot(podaarbol);text(podaarbol)

par(mfrow=c(1,2));rsq.rpart(podaarbol);
```

Vemos que en este primer acercamiento a los árboles de clasificación con R disponemos de algunas herramientas interesantes. El problema es que el algoritmo que realiza la clasificación sólo admite 400 observaciones (aproximadamente) por lo que no nos serviría para una aplicación en el mundo empresarial. De todos modos contamos con una comunidad de programadores detrás que siguen mejorando el producto. Para una siguiente entrega trabajaremos con el party. Para cualquier duda, sugerencia o encontráis un error en mi planteamiento (aprendemos todos juntos) estoy a vuestra disposición en [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)