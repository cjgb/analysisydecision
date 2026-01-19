---
author: rvaquerizo
categories:
- julia
- r
date: '2021-09-23'
lastmod: '2025-07-13'
related:
- r-python-reticulate.md
- primeros-pasos-con-julia-importar-un-csv-y-basicos-con-un-data-frame.md
- graficos-basicos-con-julia.md
- estadistica-para-cientificos-de-datos-con-r-introduccion.md
- evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
tags:
- sin etiqueta
title: Trabajando con R y Julia desde RStudio
url: /blog/trabajando-con-r-y-julia-desde-rstudio/
---
Muchas veces pienso que no es R es RStudio. Por eso hoy traigo unas líneas para ilustrar el uso de Julia en R markdown y poder elaborar vuestros documentos y vuestra documentación con RStudio. Todo el trabajo se articula [entorno a la librería JuliaCall](https://github.com/Non-Contradiction/JuliaCall) y se fundamenta en el uso de markdown donde usaremos indistintamente R o Julia. Todo comienza con un chunk de R:

```r
```{r}
#install.packages("JuliaCall")

library(JuliaCall)
julia_setup()
```
```


Instalamos el paquete y “suponemos” que hemos instalado Julia, de este modo, nada más cargar JuliaCall pondremos julia_setup() y ya dispondremos de nuestro entorno de Julia. Una vez ejecutados estos pasos en R ya podemos trabajar con algún chunk de Julia y con código conocido:

```r
```{julia}
using CSV
using DataFrames
using HTTP

url=https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv
res = HTTP.get(url)
penguins = DataFrame(CSV.File(res.body))
```
```


Destacar que no tenemos una integración en RStudio tan chula como la que hay con reticulate donde disponemos del entorno Python y del entorno R para navegar por nuestros objetos. Esta situación hace que el ahora escribiente (por ejemplo) realice el trabajo en Visual Code y posteriormente lleve esos códigos a Markdown. Si visitáis la ayuda de JuliaCall podréis ver todas las posibilidades que tenemos para mover objetos y funciones, para ilustrar este paso de objetos de un entorno a otro os traigo un pase de un data frame de R a Julia:

```r
```{r}
data("iris")
iris <- julia_assign("iris", iris)
```
```


La función julia_assign es la que nos permite mover data frames y ya podemos usarlo en Julia:

```r
```{julia}
using StatsPlots
boxplot(iris.Sepal_Width)
```
```


Y por supuesto el camino inverso, pasar un data frame de Julia a R:

```r
```{r}
penguins <- julia_eval("penguins")
```
```


Aquellos que usamos RStudio para casi todo ya no tenemos escusa para emplear Julia, aunque veremos que pasa con Visual Code.