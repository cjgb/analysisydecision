---
author: rvaquerizo
categories:
- Formación
- Mapas
- Python
- R
date: '2020-12-28T04:19:42-05:00'
lastmod: '2025-07-13T16:02:05.891175'
related:
- mapa-estatico-de-espana-con-python.md
- mapas-con-spatial-data-de-r.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- mapa-de-argentina-con-r.md
- mapas-municipales-de-argentina-con-r.md
slug: mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito
tags: []
title: Mapas estáticos de Perú con R y Python a nivel de Distrito
url: /mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito/
---

[![](/images/2020/12/mapa_peru_distritos2.png)](/images/2020/12/mapa_peru_distritos2.png)

Petición de un lector de un código de ejemplo para hacer mapas de Perú con R y con Python, perfectamente reproducible si seguimos algunas entradas del blog pero que, de este modo, quedan resumidos en un solo sitio. En este caso se va a **emplear un notebook** desde RStudio donde tendremos chunks de R y Python en función de lo que necesitemos. Podéis copiar y pegar directamente, debe salir lo mismo.

### Mapa de Perú con ggplot

```r
library(tidyverse)
library(reticulate)
library(raster)
library(maptools)

Peru <- getData('GADM', country='Peru', level=2)

Peruname = PeruNAME_2
Peru2 <- map_data(Peru)
provincias <- data.frame(region = unique(Peru2region))
provinciasaleatorio = runif(nrow(provincias), 10,30)

Peru2 <- left_join(Peru2,provincias)

ggplot(data = Peru2, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = aleatorio)) +
  scale_fill_continuous(low="white",high="red")
```
 

Código conocido obtenemos el mapa en formato rds de GADM con nivel 2 que es nivel de Distrito(corregidme si me equivoco) para emplear ggplot necesitamos el campo name que le creamos a partir de NAME_2, el nivel administrativo que queremos dar al mapa. Mediante map_data creamos el data frame que necesita ggplot donde el campo region corresponde al campo name del objeto rds. En este caso no busco datos, genero unos datos aleatorios a partir de los distintos distritos, en vuestro caso tendríais que cruzar datos, ojo, yo empleo el nombre, siempre es mejor emplear una codificación. El resultado:

[![](/images/2020/12/mapa_peru_distritos1.png)](/images/2020/12/mapa_peru_distritos1.png)

### Mapa de Perú con Python desde notebook RStudio

```r
# py_install("geopandas")
# py_install("mapclassify")
# py_install("pysal")
# py_install("descartes")

#dir.create("c:/temp/mapas/Peru/")
raster::shapefile(Peru, "c:/temp/mapas/Peru/Peru.shp", overwrite=T)
```
 
```r
import pandas as pd
import numpy as np
import geopandas as gpd
import matplotlib.pyplot as plt

# Ubicación shapefile
ub_shp = 'c:/temp/mapas/Peru/Peru.shp'

# Creación del data frame
peru = gpd.read_file(ub_shp, encoding='utf-8')
peru.head()
```
 
```r
estados = pd.DataFrame(peru.NAME_1.unique(), columns=['NAME_1'])
estados['aleatorio'] = np.random.randint(1,20,size=len(estados))
estados.head()
```
 
```r
peru = peru.merge(estados, how='left')

mapa = peru.plot(column="aleatorio", linewidth=0.3, cmap="Reds", scheme="quantiles", k=8, alpha=0.7)
plt.show()
```
 

Aquí suponemos que habéis instalado reticulate y que os funciona Python a la perfección desde RStudio. Hay un primer chunk `Crea_shp ` que va a crear el shp desde el rds que hemos descargado de GADM con la función de raster shapelife, recomiendo guardar en un directorio, por eso el dir.create. Ahora ya disponemos de un shapefile para trabajar en Python que nos hemos bajado de GADM mediante R, hay un paquete en Python que llama a la API pero no me funcionaba. Una vez tenemos el shp tenemos que crear el data frame mediante geopandas y la función read_file. En este caso estamos como antes, no se buscan datos, se emplean unos datos aleatorios que posteriormente se cruzan y son los que se representarán en el mapa estático de Departamentos de Peru con el que comienza esta entrada.

**Comentario** : los mapas son feos de solemnidad, yo os digo como hacerlo, vosotros dadle formato.