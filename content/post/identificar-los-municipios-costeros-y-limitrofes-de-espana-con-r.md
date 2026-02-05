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
title: Identificar los municipios costeros y limítrofes de España con R
url: /blog/identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r/
---

![municpios_limitrofes_costeros.png](/images/2020/04/municpios_limitrofes_costeros.png)

Otro ejercicio con *spatial data*, R y *data science* para el trabajo con objetos espaciales. El tema que traigo hoy puede ser útil para aquellos que, dado un *spatial data*, tienen que identificar los polígonos que bordean ese objeto; en este caso vamos a identificar los municipios que bordean España (ya sean limítrofes con Francia y Portugal o municipios costeros). No se plantean algoritmos complicados; como en entradas anteriores, nos centramos en la extracción de mapas de `GADM`.

### Obtención de los mapas necesarios

```r
library(maptools)
library(raster)
library(maps)
library(tidyverse)
library(sqldf)

# Obtenemos el mapa de España (level 0: contorno nacional)
Espania <- getData('GADM', country = 'Spain', level = 0)

# Obtenemos el mapa municipal (level 4)
Espania2 <- getData('GADM', country = 'Spain', level = 4)
```

Por un lado obtenemos el contorno nacional (`level 0`) y, por otro, la división municipal (`level 4`). Un tipo brillante sería capaz de encontrar un algoritmo que identificara qué polígonos no tienen adyacencia por algún lado, pero una aproximación más sencilla es: «si cruzo el borde con los municipios, los polígonos que coincidan son el exterior».

### Municipios del contorno

```r
# Extraemos puntos del contorno redondeando coordenadas para facilitar el cruce
contorno_puntos <- fortify(Espania) %>% 
  mutate(lat2 = round(lat, 1), long2 = round(long, 1)) %>% 
  select(long2, lat2)

# Extraemos puntos de los municipios con el mismo redondeo
municipios_puntos <- fortify(Espania2) %>% 
  mutate(lat2 = round(lat, 1), long2 = round(long, 1)) %>% 
  select(long2, lat2, id) # 'id' identifica al municipio

# Cruce para identificar puntos coincidentes
coincidencias <- inner_join(municipios_puntos, contorno_puntos, by = c("long2", "lat2"))
```

En este punto hay aspectos mejorables: el cruce se realiza por latitud y longitud. Difícilmente encajarán al decimal los dos objetos espaciales, así que se opta por redondear a un decimal tanto la longitud como la latitud. Ésto provoca duplicados y un objeto de gran tamaño. Por ello es necesario seleccionar registros únicos por municipio:

```r
# Identificamos municipios que tienen puntos en el contorno
contorno_final <- coincidencias %>% 
  distinct(id) %>% 
  mutate(exterior = 1)
```

Lo pongo en dos objetos para que lo veáis mejor. Advertencia: este paso puede tardar un poco dependiendo del volumen de puntos. Ahora `contorno_final` tiene los identificadores de los municipios que bordean España.

### Representación final

```r
# Unimos con los datos del mapa completo
Espania2_df <- fortify(Espania2)
municipios_mapa <- left_join(Espania2_df, contorno_final, by = "id")

# Pintamos el mapa
ggplot(data = municipios_mapa, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = as.factor(exterior))) +
  scale_fill_manual(values = c("1" = "red"), na.value = "white") +
  theme_minimal() +
  labs(title = "Municipios costeros y limítrofes de España")
```

Y así tenéis el mapa resultante. Con poco esfuerzo podréis separar los municipios limítrofes con Francia de los de Portugal o los costeros basándoos en sus coordenadas. Saludos.