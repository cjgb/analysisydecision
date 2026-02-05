---
author: rvaquerizo
categories:
  - formación
  - libro estadística
  - r
date: '2022-01-18'
lastmod: '2025-07-13'
related:
  - tipos-de-uniones-join-de-tablas-con-python-pandas.md
  - proc-sql-merge-set.md
  - monografico-paquete-sqldf-si-sabes-sql-sabes-r.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - data-management-con-dplyr.md
tags:
  - formación
  - libro estadística
  - r
title: Introducción a la Estadística para Científicos de Datos. Capítulo 4. Uniones de tablas con R
url: /blog/capitulo-4-uniones-de-tablas-con-r/
---

Además de manejar los datos de un `data.frame`, in ocasiones es necesario realizar uniones entre conjuntos de datos para crear o añadir nuevas variables a un `data.frame` que es una base de observaciones inicial. Se pueden establecer dos tipos de uniones fundamentales: uniones verticales de tablas y uniones horizontales. Las uniones verticales serán las concatenaciones de `data.frames` (poner una estructura de datos encima de otra) y las uniones horizontales serán las que se denominarán *join*.

Se emplea una estructura de datos sencilla para ejemplificar el funcionamiento:

```r
library(kableExtra)
library(tidyverse)

df1 <- data.frame(anio = c(2018, 2019, 2020, 2021), 
                  variable1 = c(10, 20, 30, 40), 
                  variable2 = c(1000, 2000, 3000, 4000))
df2 <- data.frame(anio = c(2017, 2018, 2019, 2020), 
                  variable1 = c(50, 60, 70, 80), 
                  variable3 = c(5000, 6000, 7000, 8000))

df1 %>% kable()
df2 %>% kable()
```

Se puede observar cómo se han creado manualmente dos `data.frames` con los que trabajaremos y el uso de `tidyverse` y `kableExtra` para la visualización de tablas in `R`. Veamos los principales tipos de uniones.

## Uniones verticales

El siguiente código emplea la función `rbind.data.frame()` para concatenar datos (para poner una tabla encima de otra) y generaría un error:

```r
df <- rbind.data.frame(df1, df2)
```

`Error in match.names(clabs, names(xi)) : names do not match previous names`

Significa que ambos conjuntos de datos no tienen las mismas variables. In las uniones verticales con la función `rbind.data.frame()`, se han de unir las **mismas estructuras**. In los datos de trabajo no se dispone de la misma estructura, por lo que se torna necesario saber qué deseamos unir verticalmente, qué deseamos concatenar. Si deseamos realizar una unión de todos los datos, ambas tablas requieren de las mismas variables:

```r
df1$variable3 <- NA
df2$variable2 <- NA

df <- rbind.data.frame(df1, df2)
df %>% kable()
```

Se han creado la `variable3` y `variable2` donde ha sido necesario y ya se está in disposición de concatenar ambos `data.frames`. Observemos cómo queda el `data.frame` resultante. Es importante puntualizar que se están produciendo duplicidades por la variable `anio`; cabe preguntarse: ¿son necesarias esas duplicidades? Cuando se trabaje con datos, es muy importante disponer de un campo identificativo del registro y determinar si existen duplicidades por ese campo.

In cualquier caso, con el paquete `dplyr` se pueden concatenar `data.frames` mediante la función `bind_rows()`.

```r
df <- bind_rows(df1, df2)
df %>% kable()
```

El empleo de esta función no es sensible a la necesidad de que ambos conjuntos de datos tengan los mismos nombres de variables; si eso no ocurre, se emplean valores perdidos representados in `R` como `NA` para aquellas ocasiones in las que no coincida.

## Uniones horizontales o *join*

Esta conocida figura recoge in `SQL` todos los tipos de *join*:

