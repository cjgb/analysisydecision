---
author: rvaquerizo
categories:
- Formación
date: '2020-03-21T06:08:05-05:00'
slug: transformar-todos-los-factores-a-caracter-de-mi-data-frame-de-r
tags: []
title: Transformar todos los factores a carácter de mi data frame de R
url: /transformar-todos-los-factores-a-caracter-de-mi-data-frame-de-r/
---

En muchas ocasiones no quiero factores en mi dataframe cuando trabajo con R. Y estoy en mi derecho de poner una entrada sobre una de las tareas que más realizo y que siempre se me olvida el como la realizo, tardo menos en buscarlo en www.analisisydecision.es que entre mis programas:

```r
df<- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)
```
 

Todos los elementos factor ahora son character.