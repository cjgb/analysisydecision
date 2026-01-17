---
author: rvaquerizo
categories:
- Formación
- R
date: '2008-03-31T09:25:17-05:00'
lastmod: '2025-07-13T16:01:33.319829'
related:
- manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
- determinar-la-distribucion-de-un-vector-de-datos-con-r.md
- trucos-sas-calcular-percentiles-como-excel-o-r.md
- manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
slug: manual-curso-introduccion-de-r-capitulo-6-funciones-de-estadistica-descriptiva
tags: []
title: 'Manual. Curso introducción de R. Capítulo 6: Funciones de estadística descriptiva'
url: /blog/manual-curso-introduccion-de-r-capitulo-6-funciones-de-estadistica-descriptiva/
---

En R trabajaremos con objetos y funciones. En capítulos anteriores hemos empezado a crear objetos, fundamentalmente vectores y matrices. En la presente entrega vamos a estudiar las funciones básicas de estadística descriptiva.

Como funciones de medida de tendencia y localización tendremos:



```r
> alturas<- scan() #creamos el objeto alturas con 11 observaciones

1: 1.75 1.67 1.89 1.78 1.54 1.90 1.87

8: 1.67 1.76 1.75 1.90

12:

Read 11 items

> mean(alturas)

[1] 1.770909

> median(alturas)

[1] 1.76

> min(alturas)

[1] 1.54

> max(alturas)

[1] 1.9

> quantile(alturas) #cuartiles

  0% 25% 50% 75% 100%

1.54 1.71 1.76 1.88 1.90

> IQR(alturas) #rango intercuartílico

[1] 0.17
```

Como funciones de medida de dispersión tenemos:

```r
> var(alturas) #cuasivarianza

[1] 0.01320909

> sd(alturas) #desviación estándar

[1] 0.1149308
```

Si deseamos la varianza hemos de crear en R una función que nos calcule [(n-1)/n]*cuasivarianza:

```r
> varianza<-function(x) { ((length(x)-1)/length(x))*var(x) } #creamos la función varianza

> varianza(alturas)

[1] 0.01200826

>
```

Para crear funciones en R empleamos _function( <parametro1>,…<parametroN>)_ y para llamarla hacemos lo mismo que hacemos con las funciones habituales. Esta es la forma de programar con R. Del mismo modo si deseamos medir el coeficiente de curtosis (momento de orden 4) para medir la asimetría hemos de crear la función:

```r
> kurtosis=function(x) {

+ m4=mean((x-mean(x))^4)

+ kurt=m4/(sd(x)^4)-3

+ kurt}

> kurtosis(alturas)

[1] -0.9660813
```

Con todo lo visto anteriormente podemos crear una función que nos haga un pequeño análisis descriptivo de un vector:

```r
> descriptivos<-function(x){

+ desc<-c(mean(x),varianza(x),min(x),max(x),quantile(x),kurtosis(x))

+ nom<-c("Media","Varianza","Mínimo","Máximo","Cuantil 0","Cuantil 25","Cuantil 50","Cuantil 75",

+ "Cuantil 100", "Kurtosis")

+ names(desc)<-nom

+ desc}

> descriptivos(alturas)

  Media Varianza Mínimo Máximo Cuantil 0 Cuantil 25 Cuantil 50 Cuantil 75 Cuantil 100 Kurtosis

 1.77090909 0.01200826 1.54000000 1.90000000 1.54000000 1.71000000 1.76000000 1.88000000 1.90000000 -0.96608127
```

Creamos la función _descriptivos_ que recibirá un parámetro vector. Obtenemos algunas medidas descriptivas que almacenamos en otro vector y asignamos los nombres de los valores con la función _names_ , por último simplemente vemos el vector.

Comenzamos a familiarizarnos con el uso de vectores y funciones en R. En la siguiente entrega empezaremos a crear estructuras de datos más complejas y realizaremos operaciones con vectores para tomar contacto con los operadores matemáticos y lógicos. Por supuesto, si tenéis alguna duda o sugerencia, estoy en rvaquerizo@analisisydecision.es