---
author: cgbellosta
categories:
- formación
- r
- trucos
date: '2009-06-04'
lastmod: '2025-07-13'
related:
- trucos-sas-muestreo-con-proc-surveyselect.md
- sobremuestreo-y-pesos-a-las-observaciones-ahora-con-r.md
- trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento.md
- introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-12-muestreo-e-inferencia-estadistica.md
- truco-sas-categorizar-variables-continuas.md
tags:
- sin etiqueta
title: Muestreo de datos con R
url: /blog/muestreo-de-datos-con-r/
---
Recientemente, hubo una entrada en este blog sobre [cómo realizar muestreos aleatorios en tablas SAS](https://analisisydecision.es/trucos-sas-muestras-aleatorias-con-y-sin-reemplazamiento/). En ésta vamos a ver cómo se procedería con R.

Consideraremos el conjunto de datos `iris` —de dimensión 150 x 5— y extraeremos 60 filas con distintos procedimientos.

Para el **muestreo aleatorio simple sin repetición** , basta con hacer:

```r
indices <- sample( 1:nrow( iris ), 60 )

iris.muestreado <- iris[ indices, ]
```

Para relizar un **muestreo aleatorio simple con repetición** , basta con sustituir la variable `indices` anterior por

```r
indices <- sample( 1:nrow( iris ), 60, replace = TRUE )
```

No es complicado realizar **muestreos estratificados con o sin reemplazamiento**. La manera más sencilla de obtenerlos consiste en usar el paquete `sampling`.

El muestreo sin reemplazamiento y estratificado respecto a `iris$Species` —que es un factor con tres niveles de 50 elementos cada uno— puede llevarse a cabo así:

```r
library( sampling )

estratos <- strata( iris, stratanames = c("Species"), size = c(20,20,20), method = "srswor" )

iris.muestreado <- getdata( iris, estratos )
```

Para obtener un muestreo con reemplazamiento se sustituye el método `srswor` por el `srswr`.

El interesado en utilizar técnicas de muestreo estratificado más sofisticadas no tiene sino que consultar la ayuda y ejemplos de la función `strata`.