---
author: rvaquerizo
categories:
  - formación
  - r
date: '2013-05-14'
lastmod: '2025-07-13'
related:
  - recodificar-el-valor-de-un-factor-en-r.md
  - truco-r-eval-parse-y-paste-para-automatizar-codigo.md
  - transformar-todos-los-factores-a-caracter-de-mi-data-frame-de-r.md
  - analisis-de-textos-con-r.md
  - trucos-simples-para-rstats.md
tags:
  - attach
  - car
  - recode
title: Trabajando con factores en R. Attach frente a within
url: /blog/trabajando-con-factores-en-r-attach-frente-a-within/
---

Un ejemplo de trabajo con datos en R. Transformamos factores de dos formas distintas. Por un lado empleamos `within` con `recode` de la librería `car` y, por otro lado, empleamos el mítico `attach`.

Manejo de datos con `within`:

```r
library(car)

# Supongamos que tenemos un data frame llamado datos
datos <- within(datos, {
  reconocimientos2 <- recode(num_awards, "0='Sin reconocimiento'; 1='1 reconocimiento'; else='Más de un reconocimiento'")
})
```

Manejo de datos con `attach` / `detach`:

```r
attach(datos)

datos$math_cat[math < 50] <- "D"
datos$math_cat[math >= 50 & math < 60] <- "C"
datos$math_cat[math >= 60 & math < 75] <- "B"
datos$math_cat[math >= 75] <- "A"

detach(datos)
```

No voy a entrar en qué es más óptimo, tarda menos y demás. En mi opinión es mejor utilizar `within`; parece más "pulcro" y la verdad es que la función `recode` nos facilita mucho el trabajo; pero, como siempre, tenemos múltiples posibilidades con R, por eso es R. Saludos.