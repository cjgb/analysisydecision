---
author: rvaquerizo
categories:
  - monográficos
  - r
date: '2019-09-18'
lastmod: '2025-07-13'
related:
  - trucos-r-graficos-de-velocimetro-con-r.md
  - representar-poligonos-de-voronoi-dentro-de-un-poligono.md
  - graficos-dinamicos-en-r-con-la-funcion-text.md
  - descubriendo-ggplot2-421.md
  - manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
tags:
  - learngeom
title: Geometría básica con R. Triángulos, circunferencias, estrellas, distancias, ángulos,…
url: /blog/geometria-basica-con-r-triangulos-circunferencias-estrellas-distancias-angulos/
---

Trabajar con triángulos y `R` es bien sencillo con el paquete `learnGeom`. La entrada viene a cuento por una duda en [lista de correo de ayuda en R](https://stat.ethz.ch/mailman/listinfo/r-help-es) que no pude ayudar a resolver por no disponer de un equipo informático en ese momento. Es un paquete que nos permite visualizar los aspectos básicos de la geometría que todos tenemos olvidada. Un ejemplo de uso sería:

```r
#install.packages("LearnGeom")
library(LearnGeom)

x_min <- 0; x_max <- 100
y_min <- 0; y_max <- 100

CoordinatePlane(x_min, x_max, y_min, y_max)

A <-c(50,50)
B <- c(70,70)
C <- c(70,50)

triangulo <- CreatePolygon(A, B, C)
Draw(triangulo, "grey")
PolygonAngles(triangulo)
```

Fijamos un plano, en este caso de `0` a `100` en ambos ejes y sobre ese plano pintamos un polígono indicando los vértices y como resultado obtenemos un triángulo rectángulo, podemos ver los ángulos que forman los vértices también y hay otras funciones interesantes como distancias entre puntos que nos sirven para recordar a Pitágoras;

```r
DistancePoints(A,B)
sqrt(20^2+20^2)
```

Llegué a este paquete por lo sencillo que resultaba obtener los ángulos entre los puntos y poderlos graficar:

```r
angle <- Angle(A, B, C, label = TRUE)
angle <- Angle(A, C, B, label = TRUE)
angle <- Angle(B, A, C, label = TRUE)
```

![Geometría con R 1](/images/2019/09/geometria-con-R-1.png)

Trazar circunferencias con dirección es otra de las posibilidades con las que estoy trabajando:

```r
CoordinatePlane(x_min, x_max, y_min, y_max)
Draw(triangulo, "transparent")
direction <- "anticlock"
inicio = 0
fin = 45
Arc2 <- CreateArcAngles(A, 20, inicio, fin, direction)
Draw(Arc2, "red")
```

![Geometría con R 2](/images/2019/09/geometria-con-R-2.png)

Por algún motivo que desconozco mi cabeza sólo puede trabajar con la dirección `anticlock` a las agujas del reloj, es curioso. Por último, por si alguien tiene que hacer ese tipo de estructuras geométricas podemos trazar estrellas con `R` fijando el inicio y el ángulo de rotación:

```r
CoordinatePlane(x_min, x_max, y_min, y_max)
Star(A, 180, 10, color= "blue")
```

![Geometría con R 3](/images/2019/09/geometria-con-R-3.png)

Esta función te lleva a [otra más interesante (Scissor)](https://github.com/cran/LearnGeom/blob/master/R/Scissor.R). Ya sabéis `learnGeom` un paquete de `R` para trabajar aspectos básicos (o no tan básicos) de la geometría. Yo esto intentando hacer un proceso que haga la vuelta perfecta para todos los circuitos automovilísticos del mundo con `R`. Seguramente abandone el proyecto, pero siempre es bueno compartir algún conocimiento adquirido.
