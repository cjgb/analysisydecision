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

Si leéis habitualmente el blog ya conocéis la [entrada sobre el mapa del COVID por Comunidades Autónomas](https://analisisydecision.es/mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats/) y estaréis de acuerdo conmigo en que el mapa de España representado con `Rstats` es feo de solemnidad. Pero el código es «sencillo» por ahí se ve cada representación que requiere ser desarrollador de `R` cinturón negro. Bueno, los torpes empleamos `ggplot` con `geom_polygon` pero podemos empezar a complicar el mapa añadiendo nuevas posibilidades. La que os traigo hoy es muy interesante en el caso de España, se trata de mover las Islas Canarias en el mapa de Comunidades Autónomas pero directamente con `R`. [Ya tenemos hecho un mapa con QGIS en otra entrada](https://analisisydecision.es/mover-elementos-de-un-mapa-con-qgis-ejemplo-mover-canarias/), pero ahora vamos a mover esa parte del `shapefile` directamente con `R` y [la función `elide` como hemos hecho en otra ocasión.](https://analisisydecision.es/el-brexit-con-rstats-o-como-mover-spatial-data-con-r/) Estaréis pensando «Vaquerizo no tiene imaginación por eso tira de entradas anteriores y las junta», no es el caso.

### Población por Comunidad Autónoma de datosmacro.expansion.com

```r
library(rvest)
library(xml2)
library(lubridate)
library(tidyverse)
library(tabulizer)
library(tm)
numerea <- function(x) {as.numeric(sub(",",".",x)) }

url = 'https://datosmacro.expansion.com/demografia/poblacion/espana-comunidades-autonomas'

poblacion <- url %>%
  html() %>%
  html_nodes(xpath='//*[@id="tb1"]') %>%
  html_table()
poblacion <- poblacion[[1]]

poblacion <- poblacion [,-4] %>% mutate(CCAA = removePunctuation(CCAA),
                                        CCAA = substr(CCAA,1,nchar(CCAA)-1),
                                        habitantes=numerea(removePunctuation(Población))) %>%
  rename(region=CCAA)  %>% as_tibble()

poblacion <- poblacion [,c(1,5)] %>% mutate(region=case_when(
  region == "Comunidad Valenciana" ~ "C. Valenciana",
  region == "Castilla La Mancha" ~ "Castilla-La Mancha",
  region == "Islas Baleares" ~ "Baleares",
  TRUE ~ region  ))
```

Nada innovador, si queréis entender mejor qué hace ir a la primera de las páginas antes mencionadas.

### Tabla de casos de COVID por Comunidad Autónoma y mapa de comunidades de GADM

```r
#Situación por Comunidad Autónoma
library(maptools)
library(raster)
library(maps)

datadista = "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos.csv"

tabla_ccaa <- read.csv2(datadista, sep=',',encoding = 'UTF-8', check.names=FALSE)

Espania <- getData('GADM', country='Spain', level=1)
Espanianame = Espania$NAME_1
```

Situación similar al anterior código, pero siempre es necesario mencionar y rendir homenaje a `Datadista` y su trabajo.

### Mover Canarias con `elide`

```r
Espania_sin_canarias <- Espania[Espania$NAME_1 != 'Islas Canarias',]
Canarias <- Espania[Espania$NAME_1 == 'Islas Canarias',]
Canarias = elide(Canarias,shift=c(3.7,7))

ccaa1 <- map_data(Espania_sin_canarias)
ccaa2 <- map_data(Canarias)
ccaa <- rbind(ccaa1,ccaa2)
```

En este caso sí es necesario pararse brevemente. Creamos un `shapefile` sin Canarias (no empleéis `dplyr` para realizar filtros, hacedlo por índices). Creamos un objeto específico de Canarias que desplazamos con la **función `elide`** de `maptools` que mueve las coordenadas del `shapefile` como le indiquemos en `shift=c(lat,long)` o `shift=c(long,lat)` no recuerdo, probad hasta que os guste. Y en ese punto viene lo más curioso del código, nada de unir `shapefile`, nada de `merge spatial`,… ¡qué pereza! hacemos `map_data` de España y `map_data` de Canarias y un `rbind` como un castillo para unir ambos objetos. Ahora de nuevo el código es conocido.

### Unión del mapa con los datos

```r
pinta <- tabla_ccaa[,c(2,length(tabla_ccaa))]
names(pinta)=c("region","casos")

unique(ccaa$region)
unique(pinta$region)

ccaa <- ccaa %>% mutate(region=case_when(
  region == "Región de Murcia" ~ "Murcia",
  region == "Principado de Asturias" ~ "Asturias",
  region == "Comunidad de Madrid" ~ "Madrid",
  region == "Comunidad Foral de Navarra" ~ "Navarra",
  region == "Comunidad Valenciana" ~ "C. Valenciana",
  region == "Islas Canarias" ~ "Canarias",
  region == "Islas Baleares" ~ "Baleares",
  TRUE ~ region))
ccaa <- left_join(ccaa,pinta)
```

¡Qué poco me gustan las uniones por descripciones…! Ya estamos en disposición de pintar el mapa:

```r
mapa <- ggplot() +
  geom_polygon(data = ccaa, aes(x = long, y = lat, group = group, fill = casos)) +
  scale_fill_continuous(low="white",high="red") +
  labs(title = "Mapa del COVID-19 por Comunidad Autónoma") +
  theme(panel.background =
          element_rect(fill='#04DADA',colour='#0B0C0C'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
mapa
```

Pero lo importante no es pintar datos absolutos, lo importante es pintar datos relativos, recordad siempre esto y por ello representamos el número de casos de COVID / habitantes para relativizar los datos:

```r
ccaa <- left_join(ccaa,poblacion)
ccaa$tasa_COVID <- (ccaa$casos / ccaa$habitantes)*1000
ccaa$`Casos COVID/habitante` <- ccaa$tasa_COVID

mapa <- ggplot() +
  geom_polygon(data = ccaa, aes(x = long, y = lat, group = group, fill = `Casos COVID/habitante`)) +
  scale_fill_continuous(low="white",high="red") +
  labs(title = "Mapa del COVID-19 por Comunidad Autónoma") +
  theme(panel.background =
          element_rect(fill='#04DADA',colour='#0B0C0C'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
```

### Añadir un rectángulo a nuestro mapa con `geom_rectangle`

```r
rectangulo <- data.frame(xmin=min(ccaa2$long)-0.2, xmax=max(ccaa2$long)+0.1,
                         ymin=min(ccaa2$lat)-0.1, ymax=max(ccaa2$lat)+0.1)
mapa + geom_rect(data=rectangulo,aes( xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax), alpha=0.01, colour="#0B0C0C", size = 0.2, linetype=3) +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())
```

Añadimos más elementos al mapa, un rectángulo sobre las Islas Canarias y para eso empleamos el propio `shapefile` que tenía las Canarias y calculamos máximos, para crear un recuadro sobre las islas. Puede quedarnos más vistoso, pero eso os lo dejo a vosotros. El resultado es:

![](/images/2020/04/coronavirus20.png)

Y si cambiamos directamente casos por fallecidos tenemos el mapa con el que comienza la entrada, el verdadero motivo de esta entrada.
