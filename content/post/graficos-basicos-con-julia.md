---
author: rvaquerizo
categories:
- Formación
- Gráficos
- Julia
date: '2021-08-21T11:40:54-05:00'
lastmod: '2025-07-13T15:58:10.847160'
related:
- capitulo-5-representacion-basica-con-ggplot.md
- graficos-descriptivos-basicos-con-seaborn-python.md
- graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
- descubriendo-ggplot2-421.md
- grafico-de-barras-y-lineas-con-python.md
slug: graficos-basicos-con-julia
tags: []
title: Gráficos Básicos con Julia
url: /blog/graficos-basicos-con-julia/
---

De forma análoga a otras entradas sobre análisis gráficos básicos empezamos a trabajar con las posibilidades gráficas del lenguaje Julia. A continuación se recogerán el 80% de los gráficos que un científico de datos realizará en su vida profesional, el 20% restante se abordará en otras entradas. Emplearemos el conjunto de datos _penguins_ para ilustrar los ejemplos:

```r
using CSV
using DataFrames
using HTTP

url="https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv"
res = HTTP.get(url)
penguins = DataFrame(CSV.File(res.body))
```


En esta entrada se emplearán las librerías Plots y StatsPlots que podremos instalar con:

```r
using Pkg; Pkg.add("Plots"); Pkg.add("StatsPlots")
```


## Descripción univariable

### Variables cuantitativas

Histogramas con Julia:

```r
# Histograma
using Plots
gr()
pinta = map(!ismissing, penguins.flipper_length_mm)
histogram(penguins.flipper_length_mm[pinta])
```


[![](/images/2021/08/julia_plots_histograma.png)](/images/2021/08/julia_plots_histograma.png)

El primer gráfico con una sintaxis muy sencilla, _histogram(vector)_ Comentarios relevantes, para estas representaciones gráficas empleamos el [framework GR](https://gr-framework.org/), no podemos pintar datos missing y por ello hacemos un filtrado previo mediante map, como sólo deseamos pintar el histograma de una variable trabajamos con vectores, si deseamos variar el número de grupos empleamos nbins. Sentamos las bases del método de trabajo.

Gráficos de densidades:

```r
# Densidades
using StatsPlots
pinta = map(!ismissing, penguins.flipper_length_mm)
density(penguins.flipper_length_mm[pinta])
```


[![](/images/2021/08/julia_plots_densidad.png)](/images/2021/08/julia_plots_densidad.png)

Sintaxis muy similar a la empleada con el histograma pero en este caso se usa la función _density_

Gráfico Boxplot:

```r
# Boxplot
using StatsPlots
pinta = map(!ismissing, penguins.flipper_length_mm)
boxplot(penguins.flipper_length_mm[pinta])
```


[![](/images/2021/08/julia_plots_boxplot.png)](/images/2021/08/julia_plots_boxplot.png)

### Variables cualitativas

Gráficos de barras:

```r
# Variables cualitativas
using DataFramesMeta
using Query
using StatsPlots

agr = penguins |>
    @groupby(_.species) |>
    @map({species=key(_), conteo=length(_)}) |>
    DataFrame

bar(agr.species, agr.conteo,
    label = "Número de pinguinos",
    title = "Conteo por especie",
    xticks =:all,
    size = [600, 400],
    legend =:topright)
```


[![](/images/2021/08/julia_plots_barras.png)](/images/2021/08/julia_plots_barras.png)

Para la realización de gráficos de barras se ha realizado una agregación previa, realizamos el _groupby_ por el campo que deseamos realizar el gráfico y contamos registros. Aprovechamos el ejemplo para introducir etiquetas con label, títulos con title, ver las líneas de división, especificar el tamaño y establecer la posición de la leyenda. Se observa que las opciones del gráfico no son complejas.

Del mismo modo si deseamos la representación en porcentaje podemos calcularlo previamente:

```r
#En porcentaje
agr = penguins |>
    @groupby(_.species) |>
    @map({species=key(_), conteo=length(_)}) |>
    DataFrame

total = nrow(penguins)

agr = agr |> @mutate(pct = _.conteo/total) |> DataFrame

bar(agr.species, agr.pct,
    label = "% de pinguinos",
    title = "% por especie",
    xticks =:all,
    size = [600, 400],
    legend =:topright)
```


[![](/images/2021/08/julia_plots_barras_porcentaje.png)](/images/2021/08/julia_plots_barras_porcentaje.png)

## Descripción bivariable

Gráfico de puntos:

```r
# Gráfico de puntos
grafico = @from i in penguins begin
    @where !isna(i.flipper_length_mm) & !isna(i.bill_length_mm)
    @select i
    @collect DataFrame
end

scatter(grafico.flipper_length_mm, grafico.bill_length_mm, group = grafico.species,
legend =:topleft)
```


[![](/images/2021/08/julia_plots_scatter.png)](/images/2021/08/julia_plots_scatter.png)

Anotaciones, se eliminan aquellos registros con valores perdidos para evitar problemas en la representación gráfica, esa selección se lleva a cabo mediante una _query_ y en este caso vamos a identificar cada punto con un color por la especie. La situación es similar a los gráficos de barras, preparamos un data frame con la estructura que deseamos representar gráficamente.

Gráfico de densidad comparando un factor:

```r
# Comparación de densidades
pinta = map(!ismissing, penguins.flipper_length_mm)
density(penguins.flipper_length_mm[pinta], group=penguins.species[pinta])
```


[![](/images/2021/08/julia_plots_densidades.png)](/images/2021/08/julia_plots_densidades.png)

Boxplot comparando distribuciones por factor:

```r
# Comparación boxplot
pinta = map(!ismissing, penguins.flipper_length_mm)
boxplot(penguins.species[pinta] ,penguins.flipper_length_mm[pinta], legend=false)
```


[![](/images/2021/08/julia_plots_boxplot_factor.png)](/images/2021/08/julia_plots_boxplot_factor.png)

Gráficos de barras de dos factores:

```r
using Pkg; Pkg.add("Plots"); Pkg.add("StatsPlots")
```
0

[![](/images/2021/08/julia_plots_barras_factor.png)](/images/2021/08/julia_plots_barras_factor.png)

Para estos gráficos es necesario emplear la función groupedbar.

Gráfico de barras apiladas:

```r
using Pkg; Pkg.add("Plots"); Pkg.add("StatsPlots")
```
1

[![](/images/2021/08/julia_plots_barras_apiladas.png)](/images/2021/08/julia_plots_barras_apiladas.png)

Del mismo modo empleamos groupedbar pero con la opción bar_position= :stack

De un vistazo los 8 gráficos más habituales en el trabajo diario. Mi opinión personal, código muy sencillo pero siguen sin gustarme las agregaciones con Julia, en esta entrada se exploran varias posibilidades. El siguiente paso será replicar esta entrada con plotly.