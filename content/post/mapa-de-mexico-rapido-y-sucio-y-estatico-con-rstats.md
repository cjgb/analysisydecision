---
author: rvaquerizo
categories:
- Formación
date: '2019-01-31T15:31:51-05:00'
lastmod: '2025-07-13T16:01:50.883126'
related:
- mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
- mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
- mapa-de-argentina-con-r.md
- mapas-municipales-de-argentina-con-r.md
- mapas-con-spatial-data-de-r.md
slug: mapa-de-mexico-rapido-y-sucio-y-estatico-con-rstats
tags: []
title: 'Mapa de México rápido (y sucio) y estático con #rstats'
url: /blog/mapa-de-mexico-rapido-y-sucio-y-estatico-con-rstats/
---

[![](/images/2019/01/mexico_quick_rstats.png)](/images/2019/01/mexico_quick_rstats.png)

No sabía como mostraros el funcionamiento de getData del paquete raster para tener que evitaros ir a GADM y descargar los correspondientes mapas. Bueno, pues se me ha ocurrido hacer una entrada que tenga el menor número de líneas posibles y que genere un mapa. No me lo tengáis mucho en cuenta:

```r
library(ggplot2)
library(raster)
library(dplyr)

#Obtenemos el mapa de GADM
mex <- getData("GADM", country = "MX", level = 2)

#El dato que vamos a pintar
prov <- data.frame(region=unique(mex@dataNAME_2))
provaleatorio <- runif(nrow(prov),0,100)

#Creamos el objeto mapa al que le añadimos el dato que necesitamos pintar
mex@dataname = mex@dataNAME_2
mex <- map_data(mex)
mex <- left_join(mex,prov)

#Pintamos el mapa
ggplot(data = mex, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = aleatorio)) +
  scale_fill_continuous(low="white",high="blue") +
  labs(title = "Quick and dirty") +
  theme_void()
```


Ahí lo tenéis getData se conecta a GADM donde vía ISO 3 le decimos que mapa queremos y el nivel que queremos y pintamos un mapa de México con ggplot2 en un pis pas. Comentad si no entendéis algo, hay miles de entradas que hacen lo mismo de forma más detallada pero en menos líneas ninguna. Saludos.