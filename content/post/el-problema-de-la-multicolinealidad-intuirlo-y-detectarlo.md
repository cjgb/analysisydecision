---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2014-03-19'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-10-funciones-graficas-en-regresion-lineal.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
  - manual-curso-introduccion-de-r-capitulo-14-introduccion-al-calculo-matricial-con-analisis-de-componentes-principales.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-11-analisis-bivariable.md
  - regresion-pls-con-r.md
tags:
  - car
  - vif
title: El problema de la multicolinealidad, intuirlo y detectarlo
url: /blog/el-problema-de-la-multicolinealidad-intuirlo-y-detectarlo/
---

El **modelo líneal** se puede escribir de forma matricial como Y = X • Beta + Error. Donde Y es el vector con nuestra variable dependiente, X la matriz con las variables regresoras, Beta el vector de parámetros y el error esa parte aleatoria que tiene que tener todo modelo. La matriz con nuestras variables regresoras X ha de tener rango completo es decir, todas sus columnas tienen que ser linealmente independientes. Eso nos garantiza que a la hora de estimar por mínimos cuadrados ordinarios X’ X es invertible. Si no es invertible la estimación por mínimos cuadrados ordinarios “se vuelve inestable” ya que X’X =0 y 1/ X’X será muy complicado de calcular ya que los Beta son inversa(X’ X) •X’Y; por ello los resultados que arroja el modelo tienen una alta variabilidad. Cuando esto nos pasa tenemos colinealidad.

Hay varias formas de intuir si hay relación lineal entre nuestras variables independientes. La primera es analizar el coeficiente de correlación. Si tenemos variables altamente correladas es muy probable que el modelo pueda tener colinealidad entre esas variables. Otro de los síntomas se produce cuando nuestro modelo tiene un alto coeficiente de correlación y muchas variables no son significativas. En estos casos es muy probable la existencia de colinealidad.

Cuando hemos intuido que tenemos multicolinealidad pero hemos de detectarla, disponemos de tres métodos:

- **Determinante de la matriz de correlaciones**. Si hay dos variables que son linealmente dependientes el determinante de la matriz de correlaciones será muy parecido a 0. Lo ideal si no hay correlación entre las variables dependientes es una matriz de correlaciones con unos en su diagonal y valores muy próximos a 0 en el resto de valores.
- **El coeficiente entre el autovalor más grande de X’ X entre el autovalor más pequeño no nulo de X’X**. Si la raíz de esta división es superior a 10 podríamos tener multicolinealidad, si es superior a 30 hay multicolinealidad. Y esto por qué, pues porque si hay mucha diferencia entre estos autovalores esto implica una mayor inestabilidad en la matriz invertida.
- **El VIF** , el _variance inflation factor_. ¿Cuánto se me “hincha” la varianza si elimino esa variable del modelo? ¿Cuánta inestabilidad aporta a mi modelo? Yo recomiendo emplear este método. Y va a ser sobre el que vamos a trabajar.

Para ilustrar el problema vamos a trabajar con R:

```r
#install.packages("car")
library(car)
head(mtcars)
?mtcars
#Matriz de correlaciones
cor(mtcars[,-1])
```

Un clásico, el data mtcars, no hace falta presentación. Ya con la matriz de correlaciones podemos pensar que habrá problemas:

```r
cyl       disp         hp        drat         wt        qsec         vs
cyl   1.0000000  0.9020329  0.8324475 -0.69993811  0.7824958 -0.59124207 -0.8108118
disp  0.9020329  1.0000000  0.7909486 -0.71021393  0.8879799 -0.43369788 -0.7104159
hp    0.8324475  0.7909486  1.0000000 -0.44875912  0.6587479 -0.70822339 -0.7230967
drat -0.6999381 -0.7102139 -0.4487591  1.00000000 -0.7124406  0.09120476  0.4402785
wt    0.7824958  0.8879799  0.6587479 -0.71244065  1.0000000 -0.17471588 -0.5549157
qsec -0.5912421 -0.4336979 -0.7082234  0.09120476 -0.1747159  1.00000000  0.7445354
vs   -0.8108118 -0.7104159 -0.7230967  0.44027846 -0.5549157  0.74453544  1.0000000
am   -0.5226070 -0.5912270 -0.2432043  0.71271113 -0.6924953 -0.22986086  0.1683451
gear -0.4926866 -0.5555692 -0.1257043  0.69961013 -0.5832870 -0.21268223  0.2060233
carb  0.5269883  0.3949769  0.7498125 -0.09078980  0.4276059 -0.65624923 -0.5696071
              am       gear        carb
cyl  -0.52260705 -0.4926866  0.52698829
disp -0.59122704 -0.5555692  0.39497686
hp   -0.24320426 -0.1257043  0.74981247
drat  0.71271113  0.6996101 -0.09078980
wt   -0.69249526 -0.5832870  0.42760594
qsec -0.22986086 -0.2126822 -0.65624923
```

Hay mucha correlación entre algunas variables presentes en el conjunto de datos. Realizamos el modelo:

```r
modelo
```

```r
Call:
lm(formula = mpg ~ wt + hp + disp + qsec + drat + cyl + carb,
    data = mtcars)

Residuals:
    Min      1Q  Median      3Q     Max
-3.9445 -1.6098 -0.4142  1.1533  5.5584

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) 26.15955   15.06469   1.736   0.0953 .
wt          -4.28429    1.80664  -2.371   0.0261 *
hp          -0.01889    0.02050  -0.921   0.3661
disp         0.01412    0.01744   0.809   0.4264
qsec         0.42307    0.60358   0.701   0.4901
drat         1.28705    1.57651   0.816   0.4223
cyl         -0.82473    0.83245  -0.991   0.3317
carb         0.05386    0.73259   0.074   0.9420
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.61 on 24 degrees of freedom
Multiple R-squared: 0.8549,	Adjusted R-squared: 0.8125
F-statistic: 20.19 on 7 and 24 DF,  p-value: 1.284e-08
```

Un gran modelo con un R cuadrado de 0.8125 donde sólo tenemos una variable significativa si fijamos un nivel de 0.05, eso es un contrasentido. Otro síntoma claro de la existencia de multicolinealidad. Pero es necesario comprobar esta primera impresión y para ello vamos a utilizar la función _vif_ del paquete _car_ :

```r
vif(modelo)
       wt        hp      disp      qsec      drat       cyl      carb
14.224688  8.996796 21.277170  5.295516  3.234394 10.061251  6.373673
```

Es evidente que hay multicolinealidad, tenemos factores que hinflan mucho la variabilidad en nuestro modelo. ¿Fijar un valor para el VIF? Yo entiendo que a partir de 4 merece la pena pararse a ver que pasa, he leído por ahí que a partir de 5 hay que disparar las alarmas. Un valor de 14 o 10 es para asustarse. ¿Cómo solucionamos esto? Directamente os digo, no debemos eliminar variables, nuestro modelo es muy bueno. Se trata de que le demos estabilidad a los parámetros resultantes. Podemos introducirles un sesgo para hacerlos más pequeños y que tengan más estabilidad… En otra entrada. Saludos.
