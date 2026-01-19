---
author: rvaquerizo
categories:
  - gráficos
  - mapas
  - monográficos
  - python
date: '2021-03-22'
lastmod: '2025-07-13'
related:
  - mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
  - mapa-estatico-de-espana-con-python.md
  - mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
  - incluir-subplot-en-mapa-con-ggplot.md
  - anadiendo-graficos-de-tarta-a-nuestros-mapas-de-ggplot-con-scatterpie.md
tags:
  - mapas
  - python
title: Animación de un mapa con Python. Porcentaje de vacunas administradas
url: /blog/animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas/
---

[![](/images/2021/03/animacion1.gif)](/images/2021/03/animacion1.gif)

Las animaciones con Python que mostramos hoy, al final, son animaciones con Image Magick pero esta entrada es un ejemplo de como podemos usar Python para la creación de gráficos que posteriormente generarán esa animación con las instrucciones concretas de Imagemagick (que tiene que estar instalado). La idea es realizar un mapa animado con el porcentaje de vacunas de COVID administradas.

### Obtención de datos

Los datos los descargamos directamente del github de datadista.

```r
import pandas as pd
import io
import requests
import geopandas as gpd
from shapely import affinity
import mapclassify

# Importación de datos
datadista = "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_vacunas.csv"

s = requests.get(datadista).content
df = pd.read_csv(io.StringIO(s.decode('utf-8')))

df[['Fecha publicación','Pct_dosis']].groupby('Fecha publicación').mean()
```

Podemos destacar la importación de un csv desde una url previa descarga con request.get y posterior uso de read_csv. Para el mapa empleamos uno de los [mapas de España de GADM](https://gadm.org/download_country_v3.html). Nos lo hemos descargado y vía geopandas podemos importar y usar:

```r
# trabajo con mapa
ub_shp = "///home/rvaquerizo/Escritorio/Mapas/gadm36_ESP_shp/gadm36_ESP_2.shp"
esp = gpd.read_file(ub_shp, encoding='utf-8')
```

En este punto es necesario establecer que campo servirá para cruzar los datos de datadista y los datos del mapa de GADM, vamos a usar CCAA y NAME_1 respectivamente. Como la vida no es fácil es necesaria una normalización de los datos y ya vemos que no es posible representar Ceuta y Melilla.

```r
esp['NAME_1'].unique()
df['CCAA'].unique()

import numpy as np
df.CCAA = np.where(df['CCAA']=='Canarias', 'Islas Canarias',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Castilla y Leon', 'Castilla y León',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Madrid', 'Comunidad de Madrid',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Navarra', 'Comunidad Foral de Navarra',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='C. Valenciana', 'Comunidad Valenciana',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Baleares', 'Islas Baleares',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Asturias', 'Principado de Asturias',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Murcia', 'Región de Murcia',df['CCAA'])
df.CCAA = np.where(df['CCAA']=='Castilla La Mancha', 'Castilla-La Mancha',df['CCAA'])
```

Por otro lado tenemos el habitual problema con los decimales y lo poco que pintamos los europeos en el ámbito de la innovación, es necesario cambiar la variable que queremos representar en el mapa de texto a numérico con decimales.

```r
df.rename(columns={'Porcentaje de dosis administradas por 100 habitantes': 'Pct_dosis'}, inplace=True)
df['Pct_dosis'] = pd.to_numeric(df['Pct_dosis'].str.replace(',','.'))
```

Para pasar de string a número se emplea una combinación de str.replace y pd.to_numeric además aprovechamos para renombrar la variable porque Porcentaje de dosis administradas por 100 habitantes es muy largo.

### Preparación del mapa

Nuestro mapa tiene las Islas Canarias muy separadas y eso da problemas a la hora de representar el gráfico, por este motivo es necesario mover las Islas Canarias, pegarlas más a la Península y así mejorar la visualización.

```r
esp_sin_canarias = esp[esp.NAME_1 != "Islas Canarias"]
canarias = esp[esp.NAME_1 == "Islas Canarias"]
canarias['geometry'] = canarias['geometry'].apply(affinity.translate, xoff=4.5, yoff=7)
esp2 = pd.concat([esp_sin_canarias, canarias])
esp2.plot()
```

Creamos un objeto sin las Islas Canarias y otro con las Islas. En el objeto con las Islas Canarias empleamos affinity.translate sobre la variable geometry para subir y poner a la derecha las Islas de forma que estén más pegadas a la Península. Por último, unimos el objeto sin las islas y Canarias de forma que disponemos del objeto necesario para realizar el mapa.

### Unión de datos con el mapa

Pequeña preparación de los datos para realizar la animación.

```r
df2 = df[['CCAA','Fecha publicación','Pct_dosis']]
esp2 = esp2.merge(df2, left_on=['NAME_1'],right_on=['CCAA'], how='left')

esp2[['NAME_1','Pct_dosis']].groupby('NAME_1').mean()

import matplotlib.pyplot as plt
rango = plt.Normalize(vmin=0, vmax=df['Pct_dosis'].max() + 5)
fechas = esp2['Fecha publicación'].unique()

plt.rcParams['figure.figsize'] = [12, 8]
```

Sólo se unen los datos necesarios, fecha y porcentaje de dosis administradas, que provocarán duplicidades por fecha de forma que tendremos para cada fecha y cada Comunidad Autónoma un porcentaje de dosis suministrada. Además, es necesario establecer un rango para colorear el mapa que sirva para todos los gráficos que posteriormente vamos a unir, esto lo hacemos con plt.Normalize y así todos tendrán la misma escala. También necesitamos todas las fechas y mediante plt.rcParams[‘figure.figsize’] cambiamos el tamaño de los mapas.

### Bucle para generar los mapas

En realidad lo más sencillo.

```r
i = 0
while i < len(fechas) - 1:
    esp3 = esp2[esp2['Fecha publicación']==fechas[i]]
    esp3.plot(column="Pct_dosis", linewidth=0.3, cmap="Reds", norm = rango)
    plt.axis('off')
    plt.title('Porcentaje de dosis suministradas a fecha ' + str(fechas[i]), fontsize=14)
    plt.savefig("///home/rvaquerizo/Escritorio/wordpress/animacion1/G" + str(fechas[i]) +".png", format="PNG")
    i += 1
```

Realizamos un mapa para cada fecha disponible, un objeto esp3 tiene el mapa con esa fecha y realizamos el mapa donde destacamos la opción norm que nos permite guardar la escala. El mapa no tiene ejes, va con títulos y guardamos en una ubicación determinada esos gráficos resultantes, **importante guardar en la misma ubicación y con un nombre que guarde el orden** este tema se da por supuesto pero luego llegan dudas.

### Creación de la animación

Por último, surgía un buen ejemplo de uso de subprocess para ejecutar shell desde Python pero no funcionó correctamente. Por ese motivo en el terminal nos dirigimos a la carpeta correspondiente y ejecutamos convert.

```r
cd /home/rvaquerizo/Escritorio/wordpress/animacion1/
convert -delay 20 -loop 0 *.png animacion1.gif
```

Resultado el gif con el que comienza la entrada.
