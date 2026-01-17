---
author: rvaquerizo
categories:
- Formación
- Modelos
- R
- Trucos
date: '2014-05-22T10:22:35-05:00'
lastmod: '2025-07-13T15:56:25.051896'
related:
- manual-curso-introduccion-de-r-capitulo-6-funciones-de-estadistica-descriptiva.md
- manual-introduccion-a-r-s-plus.md
- sobremuestreo-y-pesos-a-las-observaciones-ahora-con-r.md
- la-distribucion-tweedie.md
- numeros-aleatorios-con-sas.md
slug: determinar-la-distribucion-de-un-vector-de-datos-con-r
tags:
- rriskDistributions
title: Determinar la distribución de un vector de datos con R
url: /blog/determinar-la-distribucion-de-un-vector-de-datos-con-r/
---

Para determinar la distribución que sigue un vector de datos en R contamos con el paquete rriskDistributions. Este paquete de R nos permite realizar un test para las distribuciones siguientes:

• Normal
• Logística
• Uniforme
• Gamma
• Lognormal
• Weibull
• Cauchy
• Exponencial
• Chi-cuadrado
• F
• T-Student

Todos aquellos que estén trabajando con los modelos de supervisión de riesgos seguramente conocerán este paquete y si no lo conocen espero que lean estas líneas porque pueden ser de mucha ayuda para ellos, aunque se trate de software libre, no pasa nada, no receléis de R. La sintaxis es tan sencilla que se puede resumir en:

install.packages(«rriskDistributions»)
library(rriskDistributions)
res1<-fit.cont(data2fit=rnorm(374,40,1)) res1 Tras llamar al objeto tenemos la siguiente ventana: ![](/images/2014/05/rriskDistributions-ejemplo-300x191.png)

Ya podéis seleccionar la distribución más adecuada. Saludos.