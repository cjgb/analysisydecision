---
author: rvaquerizo
categories:
- Formación
- Gráficos
- Mapas
- R
date: '2020-11-18T06:34:08-05:00'
lastmod: '2025-07-13T15:53:54.532238'
related:
- incluir-subplot-en-mapa-con-ggplot.md
- mapa-estatico-de-espana-con-python.md
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
slug: anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie
tags:
- geom_scatterpie
title: Añadiendo gráficos de tarta a nuestros mapas de ggplot con scatterpie
url: /anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie/
---

[![](/images/2020/11/piechart_mapa1.png)](/images/2020/11/piechart_mapa1.png)

Los gráficos de tarta o pie charts [tienen algunos peligros](https://www.data-to-viz.com/caveat/pie.html) y el ahora escribiente no es muy partidario de su uso, sin embargo la librería scatterpie facilita mucho su realización en R y quería traer al blog un método más o menos sencillo para entender como hacer el gráfico y como disponer los datos. 

## Obtención del shp con el mapa

Se comienza por realizar un mapa sin nada con ggplot y raster que a los seguidores de los artículos de R del blog les será familiar:

```r
library(scatterpie)
library(tidyverse)
library(raster)

Espania <- getData('GADM', country='Spain', level=1)
Espanianame = EspaniaNAME_1

mapa.comunidades <- map_data(Espania)
```
 

Se obtiene el shp con el mapa por Comunidades de GADM, el nivel de Comunidad Autónoma es el 1, para crear un data frame que emplear en ggplot necesitamos un campo name que la función map_data transformará en region, en este paso recomiendo usar como name el campo que más sencillo sea de cruzar, habitualmente códigos porque los nombres de las Comunidades Autónomas son un follón. En este caso si se emplea el nombre para entender mejor los datos necesarios para crear los gráficos de bolas y que el código sea reproducible (con las cositas del wordpress). 

## Pintar un mapa sin nada

A la hora de pintar el mapa se va a emplear geom_map, habitualmente se usa geom_polygon:

```r
mapa.comunidades <- mapa.comunidades %>% mutate(lat=case_when(
  region %in% c('Islas Canarias') ~ lat + 6,
  TRUE ~ lat),
  long=case_when(
    region %in% c('Islas Canarias') ~  long + 6,
    TRUE ~long))

mapa <- ggplot(data = mapa.comunidades, aes(x = long, y = lat)) +
  geom_map (map= mapa.comunidades, aes(map_id=region), fill=NA, color="grey50") +
  labs(title = "Mapa sin nada") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
mapa
```
 

[![](/images/2020/11/piechart_mapa2.png)](/images/2020/11/piechart_mapa2.png)

Como sabéis ggplot es perfectamente modulable y podéis elegir colores de fondo, colores de línea, ubicación de títulos,… muchas veces tantas posibilidades pueden provocar que nos perdamos. Si recomiendo en estos gráficos eliminar los ejes y los textos de los ejes. 

## Datos para los piechart

Para las tartas se prefiere simular datos. En el ejemplo vamos a realizar una tarta para cada comunidad y el tamaño de la tarta tendrá una escala determinada.

```r
#Datos por comunidad
comunidades <- data.frame(region = unique(mapa.comunidadesregion))
comunidadesproporcion_1 <- round(runif(nrow(comunidades)),2)
comunidadesproporcion_2 <- 1 - comunidadesproporcion_1

#Nos inventamos una escala para el tamaño de la bola
comunidades$escala <- rpois(nrow(comunidades), 2) + 1
```
 

Cada comunidad autónoma tiene 2 proporciones y se crea un campo escala para definir el radio del gráfico de tarta, los datos tienen que tener disposición de columna. Ahora se ha de ubicar cada piechart dentro del mapa y para ello se opta por una solución sencilla, ubicarla en el punto medio por Comunidad Autónoma:

```r
#Necesitamos ubicar cada comunidad, en el centro del objeto
ubicacion <- mapa.comunidades %>% group_by(region) %>% summarise(lat=mean(lat), long=mean(long))

comunidades <- left_join(comunidades, ubicacion)
```
 

Ahora el data frame comunidades tiene una latitud y una longitud para ubicar cada piechart. Ahora sólo es necesario realizar el mapa.

## Mapa final

Y el mapa con el que comienza la entrada se realiza con este sencillo código:

```r
mappie <- mapa + labs(title = "No uséis bolas") +
  geom_scatterpie(data = comunidades, aes(x=long, y=lat, group = region, r = escala/50 * 6),
                  cols = c('proporcion_1', 'proporcion_2'),
                  legend_name = "Leyenda")

mappie
```
 

geom_scatterpie necesita los datos, la posición y la region, el tamaño, el radio del gráfico lo especificamos con r y siempre irá multiplicado por 6 (por temas de escala). En cols es necesario especificar las variables a representar, en este caso solo tenemos 2 proporciones, son pocos parámetros complejos y la solución no es mala si no fuera por que se tratan de gráficos de tarta. Saludos.