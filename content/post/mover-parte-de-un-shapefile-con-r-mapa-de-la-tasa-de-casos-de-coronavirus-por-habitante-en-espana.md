---
author: rvaquerizo
categories:
  - business intelligence
  - formación
  - mapas
  - monográficos
  - r
date: '2020-04-23'
lastmod: '2025-07-13'
related:
  - animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
  - mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
  - mapa-estatico-de-espana-con-python.md
  - libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
  - mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
tags:
  - elide
  - maptools
  - raster
  - shapefile
  - mapas
title: Mover parte de un shapefile con R. Mapa con tasa de casos de coronavirus por habitante en España
url: /blog/mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana/
---

![](/images/2020/04/coronavirus21.png)

Si leéis habitualmente el blog, ya conocéis la [entrada sobre el mapa del COVID por comunidades autónomas](https://analisisydecision.es/mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats/) y estaréis de acuerdo conmigo en que el mapa de España representado con `Rstats` es feo de solemnidad. Pero el código es «sencillo»; por ahí se ve cada representación que requiere ser desarrollador de R cinturón negro. 

Bueno, los torpes empleamos `ggplot2` con `geom_polygon()`, pero podemos empezar a complicar el mapa añadiendo nuevas posibilidades. La que os traigo hoy es muy interesante en el caso de España: se trata de mover las Islas Canarias en el mapa de comunidades autónomas, pero directamente con R. [Ya tenemos hecho un mapa con QGIS en otra entrada](https://analisisydecision.es/mover-elementos-de-un-mapa-con-qgis-ejemplo-mover-canarias/), pero ahora vamos a mover esa parte del `shapefile` directamente con R y la función `elide()`, como hemos hecho en otra ocasión.

### Población por comunidad autónoma de `datosmacro.expansion.com`

```r
library(rvest)
library(xml2)
library(lubridate)
library(tidyverse)
library(tabulizer)
library(tm)

# Función para limpiar números
numerea <- function(x) { as.numeric(sub(",", ".", x)) }

url <- 'https://datosmacro.expansion.com/demografia/poblacion/espana-comunidades-autonomas'

# Web scraping básico
poblacion_web <- url %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="tb1"]') %>%
  html_table()
poblacion <- poblacion_web[[1]]

# Limpieza de datos
poblacion <- poblacion[, -4] %>% 
  mutate(CCAA = removePunctuation(CCAA),
         CCAA = substr(CCAA, 1, nchar(CCAA) - 1),
         habitantes = numerea(removePunctuation(Población))) %>%
  rename(region = CCAA) %>% 
  as_tibble()

poblacion <- poblacion[, c(1, 5)] %>% 
  mutate(region = case_when(
    region == "Comunidad Valenciana" ~ "C. Valenciana",
    region == "Castilla La Mancha" ~ "Castilla-La Mancha",
    region == "Islas Baleares" ~ "Baleares",
    TRUE ~ region
  ))
```

Nada innovador; si queréis entender mejor qué hace, id a la primera de las páginas antes mencionadas.

### Tabla de casos de COVID-19 y mapa de GADM

```r
library(maptools)
library(raster)
library(maps)

# Datos de Datadista
datadista <- "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos.csv"
tabla_ccaa <- read.csv2(datadista, sep = ',', encoding = 'UTF-8', check.names = FALSE)

# Descarga del mapa de España (nivel 1: comunidades)
espania <- getData('GADM', country = 'Spain', level = 1)
```

Es necesario mencionar y rendir homenaje a `Datadista` y su trabajo.

### Mover Canarias con `elide()`

```r
# Separamos Canarias del resto de España
espania_sin_canarias <- espania[espania$NAME_1 != 'Islas Canarias', ]
canarias <- espania[espania$NAME_1 == 'Islas Canarias', ]

# Desplazamos Canarias
canarias_movida <- elide(canarias, shift = c(3.7, 7))

# Convertimos a data frame para ggplot2
ccaa1 <- fortify(espania_sin_canarias)
ccaa2 <- fortify(canarias_movida)
ccaa <- rbind(ccaa1, ccaa2)
```

En este caso sí es necesario pararse brevemente. Creamos un `shapefile` sin Canarias (hacedlo por índices). Creamos un objeto específico de Canarias que desplazamos con la **función `elide()`** de `maptools`, que mueve las coordenadas del `shapefile` como le indiquemos en `shift = c(x, y)`. Hacemos un `rbind()` como un castillo para unir ambos objetos ya convertidos a puntos.

### Unión del mapa con los datos

```r
# Preparamos los datos a pintar (última columna de casos)
pinta <- tabla_ccaa[, c(2, ncol(tabla_ccaa))]
names(pinta) <- c("region", "casos")

# Normalizamos nombres de regiones en el mapa
ccaa <- ccaa %>% mutate(region = case_when(
  id == "14" ~ "Murcia", # Ejemplo por ID si name_1 se pierde al fortify
  TRUE ~ id # Aquí habría que asegurar la unión correcta id/region
))

# Nota: Asegurar que el objeto 'ccaa' tiene la columna 'region' 
# vinculada correctamente a los datos de 'pinta'
ccaa <- left_join(ccaa, pinta, by = "region")
```

¡Qué poco me gustan las uniones por descripciones…! Ya estamos en disposición de pintar el mapa. Pero lo importante no es pintar datos absolutos, sino relativos: representamos el número de casos de COVID / habitantes para relativizar los datos:

```r
ccaa <- left_join(ccaa, poblacion, by = "region")
ccaa$tasa_COVID <- (ccaa$casos / ccaa$habitantes) * 1000

mapa <- ggplot() +
  geom_polygon(data = ccaa, aes(x = long, y = lat, group = group, fill = tasa_COVID)) +
  scale_fill_continuous(low = "white", high = "red") +
  labs(title = "Mapa de tasa COVID-19 por Comunidad Autónoma") +
  theme(panel.background = element_rect(fill = '#04DADA', colour = '#0B0C0C'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
```

### Añadir un rectángulo con `geom_rect()`

```r
# Definimos el recuadro para Canarias
rectangulo <- data.frame(xmin = min(ccaa2$long) - 0.2, xmax = max(ccaa2$long) + 0.1,
                         ymin = min(ccaa2$lat) - 0.1, ymax = max(ccaa2$lat) + 0.1)

mapa_final <- mapa + 
  geom_rect(data = rectangulo, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), 
            alpha = 0.01, colour = "#0B0C0C", size = 0.2, linetype = 3) +
  theme(axis.line = element_blank(), axis.text = element_blank(),
        axis.ticks = element_blank(), axis.title = element_blank())

mapa_final
```

Añadimos un rectángulo sobre las Islas Canarias empleando el propio objeto que tenía las Canarias movidas para calcular los límites del recuadro. El resultado es el mapa con el que comienza la entrada. Saludos.