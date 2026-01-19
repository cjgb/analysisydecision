---
author: rvaquerizo
categories:
- formación
- modelos
- r
date: '2008-10-04'
lastmod: '2025-07-13'
related:
- manual-curso-introduccion-de-r-capitulo-11-introduccion-al-analisis-de-la-varianza-anova.md
- manual-curso-introduccion-de-r-capitulo-13-analisis-de-la-varianza-disenos-anidados.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
- manual-curso-introduccion-de-r-capitulo-10-funciones-graficas-en-regresion-lineal.md
- monografico-analisis-de-factores-con-r-una-introduccion.md
tags:
- anova
- diseño bifactorial
- modelos
title: 'Manual. Curso introducción de R. Capítulo 12: Análisis de la varianza. Diseños
  bifactoriales'
url: /blog/manual-curso-introduccion-de-r-capitulo-12-analisis-de-la-varianza-disenos-bifactoriales/
---
En esta nueva entrega del manual de R vamos a ver un modelo ANOVA que analiza dos fuentes de variación. Si recordamos en el capítulo 11 estudiamos la diferencia entre los tratamientos que seguían determinados pacientes teníamos una variable respuesta en función de una variable factor, el diseño factorial aleatorizado. En este caso vamos a tener la variable respuesta en función de dos factores y podrá existir una interacción entre ambos. Con lo que la tabla ANOVA será del siguiente modo:

![Figura 12.1](/images/2008/10/c121.JPG)

Con ello el modelo matemático sería: Y_ij = media + media_i + media_j + media_ij + e_ij. Con las hipótesis de suma de los coeficientes asociados igual a 0 y distribución normal del error. Trabajemos con un ejemplo para conocer las sentencias de R:

Ejemplo 12.1:

Se pretende medir la eficacia de 4 tipos de taladradoras junto con 3 tipos de brocas. Se realiza una prueba de penetración en una determinada superficie (la misma para todas) se miden los resultados obteniéndose:

![Figura 12.2](/images/2008/10/c122.JPG)

Nuestro experimento tiene como variable respuesta la capacidad de penetración y en él intervienen 2 factores: la taladradora empleada y la broca. Así pues tenemos un modelo bifactorial de efectos fijos. El modelo matemático es: y_ij = media + media_i + media_j + media_ij +error_ij i en (1,2,3,4) y j en (1,2,3). Donde y_ij es el valor de la variable respuesta para la taladradora i con la broca j, media es la media global, media_i es la media para la taladradora i-ésima, media_j es la media para la taladradora j-ésima, media_ij es la media de la interacción entre los factores y el error_ij es el error. Las condiciones son que la suma de las medias sea 0 y que el error se distribuye normalmente con media 0. Introduzcamos los datos en R:

```r
datos<-c(66.15,70.62,63,71.4,75.97,68.25,73.5,78.11,71.4,71.4,78.11,66.15,

+ 65.1,70.62,64.05,70.35,75.97,69.3,72.45,77.04,72.45,69.3,75.97,67.2,

+ 65.1,72.76,65.1,70.35,77.04,67.2,73.5,75.97,71.4,70.35,78.11,68.25,

+ 67.2,71.69,65.1,70.35,75.97,68.25,74.55,77.04,70.35,71.4,77.04,67.2) taladradora<-(rep(1:4,each=3,len=12))

taladradora<-factor(rep(1:4,each=12,len=48)) broca<-factor(rep(1:3,each=1,len=48))

$ estudio<-data.frame(cbind(datos,taladradora,broca))
```

Como siempre en el manual vamos introduciendo nuevas funciones para el trabajo con datos. La función rep crea un vector de repeticiones, en el caso de la taladradora, repeticiones de 1 a 4 repetido 3 veces y de longitud 12, es decir un vector 3*12=48 de longitud. En el caso del vector broca hacemos un vector con valores de 1 a 3 que se repiten 1 sola vez hasta 48. Al final creamos un data.frame que es el resultado de la unión de los 3 vectores de datos y factores.

El primer paso a seguir es ver si el modelo tiene que incluir la interacción entre los factores, para realizar esta comprobación emplearemos una visión gráfica de los datos. El gráfico a realizar será un gráfico con 4 líneas (una por taladradora) y cada punto del eje x representará las brocas, en el eje y tendremos el valor de penetración de cada combinación. Parra este tipo de gráficos empleamos la función interaction.plot:

```r
interaction.plot(broca,taladradora,datos) grid()
```

[![c124.jpeg](/images/2008/10/c124.thumbnail.jpeg)](/images/2008/10/c124.jpeg "c124.jpeg")

Como se puede observar en el gráfico se produce interacción ya que se hay cruces entre las mediciones de la penetración por taladradora y broca. Luego el diseño es bifactorial con interacción entre los factores. Realicemos el modelo con R:

```r
anova.12.1 <- aov(datos~broca*taladradora,data=estudio) #modelo con interacción summary(anova.12.1)

Df Sum Sq Mean Sq F value Pr(>F)

broca 1 44.65 44.65 2.4690 0.1233

taladradora 1 0.56 0.56 0.0308 0.8614

broca:taladradora 1 1.210e-27 1.210e-27 6.693e-29 1.0000

Residuals 44 795.72 18.08
```

A la vista de la tabla resultante concluimos que no existen diferencias en la capacidad de penetración de las brocas y las taladradoras participantes en el estudio. Podemos ver las medias por factor con la función PRINT:

```r
> print(model.tables(anova.12.1,"means"),digits=3)

Tables of means

Grand mean
```

71.14854

broca
broca
1 2 3
72.3 71.1 70.0

taladradora
taladradora
1 2 3 4
68.8 70.4 71.9 73.5

broca:taladradora
taladradora
broca 1 2 3 4
1 69.6 71.4 73.2 75.1
2 68.8 70.4 71.9 73.5
3 68.0 69.3 70.6 71.9
Warning messages:
1: In replications(paste("~", xx), data = mf) : non-factors ignored: broca
2: In replications(paste("~", xx), data = mf) :
non-factors ignored: taladradora
3: In replications(paste("~", xx), data = mf) :
non-factors ignored: broca, taladradora
``