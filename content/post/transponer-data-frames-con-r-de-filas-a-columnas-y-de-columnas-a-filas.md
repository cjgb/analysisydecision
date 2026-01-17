---
author: rvaquerizo
categories:
- R
- Trucos
date: '2021-05-19T10:49:28-05:00'
lastmod: '2025-07-13T16:06:55.078373'
related:
- data-management-con-dplyr.md
- trucos-simples-para-rstats.md
- leer-fichero-de-texto-de-ancho-fijo-con-python-pandas.md
- expandir-un-data-frame-de-r-con-tidyr.md
- truco-sas-transponer-tablas-con-proc-transpose-data-o-proc-sql.md
slug: transponer-data-frames-con-r-de-filas-a-columnas-y-de-columnas-a-filas
tags:
- tidyr
title: Transponer data frames con R. De filas a columnas y de columnas a filas
url: /blog/transponer-data-frames-con-r-de-filas-a-columnas-y-de-columnas-a-filas/
---

Entrada para recordar como transponer data frames con R, como pasar de n filas a n columnas manteniendo campos identificativos y como pasar de columnas a filas y crear un campo identificativo. Siento que últimamente más que un blog tengo un cuaderno de apuntes pero si estos apuntes pueden ayudar a alguien mejor. En realidad la entrada es un ejemplo ilustrativo de las funciones de tidy pivot_wider y pivot_longer.

### Pasar de filas a columnas

```r
#install.packages("palmerpenguins")

library(palmerpenguins)
```

agregado_especies <\- penguins %>% group_by(species, year) %>%
summarise(bill_depth_mm=mean(bill_depth_mm, na.rm=T)) %>%
pivot_wider(names_from = year, values_from = bill_depth_mm, names_prefix = "ANIO_")

Teníamos un campo por filas que contenía el año, hemos transpuesto por ese campo año y creado tantas variables (names_from) como años tengo para las variables numéricas deseadas (values_from), además hemos creado esas variables con el prefijo ANIO_

### Pasar de columnas a filas

```r
agregado_especies2 <- agregado_especies %>%

  pivot_longer(

    cols = starts_with("ANIO_"),

    names_to = "ANIO",

    values_to = "bill_depth_mm"  )
```

Deshacemos la transposición de filas a columnas anterior, ahora pasamos de columnas a filas el valor (value_to) y creamos un campo identificativo (names_to) y lo hacemos para todas aquellas variables que empiezan por el prefijo «ANIO_» (start_with).

Si se me vuelve a olvidar por enésima vez por lo menos sé donde buscar. Saludos.