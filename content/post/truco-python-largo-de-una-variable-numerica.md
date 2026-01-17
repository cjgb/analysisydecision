---
author: rvaquerizo
categories:
- Python
- Trucos
date: '2017-06-08T10:16:36-05:00'
lastmod: '2025-07-13T16:07:45.945199'
related:
- macro-facil-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
- macros-sas-calular-la-longitud-de-un-numero.md
- duda-de-sas-longitud-de-la-parte-decimal-de-un-numero.md
- truco-python-reemplazar-una-cadena-de-caracteres-en-los-nombres-de-las-columnas-de-un-data-frame.md
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
slug: truco-python-largo-de-una-variable-numerica
tags: []
title: Truco Python. Largo de una variable numérica
url: /blog/truco-python-largo-de-una-variable-numerica/
---

Hoy he tenido que determinar la longitud de una variable numérica de un data frame en python y tras pegarme unos minutos con len he encontrado la fórmula con str.len() el ejemplo es:

```r
df['largo_numero'] = df['variable_numerica'].astype(str).str.len()
```


Me ha parecido interesante traerlo.