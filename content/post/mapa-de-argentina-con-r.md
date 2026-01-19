---
author: rvaquerizo
categories:
  - monográficos
  - r
  - trucos
date: '2015-07-09'
lastmod: '2025-07-13'
related:
  - mapas-municipales-de-argentina-con-r.md
  - mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
  - mapas-con-spatial-data-de-r.md
  - mapa-de-mexico-rapido-y-sucio-y-estatico-con-rstats.md
  - mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
tags:
  - mapas
  - sp
title: Mapa de Argentina con R
url: /blog/mapa-de-argentina-con-r/
---

Un lector necesita realizar un mapa de Argentina con R. El primer paso es descargar el mapa en formato R de la página web de siempre: <http://www.gadm.org/country> seleccionamos Argentina y el formato en R. Podéis descargar en otros formatos y trabajar con R, pero eso lo contaré otro día. Para ilustrar el ejemplo me he descargado el mapa de nivel 2, es decir, a nivel de Estado argentino. Una vez descargado el mapa empleamos el código de siempre:

library(sp)
library(RColorBrewer)

ub_argentina=»C:\\\\TEMP\\\\00 raul\\\\MAPA\\\\ARG_adm1.RData»

#Creamos los objetos de R
load(ub_argentina)
argentina=gadm

plot(argentina)

![argentina_R](/images/2015/07/argentina_R.png)

Es sencillo trabajar con el objeto y colorear en función de valores. Un ejemplo simplista:

```r
argentina$NAME_1
datos<-c(1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

plot(argentina,col=datos)
```

Pinta de negro el estado de Buenos Aires. A ver si dispongo de más tiempo y puedo desarrollar más esta entrada. Saludos.
