---
author: rvaquerizo
categories:
  - formación
  - mapas
  - python
  - r
date: '2020-12-28'
lastmod: '2025-07-13'
related:
  - mapa-estatico-de-espana-con-python.md
  - mapas-con-spatial-data-de-r.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
  - mapa-de-argentina-con-r.md
  - mapas-municipales-de-argentina-con-r.md
tags:
  - mapas
title: Mapas estáticos de Perú con R y Python a nivel de Distrito
url: /blog/mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito/
---

![mapa_peru_distritos2.png](/images/2020/12/mapa_peru_distritos2.png)

Petición de un lector: un código de ejemplo para hacer mapas de Perú con R y con `Python`. Estos ejemplos quedan resumidos en un solo sitio y se va a **emplear un notebook** desde `RStudio` donde tendremos bloques de R y `Python` en función de lo que necesitemos.

### Mapa de Perú con R y ggplot2

```r
library(tidyverse)
library(reticulate)
library(raster)
library(maptools)

# Obtenemos datos de GADM
peru_shp <- getData('GADM', country = 'Peru', level = 2)

# Convertimos a data frame para ggplot2
peru_df <- fortify(peru_shp, region = "NAME_2")

# Generamos datos aleatorios para ilustrar
distritos <- data.frame(id = unique(peru_df$id))
distritos$aleatorio <- runif(nrow(distritos), 10, 30)

# Unimos datos con el mapa
peru_plot <- left_join(peru_df, distritos, by = "id")

# Pintamos el mapa
ggplot(data = peru_plot, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = aleatorio)) +
  scale_fill_continuous(low = "white", high = "red") +
  theme_minimal()
```

Código conocido: obtenemos el mapa de `GADM` con **nivel 2** (distritos). Mediante `fortify` (o `map_data`) creamos el *data frame* que necesita `ggplot2`. En este caso genero unos datos aleatorios; en vuestro caso tendríais que cruzar vuestros datos (siempre es mejor emplear una codificación `INE` o similar en vez del nombre). El resultado:

![mapa_peru_distritos1.png](/images/2020/12/mapa_peru_distritos1.png)

### Mapa de Perú con Python desde notebook RStudio

Para este bloque suponemos que habéis instalado `reticulate` y que os funciona `Python` a la perfección desde `RStudio`.

Primero, preparamos el *shapefile* desde R:

```r
# raster::shapefile(peru_shp, "C:/temp/mapas/Peru/Peru.shp", overwrite = TRUE)
```

Ahora, el código en `Python`:

```python
import pandas as pd
import numpy as np
import geopandas as gpd
import matplotlib.pyplot as plt

# Ubicación del shapefile generado anteriormente
ub_shp = 'C:/temp/mapas/Peru/Peru.shp'

# Creación del GeoDataFrame
peru = gpd.read_file(ub_shp, encoding='utf-8')

# Generamos datos aleatorios por departamento (NAME_1)
estados = pd.DataFrame(peru.NAME_1.unique(), columns=['NAME_1'])
estados['aleatorio'] = np.random.randint(1, 20, size=len(estados))

# Cruzamos datos
peru_final = peru.merge(estados, on='NAME_1', how='left')

# Pintamos el mapa
mapa = peru_final.plot(column="aleatorio", linewidth=0.3, cmap="Reds", scheme="quantiles", k=8, alpha=0.7)
plt.title("Mapa de Perú por Departamentos")
plt.show()
```

Una vez tenemos el *shapefile*, creamos el *data frame* mediante `geopandas` y la función `read_file`. El proceso es análogo: se emplean datos aleatorios que posteriormente se cruzan y son los que se representan en el mapa estático de Departamentos de Perú con el que comienza esta entrada.

**Comentario**: los mapas son básicos estéticamente; yo os digo cómo hacer la estructura, vosotros dadle el formato final. Saludos.