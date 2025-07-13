---
author: rvaquerizo
categories:
- Formación
- R
date: '2013-05-14T10:20:04-05:00'
lastmod: '2025-07-13T16:06:38.783295'
related:
- recodificar-el-valor-de-un-factor-en-r.md
- truco-r-eval-parse-y-paste-para-automatizar-codigo.md
- transformar-todos-los-factores-a-caracter-de-mi-data-frame-de-r.md
- analisis-de-textos-con-r.md
- trucos-simples-para-rstats.md
slug: trabajando-con-factores-en-r-attach-frente-a-within
tags:
- attach
- car
- recode
title: Trabajando con factores en R. Attach frente a within
url: /trabajando-con-factores-en-r-attach-frente-a-within/
---

Un ejemplo de trabajo con datos en R. Transformamos factores de dos formas distintas. Por un lado empleamos _within_ con _recode_ de la librería _car_ y por otro lado empleamos el mítico _attach_.

Manejo de datos con **within** :  

```r
datos library(car)

datos prog id reconocimientos reconocimientos2 = recode(num_awards,"0='Sin renococimiento';1='1 reconocimiento';

else='Más de un reconocimiento'")

})
```

Manejo de datos con **attach/detach** :  

```r
attach(datos)

datosmath_cat[math<50 ] <- "D" datosmath_cat[math >= 50 & math < 60] <- "C" datosmath_cat[math >= 60&math<75] <- "B" datosmath_cat[math >= 75] <- "A"

datos$math_cat detach(datos)
```

No voy a entrar en que es más óptimo, tarda menos y demás. En mi opinión es mejor utilizar _within_ pacece más «pulcro» y la verdad es que la función _recode_ nos facilita mucho el trabajo pero como siempre tenemos múltiples posibilidades con R, por eso es R. Saludos.