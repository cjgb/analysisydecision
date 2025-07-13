---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2015-12-20T12:48:34-05:00'
slug: creacion-de-ranking-con-r
tags:
- plyr
title: Creacion de ranking con R
url: /creacion-de-ranking-con-r/
---

[![Captura de pantalla 2015-12-20 a las 18.23.04](/images/2015/12/Captura-de-pantalla-2015-12-20-a-las-18.23.04.png)](/images/2015/12/Captura-de-pantalla-2015-12-20-a-las-18.23.04.png)

Hasta la fecha si necesitaba crear un ranking o un orden con R realizaba la tarea del siguiente modo:

_nombres <-c(«grupo_1″,»grupo_2»)_  
_grupo <-sample( nombres, 10, replace=TRUE, prob=c( 0.5, 0.5) )_  
_dataset <\- data.frame(grupo)_  
_dataset$importes <\- runif(10,100,30000)_

_#Creación del ranking de las variables agrupadas_  
_dataset ranking = ave(datasetimportes,dataset$grupo,_  
_FUN= function(x) rank(x, ties.method = «first»))_

Es una agrupación de factores a la que asignamos el orden con rank, con ties.method=»first» esta agrupación se lleva a cabo desde el primer nivel del factor. El resultado se puede comprobar haciendo:

_library(reshape)_  
_dataset <-sort_df(dataset,vars=c(‘grupo’,’importes’))_

Otra solución posible la tenemos con plyr:

_library(plyr)_  
_dataset <\- ddply(dataset,.(grupo), transform, ranking2 = (seq_along(importes)))_

Si nuestra agrupación tiene más de una variable podemos hacer:

_dataset$grupo2 <\- rpois(10,1)_  
_dataset <\- ddply(dataset,.(grupo,grupo2), transform, ranking3 = (seq_along(importes)))_

Imagino que en alguna ocasión os habéis encontrado con este problema, pues ya conocéis dos formas de solucionarlo. Saludos.