---
author: rvaquerizo
categories:
  - formación
  - gráficos
  - julia
date: '2021-08-21'
lastmod: '2025-07-13'
related:
  - capitulo-5-representacion-basica-con-ggplot.md
  - graficos-descriptivos-basicos-con-seaborn-python.md
  - graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
  - descubriendo-ggplot2-421.md
  - grafico-de-barras-y-lineas-con-python.md
tags:
  - formación
  - gráficos
  - julia
title: Gráficos Básicos con Julia
url: /blog/graficos-basicos-con-julia/
---

De forma análoga a otras entradas sobre análisis gráficos básicos empezamos a trabajar con las posibilidades gráficas del `Julia`. A continuación se recogerán el 80% de los gráficos que un científico de datos realizará en su vida profesional, el 20% restante se abordará en otras entradas. Emplearemos el conjunto de datos `penguins` para ilustrar los ejemplos:

```julia
using CSV
using DataFrames
using HTTP

url="https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv"
res = HTTP.get(url)
penguins = DataFrame(CSV.File(res.body))
```

```julia
using Pkg; Pkg.add("Plots"); Pkg.add("StatsPlots")
```

## Descripción univariable

### Variables cuantitativas

Histogramas con Julia:

```julia
# Histograma
using Plots
gr()
pinta = map(!ismissing, penguins.flipper_length_mm)
histogram(penguins.flipper_length_mm[pinta])
```

[![](/images/2021/08/julia_plots_histograma.png)](/images/2021/08/julia_plots_histograma.png)

El primer gráfico con una sintaxis muy sencilla, `histogram(vector)` Comentarios relevantes, para estas representaciones gráficas empleamos el [framework `GR`](https://gr-framework.org/), no podemos pintar datos missing y por ello hacemos un `map` pintar el histograma de una variable trabajamos con vectores, si deseamos variar el número de grupos empleamos `nbins`. Sentamos las bases del método de trabajo.

Gráficos de densidades:

```julia
# Densidades
using StatsPlots
pinta = map(!ismissing, penguins.flipper_length_mm)
density(penguins.flipper_length_mm[pinta])
```

[![](/images/2021/08/julia_plots_densidad.png)](/images/2021/08/julia_plots_densidad.png)

Sintaxis muy similar a la empleada con el histograma pero en este caso se usa la función `density`

Gráfico Boxplot:

```julia
# Boxplot
using StatsPlots
pinta = map(!ismissing, penguins.flipper_length_mm)
boxplot(penguins.flipper_length_mm[pinta])
```

[![](/images/2021/08/julia_plots_boxplot.png)](/images/2021/08/julia_plots_boxplot.png)

### Variables cualitativas

Gráficos de barras:

```julia
# Variables cualitativas
using `DataFramesMeta` y `Query`
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

Para la realización de gráficos de barras se ha realizado una agregación previa, realizamos el `groupby` por el campo que deseamos realizar el gráfico y contamos registros. Aprovechamos el ejemplo para introducir etiquetas con `label`, títulos con `title`, ver las líneas de división, especificar el tamaño y establecer la posición de la leyenda. Se observa que las opciones del gráfico no son complejas.

Del mismo modo si deseamos la representación en porcentaje podemos calcularlo previamente:

```julia
#En porcentaje
agr = penguins |>
    @groupby(_.species) |>
    @map({species=key(_), conteo=length(_)}) |>
    DataFrame

total = `nrow(penguins)`

agr = agr |> `mutate`(pct = _.conteo/total) |> DataFrame

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

```julia
# Gráfico de puntos
grafico = @from i in penguins begin
    @where !isna(i.flipper_length_mm) & !isna(i.bill_length_mm)
    @select i
    @collect DataFrame
end

`scatter`(grafico.flipper_length_mm, grafico.bill_length_mm, group = grafico.species,
legend =:topleft)
```

[![](/images/2021/08/julia_plots_%60scatter%60.png)](/images/2021/08/julia_plots_%60scatter%60.png)

Anotaciones, se eliminan aquellos registros con valores perdidos para evitar problemas en la representación gráfica, esa selección se lleva a cabo mediante una `query` y en este caso vamos a identificar cada punto con un color por la especie. La situación es similar a los gráficos de barras, preparamos un data frame con la estructura que deseamos representar gráficamente.

Gráfico de densidad comparando un factor:

```julia
# Comparación de densidades
pinta = map(!ismissing, penguins.flipper_length_mm)
density(penguins.flipper_length_mm[pinta], group=penguins.species[pinta])
```

[![](/images/2021/08/julia_plots_densidades.png)](/images/2021/08/julia_plots_densidades.png)

Boxplot comparando distribuciones por factor:

```julia
# Comparación boxplot
pinta = map(!ismissing, penguins.flipper_length_mm)
boxplot(penguins.species[pinta] ,penguins.flipper_length_mm[pinta], legend=false)
```

[![](/images/2021/08/julia_plots_boxplot_factor.png)](/images/2021/08/julia_plots_boxplot_factor.png)

```julia
using Pkg; Pkg.add("Plots"); Pkg.add("StatsPlots")
```

Para estos gráficos es necesario emplear la `groupedbar`

Gráfico de barras apiladas:

```julia
using Pkg; Pkg.add("Plots"); Pkg.add("StatsPlots")
```

Del mismo modo empleamos groupedbar pero con la opción bar_position= :stack

De un vistazo los 8 gráficos más habituales en el trabajo diario. Mi opinión personal, código muy sencillo pero siguen sin gustarme las agregaciones con Julia, en esta entrada se exploran varias posibilidades. El siguiente paso será replicar esta entrada con plotly.
