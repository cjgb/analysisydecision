---
author: rvaquerizo
categories:
  - formación
  - modelos
  - r
date: '2009-10-23'
lastmod: '2025-07-13'
related:
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-15-modelos-glm-regresion-logistica-y-regresion-de-poisson.md
  - interpretacion-de-los-parametros-de-un-modelo-glm.md
  - que-pasa-si-uso-una-regresion-de-poisson-en-vez-de-una-regresion-logistica.md
  - monografico-regresion-logistica-con-r.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
tags:
  - formación
  - modelos
  - r
title: 'Manual. Curso introducción de R. Capítulo 18: Modelos de regresión de Poisson'
url: /blog/manual-curso-introduccion-de-r-capitulo-18-modelos-de-regresion-de-poisson/
---

Cuando disponemos de un número de eventos que ocurren en un intervalo de tiempo estamos ante una variable de Poisson; además tiene que producirse que este número de eventos en intervalos sea independiente del número de eventos que ocurran fuera de ese intervalo de tiempo. En un intervalo muy pequeño, la probabilidad de que ocurra un evento es proporcional al tamaño del intervalo y, por último, la probabilidad de que ocurran dos o más eventos en un intervalo muy pequeño es prácticamente 0. Cualquier variable medida en un intervalo de tiempo o en un intervalo espacial es una variable de Poisson; también se pueden emplear para medir frecuencias en intervalos de población (casos de cáncer en poblaciones, frecuencias siniestrales…). Tiene como particularidad que la media y la varianza son iguales a $p \times s$, donde $p$ es la probabilidad de ocurrencia de un evento de Poisson en un intervalo de tiempo de tamaño unidad y $s$ es el tamaño del intervalo de tiempo o espacial en estudio.

Un modelo de regresión de Poisson mide la relación de dependencia de una variable de Poisson con una o varias variables. Si $p$, repetimos, es la probabilidad de ocurrencia de un evento de Poisson en un intervalo de tiempo de tamaño unidad y $s$ es el tamaño del intervalo, el modelo matemático podría expresarse como $\ln(p \cdot s) = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \dots + \beta_n X_n$. De este modo, si $X_1 = X_2 = \dots = X_n = 0 \implies p = e^{\beta_0}$, luego $e^{\beta_0}$ es la probabilidad de que ocurra el evento en un intervalo igual a 1. También podría expresarse como $\ln(p) = \ln(s) + \beta_0 + \beta_1 X_1 + \dots + \beta_n X_n$. Para ilustrar este ejemplo, partimos de una BBDD Access que contiene reclamaciones en una compañía aseguradora:

| POBLACION | RECLAM | TAM_COCHE | GRUPO_EDAD |
| :--- | :--- | :--- | :--- |
| 500 | 42 | small | 1 |
| 1200 | 37 | medium | 1 |
| 100 | 1 | large | 1 |
| 400 | 101 | small | 2 |
| 500 | 73 | medium | 2 |
| 300 | 14 | large | 2 |

Para conectar R con una BBDD Access es necesario tener el paquete `RODBC`, que seguro que ya tenéis. En nuestro ejemplo concreto, al no disponer del paquete, las instrucciones a ejecutar para disponer de un `data.frame` de trabajo son las siguientes:

```r
# install.packages("RODBC")
setwd("c:/raul/trabajo") # Especificamos el directorio de trabajo.
library(RODBC)           # Cargamos los paquetes.
bd <- odbcConnectAccess("bd1.mdb")
bd # Analizamos la conexión ODBC
```

```text
RODBC Connection 2
Details:
  case=nochange
  DBQ=c:\raul\trabajo\bd1.mdb
  Driver={Microsoft Access Driver (*.mdb)}
  DriverId=25
  FIL=MS Access
  MaxBufferSize=2048
  PageTimeout=5
  UID=admin
```

La conexión funciona perfectamente. Ahora tenemos que realizar la query:

```r
datos <- sqlQuery(bd, "SELECT * FROM tabla")
datos <- data.frame(datos)
```

