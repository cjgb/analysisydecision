---
author: rvaquerizo
categories:
  - formación
  - r
date: '2008-03-31'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
  - determinar-la-distribucion-de-un-vector-de-datos-con-r.md
  - trucos-sas-calcular-percentiles-como-excel-o-r.md
  - manual-curso-introduccion-de-r-capitulo-2-interfaz-y-primeras-sentencias.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
tags:
  - formación
  - r
title: 'Manual. Curso introducción de R. Capítulo 6: Funciones de estadística descriptiva'
url: /blog/manual-curso-introduccion-de-r-capitulo-6-funciones-de-estadistica-descriptiva/
---

In `R` trabajaremos con objetos y funciones. In capítulos anteriores hemos empezado a crear objetos, fundamentalmente vectores y matrices. In la presente entrega, vamos a estudiar las funciones básicas de estadística descriptiva.

Como funciones de medida de tendencia y localización, tendremos:

```r
alturas <- scan() # creamos el objeto alturas con 11 observaciones
```

```
1: 1.75 1.67 1.89 1.78 1.54 1.90 1.87
8: 1.67 1.76 1.75 1.90
12:
Read 11 items
```

```r
mean(alturas)
```

```
1.770909
```

```r
median(alturas)
```

```
1.76
```

```r
min(alturas)
```

```
1.54
```

```r
max(alturas)
```

```
1.9
```

```r
quantile(alturas) # cuartiles
```

```
 0%   25%   50%   75%  100%
1.54 1.71 1.76 1.88 1.90
```

```r
# rango intercuartílico
IQR(alturas)
```

```
0.17
```

Como funciones de medida de dispersión, tenemos:

```r
# cuasivarianza
var(alturas)
```

```
0.01320909
```

```r
# desviación estándar
sd(alturas)
```

```
0.1149308
```

Si deseamos la varianza, hemos de crear in `R` una función que nos calcule $\frac{n-1}{n} \cdot \text{cuasivarianza}$:

```r
# creamos la función varianza
varianza <- function(x) { 
  ((length(x) - 1) / length(x)) * var(x) 
}

varianza(alturas)
```

```
0.01200826
```

Para crear funciones in `R`, empleamos `function(<parametro1>, ..., <parametroN>)` y, para llamarla, hacemos lo mismo que hacemos con las funciones habituales. Esta es la forma de programar con `R`. Del mismo modo, si deseamos medir el coeficiente de curtosis (momento de orden 4) para medir la asimetría, hemos de crear la función:

```r
kurtosis <- function(x) {
  m4 <- mean((x - mean(x))^4)
  kurt <- m4 / (sd(x)^4) - 3
  return(kurt)
}

kurtosis(alturas)
```

```
-0.9660813
```

Con todo lo visto anteriormente, podemos crear una función que nos haga un pequeño análisis descriptivo de un vector:

```r
descriptivos <- function(x) {
  desc <- c(mean(x), varianza(x), min(x), max(x), quantile(x), kurtosis(x))
  nom <- c("Media", "Varianza", "Mínimo", "Máximo", 
           "Cuantil 0", "Cuantil 25", "Cuantil 50", "Cuantil 75", "Cuantil 100", 
           "Kurtosis")
  names(desc) <- nom
  return(desc)
}

descriptivos(alturas)
```

```
      Media    Varianza      Mínimo      Máximo   Cuantil 0  Cuantil 25 
 1.77090909  0.01200826  1.54000000  1.90000000  1.54000000  1.71000000 
 Cuantil 50  Cuantil 75 Cuantil 100    Kurtosis 
 1.76000000  1.88000000  1.90000000 -0.96608127 
```

Creamos la función `descriptivos` que recibirá un parámetro vector. Obtenemos algunas medidas descriptivas que almacenamos in otro vector y asignamos los nombres de los valores con la función `names()`; por último, simplemente vemos el vector.

Comenzamos a familiarizarnos con el uso de vectores y funciones in `R`. In la siguiente entrega, empezaremos a crear estructuras de datos más complejas y realizaremos operaciones con vectores para tomar contacto con los operadores matemáticos y lógicos. Por supuesto, si tenéis alguna duda o sugerencia, estoy in `rvaquerizo@analisisydecision.es`. Saludos.
