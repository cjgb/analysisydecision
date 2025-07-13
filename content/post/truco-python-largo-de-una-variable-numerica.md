---
author: rvaquerizo
categories:
- Python
- Trucos
date: '2017-06-08T10:16:36-05:00'
slug: truco-python-largo-de-una-variable-numerica
tags: []
title: Truco Python. Largo de una variable numérica
url: /truco-python-largo-de-una-variable-numerica/
---

Hoy he tenido que determinar la longitud de una variable numérica de un data frame en python y tras pegarme unos minutos con len he encontrado la fórmula con str.len() el ejemplo es:

```r
df['largo_numero'] = df['variable_numerica'].astype(str).str.len()
```
 

Me ha parecido interesante traerlo.