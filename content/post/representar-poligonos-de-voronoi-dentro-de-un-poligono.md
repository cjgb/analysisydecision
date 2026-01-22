---
author: rvaquerizo
categories:
  - formación
  - gráficos
  - mapas
  - r
date: '2021-11-29'
lastmod: '2025-07-13'
related:
  - incluir-subplot-en-mapa-con-ggplot.md
  - diagramas-de-voronoi-con-spatial-de-python.md
  - como-obtener-los-centroides-de-municipios-con-sas-mapas-con-sgplot.md
  - identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
  - adyacencia-de-poligonos-con-el-paquete-spdep-de-r.md
tags:
  - mapas
  - r
title: Representar polígonos de Voronoi dentro de un polígono
url: /blog/representar-poligonos-de-voronoi-dentro-de-un-poligono/
---

No es la primera vez que traigo al blog la realización de polígonos de Voronoi pero hoy la entrada está más orientada a la representación gráfica con `#rstats` y `ggplot`. En este caso deseamos crear polígonos de Voronoi en función del centro geográfico de las provincias españolas.

## Origen de los datos

El pasado 25 de noviembre el [Grupo de Usuarios de R de Madrid](http://madrid.r-es.org/) trajo la presentación de [@dieghernan](https://twitter.com/dhernangomez) sobre la creación de mapas con la librería `mapSpain` que será la que nos permita crear mapas de españa a distintos niveles, entre ellos mapas a nivel provincial mediante un código en R que no puede ser más sencillo:

```r
library(tidyverse)
library(mapSpain)
library(sf)

PROVINCIAS.sf <- esp_get_prov()
ggplot() + geom_sf(data=PROVINCIAS.sf, fill='grey80', color='blue')
```

![wp_editor_md_d0db9f978d1445a138badea49b807807.jpg](/images/2021/11/wp_editor_md_d0db9f978d1445a138badea49b807807.jpg)

Bajo el punto de vista del ahora escribiente el mejor y más sencillo mapa estático de España. La función `esp_get_prov` y dos líneas de código. Tenéis revisiones en el blog sobre ejemplos de uso.

## Obtención de los centroides

Todo pivota sobre la función `st_centroid` del paquete sf

```r
centroides <- `st_coordinates`(st_centroid(PROVINCIAS.sf$geometry))
centroides <- `data.frame`(centroides)

ggplot(centroides, aes(`X`, `Y`) + `geom_point`()
```

![wp_editor_md_e3ee44d5f94bba4b69586c3e06062e28.jpg](/images/2021/11/wp_editor_md_e3ee44d5f94bba4b69586c3e06062e28.jpg)

Cada punto marca el centro geográfico de cada provincia de España.

## Polígonos de Voronoi con sf

Aplicamos `st_voronoi` de `sf` para obtener los `polígonos`, destacar la necesidad de unir cada polígono generado para crear un objeto sf con `st_union`, sin ello no funciona.

```r
voronoi <- st_voronoi(st_union(st_centroid(PROVINCIAS.sf$geometry)))
ggplot() + geom_sf(data=voronoi, fill='grey80', color='blue')
```

![wp_editor_md_096a6b5cffb0e934cd4ca151fd6fba0e.jpg](/images/2021/11/wp_editor_md_096a6b5cffb0e934cd4ca151fd6fba0e.jpg)

Lo que sucede es que nos ha generado la división en `polígonos` de Voronoi en base al espacio que han creado las coordenadas geográficas y necesitamos que esas divisiones estén dentro del territorio de España.

## Los polígonos dentro del polígono

A continuación la motivación de la entrada. Acotamos esa representación gráfica a la geografía de España, el código en R no se complica mucho.

```r
ESPANIA.sf <- esp_get_country()
# ggplot() + geom_sf(data=ESPANIA.sf, fill='grey80', color='blue')

ggplot() + geom_sf(data= st_intersection(st_cast(voronoi), st_union(ESPANIA.sf)), fill='grey80', color='blue')
```

![wp_editor_md_8ebd3e270c48ece8db61d8f45fb1bd7f.jpg](/images/2021/11/wp_editor_md_8ebd3e270c48ece8db61d8f45fb1bd7f.jpg)

Ahora ya tenemos un mapa que se parece mucho a lo que deseamos, es claramente mejorable. La función de `sf` `st_intersection` hace que «crucemos» el objeto Voronoi con el objeto `ESPANIA.sf` y solo se representarán aquellos que estén dentro del polígono que intersecan ambos objetos. Por supuesto, esta es la `representación` gráfica, pero disponéis de `polígonos` con los que podréis hacer algún que otro análisis espacial.
