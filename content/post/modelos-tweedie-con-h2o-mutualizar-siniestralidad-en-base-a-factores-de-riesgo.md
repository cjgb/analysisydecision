---
author: rvaquerizo
categories:
  - formación
  - machine learning
  - modelos
  - r
  - seguros
date: '2020-12-01'
lastmod: '2025-07-13'
related:
  - evaluando-la-capacidad-predictiva-de-mi-modelo-tweedie.md
  - el-modelo-multivariante-en-el-sector-asegurador-los-modelos-por-coberturas-v.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-17-modelizacion-estadistica-seleccionar-variables-y-modelo.md
  - la-distribucion-tweedie.md
  - el-modelo-multivariante-en-el-sector-asegurador-la-variable-dependiente-iii.md
tags:
  - h2o
  - tweedie
title: Modelos tweedie con H2O. Mutualizar siniestralidad en base a factores de riesgo
url: /blog/modelos-tweedie-con-h2o-mutualizar-siniestralidad-en-base-a-factores-de-riesgo/
---

[Ya he escrito sobre la distribución tweedie en otra ocasión](https://analisisydecision.es/la-distribucion-tweedie/) y hoy vuelvo a traeros un ejemplo de uso que además servirá para introducir un método, una forma de trabajar con modelos en `H2O` y R, además de emplear `Gradient Boosting Machine` (`GBM`) para la obtención de primas de riesgo. 

Ya hay buenos profesionales repartidos en el mercado laboral a los que les he mostrado cómo hacer modelos de riesgo para el sector asegurador con R y `H2O` dentro del [Máster en Big Data de la UNED](https://www.masterbigdataonline.com/index.php) donde imparto el módulo de seguros. Pero hoy quiero traer al blog un resumen de otro tipo de modelos que nos pueden servir para segmentar una cartera de seguros en base a la siniestralidad esperada de un riesgo. 

Recordad que un seguro trata de mutualizar el gasto entre una cartera: no sé *a priori* quién va a tener un siniestro (¡si lo supiera!), pero si dispongo de información histórica de mi cartera y esa información me puede dar unas pistas sobre lo que ocurrirá a futuro (habitualmente un año), quiero ver qué parte de esa información histórica es reproducible asumiendo siempre un error.

Para entender mejor cómo se mutualiza, cómo se reparte el riesgo y la siniestralidad en nuestra cartera, vamos a emplear modelos `tweedie`. Además los vamos a realizar con `H2O` y, de paso, os comento cómo trabajo en un entorno R + `H2O`. El ejemplo lo ilustramos con un conjunto de datos de la librería `CASdatasets`:

```r
# library(CASdatasets)
library(tidyverse)
data("norauto")
```

El conjunto de datos de trabajo será `norauto`, que contiene los datos de una cartera de seguros de automóviles. Como he comentado, si simplificamos, lo que buscamos es reproducir esa parte del pasado en el año siguiente. En nuestro caso tenemos un importe siniestral (`ClaimAmount`) y una exposición al riesgo (`Expo`).

Si queremos repartir la siniestralidad total tendríamos que hacer la media por expuesto, entendiendo por expuesto el tiempo que está activo ese riesgo en un año. La exposición pondera el tiempo que un riesgo nos puede provocar un siniestro. En nuestro caso, la media por unidad de exposición es:

```r
sum(norauto$ClaimAmount) / sum(norauto$Expo)
```

Sin embargo, como decía un jefe mío: «esto es café para todos, hay que alejarse del café para todos». Basta con resumir por un factor de riesgo para ver que las medias varían:

```r
norauto %>% 
  group_by(GeoRegion) %>% 
  summarise(media = sum(ClaimAmount) / sum(Expo))
```

Estaríamos cobrando mucho a los "buenos" y cobrando poco a los "malos", lo que se conoce como **antiselección**. Vamos a repartir esa siniestralidad mediante modelos `tweedie`. Pero antes, un paso inicial que sugiero es **descrestar** los siniestros para que su distribución sea más sencilla de modelar:

```r
# Acotamos siniestros a 50.000 unidades
norauto$ClaimAmount2 <- ifelse(norauto$ClaimAmount > 50000, 50000, norauto$ClaimAmount)

# Aplicamos un factor de elevación para no perder la siniestralidad total
factor_elevacion <- sum(norauto$ClaimAmount) / sum(norauto$ClaimAmount2)
norauto$ClaimAmount2 <- norauto$ClaimAmount2 * factor_elevacion
```

Ahora estamos en disposición de realizar nuestro modelo. Preparamos las variables:

```r
norauto$log_exposure <- log(norauto$Expo)
# Trabajamos con una muestra para el ejemplo
norauto_sample <- norauto %>% sample_frac(0.1)

predictoras <- c('Male', 'Young', 'DistLimit', 'GeoRegion')
respuesta <- "ClaimAmount2"
offset_var <- "log_exposure"
```

**Importante**: el modelo es aditivo y la ponderación se lleva a cabo por el logaritmo de la exposición (`offset`). Yo prefiero modelar el importe siniestral descrestado a modelar la prima pura; la experiencia me ha demostrado que se obtienen mejores resultados.

Empezamos nuestro trabajo con `H2O`:

```r
library(h2o)
h2o.init()

norauto.hex <- as.h2o(norauto_sample)

auto.splits <- h2o.splitFrame(data = norauto.hex, ratios = 0.6, seed = 1234)
train <- auto.splits[[1]]
valid <- auto.splits[[2]]
```

Cuando realizamos modelos `tweedie`, el primer paso siempre será identificar el parámetro `tweedie_variance_power`:

```r
param_grid <- list(tweedie_variance_power = c(1.5, 1.7, 1.9, 2.1))

grid_search <- h2o.grid(
  algorithm = "glm",
  grid_id = "tweedie_power_search",
  x = predictoras, y = respuesta, 
  training_frame = train, validation_frame = valid,
  family = 'tweedie',
  hyper_params = param_grid
)

# Obtenemos el mejor parámetro
best_power <- h2o.getGrid("tweedie_power_search", sort_by = "mse")
```

Una vez identificado el mejor parámetro (supongamos `vp = 1.9`), podemos realizar un modelo más complejo como un `GBM`:

```r
# Parámetros para la búsqueda aleatoria (simplificado)
hyper_params <- list(
  ntrees = c(100, 500),
  max_depth = c(3, 5),
  learn_rate = c(0.01, 0.1)
)

gbm_grid <- h2o.grid(
  algorithm = "gbm",
  grid_id = "gbm_tweedie",
  x = predictoras, y = respuesta,
  training_frame = train, validation_frame = valid,
  distribution = "tweedie",
  tweedie_power = 1.9,
  offset_column = offset_var,
  hyper_params = hyper_params,
  search_criteria = list(strategy = "RandomDiscrete", max_models = 10)
)

# Seleccionamos el mejor modelo del GBM
best_gbm <- h2o.getModel(h2o.getGrid("gbm_tweedie", sort_by = "mse")@model_ids[[1]])
```

Ya disponemos de un modelo que podemos aplicar para segmentar nuestra cartera. Yo soy fan de los modelos `tweedie` para segmentar y puntuar (*scorear*) carteras; los que han trabajado con `Emblem` me entenderán perfectamente. Como aproximación al problema es un buen método, además de que empleáis algoritmos de `Machine Learning` dentro del ámbito actuarial. 

Siempre es preferible realizar modelos de frecuencia y coste por separado y combinarlos, pero este enfoque es muy práctico. Saludos.