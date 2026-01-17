---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2020-08-13T09:04:38-05:00'
lastmod: '2025-07-13T15:57:45.053446'
related:
- transponer-data-frames-con-r-de-filas-a-columnas-y-de-columnas-a-filas.md
- trucos-r-funcion-ddply-del-paquete-plyr.md
- datos-agrupados-en-r-con-dplyr.md
- capitulo-4-uniones-de-tablas-con-r.md
- data-management-con-dplyr.md
slug: expandir-un-data-frame-de-r-con-tidyr
tags:
- expand
- tidyr
title: Expandir un data frame de R con tidyr
url: /blog/expandir-un-data-frame-de-r-con-tidyr/
---

[En alguna entrada del blog ya he tratado sobre la expansión de un conjunto de datos](https://analisisydecision.es/los-pilares-de-mi-simulacion-de-la-extension-del-covid19/) pero quería tener una entrada específica. Es algo que se puede programar mediante bucles (tarda una vida) o bien podemos usar la función expand del paquete tydyr. Viendo un ejemplo y los conjuntos de datos generados vais a entender el propósito de la expansión de tablas, se trata de un inicio y un fin y deseamos que se genere una secuencia de observaciones sucesivas dado ese inicio y ese fin. A modo de ejemplo ilustrativo:

```r
library(tidyverse)

clientes <- 100

cliente <- data.frame(id_cliente = seq(1, clientes))
cliente %>% mutate( inicio = rpois(nrow(cliente), 2),
                    fin = inicio + rpois(nrow(cliente), 4)) ->
  cliente

cliente_expand <- cliente %>% group_by(id_cliente) %>% expand(entrada=inicio:fin) %>% as_tibble()
```


Con este programa pasamos de un data frame con un registro por id a otro data frame con tantos registros por id como longitud tenga la secuencia entre el campo de inicio y el campo fin:

[![](/images/2020/08/expand.png)](/images/2020/08/expand.png)

Esta función expand de rstats me está siendo especialmente útil para trabajar con horas. Saludos.