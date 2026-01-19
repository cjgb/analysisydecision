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
[Ya he escrito sobre la distribución tweedie en otra ocasión](https://analisisydecision.es/la-distribucion-tweedie/) y hoy vuelvo a traeros un ejemplo de uso que además servirá para introducir un método, una forma de trabajar con modelos en H2O y R además de emplear gradient boosting machine (gbm) para la obtención de primas de riesgo. Ya hay buenos profesionales repartidos en el mercado laboral a los que les he mostrado como hacer modelos de riesgo para el sector asegurador con R y H2O dentro del [Máster en Big Data de la UNED](https://www.masterbigdataonline.com/index.php) donde imparto el módulo de seguros. Pero hoy quiero traer al blog un resumen de otro tipo de modelos que nos pueden servir para segmentar una cartera de seguros en base a la siniestralidad esperada de un riesgo. Recordad que un seguro trata de mutualizar el gasto entre una cartera, no sé a priori quien va a tener un siniestro (¡si lo supiera!) pero si dispongo de información histórica de mi cartera y esa información me puede dar unas pistas sobre lo que ocurrirá a futuro (habitualmente un año), quiero ver que parte de esa información histórica es reproducible asumiendo siempre un error.

Para entender mejor como se mutualiza, como se reparte el riesgo, como se reparte la siniestralidad en nuestra cartera, vamos a emplear modelos tweedie, además los vamos a realizar con H2O y de paso os comento como trabajo en un entorno R + H2O. El ejemplo lo ilustramos con un conjunto de datos de la librería CASdatasets:

```r
library(CASdatasets)
library(tidyverse)
data("norauto")
```


Para instalar la librería CASdatasets seguid las instrucciones, [no hagáis el español como hice yo](https://www.mail-archive.com/r-help-es@r-project.org/msg06177.html). El conjunto de datos de trabajo será norauto que contiene los datos de una cartera de seguros de automóviles. Como he comentado, si simplificamos, lo que buscamos es reproducir esa parte del pasado en el año siguiente. En nuestro caso tenemos un importe siniestral y si asumimos que no hay IPC (si, el IPC afecta a los seguros por eso os suben aunque no hayáis tenido siniestros) entonces el año siguiente tendríamos una siniestralidad en nuestra cartera de:

```r
sum(norautoClaimAmount)
sum(is.na(norautoExpo))
sum(norauto$Expo==0)
```


Ya os digo que es muy simplista se pueden añadir hipótesis y escenarios. Si queremos repartir entre todos esos 236.580.507 unidades monetarias tendríamos que hacer la media de la siniestralidad por expuesto, entendiendo por expuesto el número de días que está activo ese riesgo en un año entre lo que dura el año ya que no podemos dar el mismo valor a una póliza que lleva todo el periodo que una póliza que lleva pocos meses. La exposición pondera el tiempo que un riesgo nos puede provocar un siniestro. De hecho, el número de siniestros dividido por el tiempo supone la frecuencia siniestral. La exposición nunca podrá se negativa o 0 por definición. En nuestro caso la media por expuesto al riesgo es:

```r
sum(norautoClaimAmount)/sum(norautoExpo)
```


Con 1941.63 a cada uno de los riesgos tendríamos cubierta la siniestralidad. Sin embargo, un jefe al que aprecié mucho decía «esto es café para todos, hay que alejarse del café para todos» y siempre podía una diapositiva con unas tazas de café muy feas [lo mismo lees esto, un saludo]. Sin embargo, basta con sumarizar por un factor de riesgo, tendríamos distintas medias por unidad de exposición.

```r
norauto %>% group_by(GeoRegion) %>% summarise(media = sum(ClaimAmount)/sum(Expo))
```


A todos no les gusta el café. Estaríamos cobrando mucho a los buenos y cobrando poco a los malos y esto en el mundo del cálculo actuarial de primas se conoce como **antiselección**. Vamos a repartir esa siniestralidad en función de lo que pasó en años anteriores y que esperamos que pase en el siguiente y esto lo vamos a hacer con modelos tweedie. Pero un paso inicial que sugiero es descrestar los siniestros para que no tengan un importe disparatado y su distribución sea más sencilla de modelar:

```r
ggplot(norauto, aes(ClaimAmount)) + geom_density()
summary(filter(norauto,ClaimAmount>0)ClaimAmount)
norautoClaimAmount2 <- ifelse(norautoClaimAmount>50000, 50000, norautoClaimAmount)

factor_elevacion = sum(norautoClaimAmount)/sum(norautoClaimAmount2)

norautoClaimAmount2 = norautoClaimAmount2 * factor_elevacion

ggplot(norauto, aes(ClaimAmount2)) + geom_density()
sum(norautoClaimAmount) - sum(norautoClaimAmount2)
```


Estas líneas de código dan para una entrada, quedaos con la idea de acotar la siniestralidad en 50000 unidades monetarias y repartir el exceso entre el resto de siniestros para no perder dinero. Como véis, el segundo gráfico tiene una forma muy similar a una distribución gamma. No nos hemos parado con los factores de riesgo disponibles en la tabla, asumimos que vienen trabajados previamente y por ello estamos en disposición de realizar nuestro modelo tweedie.

```r
norautolog_exposure <- log(norautoExpo)
norauto2 <- sample_frac(norauto,0.1)

predictoras <- c('Male','Young','DistLimit','GeoRegion')
respuesta <- "ClaimAmount2"
offset_var <- "log_exposure"
```


**Importante** el modelo es aditivo, la ponderación no se lleva a cabo por la exposición, se lleva a cabo por el logaritmo. Unos entendéis esto y otros pensáis «ya nos está liando Vaquerizo», es por la definición matemática del modelo. Por otro lado, trabajo con una fracción del conjunto de datos para que el proceso tarde menos. Y por último, **siempre que trabajemos con modelos tenemos que definir los roles de las variables**. Siento ser tan axiomático. Como predictoras están nuestros factores de riesgo, como offset o variable de ponderación tenemos el logaritmo de la exposición y por último un nuevo motivo para desconfiar en esta entrada del blog, **YO PREFIERO MODELAR EL IMPORTE SINIESTRAL DESCRESTADO A MODELAR LA PRIMA PURA** el motivo es claro, la experiencia me ha demostrado que se obtienen mejores modelos. Podemos debatirlo.

Ya tenemos los datos y todas las variables preparadas, como norma habitual/sugerencia el trabajo con datos lo haremos con R y emplearemos H2O solo para la modelización, no es que no se pueda hacer, es que a la hora de productivizar modelos parece funcionar mejor. Empezamos nuestro trabajo con H2O:

```r
library(h2o)
h2o.init()
#h2o.shutdown()

norauto.hex <- as.h2o(norauto2)

auto.splits <- h2o.splitFrame(data = norauto.hex, ratios = .6)
train <- auto.splits[[1]]
valid <- auto.splits[[2]]
```


Lo primero iniciar cluster y crear el objeto H2O con el que trabajaremos, exactamente el mismo que teníamos en R y que conseguimos con as.h2o; creamos el conjunto de datos de entrenamiento y el conjunto de datos de validación con auto.splits y ya podemos acceder a los objetos. Cuando realizamos modelos tweedie el primer paso siempre será identificar el parámetro «variance power» que nos ofrece una forma de la distribución que tiene, [de nuevo me remito a una entrada anterior](https://analisisydecision.es/la-distribucion-tweedie/).

```r
parametro_tweedie <- list( tweedie_variance_power = c(1.5,1.6,1.7,1.8,1.9,2,2.2,2.5))

grid <- h2o.grid(seed=10,
                 x = predictoras, y = respuesta, training_frame = train, validation_frame = valid,
                 family = 'tweedie', algorithm = "glm", grid_id = "auto_grid",
                 hyper_params = parametro_tweedie,
                 search_criteria = list(strategy = "Cartesian"))

busqueda_ordenada <- h2o.getGrid("auto_grid", sort_by = "mse", decreasing = FALSE)
busqueda_ordenada
```


En este caso se sugiere una lista de posibles parámetros, podemos pasar una secuencia. Con h2o.grid realizamos esa búsqueda especificando que es un modelo tweedie, para buscar siempre empleamos GLM y el search_criteria no me he atrevido nunca a tocarle. En este ejemplo he obtenido un variance power de 1.9 tengo un proceso de búsqueda fina de parámetros que os sugiero desarrolléis. Ahora estamos en disposición de realizar un modelo tweedie para repartir la siniestralidad de nuestra cartera y como bonus track vamos a realizar un GBM, un gradient boosting machine, con un modelo tweedie. Y para ello lo primero son los parámetros para la grid search.

```r
vp = 1.9

ntrees_opts = c(500)
max_depth_opts = seq(5,7)
min_rows_opts = c(50,100)
learn_rate_opts = c(0.01)
sample_rate_opts = seq(0.5,0.75)
col_sample_rate_opts = seq(0.5,0.8)
col_sample_rate_per_tree_opts = seq(0.5,1)
nbins_cats_opts = seq(100,500)

hyper_params = list( ntrees = ntrees_opts,
                     max_depth = max_depth_opts,
                     min_rows = min_rows_opts,
                     learn_rate = learn_rate_opts,
                     sample_rate = sample_rate_opts,
                     col_sample_rate = col_sample_rate_opts,
                     col_sample_rate_per_tree = col_sample_rate_per_tree_opts,
                     nbins_cats = nbins_cats_opts)

search_criteria = list(strategy = "RandomDiscrete",
                       max_runtime_secs = 600,
                       max_models = 100,
                       stopping_metric = "AUTO",
                       stopping_tolerance = 0.00001,
                       stopping_rounds = 5,
                       seed = 123456)
```


Buscad en la ayuda de H2O para conocer su funcionamiento y tened en cuenta que un gran número de parámetros ralentiza mucho la ejecución os traigo estos y podéis modularlo a voluntad. Un comentario, hace un par de años me diseñé una grid search para los gbm y no lo he vuelto a tocar, tampoco suelo tocar el nombre de los conjuntos de datos ni de las variables por eso insisto en que fijéis y sigáis una forma de trabajar como esta que os enseño o como os sintáis más cómodos pero si la desarrolláis seréis más productivos y emplearéis más tiempo en el análisis que en la programación. Por ultimo realizamos el modelo.

```r
gbm_grid <- h2o.grid("gbm",
                     grid_id = "mygrid",
                     x = predictoras,
                     y = respuesta,
                     tweedie_power=vp,
                     offset_column=offset_var,
                     training_frame = train,
                     validation_frame = valid,
                     nfolds = 0,
                     distribution="tweedie",
                     stopping_rounds = 2,
                     stopping_tolerance = 1e-3,
                     stopping_metric = "MSE",
                     score_tree_interval = 100,
                     seed = 123456,
                     hyper_params = hyper_params,
                     search_criteria = search_criteria)

sorted_grid <- h2o.getGrid(grid_id = "mygrid", sort_by = "mse")
print(sorted_grid)
modelo_final <- h2o.getModel(sorted_grid@model_ids[[1]])
```


Ya disponemos de un modelo que podemos aplicar y conocer el funcionamiento que vamos a probar en el total de datos

```r
sum(norautoClaimAmount)
sum(is.na(norautoExpo))
sum(norauto$Expo==0)
```
0

Nuestra estimación está quedando por debajo, sería necesaria una corrección. Yo soy fan de los modelos tweedie para segmentar y scorear carteras (en una siguiente entrada), los que han trabajado con Emblem me entenderán perfectamente. Como aproximación al problema es un buen método, además estáis empleando algoritmos del ecosistema de machine learning dentro del ámbito actuarial. Siempre es preferible realizar modelos de frecuencia y coste, combinarlos y obtener una prima final, si deseáis profundizar mejor podéis elegir el módulo de seguros del [Master en Big Data aplicado de la UNED](https://www.masterbigdataonline.com/index.php). Además de este análisis trabajamos modelos de riesgo con R. Saludos.

[Si deseáis ejecutar el código entero (a veces cometo errores cuando lo pongo en la entrada)](/images/2020/12/modelos_tweedie.txt)