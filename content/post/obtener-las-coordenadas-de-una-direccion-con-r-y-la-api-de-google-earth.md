---
author: rvaquerizo
categories:
  - mapas
  - r
date: '2021-09-06'
lastmod: '2025-07-13'
related:
  - funcion-de-r-para-geolocalizar-ip.md
  - paquete-opendataes-en-ropenspain-para-acceder-a-los-datos-de-datos-gob-es-con-r.md
  - identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
  - archivos-shape-y-geojason-para-crear-un-mapa-de-espana-por-codigos-postales.md
  - libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
tags:
  - mapas
  - r
title: Obtener las coordenadas de una dirección con R y la API de Google Earth
url: /blog/obtener-las-coordenadas-de-una-direccion-con-r-y-la-api-de-google-earth/
---

Obtener coordenadas desde la API de Google Maps a partir de una dirección consiste en realizar la petición a la API y obtener un json pero tenemos la suerte de contar con R y ese proceso le podemos hacer de forma más sencilla e incluso le podemos tabular. En realidad son 4 líneas de código pero es posible que a alguien le sean de utilidad. Lo primero es disponer de un proyecto en la [Google Cloud Plattform](https://console.cloud.google.com/) si ya lo tenemos lo que necesitamos es autorizar a este proyecto a acceder a la API de Google Maps, [para ello yo he usado este enlace](https://www.loopeando.com/google-maps-platform-rejected-your-request-an-internal-error-was-found-for-this-api/) y he habilitado la Geocoding API, la que vamos a usar para la consulta de la dirección.

En este punto disponemos de un proyecto habilitado para conectar a la API que nos va a facilitar las coordenadas, necesitamos nuestra API Key que podemos ver en credenciales. Nuestras líneas con R se van a limitar:

```r
# install.packagest('ggmap')
library(ggmap)
register_google("[API key]")

coordenadas <- geocode("Calle Murga 15 El Molar Madrid", output = "latlona", source = "google")
```

Así de sencillo y en este punto os podéis imaginar, podemos pasar una lista o un data frame y realizar un bucle para obtener las coordenadas y que éstas se guarden en un data frame. Dando una vuelta de tuerca podemos obtener el código postal:

```r
coordenadas <- geocode("Paseo Castellana 259 Madrid", output = "more", source = "google")
coordenadascodpostal = regmatches(coordenadasaddress,
                                   gregexpr('(?<!\\d)\\d{5}(?:[ -]\\d{4})?\\b', coordenadas$address, perl=T))
```

Una tontería pero que puede ser útil para algunos. Saludos.
