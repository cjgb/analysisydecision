---
author: rvaquerizo
categories:
- formación
date: '2020-03-21'
lastmod: '2025-07-13'
related:
- trabajando-con-factores-en-r-attach-frente-a-within.md
- recodificar-el-valor-de-un-factor-en-r.md
- trucos-simples-para-rstats.md
- trucos-r-de-string-a-dataframe-de-palabras.md
- truco-r-eval-parse-y-paste-para-automatizar-codigo.md
tags:
- sin etiqueta
title: Transformar todos los factores a carácter de mi data frame de R
url: /blog/transformar-todos-los-factores-a-caracter-de-mi-data-frame-de-r/
---
En muchas ocasiones no quiero factores en mi dataframe cuando trabajo con R. Y estoy en mi derecho de poner una entrada sobre una de las tareas que más realizo y que siempre se me olvida el como la realizo, tardo menos en buscarlo en www.analisisydecision.es que entre mis programas:

```r
df<- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)
```


Todos los elementos factor ahora son character.