---
author: rvaquerizo
categories:
- consultoría
- fútbol
- formación
- r
date: '2023-08-23'
lastmod: '2025-07-13'
related:
- pintando-campos-de-futbol-con-rstats-y-entendiendo-funciones-de-densidad.md
- datos-libres-de-statsbomb-independencia-estadistica-y-tandas-de-penaltis.md
- alineaciones-de-equipos-de-futbol-con-worldfootballr-de-rstats.md
- minutos-de-juego-y-puntos-es-espanyol-y-sus-finales-de-partido.md
- resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas.md
tags:
- sin etiqueta
title: Datos de eventing gratuitos en Statsbomb
url: /blog/datos-de-eventing-gratuitos-en-statsbomb/
---
![](https://import.cdn.thinkific.com/277488%2Fcustom_site_themes%2Fid%2F8yHhosOVQji56gzkZcqm_sb_-_core_wordmark_-_colour_positive.png)

Da comienzo una serie de entradas sobre datos, fútbol y rstats. Todas estas entradas estarán disponibles en [mi repositorio de github](https://github.com/rvaquerizo02 "mi repositorio de github"). La función de estos artículos es poner en orden cosas que yo he ido aprendiendo, no olvidar esas cosas y servir de ayuda a nuevos analistas. Para entender mejor esta serie recomiendo leer el libro [Introducción a la Estadística para Científicos de Datos con R](https://analisisydecision.es/estadistica-data-scientist/index.html) que yo mismo escribí.

[Statsbomb](https://statsbomb.com/es/) es uno de los principales proveedores de datos futbolísticos, tienen su equipo de consultoría y recopilan datos para sus clientes. Sin embargo, además de ese trabajo de consultoría ponen a disposición de todo el mundo datos libres para que los analistas puedan trabajar y, por si fuera poco, tienen un paquete en R que permite descargar datos de forma muy sencilla y por aquí vamos a empezar con el trabajo, instalando la librería `StatsBombR`

```r
# Librerías de statsbomb
# devtools::install_github("statsbomb/SDMTools")
# devtools::install_github("statsbomb/StatsBombR")
```


El código lo tenéis comentado porque ya las tengo instaladas, tendréis que ejecutarlo aquellos que aun no dispongáis de estas librerías en vuestra sesión de R. Por favor no las instaléis cada vez que ejecutáis el código, he sido profesor en algunas escuelas de negocio y doy fe que es habitual ejecutar código sin mirar. Mi behemencia ante ese tipo de _analistas_ me ha provocado algún problema. Una vez instalada esa librería de R disponemos de un buen número de [conjuntos de datos gratuitos](https://github.com/statsbomb/open-data) entre los que podemos destacar las siguientes competiciones:

```r
library(tidyverse)
library(StatsBombR)
library(lubridate)

comp <- FreeCompetitions()
```


Te has creado un objeto `comp` que te permite ver todas las competiciones de libre acceso de Statsbomb. Por ejemplo, la Liga española corresponde con la competición ID = 11 y si deseamos ver todos los partidos de la Liga a nuestra disposición podemos hacer.

```r
partidos_messi <- comp %>%
  filter(competition_id == 11) %>%
  FreeMatches()
```


El nombre del objeto creado con los más de 860 partidos libres de Statsbomb ya nos da una idea de cual es nuestra intención. Statsbomb permite acceder a **datos de eventing** de todos los partidos que ha jugado Messi con el Barcelona. Los datos de eventing son aquellos datos que se generan cuando el jugador ha tocado un balón, no sabemos nada de la posición del resto de jugadores pero tenemos información acerca de lo que sucede con aquel jugador que está en posesión del balón y lo que hace en esa posesión. Para descargar esos datos es necesario ejecutar este código y tener paciencia:

```r
messi_data <- StatsBombFreeEvents(MatchesDF = partidos_messi)
# saveRDS(messi_data,'./data/messi_data.rds')
# messi_data <- readRDS('./data/messi_data.rds')
```


Son más de 230 MB de datos que recomiendo que guardéis en vuestro equipo aunque Statsbomb ha cambiado el formato de estos datos a lo largo del tiempo y eso puede dificultar posteriores análisis. Como se puede comprobar, los datos de eventing no dicen nada:

```r
library(DT)
datatable(head(messi_data,10))
```


Tienen un id que recoge cada intervención de cada jugador en el partido y que permite relacionar eventos, estos datos tienen información temporal, de posición, de jugador,… recomiendo mirar el data frame resultante para familiarizarse con este tipo de dato. Pero lo más importante es que **estos datos no nos están aportando nada** es necesario dar una estructura para poder sacar partido de ellos y esa estructura depende del objetivo del analista. Éste será capaz de transformar los datos para dar respuesta a su problema, si quiere grafos de pases tendrá origen-destino y lo que quiera representar, si quiere datos de tiros a puerta se quedará sólo con aquellos cuyo `type.name` sea ‘Shot’, o resultados de pases, saques de esquina,… Los datos están ahí, es función del analista dar la forma correcta y en sucesivas entradas del blog se irán planteando problemas y resoluciones a la vez que se irá aprendiendo estadística.