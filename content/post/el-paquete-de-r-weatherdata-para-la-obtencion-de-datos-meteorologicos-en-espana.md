---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2016-08-03T06:47:39-05:00'
lastmod: '2025-07-13T15:57:07.137264'
related:
- paquete-opendataes-en-ropenspain-para-acceder-a-los-datos-de-datos-gob-es-con-r.md
- un-repaso-a-los-paquetes-de-r-solar-chron-directlabels-y-graficos-de-densidades-con-lattice.md
- libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
- mapas-municipales-de-argentina-con-r.md
- manual-curso-introduccion-de-r-capitulo-4-contribuciones-a-r-paquetes.md
slug: el-paquete-de-r-weatherdata-para-la-obtencion-de-datos-meteorologicos-en-espana
tags:
- weatherData
title: El paquete de R weatherData para la obtención de datos meteorológicos en España
url: /blog/el-paquete-de-r-weatherdata-para-la-obtencion-de-datos-meteorologicos-en-espana/
---

Tenía pendiente un proyecto con modelos de Lee Carter y el paquete **weatherData** de R (¡toma!) pero como no lo voy a llevar a cabo nunca os traigo a estas líneas un paquete más que interesante de R que nos permite obtener datos de las **estaciones meteorológicas de los aeropuertos del mundo** (<https://www.wunderground.com/history/airport/>) y encima te lo pone como un objeto de R, qué más podemos pedir. [En github tenéis una completa batería de ejemplos de uso](http://ram-n.github.io/weatherData/). En el caso de que necesitemos descargar información meteorológica de España tenemos que irnos a <http://weather.rap.ucar.edu/surface/stations.txt> donde están listados todos los aeropuertos que recoge este sistema de información, buscamos SPAIN y nos interesa el «ICAO» que es el _International Civil Aviation Organization_ , el código del aeropuerto vamos. Con estas premisas si quiero recoger las temperaturas de 2015 del aeropuerto de Albacete:

```r
install.packages("weatherData")
library(weatherData)

anio = getWeatherForYear("LEAB",2015)
```


La información de los aeropuertos es bastante completa y están distribuidos por toda la geografía nacional además tenemos muchos datos a nuestra disposición y bien tabulados. Yo conozco más de uno que se está acordando de mi por no haber escrito sobre este paquete unos meses antes. Saludos.