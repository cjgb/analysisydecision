---
author: rvaquerizo
categories:
  - formación
  - modelos
  - monográficos
  - r
date: '2010-02-11'
lastmod: '2025-07-13'
related:
  - monografico-regresion-logistica-con-r.md
  - manual-curso-introduccion-de-r-capitulo-13-analisis-de-la-varianza-disenos-anidados.md
  - manual-curso-introduccion-de-r-capitulo-11-introduccion-al-analisis-de-la-varianza-anova.md
  - manual-curso-introduccion-de-r-capitulo-14-introduccion-al-calculo-matricial-con-analisis-de-componentes-principales.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-7-descripcion-grafica-de-variables.md
tags:
  - formación
  - modelos
  - monográficos
  - r
title: Monográfico. Análisis de Factores con R (una introducción)
url: /blog/monografico-analisis-de-factores-con-r-una-introduccion/
---

El análisis de factores es una técnica de reducción de datos: menor dimensión mayor portentaje de varianza. Distinguimos el análisis factorial exploratorio del análisis factorial confirmatorio en función del conocimiento del número de factores a obtener. Este análisis está muy relacionado con el análisis de componentes principales pero no buscamos explicar el mayor porcentaje de varianza a partir de combinaciones lineales de variables, buscamos conjuntos de variables comunes entre si. Este análisis supone que hay un factor intrínseco a las variables a combinar. El proceso a seguir para este tipo de análisis sería:

1\. Estudio de la matriz de correlaciones
2\. Análisis factorial y representación de los factores
3\. Factores por individuo

En [este enlace](http://www.psico.uniovi.es/Dpto_Psicologia/metodos/tutor.1/indice.html) tenemos una detallada descripción de esta metodología.

Para nuestro ejemplo vamos a trabajar con el mismo objeto de R [sociodemo.RData](/images/2010/01/sociodemo.RData "sociodemo.RData") que empleamos para el monográfico de introducción a la regresión logística. En este objeto disponemos de las tasas de paro desde 1996 a 2008, las tasas por edad y las tasas por sexo y la intención es reducir estás 16 variables a un subconjunto de factores lo menor posible que contengan la mayor variabilidad de los datos. Para facilitar el trabajo vamos a crear un objeto con las variables a estudiar:

```r
lista=names(datos)

lista=subset(names(datos),substr(lista,1,4)=="paro"

| lista=="municipio" )

#Seleccionamos sólo paro y municipio

datos.1=subset(datos,select=lista)

summary(datos.1)
```

Os planteo una metodología muy sencilla para crear listas de variables con R y con esta lista ya tenemos un _data.frame_ de partida para realizar nuestro estudio. Ahora tenemos que seguir los pasos antes indicados:

1\. Estudio de la matriz de correlaciones:

```r
cor(datos.1[,-1])

#Tenemos problemas con NAs

haz.cero.na=function(x){

ifelse(is.na(x),0,x)}

#Esta función hace 0 los NA

datos.1=data.frame(sapply(datos.1,haz.cero.na))

cor(datos.1[,-1])
```

Es evidente que tenemos un problema con valores _NA_. Los hemos resuelto con la función _haz.cero.na_ (apuntadla) que nos transforma valores perdidos a 0. No es muy riguroso, de acuerdo, pero es una solución rápida y que no debe influir mucho en nuestro estudio. Vemos que los datos están altamente correlados (como era evidente) por lo que se espera que en pocos factores recojamos una buena cantidad de varianza.

2\. Análisis factorial y representación de los factores:

```r
library(stats)

analisis=factanal(datos.1[,-1],factors=6,rotation="none")

print(analisis, digits=2, cutoff=.2, sort=FALSE)
```

Empleamos la función _factanal_ de la librería _stats_ , esta función nos ofrece el análisis de factores por máxima verosimilitud. A la vista de los datos parece evidente que dos factores pueden ser suficientes porque contendrían en torno al 80% de la varianza. Replicamos el análisis para estudiar como se comporta con esos 2 factores:

```r
analisis=factanal(datos.1[,-1],factors=2,rotation="none")

print(analisis, digits=2, cutoff=.2, sort=FALSE)
```

Efectivamente con dos factores ya superamos el 80% de la variabilidad. Los factores vienen dados por una matriz de cargas que en este caso es la que nos ofrece la salida de R:

```r
Factor1 Factor2

paro2008 0.96 -0.26

paro2007 0.95

paro2006 0.95

paro2005 0.93

paro2004 0.90 0.22

paro2003 0.89 0.29

paro2002 0.88 0.36

paro2001 0.86 0.42

paro2000 0.85 0.44

paro1999 0.84 0.43

paro1998 0.82 0.42

paro1997 0.77 0.41

paro1996 0.68 0.35

paro.hombres 0.75 -0.30

paro.mujeres 0.93

paro.16.24 0.67 -0.26

paro.25.49 0.92 -0.26

paro.50 0.83
```

Para comprender mejor como se crean es interesante resalizar una aproximación gráfica a su comportamiento:

```r
#Objeto con matriz de cargas

cargas=analisis$loadings

#Graficamos las cargas

plot(cargas, type="p",col="red",lwd=8)

text(cargas,labels=subset(lista,substr(lista,1,4)=="paro"),

pos=1)
```

El paro en los últimos 3 años se asocia mucho mejor con mujeres y con edades comprendidas entre los 24 y 49 años, se ceba en mujeres y jóvenes. Para los hombres ha tenido un comportamiento más lineal, pero, al igual que la tasa de paro de los más jóvenes busca al paro en 2008 en el segundo factor del análisis. Para mejorar nuestro análisis puede proceder realizar una rotación de los factores:

```r
analisis=factanal(datos.1[,-1],factors=2,rotation="varimax")

print(analisis, digits=2, cutoff=.2, sort=FALSE)

cargas=analisis$loadings

plot(cargas, type="p",col="red",lwd=8)

text(cargas,labels=subset(lista,substr(lista,1,4)=="paro"),

pos=1)
```

La rotación no nos ha aportado una mayor variabilidad en los factores, sin embargo parece que mejora la capacidad de explicación de los factores. Ahora hemos de terminar nuestro análisis.

3\. Factores por individuo:

```r
analisis=factanal(datos.1[,-1],factors=2,

rotation="varimax",scores="regression")

nrow(analisis$scores)
```

Con la opción scores (que por defecto está a none) le indicamos a la función que se creen las puntuaciones de cada factor. Ahora sólo tenemos que añadir estas puntuaciones al conjunto de datos de partida:

```r
datos.1=cbind(datos.1,analisisscores)

summary(analisisscores)
```

Nuestro data.frame tiene dos nuevas variables que «reducen» las anteriores y podemos emplear en nuestros modelos. ¡Seguimos divulgando R, saludos!
