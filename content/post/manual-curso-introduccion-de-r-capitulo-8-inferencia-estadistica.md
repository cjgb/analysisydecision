---
author: rvaquerizo
categories:
  - formación
  - r
date: '2008-06-23'
lastmod: '2025-07-13'
related:
  - capitulo-5-representacion-basica-con-ggplot.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-10-probabilidad-y-distribuciones.md
  - manual-curso-introduccion-de-r-capitulo-11-introduccion-al-analisis-de-la-varianza-anova.md
  - manual-curso-introduccion-de-r-capitulo-13-analisis-de-la-varianza-disenos-anidados.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
tags:
  - sin etiqueta
title: 'Manual. Curso introducción de R. Capítulo 8: Inferencia estadística'
url: /blog/manual-curso-introduccion-de-r-capitulo-8-inferencia-estadistica/
---

En esta nueva entrega del curso de R vamos a trabajar con algunos conceptos básicos de inferencia estadística. En primer lugar hacemos inferencia a partir de unas observaciones obtenidas a partir de la **población** a las que vamos a extraer unas propiedades que se denominan **estadísticos muestrales**. Además vamos a conocer la distribución de dichos estadísticos (generalmente distribución normal) por lo que hacemos **inferencia paramétrica**.

La **inferencia paramétrica** puede recogerse en una vertiente o en otra según el parámetro a estimar; tenemos por un lado la estadística clásica (que es en la que nos vamos a centrar) y por otro lado la estadística ballesiana.

La **estadística paramétrica clásica** plantea tres tipos de problemas:

- Estimación puntual en la que pretendemos dar un valor al parámetro a estimar.

- Estimación por intervalos (buscamos un intervalo de confianza)

- Contrastes de hipótesis donde buscamos contrastar información acerca del parámetro.

Tenemos un experimento, lo repetimos varias veces y obtenemos una muestra con variables aleatorias independientes idénticamente distribuidas con función de distribución conocida. (Por ejemplo tenemos las alturas de 30 varones españoles y estimo que la altura media de los españoles es 1,77 estamos ante una estimación puntual). Pues cualquier función de la muestra que no dependa del parámetro a estimar es un **estadístico** y aquel estadístico que se utiliza para inferir sobre el parámetro desconocido es un **estimador**. Ejemplos de estadísticos son el total muestral, la media muestral, la varianza muestral, la cuasivarianza muestral, los estadísticos de orden,…

Conocemos los conceptos básicos para comenzar a trabajar, también sabemos que las observaciones del experimento generalmente tienen distribución normal (esto es inferencia paramétrica). Ahora bien, necesitamos determinar unas distribuciones en el muestreo que estén asociadas con la distribución normal. Estas distribuciones son la chi-cuadrado, la t de Student y la F de Snedecor.

«La **chi-cuadrado** es una suma de normales al cuadrado» más o menos se podía definir así ya que si calculamos la distribución de una variable normal al cuadrado no podemos aplicar cambio de variable y a partir de su función de distribución llegamos a una función de densidad de una gamma con parámetros 1/2 y 1/2 que es una chi-cuadrado con 1 grado de libertad. La gamma es reproductiva respecto al primer parámetro por lo que sumas de normales (0,1) nos proporcionan gammas de parámetros n/2 y 1/2 o lo que es lo mismo chi-cuadrado con n grados de libertad.

La**t de Student** se crea a partir de una normal (0,1) y una chi-cuadrado con n grados de libertad independientes. Una variable se distribuye bajo una t de Student si se puede definir como normal(0,1) dividido por la raíz cuadrada de una chi-cuadrado partida por sus grados de libertad; difícil de comprender así mejor veamos un ejemplo:

```r
Z1, Z2 ,Z3 ,Z4  variables aleatorias independientes
```

```r
idénticamente distribuidas bajo una N(0,1)
```

```r
Z1 / [(Z2+Z3+Z4)/3]^1/2   esto se distribuye según
```

```r
una t de Student de 3 grados de libertad
```

La **F de Snedecor** se crea a partir de dos chi-cuadrado independientes dividivas por sus respectivos grados de libertad, así la F de Snedecor tiene dos parámetros que indican sus grados de libertad:

```r
X se distribuye como chi-cuadrado con m grados de libertad ==>
```

```r
F=(X/m)/(Y/m) es F de snedecor con m,n grados de libertad
```

```r
Y se distribuye como chi-cuadrado   con n grados de libertad
```

Me dejo en el tintero muchos aspectos como las distribuciones de los estadísticos o los métodos de construcción de contrastes e intervalos pero me podría extender mucho, y me extenderé pero hasta aquí os cuento de momento. Aun así recomendaros una bibliografía básica por si queréis profundizar más en el tema. También estoy a expensas de poder publicar archivos LaTeX para que los aspectos matemáticos queden mejor resueltos pero de momento conformaros con los ejemplos de más abajo.

