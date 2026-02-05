---
author: rvaquerizo
categories:
  - data mining
  - formación
  - modelos
  - monográficos
  - r
date: '2009-08-31'
lastmod: '2025-07-13'
related:
  - monografico-arboles-de-decision-con-party.md
  - trucos-r-llevar-a-sas-las-reglas-de-un-arbol-de-decision.md
  - arboles-de-decision-con-sas-base-con-r-por-supuesto.md
  - monografico-paquete-de-r-nnet-para-modelos-de-redes-neuronales.md
  - monografico-un-poco-de-proc-logistic.md
tags:
  - árbol decisión
  - rpart
title: Monográfico. Árboles de clasificación con RPART
url: /blog/monografico-arboles-de-clasificacion-con-rpart/
---

Con este rápido monográfico voy a acercarme a los árboles de regresión con R. Esta metodología de predicción realiza construcciones lógicas que establecen reglas que nos permiten clasificar observaciones en función de una variable respuesta y de las relaciones existentes entre las variables dependientes. 

En esta primera aproximación, no voy a entrar en algoritmos ni en tipos de árboles; intentaré despertar la curiosidad del lector sobre este tipo de análisis y, sobre todo, quiero acercar R al mundo empresarial, un ámbito donde creo que R aún tiene mucho camino por recorrer en España.

Como es habitual, voy a plantear un ejemplo e iremos analizando las posibilidades del paquete `rpart`. También quiero que este ejemplo sirva como introducción a la generación de datos aleatorios con R. Vamos a "simular" la cartera de un banco que tiene 380 clientes y quiere estudiar la propensión a la contratación de una Pensión Vitalicia Inmediata (`PVI`). Para el estudio se emplearán las siguientes variables:

- El saldo en vista.
- El máximo saldo en planes de pensiones individuales en los últimos tres años.
- El saldo en fondos.
- La edad del cliente.

Generamos aleatoriamente un `data.frame` con la cartera de clientes:

```r
set.seed(123)
clientes <- 380
saldo_vista <- runif(clientes, 0, 1) * 10000
saldo_ppi <- (runif(clientes, 0.1, 0.2) * rpois(clientes, 1)) * 100000
saldo_fondos <- (runif(clientes, 0.1, 0.9) * (rpois(clientes, 1) - 1 > 0)) * 100000
edad <- rpois(clientes, 60)

datos_ini <- data.frame(saldo_vista, saldo_ppi, saldo_fondos, edad)
datos_ini$saldo_ppi <- (datos_ini$edad <= 68) * datos_ini$saldo_ppi
```

`runif()` y `rpois()` generan vectores aleatorios: `rpois()` con distribuciones de Poisson y `runif()` genera números aleatorios de distribución uniforme. Éstas serán nuestras variables predictoras. Ahora necesitamos generar la variable dependiente de nuestro modelo. Para ello, vamos a crear un potencial de contratación de `PVI` para cada cliente:

```r
datos_ini$potencial <- runif(clientes, 0, 1) + 
                       (log(datos_ini$edad) / (log(68)) / 100) + 
                       0.001 * (datos_ini$saldo_vista > 5000) + 
                       0.001 * (datos_ini$saldo_fondos > 10000) + 
                       0.007 * (datos_ini$saldo_ppi > 10000)

datos_ini$pvi <- as.factor((datos_ini$potencial >= quantile(datos_ini$potencial, 0.90)) * 1)
```

El potencial es un valor que aumentamos ligeramente si se cumplen ciertas condiciones de negocio. Por último, creamos la variable `pvi` en el `data.frame` `datos_ini`, que tomará valores 0 o 1 de modo que un 10% de las observaciones tengan valor 1.

```r
table(datos_ini$pvi)
```

En este punto ya podemos realizar nuestro árbol con la librería `rpart`:

```r
library(rpart)

# Creación del modelo
arbol <- rpart(pvi ~ saldo_vista + saldo_ppi + saldo_fondos + edad, 
               data = datos_ini, method = "class")

# Visualización del árbol
plot(arbol)
text(arbol, use.n = TRUE, all = TRUE, cex = 0.8)
```

Vemos cómo se compone el objeto `arbol`. Es evidente que lo mejor es estudiar el árbol gráficamente. Si observamos que los clientes con poco saldo en vista forman un grupo muy claro, podríamos centrar el modelo en el resto empleando `subset()`:

```r
datos_filtrados <- subset(datos_ini, saldo_vista > 5000)

arbol_v2 <- rpart(pvi ~ saldo_vista + saldo_ppi + saldo_fondos + edad, 
                  data = datos_filtrados, method = "class")

plot(arbol_v2)
text(arbol_v2, use.n = TRUE)
```

Vemos un resumen de los parámetros de complejidad del modelo:

```r
printcp(arbol_v2)
```

Podemos visualizar gráficos para la validación del modelo:

```r
# Parámetros de validación
par(mfrow = c(1, 2))
rsq.rpart(arbol_v2)
```

También es posible realizar podas de las ramas de nuestro árbol con la función `prune()` para evitar el sobreajuste:

```r
# Ejemplo de poda basada en el parámetro de complejidad (CP)
arbol_podado <- prune(arbol_v2, cp = 0.05)

plot(arbol_podado)
text(arbol_podado, use.n = TRUE)
```

Vemos que en este primer acercamiento a los árboles de clasificación con R disponemos de herramientas potentes. El problema de `rpart` es que, con configuraciones por defecto, puede ser limitado para volúmenes masivos de datos, pero es una excelente base. En una siguiente entrega trabajaremos con el paquete `party`.

Para cualquier duda o sugerencia, estoy a vuestra disposición en `rvaquerizo@analisisydecision.es`. Saludos.