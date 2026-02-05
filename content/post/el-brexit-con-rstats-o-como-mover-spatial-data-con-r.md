---
author: rvaquerizo
categories:
  - formación
  - mapas
  - r
date: '2016-08-10'
lastmod: '2025-07-13'
related:
  - mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
  - mover-elementos-de-un-mapa-con-qgis-ejemplo-mover-canarias.md
  - animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
  - identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
  - mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
tags:
  - animaciones
  - animation
  - maptools
  - spatial data
  - mapas
title: El brexit con rstats o como mover spatial data con R
url: /blog/el-brexit-con-rstats-o-como-mover-spatial-data-con-r/
---

![bye_england](/images/2016/08/bye_england.gif)

Animación con R para ilustrar el uso de la función `elide` del paquete `maptools`, con un código "insultantemente" sencillo:

```r
library(maptools)
library(animation)

# Mapa descargado de:
# http://www.arcgis.com/home/item.html?id=6d611f8d87d54227b494d4c3becef6a0

ub_shp <- "/Users/raulvaquerizo/Desktop/R/mapas/world/MyEurope.shp"
europa <- readShapeSpatial(ub_shp)
plot(europa)

europa_sin_uk <- europa[europa$FIPS_CNTRY != "UK", ]
uk <- europa[europa$FIPS_CNTRY == "UK", ]

saveGIF({
  for (i in seq(0, 5, by = 0.1)) {
    plot(europa_sin_uk)
    uk_desplazado <- elide(uk, shift = c(-i, 1))
    plot(uk_desplazado, add = TRUE)
  }
}, interval = 0.3, movie.name = "/Users/raulvaquerizo/Desktop/R/animaciones/brexit/bye_england.gif")
```

Nos descargamos el mapa del link que os pongo y poco más que leer el *shape* con `readShapeSpatial` y crear dos objetos: uno con Europa sin la isla y otro con la isla. `elide` nos permite desplazar un objeto de *spatial data* dentro del gráfico; lo metemos en un bucle y *bye England*. Ahora, el que me mueva las Canarias en un shapefile con más de 2 líneas de código me paga una cervecita. Saludos.