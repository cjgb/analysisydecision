---
author: rvaquerizo
categories:
- consultoría
- fútbol
- gráficos
- r
date: '2023-09-13'
lastmod: '2025-07-13'
related:
- resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas.md
- minutos-de-juego-y-puntos-es-espanyol-y-sus-finales-de-partido.md
- los-porteros-del-espanyol-y-la-regresion-binomial-negativa.md
- datos-de-eventing-gratuitos-en-statsbomb.md
- pintando-campos-de-futbol-con-rstats-y-entendiendo-funciones-de-densidad.md
tags:
- sin etiqueta
title: Alineaciones de equipos de fútbol con worldfootballR de Rstats
url: /blog/alineaciones-de-equipos-de-futbol-con-worldfootballr-de-rstats/
---
Para obtener datos sobre fútbol de distintos proveedores disponemos de la librería de rstats **worldfootballR** , está disponible en CRAN, con ella podremos extraer datos de:

  * [Fotmob](https://www.fotmob.com/es)
  * [FBRef](https://fbref.com/es/)
  * [Transfermarkt](https://www.transfermarkt.es/)
  * [FBRef](https://fbref.com/es/)
  * [Understat](https://understat.com/)

Por supuesto, lo primero que tenéis que hacer es navegar por esas web y pensad en como haríais el scraping, de ese modo entenderéis mejor como van a trabajar las funciones que tiene este paquete. Al estar en CRAN no vamos a empezar por instalar así que directamente vamos a obtener los partidos de la Liga con un rango de fechas.

```r
library(worldfootballR)
library(tidyverse)

# Toda la información la extraemos de FBRef
# Extraemos los partidos
partidos <- data.frame(url=fb_match_urls(country = "ESP", gender = "M",
                          season_end_year = 2023, tier = "1st"))
```


La función empleada es fb_match_urls con las opciones que podéis consultar en la ayuda pero os podéis imaginar que descarga la url de los partidos de la temporada 2023, si navegáis por FBRef al final es una web con información que aparece en tablas por eso os recomiendo entender como se haría el scraping. Esa lista es extensa si deseamos bajar todos los partidos, pero podemos descargarnos solamente los partidos del Real Madrid.

```r
partidos <- partidos %>% filter(grepl("Real-Madrid",url) >0 )
```


Ahora _partido a partido_ de esas 38 jornadas y con la función fb_match_lineups vamos a obtener las alineaciones de todos esos encuentros mediante un bucle, es un proceso largo, paciencia porque son 38 descargas.

```r
alineaciones <- tibble()

for (i in seq(1:nrow(partidos))) {
  ax <- fb_match_lineups(partidos[i,1])
  alineaciones <- rbind.data.frame(alineaciones, ax)
}
```


## Alineaciones del Real Madrid

Son las alineaciones de los 38 partidos que jugó el Real Madrid en la temporada pasada, **no son las 38 alineaciones del Real Madrid*. Para obtener las alineaciones tenemos que entender que es lo que nos estamos descargando. Pero la url siempre es igual y manipular ese texto con funciones para obtener si el Real Madrid es el equipo local (Home) o el equipo visitante (Away)

```r
alineaciones <- alineaciones %>% mutate(local =substr(MatchURL,30, length(MatchURL)),
                                        local = substr(local, str_locate(local, "/")[,1]+1, length(MatchURL)),
                                        local = str_replace(local,'El-Derbi-Madrileno-',''),
                                        local = str_replace(local, 'El-Clasico-',''))
```


En Fbref tienen una costumbre muy fea de cambiar el nombre a 2 partidos de La Liga pero no es problema porque conocemos esa fea costumbre. Entonces, si esa cadena de caracteres que hemos denominado `local` empieza por `Real-Madrid` ya sabemos cual es el equipo local y podemos realizar un filtro para quedarnos sólo con las alineaciones del Real Madrid.

```r
alineaciones <- alineaciones %>%
  mutate(equipo = case_when(
    substr(local,1,11)=='Real-Madrid' & Home_Away=='Home' ~ "RM",
    substr(local,1,11) != 'Real-Madrid' & Home_Away=='Away' ~ "RM",
    TRUE ~ 'Rival'  ))

alineaciones_RM <- alineaciones %>% filter(equipo=="RM")
```


El objeto alineaciones_RM tiene las alineaciones del Real Madrid en la Liga temporada 22-23. En cualquier caso, hay que validar siempre lo que se está haciendo.

```r
alineaciones_RM %>% group_by(Player_Name) %>%
  filter(Starting=='Pitch') %>%
  summarise(conteo=n()) %>%
  arrange(desc(conteo))
```


Y aquí lo que recomiendo es ir al final y ver que en la alineación del Real Madrid no aparezca ningún jugador «extraño», salen Mariano y Hazard. Una vez validado ya tenemos todas las alineaciones titulares del Real Madrid y se puede crear un gráfico de ranking. El objetivo de este gráfico de ranking es contar partidos de jugadores por lo que lo más adecuado parece un gráfico de barras; además, al tener hasta 21 jugadores lo mejor será disponer ese gráfico horizontalmente.

```r
alineaciones_RM %>% group_by(Player_Name) %>%
  filter(Starting=='Pitch') %>%
  summarise(Partidos=n()) %>%
  mutate(Jugador = fct_reorder(Player_Name, Partidos)) %>%
  ggplot(aes(x=Jugador, y=Partidos)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_classic()
```


[![](/images/2023/09/wp_editor_md_d5a95a6ab826372c12ad65634035a019.jpg)](/images/2023/09/wp_editor_md_d5a95a6ab826372c12ad65634035a019.jpg)

Y ya tenemos el ranking de titulares del Real Madrid en la Liga temporada 22/23 donde destaca Vinicius, todo con pocas líneas de código. Siempre que contemos elementos, número de titularidades en este caso, parece que los gráficos de barras son apropiados y si lo que estamos contando, en este caso jugadores, tiene una definición más larga, parece recomendable poner el gráfico horizontal.

Los datos están dispuestos en la forma que le interesa al suministrador de datos, tiene que ser el analista quien le de forma y por eso es importante conocer como están los datos y que variables contienen, es cierto que el código es sencillo, pero los tiempos de extracción se han alargado debido a que es scraping puro.

En sucesivas entradas del blog seguiremos estudiando funciones de esta librería worldfootballR y comprendiendo mejor como funciona. Por supuesto tenéis [este código en el repositorio de git. ](https://github.com/rvaquerizo02/datos-futbol-rstats)