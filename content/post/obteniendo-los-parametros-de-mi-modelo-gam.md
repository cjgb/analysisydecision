---
author: rvaquerizo
categories:
- Formación
- Machine Learning
- Monográficos
- R
- Seguros
date: '2019-11-21T13:38:25-05:00'
slug: obteniendo-los-parametros-de-mi-modelo-gam
tags:
- GAM
title: Obteniendo los parámetros de mi modelo GAM
url: /obteniendo-los-parametros-de-mi-modelo-gam/
---

[Vimos como los modelos GAM iban más allá del GLM](https://analisisydecision.es/modelos-gam-dejando-satisfechos-a-los-equipos-de-negocio/) porque en el momento de obtener los parámetros asociados al modelo de un factor nos proponían, en vez de una función lineal una función de suavizado no paramétrica para aquellos factores susceptibles de transformar en variables numéricas ordinales con un sentido determinado. Se trabajó con un modelo de riesgo con una sola variable como era la edad y al sumarizar el modelo no era posible obtener los parámetros en la salida. En último término nuestra intención con este tipo de modelos es obtener esos parámetros para transformarlos en relatividades. Qué sentido tiene obtener un buen modelo para Negocio si su resultado no se puede expresar en términos de incrementos o descuentos, en términos de relatividades. 

La entrada del blog que ahora os propongo nos permite extraer los parámetros de cualquier modelo GLM o GAM a partir de la función **predict** y una de las opciones más olvidadas por todos nosotros: 

```r
predict(modelo, newdata = datos,  type = "terms")
```
 

con type = «terms» lo que obtenemos en el momento de realizar la predicción son los parámetros del modelo que aplicamos, no es el resultado de la predicción.

## Obteniendo las relatividades de nuestro modelo GAM

Partimos del ejemplo que estamos manejando en la serie de entradas:

```r
library(dplyr)

varib <- c(edad = 2L, sexo = 1L, zona = 1L, clase_moto = 1L, antveh = 2L,
           bonus = 1L, exposicion = 8L, nsin = 4L, impsin = 8L)

varib.classes <- c("integer", rep("factor", 3), "integer",
                   "factor", "numeric", rep("integer", 2))

con <- url("https://staff.math.su.se/esbj/GLMbook/mccase.txt")
moto <- read.fwf(con, widths = varib, header = FALSE,
                 col.names = names(varib),
                 colClasses = varib.classes,
                 na.strings = NULL, comment.char = "")

library(mgcv)

moto$edad_numero <- as.numeric(moto$edad)

gam.1 <- gam(nsin ~ s(edad_numero,bs="cr",k=3) + zona, data=filter(moto,exposicion>0),
             offset = log(exposicion), family = poisson(link='log'))
summary(gam.1)
```
 

Ejecutad este código y obtendréis un modelo GAM con la zona por la que circula el riesgo y una función de suavizado de la edad del asegurado. A la hora de sumarizar el modelo para la edad, la variable suavizada, no vemos parámetros solo una función, si queremos obtener parámetros solo aparece la zona, ¿cómo puedo obtener las relatividades que me arroja este modelo? Empleando predict como se indicó con anterioridad:

```r
terminos <- data.frame(exp(predict(gam.1, newdata = moto, type = "terms")))
names(terminos) <- c("rela_zona","rela_edad")
terminos <- cbind.data.frame(terminos,select(moto,zona,edad))
```
 

Se crea el data.frame terminos que tiene el exponencial del parámetro asociado a ese registro para los factores participantes en el modelo. Cabe señalar que predict no respeta el orden de las variables en el modelo, primero pone las variables que no están suavizadas y después las suavizadas. Después de obtener los parámetros registro a registro lo que hacemos es añadir al data frame los factores de los que deseamos obtener las relatividades y como os podéis imaginar la tabla de relatividades finalmente es el resultado de seleccionar los distintos elementos:

```r
rela_zona <- distinct(select(terminos,zona,rela_zona))
rela_edad <- distinct(select(terminos,edad,rela_edad))
```
 

[![](/images/2019/11/parametros_GAM.png)](/images/2019/11/parametros_GAM.png)

Ya sabéis, no subestiméis a predict...