---
author: rvaquerizo
categories:
  - formación
  - gráficos
  - mapas
  - r
date: '2020-11-18'
lastmod: '2025-07-13'
related:
  - incluir-subplot-en-mapa-con-ggplot.md
  - mapa-estatico-de-espana-con-python.md
  - mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
  - animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
tags:
  - geom_scatterpie
  - mapas
title: Añadiendo gráficos de tarta a nuestros mapas de ggplot con scatterpie
url: /blog/anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie/
---

![](/images/2020/11/piechart_mapa1.png)

Los gráficos de tarta o *pie charts* [tienen algunos peligros](https://www.data-to-viz.com/caveat/pie.html) y el ahora escribiente no es muy partidario de su uso; sin embargo, la librería `scatterpie` facilita mucho su realización en R y quería traer al blog un método más o menos sencillo para entender cómo hacer el gráfico y cómo disponer los datos.

## Obtención del mapa

Se comienza por obtener un mapa por comunidades autónomas con `raster` que a los seguidores de los artículos de R del blog les será familiar:

```r
library(scatterpie)
library(tidyverse)
library(raster)

# Descargamos el mapa de España (level 1: comunidades)
espania_shp <- getData('GADM', country = 'Spain', level = 1)

# Convertimos a data frame para ggplot2
mapa.comunidades <- fortify(espania_shp, region = "NAME_1")
```

Se obtiene el objeto de `GADM`. Para crear un *data frame* que emplear en `ggplot2` necesitamos un campo identificador que la función `fortify()` (o `map_data()`) transformará en `id`. Recomiendo usar como identificador códigos `INE` porque los nombres de las comunidades autónomas a veces dan problemas de codificación.

## Pintar un mapa base

A la hora de pintar el mapa se va a emplear `geom_map()`, aunque habitualmente se use `geom_polygon()`:

```r
# Desplazamos Canarias (opcional, para visualización)
mapa.comunidades <- mapa.comunidades %>% mutate(
  lat = ifelse(id == 'Islas Canarias', lat + 6, lat),
  long = ifelse(id == 'Islas Canarias', long + 6, long)
)

mapa_base <- ggplot(data = mapa.comunidades, aes(x = long, y = lat)) +
  geom_map(map = mapa.comunidades, aes(map_id = id), fill = NA, color = "grey50") +
  labs(title = "Mapa base") +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

mapa_base
```

![mapa_base](/images/2020/11/piechart_mapa2.png)

Como sabéis, `ggplot2` es perfectamente modulable y podéis elegir colores de fondo, de línea, ubicación de títulos… En estos gráficos temáticos se recomienda eliminar los ejes.

## Datos para los `piechart`

Para las tartas vamos a simular datos. En el ejemplo realizaremos una tarta para cada comunidad y el tamaño de la tarta tendrá una escala determinada.

```r
# Datos simulados por comunidad
comunidades <- data.frame(id = unique(mapa.comunidades$id))
comunidades$proporcion_1 <- round(runif(nrow(comunidades)), 2)
comunidades$proporcion_2 <- 1 - comunidades$proporcion_1

# Escala para el tamaño de cada tarta
comunidades$escala <- rpois(nrow(comunidades), 2) + 1

# Ubicamos cada tarta en el punto medio de cada comunidad
ubicacion <- mapa.comunidades %>% 
  group_by(id) %>% 
  summarise(lat = mean(lat), long = mean(long))

comunidades <- left_join(comunidades, ubicacion, by = "id")
```

Ahora el *data frame* `comunidades` tiene la posición (`lat`, `long`) y los datos para cada tarta.

## Mapa final con `geom_scatterpie()`

El mapa con el que comienza la entrada se realiza con este sencillo código:

```r
mapa_final <- mapa_base + 
  labs(title = "Gráficos de tarta sobre el mapa") +
  geom_scatterpie(data = comunidades, 
                  aes(x = long, y = lat, group = id, r = escala/2),
                  cols = c('proporcion_1', 'proporcion_2')) +
  scale_fill_manual(values = c("proporcion_1" = "skyblue", "proporcion_2" = "orange")) +
  theme(legend.position = "bottom")

mapa_final
```

`geom_scatterpie()` necesita los datos, la posición, el grupo (la región) y el radio (`r`). En `cols` especificamos las variables a representar en las porciones. Es una solución visual potente, a pesar de las críticas habituales a los gráficos de tarta. Saludos.