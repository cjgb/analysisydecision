---
author: rvaquerizo
categories:
  - consultoría
  - fútbol
  - formación
  - gráficos
  - monográficos
  - r
  - trucos
date: '2023-03-01'
lastmod: '2025-07-13'
related:
  - alineaciones-de-equipos-de-futbol-con-worldfootballr-de-rstats.md
  - minutos-de-juego-y-puntos-es-espanyol-y-sus-finales-de-partido.md
  - los-porteros-del-espanyol-y-la-regresion-binomial-negativa.md
  - pintando-campos-de-futbol-con-rstats-y-entendiendo-funciones-de-densidad.md
  - mi-breve-seguimiento-del-coronavirus-con-r.md
tags:
  - sin etiqueta
title: Resultados de La Liga con rstats. Estudiando gráficamente rachas
url: /blog/resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas/
---

[![](/images/2023/03/wp_editor_md_13f039a1fbdc6199942259afa7e76711.jpg)](/images/2023/03/wp_editor_md_13f039a1fbdc6199942259afa7e76711.jpg)
Vamos a crear un gráfico con #rstats que recoja los resultados de La Liga equipo a equipo para poder estudiar rachas e «intuir» como puede ser la segunda vuelta. Además, este ejercicio es un buen uso del paquete `worldfootballR` y la función de ggplot `geom_tile` además me va a servir para animarme esta segunda vuelta para que el Español no sufra. La web que vamos a emplear para el trabajo es [FBREF](https://fbref.com/es/ "FBREF"). Empezamos.

## Librerías necesarias

```r
library(worldfootballR)
library(tidyverse)
library(stringr)
library(rvest)
library(lubridate)
```

## Extracción y preparación de datos

```r
partidos <- fb_match_results(country = "ESP", gender = "M", season_end_year = 2023, tier = "1st")

partidos2 <- partidos %>% filter(Date<=today()) %>%
  mutate(gana=case_when(
  HomeGoals == AwayGoals ~ 'Empate',
  HomeGoals > AwayGoals ~ 'Local',
  HomeGoals < AwayGoals ~ 'Visitante',
  TRUE ~ 'Imposible'),
  Jornada=paste0('Jor.',sprintf("%02d",as.numeric(Wk))))
```

Podéis ver que la función de `worldfootballR` que se está usando es `fb_match_results`, creo que es la más rápida y cómoda, pero como estos datos están pensada para representar datos en una web es necesario cocinar un poco y preparar un conjunto de datos por Equipo-Jornada-Resultado

```r
partidos2_local <- partidos2 %>% mutate(Equipo = Home,
                                        Resultado = case_when(
                                          gana == 'Empate' ~ 'Empate',
                                          gana == 'Local' ~ 'Gana',
                                          TRUE ~ 'Pierde' )) %>% select(Equipo, Jornada, Resultado)

partidos2_visitante <- partidos2 %>% mutate(Equipo = Away,
                                            Resultado = case_when(
                                              gana == 'Empate' ~ 'Empate',
                                              gana == 'Visitante' ~ 'Gana',
                                              TRUE ~ 'Pierde' )) %>% select(Equipo, Jornada, Resultado)

partidos3 <- rbind.data.frame(partidos2_local,partidos2_visitante) %>%
  arrange(Jornada)
```

Probablemente se pueda hacer mejor, más fácil no creo.

## Gráfico final

En este caso es necesario establecer el orden en la liga para entender mejor el gráfico por ello realizamos de nuevo una extracción sobre FBref para determinar la posición de cada equipo en La Liga.

```r
ub ="https://fbref.com/en/comps/12/La-Liga-Stats"
liga=read_html(ub,as.data.frame=TRUE,stringAsFactors=TRUE) %>%
  html_nodes("table") %>% .[[1]] %>% html_table(fill=TRUE) %>%
  select(Squad, Rk) %>% rename(Equipo = Squad)

partidos3<-partidos3 %>% left_join(liga)
```

Ya están todos los elementos necesario para realizar el gráfico con el que comienza esta entrada.

```r
ggplot(partidos3, aes(x = Jornada, y = reorder(Equipo,-Rk), fill = Resultado)) +
  geom_tile(color = "white",alpha=0.7, lwd = 1.25) +
  scale_fill_manual(values = c("orange","#4DDB1C","#F12F1C"),
                    name = "Resultado",
                    guide = guide_legend(reverse = T))+
  coord_fixed() +
  labs(title="Racha La Liga 22/23",
       x ="Jornada", y = "Equipo")
```

Como comentaba al principio es un buen ejemplo de uso de `geom_tile` para la creación de este tipo de gráficos. En cuanto a lo que se puede ver, **ojo al Espanyol**
