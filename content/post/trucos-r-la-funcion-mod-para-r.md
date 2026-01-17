---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-07-27T02:23:11-05:00'
lastmod: '2025-07-13T16:09:39.006388'
related:
- como-influyen-los-numeros-maquina-en-nuestros-programas.md
- manual-curso-introduccion-de-r-capitulo-6-funciones-de-estadistica-descriptiva.md
- trucos-sas-calcular-percentiles-como-excel-o-r.md
- truco-excel-nuestra-propia-funcion-excel.md
- manual-curso-introduccion-de-r-capitulo-7-funciones-graficas-basicas-en-r.md
slug: trucos-r-la-funcion-mod-para-r
tags: []
title: Trucos R. La función mod para R
url: /blog/trucos-r-la-funcion-mod-para-r/
---

Buscando algunas cosas sobre R he encontrado esta función que hice hace mucho tiempo. De hecho puedo decir que de las primeras que hice allá en 2001 (creo) cuando empecé a conocer esto de R. Por aquellos entonces aseguré que el futuro pasaba por R y 9 años después sigo diciendo lo mismo, el tiempo me dará la razón, lo que no me imaginaba que hacía falta tanto tiempo. En fin, historias del dinosaurio. Vamos con la función «histórica». Al no disponer de la función _mod_ en R la programé:

```r
mod=function(x,y){

(abs(x/y)%%1)*y*sign(x)}
```

Función sencilla pero que tiene un aspecto interesante el %%. Probad lo siguiente:

```r
(65/3)%%1

[1] 0.6666667

 -(65/3)%%1

[1] 0.3333333
```

Al aparecer la función no entendí porque hacía _abs_ y después _sign_. Pero veo que es debido a las peculiadirades de _%%_. Me parecía curioso. Saludos.