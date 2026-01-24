---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2009-01-12'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-11-introduccion-al-analisis-de-la-varianza-anova.md
  - manual-curso-introduccion-de-r-capitulo-12-analisis-de-la-varianza-disenos-bifactoriales.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-al-analisis-de-la-regresion-lineal-con-r.md
  - monografico-analisis-de-factores-con-r-una-introduccion.md
  - manual-curso-introduccion-de-r-capitulo-10-funciones-graficas-en-regresion-lineal.md
tags:
  - análisis de la varianza
  - anova factores anidados
  - r
title: 'Manual. Curso introducción de R. Capítulo 13: Análisis de la varianza. Diseños anidados'
url: /blog/manual-curso-introduccion-de-r-capitulo-13-analisis-de-la-varianza-disenos-anidados/
---

Continuamos con ejemplos de `análisis de la varianza` con `R`. En este caso trabajaremos con `diseño de experimentos anidados`. Definimos un `factor B` está anidado a un `factor A` si para `nivel de B` tenemos un único `nivel de A` asociado, es decir, `A dos niveles`, `B tres niveles`; `A1` (`B1`, `B2`, `B3`) ; `A2`(`B1`, `B2`, `B3`). En este caso se dice que el `nivel B` está anidado a `A`. El `modelo matemático` viene expresado como:

![modelo.JPG](/images/2009/01/modelo.JPG)

Donde `Beta-j(i)` es el `efecto anidado` del `nivel j-ésimo` anidado sobre `i`. La `tabla ANOVA` será:

![anova_anidado.JPG](/images/2009/01/anova_anidado.JPG)

Trabajemos con un `ejemplo` las `sentencias` adecuadas para el `análisis` con `R`:

`Ejemplo 13.1`:

Se disponen de las `mediciones` realizadas por un `geólogo` del `nivel de calcio` en `cinco tipos` de `terreno`. Se recogen `muestras` del `contenido` en `calcio` en `cuatro localidades distintas` de forma que hay `cuatro localidades` por cada `tipo de terreno`. Introducimos los `datos` en `R`:

```r
options(prompt="") #modificamos el prompt
terreno<-as.factor(rep(1:5,each=16,len=80))
localidad<-as.factor(rep(1:4,each=4,len=80))
```

Para los `factores` hemos empleado la `función REP` que nos repite `valores` un `determinado número` de `veces`, muy `práctico` para crear `vectores` de `factores`. Introducimos las `mediciones` tomadas por el `geólogo` y unimos los 3 `vectores` de `datos`:

```r
calcio<-c(6 ,2 ,0 ,8 ,13 ,3 ,9 ,8 ,1 ,10 ,0 ,6 ,7 ,4 ,7 ,9 ,10 ,9 ,7 ,12 ,2 ,1 ,1 ,10 ,4 ,1 ,7 ,9 ,0 ,3 ,4 ,
1 ,0 ,0 ,5 ,5 ,10 ,11 ,6 ,7 ,8 ,5 ,0 ,7 ,7 ,2 ,5 ,4 ,11 ,0 ,6 ,4 ,5 ,10 ,8 ,3 ,0 ,8 ,6 ,5 ,1 ,8 ,9
,4 ,1 ,4 ,7 ,9 ,6 ,7 ,0 ,3 ,3 ,0 ,2 ,2 ,3 ,7 ,4 ,0)
estudio<-data.frame(cbind(terreno,localidad,calcio))
boxplot(calcio~terreno*localidad)
```

Ya disponemos de un `DATA FRAME` de `trabajo` que nos permite realizar el `estudio`. Además hemos realizado un `gráfico` para estudiar la `medición` de `calcio` en los 16 `factores` que forman `parte` del `estudio`. El `factor localidad` está anidado con el `factor terreno` ya que cada `nivel` del `factor localidad` se combina con un único `nivel` del `factor terreno`, en este `caso` el `número` de `niveles` de `localidad anidados` en cada `nivel` de `terreno` es el mismo (`b=4`). El `modelo matemático` viene expresado por `Yijk=m+ai+bj(i)+eijk` donde `bj(i)` significa que para cada `nivel i` de `terreno` tenemos `j niveles` de `localidad` (`expresión` del `anidamiento`).

La `programación` del `modelo` con `R` será:

```r
ejemplo.13.1<-aov(calcio~terreno+localidad%in%terreno) #in experesa el anidamiento
summary(ejemplo.13.1)
```

Df Sum Sq Mean Sq F value Pr(>F)

broca 1 44.65 44.65 2.4690 0.1233

taladradora 1 0.56 0.56 0.0308 0.8614

broca:taladradora 1 1.210e-27 1.210e-27 6.693e-29 1.0000

Residuals 44 795.72 18.08

A la `vista` de los `resultados` no obtenemos `diferencias significativas` para los `niveles de terreno`, el `estadístico F` toma un `valor` muy alto por lo que no se puede rechara la `hipótesis nula` de `igualdad de medias` por cada `tipo de terreno`. Por otro lado para un `valor` de 0,1 no podemos rechazar la `igualdad de medias` del `anidamiento`, es necesario realizar el `test` para cada `terreno`. Veamos las `medias`:

```r
print(model.tables(ejemplo.13.1,"means"),digits=3)
```

Tables of means

Grand mean

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

Hacemos para cada `terreno` el `análisis` del `factor anidado localidad`:

```r
estudio1<-subset(estudio,terreno==1)
estudio2<-subset(estudio,terreno==2)
estudio3<-subset(estudio,terreno==3)
estudio4<-subset(estudio,terreno==4)
estudio5<-subset(estudio,terreno==5)
summary(aov(calcio~localidad,data=estudio1))
```

Df Sum Sq Mean Sq F value Pr(>F)

localidad 1 3.613 3.613 0.2354 0.635

Residuals 14 214.825 15.345

```r
summary(aov(calcio~localidad,data=estudio2))
```

Df Sum Sq Mean Sq F value Pr(>F)

localidad 1 86.113 86.113 7.6874 0.01497 \*

Residuals 14 156.825 11.202

______________________________________________________________________

Signif. codes: 0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

```r
summary(aov(calcio~localidad,data=estudio3))
```

Df Sum Sq Mean Sq F value Pr(>F)

localidad 1 1.250 1.250 0.1051 0.7506

Residuals 14 166.500 11.893

```r
summary(aov(calcio~localidad,data=estudio4))
```

Df Sum Sq Mean Sq F value Pr(>F)

localidad 1 0.200 0.200 0.0161 0.9008

Residuals 14 173.800 12.414

```r
summary(aov(calcio~localidad,data=estudio5))
```

Df Sum Sq Mean Sq F value Pr(>F)

localidad 1 11.250 11.250 1.4253 0.2524

Residuals 14 110.500 7.893

La función `SUBSET` nos crea un `subcojnjunto` de `datos` en función de una `condición`. Hacemos 5 `susbconjuntos` y `analizamos` el `factor localidad`. Vemos que para el `terreno 2` se rechaza la `igualdad de medias` de la `localidad`.
