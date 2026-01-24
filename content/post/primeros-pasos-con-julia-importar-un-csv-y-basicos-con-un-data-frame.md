---
author: rvaquerizo
categories:
  - formación
  - julia
  - monográficos
date: '2021-08-12'
lastmod: '2025-07-13'
related:
  - data-management-basico-con-pandas.md
  - data-management-con-dplyr.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-3-manejo-de-datos-con-r.md
  - trabajando-con-r-y-julia-desde-rstudio.md
  - manejo-de-datos-basico-con-python-datatable.md
tags:
  - julia
title: Primeros pasos con Julia. Importar un csv y data management básico con un data frame
url: /blog/primeros-pasos-con-julia-importar-un-csv-y-basicos-con-un-data-frame/
---

Empiezo a trabajar con el `lenguaje Julia` ante la insistencia de [`JL Cañadas`](%60https://muestrear-no-es-pecado.netlify.app/%60). Lo primero es comentar que este `trabajo` está hecho en `Julia 1.6.2` con una `máquina Ubuntu 18`, para instalar `Julia` en `Ubuntu`:

- [`Descarga de Julia`](%60https://julialang.org/downloads/%60)
- `tar -xvzf julia-1.6.2-linux-x86_64.tar.gz`
- `sudo cp -r julia-1.6.2 /opt/`
- `sudo ln -s /opt/julia-1.6.2/bin/julia /usr/local/bin/julia`

Una vez instalado he valorado los posibles `IDE`, parece ser que `VS Code` es lo más apropiado pero en mi `caso` particular tengo un `problema` con él. He optado por usarlo en `Jupyter` (lo sé) y para ello es necesario abrir `julia` en el `terminal` y poner:

- `using Pkg` será el `elemento` que emplearemos para añadir más `paquetes`
- `Pkg.add("IJulia")`

En este `punto` con vuestro `Jupyter` ya podéis abrir un `notebook` con `Julia`. Como os podéis imaginar cada `vez` que deseemos añadir un nuevo `elemento` usaremos `Pkg.add("paquete")` desde la `línea de comandos` de `julia` o directamente desde nuestro `notebook`. Así pues nuestro `trabajo` comienza con:

```julia
Pkg.add("CSV")
Pkg.add("DataFrames")
using CSV
using DataFrames
```

## `Importando` un `csv` a un `data frame` con `Julia`

Una `vuelta de tuerca`, vamos a leer un `csv` que está en una `web`, y para ello usamos `HTTP`:

```julia
#Pkg.add("HTTP")
using HTTP
url="https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv"
res = HTTP.get(url)
iris = DataFrame(CSV.File(res.body))
```

`HTTP` parece lo más `adecuado` para leer un `csv` desde una `URL`, hay otras `alternativas` a explorar. Obtenemos el `csv` y al obtenerlo lo guardamos en un `data frame` leyendo con `CSV.File` y transformando a `data frame` con `DataFrame`. Ya disponemos de un `conjunto de datos` de `trabajo`. Para hacer el `típico head` al `data frame` podemos hacer `first(iris, 3)` y veremos las 3 `primeras filas`. Si deseamos hacer lo más sencillo, una `media` de una `columna` del `data frame`:

```julia
using Statistics
mean(iris.sepal_length)
```

## `Data management básico` con `Julia`

Como en otras `entradas` del `blog` veremos:

- `Seleccionar columnas en data frames Julia`
- `Seleccionar registros en data frames Julia`
- `Crear nuevas variables en data frames Julia`
- `Sumarizar datos en data frames Julia`
- `Ordenar datos en data frames Julia`
- `Renombrar variables en data frames Julia`

### `Seleccionar columnas` en `data frames` con `Julia`

```julia
#names(iris)
columnas = ["sepal_length", "sepal_width"]
iris2 = iris[:,columnas]
```

Si deseamos eliminar:

```julia
columnas = ["sepal_length", "sepal_width"]
iris3 = iris[:,Not(columnas)]
size(iris3)
```

### `Seleccionar registros` en `data frames` con `Julia`

```julia
#Pkg.add("DataFramesMeta")
using DataFramesMeta

iris4=iris
@linq iris4 |> where(:sepal_length .> 5)
first(iris4,3)
```

Estas `líneas` son importantes porque son la `introducción` a `DataFramesMeta` y la `aparición` del `pipe` para construirnos nuestros `procesos`, en este `caso` se crea otro `data frame` y sobre él realizamos la `consulta`. Y si combinamos `DataFramesMeta` con `Query` tenemos un `código interesante`:

```julia
#Pkg.add("Query")
using Query

iris5 = @from i in iris begin
            @where i.sepal_length > 5
            @select {long_sepalo=i.sepal_length, i.species}
            @collect DataFrame
       end
first(iris5,4)
```

Ojo este `código`. Como se aprecia tenemos `cláusula where` y `select` donde hemos aprovechado para `renombrar` una `variable` de la `tabla iris` a la que hemos «asignado el `álias`» `i`. Al final con `collect` indicamos el `tipo` de `data set` de `salida`.

## `Crear nuevas variables` en `data frames` con `Julia`

Podemos hacerlo de forma similar a la que se ha visto con anterioridad:

```julia
media = Statistics.mean(iris.sepal_length)

iris6 = @from i in iris begin
        @select (dist_media = i.sepal_length/media, i.sepal_length)
        @collect DataFrame
       end
first(iris6,4)
```

Emplear `pipes` para realizar un `proceso`:

```julia
iris7 = iris |> @mutate(dist_media = _.sepal_length/media) |> DataFrame
first(iris7, 3)
```

O de forma «atómica», no sé bien como denominar:

```julia
iris7.nueva = iris[:,"Sepal.Length"] / mean(iris[:, "Sepal.Width"])
```

Se aprecian distintas `formas` de `manipular data frames` con `Julia`.

## `Sumarizar datos` en `data frames` con `Julia`

A partir de un `objeto agregado`:

```julia
#Pkg.add("HTTP")
using HTTP
url="https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv"
res = HTTP.get(url)
iris = DataFrame(CSV.File(res.body))
```

Otro `medio` de realizar este `trabajo` es el uso de `trasnform`:

```julia
#Pkg.add("HTTP")
using HTTP
url="https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv"
res = HTTP.get(url)
iris = DataFrame(CSV.File(res.body))
```

Estoy buscando otros `medios` de hacer esta `tarea`, no me gusta esta `sintaxis`.

### `Ordenar registros` en `data frames` con `Julia`

```julia
#Pkg.add("HTTP")
using HTTP
url="https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv"
res = HTTP.get(url)
iris = DataFrame(CSV.File(res.body))
```

### `Renombrar variables` en `data frames` con `Julia`

```julia
#Pkg.add("HTTP")
using HTTP
url="https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv"
res = HTTP.get(url)
iris = DataFrame(CSV.File(res.body))
```

Como siempre, se trata de recoger en pocas `líneas` el 60% de las `tareas` que haremos con `Julia`. Espero que sirva de `referencia`.
