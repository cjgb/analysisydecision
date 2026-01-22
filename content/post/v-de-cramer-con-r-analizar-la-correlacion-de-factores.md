---
author: rvaquerizo
categories:
  - formación
  - r
date: '2014-10-08'
lastmod: '2025-07-13'
related:
  - grafico-de-correlaciones-entre-factores-grafico-de-la-v-de-cramer.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-11-analisis-bivariable.md
  - monografico-analisis-de-factores-con-r-una-introduccion.md
  - el-problema-de-la-multicolinealidad-intuirlo-y-detectarlo.md
  - manual-curso-introduccion-de-r-capitulo-14-introduccion-al-calculo-matricial-con-analisis-de-componentes-principales.md
tags:
  - vcd
title: V de Cramer con R. Analizar la correlación de factores
url: /blog/v-de-cramer-con-r-analizar-la-correlacion-de-factores/
---

Cómo calcular la **`V de Cramer` con `R`** , una pregunta que me han hecho recientemente. Sirve para medir la asociación entre factores. Además esta entrada es útil para retomar el paquete `vcd` de `R` que nos permite analizar y _`Visualizar Categorical Data`_. Partimos de un ejemplo muy sencillo:

```r
datos = read.csv("http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data/car.csv")

summary(datos)
tabla = ftable(as.factor(datos$agecat), datos$area,
dnn = c("Edad", "Valor"))
library(vcd)
assocstats(tabla)
```

Desconozco si existe una función que nos presente una matriz con las distintas medidas de asociación. Pero la función `assocstats` del paquete `vcd` nos ofrece:

```text
Phi-Coefficient : 0.112
Contingency Coeff.: 0.111
Cramer’s V : 0.05
```

El `coeficiente phi` es el valor de la `chi cuadrado` entre el número de observaciones, un valor próximo a 0 indica independencia entre los factores, valores próximos o superiores a 1 implican relación entre los factores. El **coeficiente de contingencia** también es una medida de la intensidad de la relación basado en la `chi cuadrado` y toma valores entre 0 (independencia) y 1 (dependencia). La **`V de Cramer`** es muy habitual para medir la relación entre factores, es menos susceptible a valores muestrales. También 0 implica independencia y 1 una relación perfecta entre los factores. Habitualmente valores superiores a 0,30 ya nos están indicando que hay una posible relación entre las variables. En este caso tenemos valores muy próximos a 0 en todos los estadísticos que nos ofrece, ambos factores son independientes. Saludos.
