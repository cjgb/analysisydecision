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

Estoy desarrollando cosas muy interesantes con leaftlet en R y quería poner unos breves apuntes por si a alguien le sirvieran. En Stackoverflow y otras webs al uso tenéis mucha más ayuda y código de mayor interés pero en pocas líneas espero sentar las bases de uso de leaflet. Para ilustrar el ejemplo me he [descargado unos datos de datos.gob](https://datos.gob.es/en/catalogo?publisher_display_name=Ayuntamiento+de+Madrid&theme_id=seguridad) con las coordenadas de los parques de bomberos de Madrid Capital, la idea es representar estos puntos en un mapa. Lo primero es descargar los datos y ponerlos en una ubicación de nuestro equipo:

```r
bomberos <- read.csv("C:\\temp\\Personales\\wordpress\\211642-0-bomberos-parques.csv", sep=';')

bomberos <- bomberos %>% select(NOMBRE, LATITUD, LONGITUD)
```

Nos hemos quedado sólo con las variables que nos interesa representar en el mapa de leaflet que vamos a crear con este sencillo código que posteriormente os resumo:

```r
library(leaflet)

icono <- makeIcon(iconUrl = "https://www.freeiconspng.com/uploads/burn-burning-fire-flame-heat-icon--icon-search-engine-20.png", iconWidth = 18, iconHeight = 18)

leaflet() %>%
  addTiles() %>%
  setView( lng = mean(bomberosLONGITUD) ,
         lat = mean(bomberosLATITUD), zoom = 10) %>%
  addProviderTiles(providersStamen.TonerLite,
                   options = providerTileOptions(noWrap = F)) %>%
  addMarkers(lat = bomberosLATITUD, lng = bomberosLONGITUD, label = bomberosNOMBRE, icon = icono)
```

Por partes:

- Creación del icono personalizado mediante makeIcon y leemos de una web con iconos gratis como es freeiconspng
- leaflet() y empezamos a hacer un mapa con nuestro «tidycode»
- addTiles() nos permite ir añadiendo elementos a nuestro mapa
- setView centra el mapa en unas coordenadas, en este caso empleamos la media de la latitud y la longitud de los parques de bomberos
- addProviderTiles añade una capa a nuestro mapa en función de los distintos proveedores, yo siempre trabajo con esta capa por la claridad, hay muchas.
- addMarkers es la parte más interesante porque es la que nos permite añadir una marca en función de la latitud y la longitud, etiquetamos la marca con el nombre del parque de bomberos y como icono usamos el que creamos con la función makeIcon

Resultado más que digno con pocas líneas de código:

[![](/images/2021/06/leaflet1.png)](/images/2021/06/leaflet1.png)
