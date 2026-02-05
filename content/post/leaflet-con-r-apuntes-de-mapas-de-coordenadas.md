---
author: rvaquerizo
categories:
  - formación
  - mapas
  - r
date: '2021-06-10'
lastmod: '2025-07-13'
related:
  - rstats-shiny-leaftlet-mapas-interactivos.md
  - anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie.md
  - incluir-subplot-en-mapa-con-ggplot.md
  - libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
  - mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
tags:
  - leaflet
  - mapas
title: Leaflet con R. Apuntes de mapas de coordenadas
url: /blog/leaflet-con-r-apuntes-de-mapas-de-coordenadas/
---

Estoy desarrollando cosas muy interesantes con `leaflet` en R y quería poner unos breves apuntes por si a alguien le sirvieran. En Stack Overflow y otras webs al uso tenéis mucha más ayuda y código de mayor interés, pero en pocas líneas espero sentar las bases de uso de `leaflet`. Para ilustrar el ejemplo, me he [descargado unos datos de datos.gob.es](https://datos.gob.es/en/catalogo?publisher_display_name=Ayuntamiento+de+Madrid&theme_id=seguridad) con las coordenadas de los parques de bomberos de Madrid capital; la idea es representar estos puntos en un mapa. Lo primero es descargar los datos y ponerlos en una ubicación de nuestro equipo:

```r
library(dplyr)
bomberos <- read.csv("C:\\temp\\211642-0-bomberos-parques.csv", sep = ';')
bomberos <- bomberos %>% select(NOMBRE, LATITUD, LONGITUD)
```

Nos hemos quedado sólo con las variables que nos interesa representar en el mapa de `leaflet` que vamos a crear con este sencillo código:

```r
library(leaflet)

# Creación de icono personalizado
icono <- makeIcon(iconUrl = "https://www.freeiconspng.com/uploads/burn-burning-fire-flame-heat-icon--icon-search-engine-20.png",
                  iconWidth = 18, iconHeight = 18)

leaflet(data = bomberos) %>%
  addTiles() %>%
  setView(lng = mean(bomberos$LONGITUD),
          lat = mean(bomberos$LATITUD),
          zoom = 10) %>%
  addProviderTiles(providers$Stamen.TonerLite,
                   options = providerTileOptions(noWrap = FALSE)) %>%
  addMarkers(lat = ~LATITUD,
             lng = ~LONGITUD,
             label = ~NOMBRE,
             icon = icono)
```

Por partes:

- **Icono personalizado**: mediante `makeIcon` leemos de una web con iconos gratis.
- **`leaflet()`**: empezamos a hacer un mapa con nuestro *tidy code*.
- **`addTiles()`**: nos permite ir añadiendo elementos a nuestro mapa.
- **`setView()`**: centra el mapa en unas coordenadas; en este caso empleamos la media de la latitud y la longitud de los parques de bomberos.
- **`addProviderTiles()`**: añade una capa a nuestro mapa en función de los distintos proveedores; yo siempre trabajo con esta capa por la claridad, hay muchas.
- **`addMarkers()`**: es la parte más interesante, porque es la que nos permite añadir una marca en función de la latitud y la longitud; etiquetamos la marca con el nombre del parque de bomberos y como icono usamos el que creamos con la función `makeIcon`.

Resultado más que digno con pocas líneas de código:

![](/images/2021/06/leaflet1.png)
