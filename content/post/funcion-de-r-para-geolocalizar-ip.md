---
author: rvaquerizo
categories:
- R
date: '2016-12-28T07:05:40-05:00'
lastmod: '2025-07-13T15:57:54.530130'
related:
- obtener-las-coordenadas-de-una-direccion-con-r-y-la-api-de-google-earth.md
- paquete-opendataes-en-ropenspain-para-acceder-a-los-datos-de-datos-gob-es-con-r.md
- mapa-de-codigos-postales-con-r-aunque-el-mapa-es-lo-de-menos.md
- mapas-municipales-de-argentina-con-r.md
- mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
slug: funcion-de-r-para-geolocalizar-ip
tags: []
title: Función de R para geolocalizar IP
url: /funcion-de-r-para-geolocalizar-ip/
---

[El proyecto freegeoip](https://github.com/fiorix/freegeoip) tiene su propia función en R para poder crea un data frame con la geolocalización de las ips. [La función la podéis encontrar en este enlace](https://github.com/luiscape/freegeoip/blob/master/R/freegeoip.R) y tiene un funcionamiento muy sencillo:

[source languaje=»R»]  
library(rjson)

localizacion1<-freegeoip(‘23.89.204.150’)

localizacion2<-freegeoip(c(‘106.78.232.100′,’174.6.153.88’))  
[/source]

Resulta que no recordaba su existencia y ya tenía algo parecido en XML… pero siempre hay alguien que lo ha hecho antes con R. Saludo.