Bueno pues comencemos con R, la función que nos ofrece tanto estimaciones puntuales como intervalos de confianza como contrastes de hipótesis es:

`t.test(x, ...)`

```r
## Default S3 method:

t.test(x, y = NULL,

  alternative = c("two.sided", "less", "greater"),

  mu = 0, paired = FALSE, var.equal = FALSE,

  conf.level = 0.95, ...)
```

```r
## S3 method for class 'formula':

t.test(formula, data, subset, na.action, ...)
```

Esta es la salida que nos ofrece la ayuda de la función t.test (_>?t.test_). Podemos poner sólo un conjunto de datos para muestras unidimensionales (estimaciones puntuales) los dos conjuntos para comparación de muestras. El argumento alternative indica el tipo de contraste, bilateral two.sided, si la hipótesis alternativa es mayor (Ho: menor o igual) se utiliza greater, si la hipótesis alternativa es menor (Ho: mayor o igual) entonces se usa less.En mu indicamos el valor de la hipótesis nula.

En paired=T estamos ante una situación de datos no apareados para indicar que estamos ante datos apareados poner paired=F.

Con var.equal estamos estamos trabajando con los casos de igualdad o no de varianzas que sólo se emplean en comparación de dos poblaciones. Si var.equal=T las varianzas de las dos poblaciones son iguales si var.equal=F las varianzas de ambas poblaciones no se suponen iguales.

Por último tenemos el argumento conf.level en el que indicamos el el nivel de confianza del test.

Si deseáramos hacer el contraste para la igualdad de varianzas (cociente de varianzas=1) habríamos de emplear la función var.test:

`var.test(x, ...)`

```r
## Default S3 method:

var.test(x, y, ratio = 1,

  alternative = c("two.sided", "less", "greater"),

  conf.level = 0.95, ...)
```

```r
idénticamente distribuidas bajo una N(0,1)
```

0

Vemos que los argumentos son análogos a la función t.test. Trabajemos con algunos ejemplos

strong>Ejemplo 8.1

Con objeto de estimar la altura de los varones españoles menores de 25 años se recogió una muestra aleatoria simple de 15 individuos que cumplían ese requisito. Suponiendo que la muestra se distribuye normalmente determinar un intervalo de confianza al 95% para la media.

Tenemos una variable con distribución normal de media y desviación típica desconocidas por ello el intervalo de confianza ha de ser:

![null](https://es.geocities.com/r_vaquerizo/images/formula1.gif)

La programación en R queda:

```r
idénticamente distribuidas bajo una N(0,1)
```

1`One Sample t-test`

```r
idénticamente distribuidas bajo una N(0,1)
```

2

El intervalo de confianza es (1,717;1,809). No ha sido necesario modificar las opciones de la función; si contrastar la hipótesis nula «los españoles miden 177 cm» necesitamos la opción mu:

`> t.test(alturas,mu=1.77)`

```r
idénticamente distribuidas bajo una N(0,1)
```

3

El p-valor la probabilidad de aceptar la hipótesis nula, en este caso es 0,7602 luego no se rechaza que la altura de los españoles es de 177 cm.

**Ejemplo 8.2**

El director de una sucursal de una compañía de seguros espera que dos de sus mejores agentes consigan formalizar por término medio el mismo número de pólizas mensuales. Los datos de la tabla adjunta indican las pólizas formalizadas en los últimos cinco meses por ambos agentes.

**Agente A** | **Agente B**
---|---
12 | 14
11 | 18
18 | 18
16 | 17
13 | 16

Admitiendo que el número de pólizas contratadas mensualmente por los dos trabajadores son variables aleatorias independientes y distribuidas normalmente: ¿Tiene igual varianza? ¿Se puede aceptar la hipótesis del director de la sucursal en función de los resultados de la tabla y a un nivel de confianza del 99%?

Primero comprobamos si los datos tienen igual varianza:

```r
idénticamente distribuidas bajo una N(0,1)
```

4`F test to compare two variances`

```r
idénticamente distribuidas bajo una N(0,1)
```

5

El p-valor (0,3075) nos indica que la diferencia de las varianzas no es estadísticamente significativa. Los datos están distribuidos normalmente, además presentan igualdad de varianzas. Entonces los agentes harán el mismo número de pólizas si la diferencia de sus medias es distinta de 0. Rechararemos la igualdad de medias cuando:

![](https://es.geocities.com/r_vaquerizo/images/formula2.gif)

``` > t.test (agente_A,agente_B, paired=T, conf.level=0.99)``Paired t-test ```

```r
idénticamente distribuidas bajo una N(0,1)
```

6

El p-valor obtenido supera el 0,01% de nivel de confianza, luego se asume que ambos agentes realizan el mismo número de pólizas.