![](https://ingenieriadesoftware.es/wp-content/uploads/2018/07/sqljoin.jpeg)

No se considera ver todos los ejemplos; se estudiarán las uniones más habituales in el trabajo diario.

### Inner join

Es la intersección de dos conjuntos de datos. Usamos la función `inner_join()` de `dplyr`.

```r
df1 <- data.frame(anio = c(2018, 2019, 2020, 2021), 
                  variable1 = c(10, 20, 30, 40), 
                  variable2 = c(1000, 2000, 3000, 4000))
df2 <- data.frame(anio = c(2017, 2018, 2019, 2020), 
                  variable1 = c(50, 60, 70, 80), 
                  variable3 = c(5000, 6000, 7000, 8000))

df <- inner_join(df1, df2, by = 'anio')

# Equivale a df <- df1 %>% inner_join(df2, by = 'anio')
df %>% kable()
```

La unión de ambas estructuras tiene una variable `variable1` in común; `dplyr` entiende que es necesario preservar las variables del conjunto de datos de la derecha (con el sufijo `.x`) y las variables del conjunto de datos de la izquierda (con el sufijo `.y`); por este motivo es muy relevante determinar qué se quiere unir. In los datos de trabajo podríamos saber cuáles de los datos de la izquierda coinciden por año con los de la derecha y unir la `variable3`.

```r
df2 <- df2 %>% select(-variable1)
df <- inner_join(df1, df2, by = 'anio')
df %>% kable()
```

Se ha eliminado la `variable1` del `df2` como paso previo; es la que ambos conjuntos de datos tienen in común. Se realiza la unión y, in este caso, se ha buscado la «unión natural» por el campo in común que es `anio`. In el trabajo diario del científico de datos, es necesario realizar múltiples uniones de conjuntos de datos por un campo identificativo (roles de las variables); es buena práctica que este campo identificativo tenga el mismo nombre para todos los conjuntos de datos de trabajo.

### Left join

Quizá una de las uniones más habituales in el trabajo diario de un científico de datos. Se parte de un conjunto de datos de base y se le añaden nuevas variables por la derecha respetando las observaciones de la izquierda. La función de `dplyr` usada es `left_join()`.

```r
df1 <- data.frame(anio = c(2018, 2019, 2020, 2021), variable1 = c(10, 20, 30, 40))
df2 <- data.frame(anio = c(2017, 2018, 2019, 2020), variable3 = c(5000, 6000, 7000, 8000))

df1 <- df1 %>% left_join(df2, by = 'anio')
df1 %>% kable()
```

Se ha añadido por la derecha la `variable3` al `df1`: añadimos una nueva variable a un **`data.frame` de base**.

### Anti join

Se van a seleccionar aquellos registros de una tabla base que no están in otra tabla de cruce.

```r
df1 <- data.frame(anio = c(2018, 2019, 2020, 2021), variable1 = c(10, 20, 30, 40))
df2 <- data.frame(anio = c(2017, 2018, 2019, 2020), variable3 = c(5000, 6000, 7000, 8000))

df <- df1 %>% anti_join(df2, by = 'anio')
df %>% kable()
```

Se observa que no se ha unido ninguna variable, solo se ha seleccionado el registro de `df1` que no cruza con `df2`.

### Librería sqldf

Como científicos de datos, es **importante saber `SQL`** como lenguaje de consulta; si sabemos `SQL`, tenemos la librería `sqldf` para utilizar directamente `SQL` sobre `data.frames` de `R`.

```r
library(sqldf)

df1 <- data.frame(anio = c(2018, 2019, 2020, 2021), 
                  variable1 = c(10, 20, 30, 40), 
                  variable2 = c(1000, 2000, 3000, 4000))
df2 <- data.frame(anio = c(2017, 2018, 2019, 2020), 
                  variable1 = c(50, 60, 70, 80), 
                  variable3 = c(5000, 6000, 7000, 8000))

# Inner Join
df_inner <- sqldf("select a.anio, a.variable1, variable3
                   from df1 a, df2 b
                   where a.anio = b.anio")
df_inner %>% kable()

# Left join
df_left <- sqldf("select a.anio, a.variable1, variable3
                  from df1 a left join df2 b
                  on a.anio = b.anio")
df_left %>% kable()

# Anti Join
df_anti <- sqldf("select * from df1 where anio not in (select anio from df2)")
df_anti %>% kable()
```

## Duplicidades in las uniones de tablas

Otra situación habitual que se va a encontrar el científico de datos es la aparición de registros duplicados; es necesario controlar su existencia porque pueden distorsionar el resultado de un análisis.

```r
df1 <- data.frame(anio = c(2018, 2019, 2020, 2021), variable1 = c(10, 20, 30, 40))
df2 <- data.frame(anio = c(2017, 2018, 2019, 2020, 2020), 
                  variable3 = c(5000, 6000, 7000, 8000, 1000))

df <- df1 %>% left_join(df2, by = 'anio')
df %>% kable()
```

In este burdo ejemplo, `df2` tiene duplicado el año 2020, por lo que una `left_join()` con ese conjunto de datos por ese campo provocará duplicidades. Una forma de controlarlo será contabilizar por el campo identificativo.

In el capítulo anterior ya se anotó la **importancia de establecer mecanismos de control cuando se trabaje con datos**, bien sea visualizaciones de datos, agrupaciones, tablas de frecuencia o estadísticos básicos que veremos in posteriores capítulos. Saludos.
