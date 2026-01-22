---
author: rvaquerizo
categories:
  - data mining
  - formación
  - monográficos
  - r
date: '2012-03-27'
lastmod: '2025-07-13'
related:
  - en-la-regresion-logistica-el-sobremuestreo-es-lo-mismo-que-asignar-pesos-a-las-observaciones.md
  - el-sobremuestreo-mejora-mi-estimacion.md
  - que-pasa-si-uso-una-regresion-de-poisson-en-vez-de-una-regresion-logistica.md
  - trucos-sas-muestreo-con-proc-surveyselect.md
  - muestreo-de-datos-con-r.md
tags:
  - regresión logística
  - sampling
title: Sobremuestreo y pesos a las observaciones. Ahora con R
url: /blog/sobremuestreo-y-pesos-a-las-observaciones-ahora-con-r/
---

De nuevo volvemos a la entrada de ayer para replicar el código `SAS` utilizado en `R`. Se trata de realizar 3 modelos de regresión logística con `R` para estudiar como influyen en los parámetros el uso de un conjunto de datos con sobremuestreo o el uso de un conjunto de datos donde asignamos pesos a las observaciones. El programa es sencillo pero tiene un uso interesante de la librería de `R sampling`. Aquí tenéis el código:

```r
#Regresión logística perfecta

num = 100000

x = rnorm(num); y=rnorm(num)

p=1/(1+exp(-(-5.5+2.55*x-1.2*y)))

z=rbinom(num,1,p)

datos_ini=data.frame(cbind(x,y,z))

table(datos_ini$z)
```

```r
modelo.1 = glm(z~x+y,data=datos_ini,family=binomial)

summary(modelo.1)
```

El mismo modelo que planteamos con `SAS` en la anterior entrada nos permite realizar una regresión logística perfecta. Veamos como se plantea la realización del sobremuestreo con `R`:

```r
#Realizamos el sobremuestreo con la librería sampling

library( sampling )

selec <- strata( datos_ini,
stratanames = c("z"),
size = c(50000,50000), method = "srswr" )
table(selec$z)
```

```r
modelo.2 = glm(z~x+y,data=datos_ini[selec$ID_unit,],

family=binomial)

summary(modelo.2)
```

Habrá que volver sobre el tema del muestreo para analizar las posibilidades de la librería `sampling`, en este caso realizamos muestreo estratificado con la función `strata` y muestreo aleatorio con reemplazamiento. Replicamos el proceso asignando pesos:

```r
#Realizamos el proceso asignando pesos

pct=sum(datos_ini$z)/num

datos_ini$peso = ifelse(datos_ini$z==1, 0.5/pct, 0.5/(1-pct))

tapply(datos_ini$peso,datos_ini$z,sum)
```

```r
modelo.3 = glm(z~x+y,data=datos_ini,

family=binomial, weights=peso)

summary(modelo.3)
```

Y obtenemos los mismos resultados (que sorpresa). Saludos.