Como se puede observar, la forma de ejecutar SQL bajo R requiere de la creación del objeto que contiene la BBDD y, posteriormente, sobre ese objeto ejecutar la consulta a la tabla que contiene los datos dentro de la BBDD (en este caso `tabla`). Ya tenemos los datos preparados y nuestro problema es ajustar un modelo de regresión al número de reclamaciones de una compañía aseguradora que se distribuye como una Poisson, en función del tamaño del coche y del grupo de edad de los asegurados. El modelo es, como hemos visto antes, $\ln(p) = \ln(s) + \beta_0 + \beta_1 X_1 + \dots + \beta_n X_n$, donde $p$ es la probabilidad de realizar una reclamación (el evento de Poisson) y $s$ es el tamaño de la población; el logaritmo del tamaño poblacional o de la exposición lo denominaremos variable *offset*; lo que traducido al caso que nos ocupa es $\ln(\text{RECLAM}) = \ln(\text{POBLACION}) + \beta_0 + \beta_1 \cdot \text{TAM\_COCHE} + \beta_2 \cdot \text{GRUPO\_EDAD}$. En R:

```r
datos$ln_pob <- log(datos$POBLACION) # Creamos la variable offset

# Creamos el modelo
modelo.poisson <- glm(RECLAM ~ offset(ln_pob) + TAM_COCHE + GRUPO_EDAD, 
                      data = datos, family = poisson()) 
```

Empleamos `GLM` para la creación del modelo; la variable dependiente evidentemente será el número de reclamaciones; como *offset* o variable de exposición tenemos el logaritmo del tamaño de la población; las variables independientes serán `TAM_COCHE` y `GRUPO_EDAD`. Con `family` indicamos que se realice el modelo de `poisson()`. Resumamos el modelo:

```r
summary(modelo.poisson)
```

```text
Call:
glm(formula = RECLAM ~ offset(ln_pob) + TAM_COCHE + GRUPO_EDAD, 
    family = poisson(), data = datos)

Deviance Residuals: 
      1        2        3        4        5        6  
 1.0085  -0.9338  -0.2114  -0.6048   0.7193   0.0609  

Coefficients:
                Estimate Std. Error z value Pr(>|z|)    
(Intercept)      -5.7209     0.3669 -15.592  < 2e-16 ***
TAM_COCHEmedium   1.0715     0.2784   3.848 0.000119 ***
TAM_COCHEsmall    1.7643     0.2724   6.478 9.32e-11 ***
GRUPO_EDAD        1.3199     0.1359   9.713  < 2e-16 ***
--- 
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

(Dispersion parameter for poisson family taken to be 1)

    Null deviance: 175.1536  on 5  degrees of freedom
Residual deviance:   2.8207  on 2  degrees of freedom
AIC: 40.928

Number of Fisher Scoring iterations: 4
```

El primer paso es validar la hipótesis de varianza = media que define una distribución de Poisson. Para ello hacemos `Residual deviance / degrees of freedom`; en nuestro caso $2.8 / 2 = 1.4$. Parece que tenemos una ligera sobredispersión. Ya estamos en disposición de emplear nuestro modelo para realizar estimaciones:

```r
# Matriz de ejemplo para estimar (Intercept, medium, small, grupo_edad)
estima <- c(1, 0, 0, 1) # Intercept y grupo_edad 1

# Coeficientes
modelo.poisson$coefficients

# Estimación de la tasa (incidencia)
exp(sum(modelo.poisson$coefficients * estima))
# [1] 0.01226541
```

Hemos creado una matriz de una fila y cuatro columnas de 0 y 1 donde el primer término multiplica al término independiente de nuestro modelo, el segundo término multiplica al tamaño del coche "medium", el tercero al tamaño del coche "small" y, por último, al `GRUPO_EDAD`. Así pues, en el ejemplo buscamos la incidencia de las reclamaciones para coches grandes y grupo de edad 1, o lo que es lo mismo $e^{-5.72 + 1.32} = 0.012265$. Si deseamos conocer las estimaciones de nuestro modelo sobre los datos:

```r
modelo.poisson$fitted.values
#         1          2          3          4          5          6 
# 35.798902  42.974556   1.226541 107.201098  67.025444  13.773459 
```

Donde de 1 a 6 tenemos las 6 posibles combinaciones de los niveles de tamaño del coche por grupo de edad. Espero que este mensaje os ayude a conocer mejor o a acercaros a los modelos de regresión de Poisson, modelos imprescindibles en la creación de tarifas en seguros, por ejemplo. ¿Por qué no emplear R en una aseguradora?