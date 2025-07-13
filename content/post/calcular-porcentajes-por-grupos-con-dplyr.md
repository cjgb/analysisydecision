---
author: rvaquerizo
categories:
- Formación
- R
date: '2020-10-26T10:35:18-05:00'
slug: calcular-porcentajes-por-grupos-con-dplyr
tags:
- dplyr
title: Calcular porcentajes por grupos con dplyr
url: /calcular-porcentajes-por-grupos-con-dplyr/
---

A la hora de sumarizar datos con dplyr podemos calcular porcentajes dentro de grupos o subgrupos con `transmute`. La sintaxis es sencilla pero tiene la peculiaridad que sólo obtendremos como salida lo que indiquemos en transmute. Mejor lo entendéis en un ejemplo:

Conjunto de datos aleatorio de ejemplo:

```r
library(dplyr)
observaciones = 100
grupo_1 = rpois(observaciones, 0.5)
grupo_2 = rpois(observaciones, 1)

df = cbind.data.frame(grupo_1, grupo_2) %>% mutate(id_cliente=n())
```
 

Sumarizamos por grupos:

```r
df %>% group_by(grupo_1, grupo_2) %>% summarise(clientes = n())
```
 

Contamos clientes y calculamos el porcentaje sobre el total:

```r
df %>% group_by(grupo_1, grupo_2) %>%
  summarise(clientes = n(),
            pct_total = n()/nrow(df))
```
 

Suelo usar `nrow` se aceptan sugencias. Calculamos el porcentaje para el subgrupo del grupo_1, primer ejemplo de uso de transmute:

```r
df %>% group_by(grupo_1, grupo_2) %>%
  summarise(clientes = n()) %>%
  transmute(grupo_2, pct_grupo = clientes/sum(clientes))
```
 

Vemos que clientes ha desaparecido, sólo obtenemos grupo_1, grupo_2 y pct_grupo. Si queremos el porcentaje sobre el total:

```r
df %>% group_by(grupo_1, grupo_2) %>%
  summarise(clientes = n()) %>%
  transmute(grupo_2, pct_grupo = clientes/sum(clientes),
            pct_total = clientes/nrow(df))
```
 

Aquí lo tengo todo recogido, para cuando no lo recuerde. Saludos.