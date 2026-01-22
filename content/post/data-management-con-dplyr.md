---
author: rvaquerizo
categories:
  - formación
  - r
date: '2018-11-22'
lastmod: '2025-07-13'
related:
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - data-management-basico-con-pandas.md
  - trucos-r-funcion-ddply-del-paquete-plyr.md
  - manejo-de-datos-basico-con-python-datatable.md
  - primeros-pasos-con-julia-importar-un-csv-y-basicos-con-un-data-frame.md
tags:
  - dplyr
title: Data management con dplyr
url: /blog/data-management-con-dplyr/
---

Dos años con `pandas` y `sckitlearn` y ahora vuelvo a `R`. Y en mi regreso me propuse comenzar a trabajar con `dplyr` y mi productividad se está incrementando exponencialmente, creo que dplyr es LA HERRAMIENTA para el manejo de `data frame` con `R`, ni me imagino como puede funcionar `sparlyr`… Para aquellos que estéis iniciando vuestra andadura con R o para los que no estéis acostumbrados a `dplyr` he hecho una recopilación de las tareas más habituales que hago con esta librería. Se pueden resumir:

• Seleccionar columnas
• Seleccionar registros
• Crear nuevas variables
• Sumarizar datos
• Ordenar datos
• Uniones de datos

Como es habitual trabajamos con ejemplos data(iris); library(dplyr):

Seleccionar columnas `select()`:

```r
two.columns <- iris %>%
select(Sepal.Length,Sepal.Width)

columns = c("Sepal.Length","Sepal.Width")
two.columns <- iris %>%
select(columns)
```
```

Seleccionar registros `filter()`:

```r
setosa <- iris %>%
filter(Species=="setosa")

species_to_select = c("setosa","virginica")
species <- iris %>%
filter(Species %in% species_to_select)
table(species$Species)
```
```

Crear nuevas variables `mutate()`:

```r
iris2 <- iris %>%
mutate(Sepal.Length.6 = ifelse(Sepal.Length >=6, "GE 6", "LT 6")) %>%
mutate(Sepal.Length.rela = Sepal.Length/mean(Sepal.Length))
```
```

Sumarizar `group_by()` `summarize()`:

```r
iris %>% group_by(Species) %>%
summarize(mean.Sepal.Length = mean(Sepal.Length),
sd.Sepal.Length = sd(Sepal.Length),
rows = n())
```
```

Ordenar datos `arrange()`:

```r
order1 <- iris %>%
arrange(Sepal.Length)

order2 <- iris %>%
arrange(desc(Sepal.Length))
```

```r
iris %>% group_by(Species) %>%
summarize(mean.Sepal.Length = mean(Sepal.Length),
sd.Sepal.Length = sd(Sepal.Length),
rows = n())
``` %>%
arrange(mean.Sepal.Length)
```

Uniones de datos:

`Inner_join()`:

```r
iris2 <- iris %>%
mutate(id = row_number())

iris3 <- iris2 %>%
filter(Species=="setosa") %>%
mutate(Sepal.Length.6 = ifelse(Sepal.Length >=6, "GE 6", "LT 6")) %>%
mutate(Sepal.Length.rela = Sepal.Length/mean(Sepal.Length)) %>%
select(id,Sepal.Length.6,Sepal.Length.rela)

iris4 <- iris2 %>% inner_join(iris3, by=c("id"))
```
```

`Left_join()`:

```r
iris5 <- iris2 %>% left_join(iris3, by=c("id"))
```
```

`anti_join()`:

```r
iris6 <- iris2 %>% anti_join(iris3)
```
```

Aquí tenéis una muestra de las posibilidades de dplyr y como se pueden combinar entre ellas. Creo que la sintaxis es bastante sencilla y se aprende con facilidad, si a mi no me esta costando mucho…
