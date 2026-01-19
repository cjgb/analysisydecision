---
author: rvaquerizo
categories:
  - formación
  - r
  - trucos
date: '2020-03-26'
lastmod: '2025-07-13'
related:
  - trucos-r-funcion-ddply-del-paquete-plyr.md
  - pasando-de-sas-a-r-primer-y-ultimo-elemento-de-un-campo-agrupado-de-un-data-frame.md
  - creacion-de-ranking-con-r.md
  - trucos-simples-para-rstats.md
  - calcular-porcentajes-por-grupos-con-dplyr.md
tags:
  - dplyr
title: Datos agrupados en R con dplyr
url: /blog/datos-agrupados-en-r-con-dplyr/
---

Entrada rápida para ilustrar como crear un campo autonumérico por un factor, es una duda que me plantean, tienen datos de clientes y fechas y necesitan crear un autonumérico en R que les diga el número de orden de los eventos de una fecha. Algo parecido a lo que hacemos con el retain de R. Vamos a ilustrar la tarea con un ejemplo:

```r
```r
clientes = 100
id_cliente = rpois(clientes,10)
fecha = rpois(clientes, today()-rpois(clientes,5) )

eventos <- cbind.data.frame(id_cliente,fecha)

eventos$fecha <- as.Date(eventos$fecha, origin="1970-01-01")
eventos <- eventos %>% arrange(id_cliente,fecha)
```

100 clientes que aparecen una o n veces con fechas asociadas, el primer paso que sugiero hacer es eliminar duplicados con dplyr:

```r
```r
eventos <- eventos %>% group_by(id_cliente, fecha) %>%
  filter(row_number()==1) %>% as_tibble()
```

Agrupamos por cliente y fecha y nos quedamos con el primer registro, en este caso da igual quedarse con el primero que con el último. Ahora que no tenemos duplicados la agrupación ya no es por cliente y por fecha, como vamos a crear un valor agrupado por cliente haremos el group_by solo por cliente:

```r
```r
eventos <- eventos %>% group_by(id_cliente) %>%
  mutate(evento=row_number()) %>% as_tibble()
```

Cada evento irá numerado de 1 a n gracias a row_number(), el mismo se reinicia a 1 cada vez que cambia el valor del group_by.
