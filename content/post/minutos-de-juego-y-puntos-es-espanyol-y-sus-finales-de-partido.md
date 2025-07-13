---
author: rvaquerizo
categories:
- Consultoría
- Fútbol
- Opinión
- R
date: '2024-04-01T03:15:44-05:00'
lastmod: '2025-07-13T16:02:37.003706'
related:
- los-porteros-del-espanyol-y-la-regresion-binomial-negativa.md
- resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas.md
- alineaciones-de-equipos-de-futbol-con-worldfootballr-de-rstats.md
- pintando-campos-de-futbol-con-rstats-y-entendiendo-funciones-de-densidad.md
- datos-de-eventing-gratuitos-en-statsbomb.md
slug: minutos-de-juego-y-puntos-es-espanyol-y-sus-finales-de-partido
tags: []
title: Minutos de juego y puntos. El Espanyol, sus finales de partido y mis enfados
url: /minutos-de-juego-y-puntos-es-espanyol-y-sus-finales-de-partido/
---

Pienso que el Espanyol este 2024 se está dejando muchos puntos al final de los partidos. Cuando el partido llega al minuto 75 pierdo años de vida. ¿Es verdad que el Espanyol se está dejando puntos en el tramo final del partido? Vamos a estudiarlo numéricamente con worldfootballR y datos de FBRef empleando funciones que ya se han trabajado con anterioridad.

El primer paso será obtener todos los partidos de la Liga Hypermotion de este 2024 con **fb_mach_url**

```r
library(worldfootballR)
library(tidyverse)

# Toda la información la extraemos de FBRef
partidos_segunda <- data.frame(url=fb_match_urls(country = "ESP", gender = "M",
                          season_end_year = c(2024), tier = "2nd"))
```
 

De todos los partidos, se seleccionan aquellos del equipo en el que estamos interesados. En este ejemplo estamos con el Espanyol pero podéis poner el nombre del equipo que deseáis sin tildes como está en al url.

```r
equipo = 'Espanyol'
```
 

Creo que existía una función que permitía obtener el reporte del partido con todos aquellos hechos más relevantes pero en el momento de escribir estas líneas no funcionaba para un equipo de segunda división o se trata de un reporte que no se puede obtener de FBRef, el caso es que se opta por emplear **fb_macth_shooting** para determinar en que minuto se produce un gol y poder ir creando un resultado de partido.

```r
partidos <- partidos_segunda %>% filter(grepl(equipo,url) >0 )

shots <- tibble()

for (i in seq(1:nrow(partidos))) {
  ax <- fb_match_shooting(partidos[i,1])
  shots <- rbind.data.frame(shots, ax)
}
```
 

Descargados todos los tiros de los partidos en los que ha participado el Espanyol esta temporada de liga se ordenan por fecha y minuto de juego para crear ese marcador.

```r
shots <- shots %>% arrange(Date, Minute)
```
 

Se observa que _Minute_ no es numérico, tiene el tiempo añadido y su ordenación puede causar problemas, por ello se crea un campo minuto con formato numérico. Se aprovecha este paso para eliminar tildes del nombre del equipo que se está analizando ya que a futuro puede dar problemas.

```r
shots <- shots %>% mutate(minuto = ifelse(grepl("+",Minute)>0, substr(Minute,1,2), Mminute),
                          minuto = as.numeric(minuto)) %>%
  arrange(Date,minuto) %>%
  mutate(Squad = chartr("áéíóú", "aeiou", Squad))
```
 

El formato ya es más adecuado acortando los tiempos añadidos en el minuto 45 o minuto 90. A continuación, se crea una tabla artificial con todas las fechas de partidos y los 90 minutos de juego que permitirá cruzar con la tabla de tiros a puerta.

```r
fechas <- shots %>% select(Date) %>% unique()
minuto <- seq(1:91)-1
minutos <- data.frame(minuto)

resultados <- crossing(fechas,minutos)
```
 

Sobre esta tabla artificial que empieza deliveradamente en el 0 se añade un campo que indica si el gol es del equipo en estudio o bien el gol es del equipo rival.

```r
goles_equipo <- shots %>% filter(Outcome == 'Goal' & Squad == equipo) %>%
  select(Date, minuto) %>% mutate(gol_equipo = 1)

goles_rival <- shots %>% filter(Outcome == 'Goal' & Squad != equipo) %>%
  select(Date, minuto) %>% mutate(gol_rival=1)

resultados <- resultados %>% left_join(goles_equipo) %>% left_join(goles_rival) %>%
  mutate(gol_equipo = ifelse(is.na(gol_equipo), 0, gol_equipo),
         gol_rival = ifelse(is.na(gol_rival), 0, gol_rival))
```
 

Como se aprecia en el código también se han eliminado valores perdidos en los campos de gol para facilitar la realización de una suma acumulada que se va a realizar con la función de base _ave_ , un homenaje a R base que cada vez parece usarse menos.

```r
resultadosgoles_equipo <- ave(resultadosgol_equipo, resultadosDate, FUN=cumsum)  
resultadosgoles_rival <- ave(resultadosgol_rival, resultadosDate, FUN=cumsum)
```

Sumando goles ya tenemos un marcador y si tenemos un marcador podemos tener unos puntos del equipo en estudio a lo largo del partido. 

```r  
resultados <- resultados %>% mutate(puntos = case_when(  
goles_equipo == goles_rival ~ 1,  
goles_equipo > goles_rival ~ 3,  
goles_equipo < goles_rival ~ 0))  
```

El equipo en estudio o empata o gana o pierde a lo largo de los 90 minutos de juego y se obtiene una puntuación media por minuto.

```r  
resumen <- resultados %>% group_by(minuto) %>%  
summarise(puntos_medios = mean(puntos))
```

En este punto se está en disposición de graficar esos puntos medios a lo largo del partido. SE añade una barra vertical en los 75 minutos para ver si esa impresión de pérdida de puntos al final del partido se sustenta en datos. 

```r  
resumen %>% ggplot(aes(x=minuto, y=puntos_medios, group=1)) +  
geom_line()+  
geom_point() +  
geom_vline(xintercept = 75, color=’Red’)  
```

[![](/images/2024/04/wp_editor_md_23267e4368cfcfcfdd1003b888f13a97.jpg)](/images/2024/04/wp_editor_md_23267e4368cfcfcfdd1003b888f13a97.jpg)

Ahí se puede observar mi enfado en los momentos finales del partido. El Espanyol se está dejando puntos en el último tercio de los partidos a pesar de la remontada contra el Eibar que no vi porque apague el TV en el minuto 90 mientras blasfemaba y pensaba seriamente si enviar mi CV al Espanyol para ayudar al equipo a subir a primera división.

Por cierto, sugiero realizar el mismo análisis para el Leganés:

[![](/images/2024/04/wp_editor_md_8c62705a68a5cb1349535621a9a5b26f.jpg)](/images/2024/04/wp_editor_md_8c62705a68a5cb1349535621a9a5b26f.jpg)

Empiezan mal pero siempre remontan, sobre todo al inicio de la segunda parte.
