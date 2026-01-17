---
author: rvaquerizo
categories:
- Formación
date: '2020-03-18T03:19:34-05:00'
lastmod: '2025-07-13T16:01:49.528131'
related:
- libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
- mi-breve-seguimiento-del-coronavirus-con-r.md
- mapa-estatico-de-espana-con-python.md
slug: mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats
tags: []
title: 'Mapa del COVID-19 por Comunidades Autónomas con R (más #rstats)'
url: /blog/mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats/
---

[![](/images/2020/03/coronavirus7.png)](/images/2020/03/coronavirus7.png)

Estoy muy activo en twitter con el #covid-19 estos días y eso está dando lugar a algunas entradas en el blog. Sin embargo, he parado esa actividad porque **el número de casos no me parece el indicador adecuado para medir la verdadera incidencia de la pandemia**. Empiezo a tener posibles casos entre personas conocidas y no se realiza ningún test, permanecen en casa y son casos no informados. Sin embargo, quería que esta entrada sirviera de homenaje a la gente de [Datadista ](https://datadista.com/) que está recogiendo datos y realizan un seguimiento del número de camas ocupadas, uno de los mejores indicadores. Además sigo mi labor formativa con Rstats, hoy toca:

  * Mapa rápido y guarro de España con GADM
  * Homogeneización de textos con dplyr y tm
  * Complicar el web scraping con rvest

Esta entrada surge aquí:

> Esto os puede interesar a los que estáis haciendo visualizaciones y análisis con datos [#COVID19](https://twitter.com/hashtag/COVID19?src=hash&ref_src=twsrc%5Etfw) en España 👇 [@ramiroaznar](https://twitter.com/ramiroaznar?ref_src=twsrc%5Etfw) [@r_vaquerizo](https://twitter.com/r_vaquerizo?ref_src=twsrc%5Etfw) <https://t.co/3NAP4YL51n>
>
> — Antonio Delgado (@adelgado) [March 12, 2020](https://twitter.com/adelgado/status/1238032972562956289?ref_src=twsrc%5Etfw)

Datadista pone a nuestra disposición datos actualizados por Comunidad Autónoma y con ellos podemos construir los mapas.

## Mapa por Comunidad Autónoma con datos de Datadista

```r
#Situación por Comunidad Autónoma
library(gganimate)
library(maptools)
library(raster)
library(maps)
library(tidyverse)

datadista = "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_casos.csv"

tabla_ccaa <- read.csv2(datadista, sep=',',encoding = 'UTF-8', check.names=FALSE)

Espania <- getData('GADM', country='Spain', level=1)
Espanianame = EspaniaNAME_1
ccaa <- map_data(Espania)

pinta <- tabla_ccaa[,c(2,length(tabla_ccaa))]
names(pinta)=c("region","casos")

unique(ccaaregion)
unique(pintaregion)

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

ggplot(data = ccaa, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = casos)) +
  scale_fill_continuous(low="white",high="red") +
  labs(title = "Mapa del COVID-19 por Comunidad Autónoma") +
  theme(panel.background =
          element_rect(fill='#838596',colour='#838596'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())
```


Este código da lugar al mapa con el que se incia esta entrada. Como aspectos interesantes tiene descargar directamente el mapa con R de gadm o la lectura de cabeceras con formato fecha, algo que no conocía, nunca había usado check.names=FALSE. Por lo demás no es un código especialmente complicado. Pero me gustaría escribir sobre la relativización de los datos, no podemos decir que Madrid tiene 5 veces más casos que otra provincia si Madrid tiene 5 veces más habitantes que otra provincia, es necesario relativizar el número de casos y en este caso vamos a emplear el número de habitantes y además nos va a servir para hacer web scraping sobre una tabla de una página web.

## Scraping sobre datosmacro. Mapa de casos por número de habitantes

El código empieza del siguiente modo:

```r
library(rvest)
library(xml2)
library(tm)
numerea <- function(x) {as.numeric(sub(",",".",x)) }

url = 'https://datosmacro.expansion.com/demografia/poblacion/espana-comunidades-autonomas'
```


Si vais a la url indicada tenemos que extraer la tabla específica con el número de habitantes y para eso necesitamos saber en que lugar del código HTML se encuentra. En mi caso empleo Google Chrome, imagino que será análogo con otros navegadores. Hacemos lo siguiente:

[![](/images/2020/03/scraping_datosmacro.png)](/images/2020/03/scraping_datosmacro.png)

Nos ubicamos sobre la tabla que deseamos scrapear (verbo regular de la primera conjugación) damos a inspeccionar y nos aparece la codificación, dentro de la codificación si pulsamos se marcará la tabla y Coppy + Copy XPath y con ello ya podemos crear un data frame con la tabla HTML:

```r
poblacion <- url %>%
  html() %>%
  html_nodes(xpath='//*[@id="tb1"]') %>%
  html_table()
poblacion <- poblacion[[1]]

poblacion <- poblacion [,-4] %>% mutate(CCAA = removePunctuation(CCAA),
                                        CCAA = substr(CCAA,1,nchar(CCAA)-1),
                                        habitantes=numerea(removePunctuation(Población))) %>%
  rename(region=CCAA) %>%
  select(region, habitantes) %>% mutate(region=case_when(
    region == "Comunidad Valenciana" ~ "C. Valenciana",
    region == "Castilla La Mancha" ~ "Castilla-La Mancha",
    region == "Islas Baleares" ~ "Baleares",
    TRUE ~ region
  ))
```


en html_nodes hemos puesto el XPath y ya sabe que parte tiene que leer, como se genera una lista nos quedamos con el primer elemento de la lista y posteriormente se realiza la homogeneización de los nombres de las comunidades, eliminación de signos de puntuación con removePunctuation (que ha cambiado mi vida porque odio regex). Esta tabla puede ser cruzada con los datos de Datadista y crear un número de casos entre habitantes x 1000:

```r
unique(poblacionregion)
unique(ccaaregion)

ccaa <- left_join(ccaa,poblacion)
ccaatasa_COVID <- (ccaacasos/ccaa$habitantes)*1000

ggplot(data = ccaa, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = tasa_COVID)) +
  scale_fill_continuous(low="white",high="red") +
  labs(title = "Mapa del COVID-19 por Comunidad Autónoma") +
  theme(panel.background =
          element_rect(fill='#838596',colour='#838596'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank())
```


Y el resultado sigue siendo alarmante en Madrid pero la tonalidad del rojo cambia mucho en otras zonas de España, la importancia relativizar un dato.

[![](/images/2020/03/coronavirus8.png)](/images/2020/03/coronavirus8.png)