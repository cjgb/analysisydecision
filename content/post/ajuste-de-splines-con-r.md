---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
  - seguros
date: '2017-01-26'
lastmod: '2025-07-13'
related:
  - resolucion-del-juego-de-modelos-con-r.md
  - modelos-gam-dejando-satisfechos-a-los-equipos-de-negocio.md
  - manual-curso-introduccion-de-r-capitulo-10-funciones-graficas-en-regresion-lineal.md
  - primeros-pasos-con-regresion-no-lineal-nls-con-r.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
tags:
  - spline
title: Ajuste de `splines` con `R`
url: /blog/ajuste-de-splines-con-r/
---

![spline_R1](/images/2017/01/spline_R1.png)

El ajuste por `polinomios`,[ el `ajuste` por `spline`](https://es.wikipedia.org/wiki/Spline), es una `técnica imprescindible` dentro de `análisis actuarial`. Como siempre la `parte matemática` y la `parte` debida al `puro azar` pueden `arrojar discrepancias`. ¿Dónde son `mayores` estas `discrepancias` cuando usamos `métodos estadísticos clásicos`? Donde siempre, donde tenemos `pocos datos`, el `comportamiento errático` que tiene una `tendencia` y que `habitualmente` `achacamos` a la `falta` de `información` los `actuarios` gustan de `corregirlo` con `ajuste` por `cúbicas`, aunque es `mejor emplear ajuste` por `polinomios` ya que no tienen que ser `necesariamente` `polinomios` de `grado 3`. En mi `caso particular` tengo un `Excel` que no puedo poner a vuestra `disposición` porque no lo hice yo, creo que lo hizo alguna `divinidad egipcia` y desde entonces `circula` por el `mundo` la `función cubic_spline`. Hoy quiero `aprovechar` el blog no solo para `sugeriros` como realizar `splines` con `R`, además quería `pedir ayuda` para crear una `herramienta` en `shiny` que permita realizar este `ajuste` que voy a mostraros a `continuación`.

Disponemos de una `serie de datos`, `probablemente` una `serie de parámetros` de un `modelo`, que tiene `tendencia`. Deseamos `ajustar` un `polinomio` que `recoja` esa `tendencia` y que `evite` por `interpolación` los `comportamientos erráticos` que tienen algunos `puntos` de la `serie`. El `código` de `R` es

:

```r
puntos <- c(2.1017	, 1.4464,1.4951,1.4068,1.3682,1.2061,1.1787,1.1191,1.0766,
1.0274,1.0077,0.9911,0.9525,0.8762,0.9327,0.8982,0.8896,0.8905,0.9036,
0.8791,0.8807,0.9061,0.8941,0.9064,0.9022,0.8821,0.8806,0.9252,0.9311,
0.9012,0.9457,0.9095,0.9389,0.9047,0.8975,0.9431,0.9236,0.9143,0.9294,
0.8885,0.9417,0.9189,0.9510,0.8897,0.8780,0.8484,0.8823,1.0000)

pesos <- c(0.01,0.01,0.01,1,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01,
0.01,0.01,0.01,0.01,0.01,0.01,0.01,0.01)

par(mfrow = c(1, 1))
plot(puntos)
suavizado.datos <- smooth.spline(puntos,w=pesos,spar=0.45)
lines(suavizado.datos$y,col="red")

#Es importante ver la tendendia de los residuos
plot(rep(0,nrow(datos)),col="red",type="l")
lines(residuals(suavizado.datos),col="blue")
```

![spline_R2](/images/2017/01/spline_R2.png)

`Simplificando` mucho tenemos la `serie de puntos` y mediante la `función smooth.spline` podemos `ajustar` una `spline` en `base` a unos `pesos` y en `base` a un `smothing parameter` (`spar`). Por este `motivo` quiero usar `R` en vez de mi `viejo Excel`, quiero `ponderar` el `ajuste` y `jugar` con el `parámetro` de `suavizado` que `habitualmente` toma `valores` entre `0` y `1`. En este `ejemplo` también se genera un `gráfico` de `residuos` que nos permite ver que `error cometemos` con el `ajuste`. Los `pesos` me interesan porque hago «`análisis caseros`» de este `tipo`:

```r
#En cierto modo obligamos que pase por detemirnados puntos
plot(datos)
pesos[1]=2
pesos[15]=1
pesos[48]
suavizado.datos <- smooth.spline(datos$y,w=pesos,spar=0.75)
lines(suavizado.datos$y,col="red")

plot(rep(0,nrow(datos)),col="red",type="l")
lines(residuals(suavizado.datos),col="blue")
```

![spline_R3](/images/2017/01/spline_R3.png)

Se puede `observar` que la `curva` se ha `modificado ligeramente`. El `análisis` no tiene mucho `rigor estadístico`, pero se trata de `ajustar` la `curva` a un `criterio comercial`. Y esto es lo que creo que sería `interesante` `montar` en una `aplicación shiny` que quiero `montar` y si alguien que `lee esto` `quier` `ayudarme` a `crear` ya `sabe` donde estoy. La `app` de `shiny` nos pediría los `datos` a `suavizar` y `pintaría` un `gráfico`. También `considero importante` `poner` los `pesos` para «`forzar` en `cierto modo`» que la `curva` pase por los `puntos` que a mi me `interese` y por último poder `seleccionar` el `parámetro` de `suavizado`, esas son las `palancas` que tendría que `mover` para poder crear la `spline` y por último sería necesario obtener los `parámetros resultantes`. A ver si puedo `montarlo` y `subirlo` para poder realizar este `tipo` de `ajustes` sin `necesidad` de mi `viejo Excel`.
