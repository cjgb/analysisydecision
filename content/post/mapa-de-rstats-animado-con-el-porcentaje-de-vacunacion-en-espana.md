---
author: rvaquerizo
categories:
- Formación
- Gráficos
- Mapas
date: '2021-01-20T09:18:08-05:00'
lastmod: '2025-07-13T16:01:52.236100'
related:
- animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- incluir-subplot-en-mapa-con-ggplot.md
- mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
- libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
slug: mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana
tags:
- Animaciones
- gganimate
- ggplot
title: Mapa de Rstats animado con el porcentaje de vacunación en España
url: /mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana/
---

[![](/images/2021/01/mapa_vacunas.gif)](/images/2021/01/mapa_vacunas.gif)

El dato del porcentaje de vacunados de COVID por Comunidad Autónoma está en prensa diariamente y yo estoy empezando a trabajar animaciones para visualizar los datos de un modo más dinámico, fundamentalmente visualizaciones con R y las librerías ggplot y gganimate, así que un mapa animado con ese dato me parecía un ejercicio interesante. No esperaba que estos ejercicios tuvieran mucho interés puesto que hay material en la web más que suficiente, pero dos personas sí mostraron interés por lo que crearé dos entradas en el blog con algunas animaciones realizadas. La primera de ellas la traigo hoy y consiste en el porcentaje de personas vacunadas en España en función de las vacunas entregadas por Comunidad Autónoma. No me quiero meter en los datos, directamente vamos a representar, todo lo referente a datos y coronovirus en España no funciona tan correcto como debiera.

### Obtención de elementos a representar

```r
library(mapSpain)
library(sf)
library(tidyverse)
library(lubridate)
library(gganimate)

#Obtenemos los datos de datadista
datadista = "https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_vacunas.csv"

tabla_ccaa <- read.csv2(datadista, sep=',',encoding = 'UTF-8', check.names=FALSE)
tabla_ccaa <- tabla_ccaa %>% mutate(fecha = as.Date(`Fecha publicación`))

CCAA.sf <- esp_get_ccaa()
```
 

Nada nuevo para los seguidores del blog, los datos son obtenidos del github de Datadista y para la obtención del mapa empleamos la [librería mapSpain con la que ya hemos trabajado](https://analisisydecision.es/libreria-mapspain-en-rstats-mapas-estaticos-de-espana/). Ahora es necesario unir los datos de vacunación con los datos del mapa, al no disponer de un campo de código de comunidad en los datos publicados que recoge Datadista es necesario realizar el cruce por texto “a lo mecagüen”:

```r
CCAA.sf = CCAA.sf %>% mutate(CCAA = ine.ccaa.name) %>% mutate(CCAA=case_when(
  grepl('Madrid', CCAA, fixed = T)>0 ~ 'Madrid',
  grepl('León', CCAA, fixed = T)>0 ~ 'Castilla y Leon',
  grepl('Asturias', CCAA, fixed = T)>0 ~ 'Asturias',
  grepl('Balea', CCAA, fixed = T)>0 ~ 'Baleares',
  grepl('Mancha', CCAA, fixed = T)>0 ~ 'Castilla La Mancha',
  grepl('Rioj', CCAA, fixed = T)>0 ~ 'La Rioja',
  grepl('Navarra', CCAA, fixed = T)>0 ~ 'Navarra',
  grepl('Valencia', CCAA, fixed = T)>0 ~ 'C. Valenciana',
  grepl('Murcia', CCAA, fixed = T)>0 ~ 'Murcia',
  TRUE ~ CCAA))

CCAA.sf <- CCAA.sf %>% left_join(select(tabla_ccaa, CCAA,`Porcentaje sobre entregadas`, fecha)) %>% rename(`% entregadas` = `Porcentaje sobre entregadas`)
```
 

A día de hoy, en el momento de escribir estas líneas, el código funciona, es posible que el Ministerio cambie datos y nombres.

### Realización de la animación

El código más simplificado posible:

```r
p <- ggplot() + geom_sf(data=CCAA.sf, aes(fill=`% vacunaciones`)) +
  scale_fill_continuous(low="white",high="red") + transition_time(fecha)
animate(p)
```
 

A la hora de realizar animaciones quiero recomendar hacerlo de esta forma, primero el código supersimplificado, incluso empezar por el gráfico estático y comprobamos que hace lo que deseamos, en ese momento empezamos a meter nuevas consideraciones en el gráfico de ggplot empezando por el campo de transición entre frames. Veamos el código que genera el gif con el que comienza la entrada:

```r
p <- ggplot() + geom_sf(data=CCAA.sf, aes(fill=`% sobre entrega`)) +
  scale_fill_continuous(low="white",high="darkred") + geom_sf(data = esp_get_can_box(), colour = "grey50") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  transition_time(fecha) + labs(title = 'Fecha de datos: {frame_time}')

mapa_vacunas <- animate(p, duration = 20, end_pause = 45)
magick::image_write(mapa_vacunas, path="/home/rvaquerizo/Documentos/wordpress/mapa_vacunas.gif")
```
 

Añadimos la caja a Canarias con esp_can_box() y realizamos un mapa con los mínimos elementos transition_time(fecha) es la parte más importante del mapa de coropletas o clorofetas (como he dicho yo toda la vida) ya que transition_time es el elemento que indica la transición entre frames, un campo en forma fecha. Además, añadimos un título con ese {frame_time}, cada cambio provocará un cambio en el título. El objeto p va a generar otro objeto con la animación, esto lo hacemos con la función animate donde hay dos parámetros interesantes, la duración de la animación que la fijamos en 20 segundos y que puede ocasionar problemas si no es múltiplo de los frames existentes y **end_pause** para pausar el loop del gif cuando se haya llegado al último frame, así podremos contemplar el último gráfico durante 45 segundos. Espero que os sea de utilidad el ejemplo.