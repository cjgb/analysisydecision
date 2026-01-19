---
author: rvaquerizo
categories:
  - business intelligence
  - formación
  - modelos
  - r
  - trucos
date: '2020-04-27'
lastmod: '2025-07-13'
related:
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
  - mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
  - mapa-estatico-de-espana-con-python.md
  - adyacencia-de-poligonos-con-el-paquete-spdep-de-r.md
  - mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
tags:
  - maps
  - raster
  - sp
title: Identificar los municipios costeros y limítrofes de España con R.
url: /blog/identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r/
---

[![](/images/2020/04/municpios_limitrofes_costeros.png)](/images/2020/04/municpios_limitrofes_costeros.png)

Otro ejercicio con spatial data R Rstats y data sciense para el trabajo con objetos espaciales en el ecosistema big data. Empiezo con frase ilógica y ridícula para mejorar las búsquedas de Google pero el tema que traigo hoy creo que puede ser útil para aquellos que, dado un spatial data, tienen que identificar los polígonos que bordean ese objeto, en este caso vamos a identificar los municipios que bordean España, pueden ser limítrofes con Francia y Portugal o bien municipios costeros. No se plantean algoritmos complicados, como en entradas anteriores nos centramos en la extracción de mapas de GADM:

### Obtención de los mapas necesarios

```r
library(maptools)
library(raster)
library(maps)
library(tidyverse)
library(sqldf)

Espania <- getData('GADM', country='Spain', level=0)
Espania$name = Espania$NAME_1
Espania2 <- getData('GADM', country='Spain', level=4)
Espania2$name = Espania$NAME_1
```

Por un lado obtenemos el mapa de España sin división territorial que en GADM es el nivel 0 y por otro lado el municipal que es nivel 4. Un tipo brillante sería capaz de encontrar un algoritmo que identificara que polígonos no tienen adyacencia, pero un tipo mediocre pensaría "si cruzo el borde con los municipios, los objetos que crucen son el exterior"

### Municipios del contorno

```r
contorno <- map_data(Espania) %>% mutate(lat2=round(lat,1), long2=round(long,1)) %>% select(long2,lat2)

municipios <- map_data(Espania2) %>% mutate(lat2=round(lat,1), long2=round(long,1))  %>% select(long2,lat2,region)

contorno <- inner_join(municipios, contorno)
```

En este punto hay aspectos claramente mejorables, el cruce se realiza por latitud y longitud,

dificilmente encajarán al decimal los dos objetos espaciales así que se opta por redondear a un decimal tanto la longitud como la latitud, y esto provoca, como os podéis imaginar, duplicados y un objeto con un tamaño que tiembla el misterio. Por ello es necesario seleccionar registros únicos por longitud, latitud y el campo region que es el que nos identifica el municipio:

```r
contorno <- sqldf("select distinct * from contorno")

contorno2 <- contorno %>% group_by(region) %>% filter(row_number()==n()) %>% mutate(exterior=1) %>%
  as_tibble() %>% select(region,exterior)
```

Lo pongo en dos objetos para que lo veáis mejor y una advertencia sobre este paso, tarda unos minutos porque elimina duplicados de un "quasi-producto-cartesiano". Pero resulta que contorno2 tiene los municipios que bordean el objeto España:

```r
municipios <- map_data(Espania2)
municipios <- left_join(municipios,contorno2)

ggplot(data = municipios, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = exterior)) +
  scale_fill_continuous(low="white",high="red")
```

Y así tenéis el mapa resultante. Con poco talento podréis obtener los municipios limítrofes con Francia y los municipios limítrofes con Portugal. Otro día lo pondré, estoy reduciendo los tiempos de lectura del blog y no debo venirme arriba. Saludos.
