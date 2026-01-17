---
author: rvaquerizo
categories:
- Business Intelligence
- Consultoría
- Formación
- Monográficos
- R
date: '2020-01-11T14:29:21-05:00'
lastmod: '2025-07-13T15:58:14.921043'
related:
- un-repaso-a-los-paquetes-de-r-solar-chron-directlabels-y-graficos-de-densidades-con-lattice.md
- mi-breve-seguimiento-del-coronavirus-con-r.md
- stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
- incluir-subplot-en-mapa-con-ggplot.md
- graficos-de-burbuja-con-r.md
slug: graficos-de-calendarios-con-series-temporales
tags: []
title: Gráficos de calendarios con series temporales
url: /blog/graficos-de-calendarios-con-series-temporales/
---

Cuando se realizan gráficos de series temporales se emplean gráficos de líneas donde el eje X contiene la fecha y el eje Y contiene el valor a representar. Hoy quiero traer al blog otra forma de representar series temporales, los gráficos de calendario y su realización con R. Para ilustrar el ejemplo vamos a emplear las cotizaciones históricas del índice bursatil IBEX35:

```r
require(quantmod)
require(ggplot2)
require(reshape2)
require(dplyr)
library(lubridate)

# Obtenemos las cotizaciones del IBEX 35 desde 2010
getSymbols('^IBEX', from = '2010-01-01')

# data frame de trabajo
df<-data.frame(date=index(IBEX),IBEX)
```


Mediante quantmod extraemos las cotizaciones del IBEX desde 2010 y creamos un data frame de trabajo que llamamos df. Vamos a realizar dos tipos de gráficos, un mapa de calor por años, meses, semanas y días y un calendario de un año puntual.

## Calendario como mapa de calor por

Este es un gráfico [ basado en un trabajo anterior ](https://www.r-bloggers.com/ggplot2-time-series-heatmaps/)(¡de 2012!) y es una forma imaginativa de representar el cierre del IBEX 35 desde 2010 en una sola imagen. El primer paso será crear las variables a representar en el mapa de calor, el mes, el día de la semana y la semana dentro del mes:

```r
df <- df %>% mutate(año=year(date),
                    mes=factor(month(date),levels=(1:12),
                               labels = c("ENE","FEB","MAR","ABR","MAY","JUN","JUL",
                                              "AGO","SEP","OCT","NOV","DIC"),ordered = T),
                    dia=factor(wday(date)-1,levels=rev(1:7),
                          labels=rev(c("L","M","X","J","V","S","D"))),
                    semanames=ceiling(day(date) / 7))
```


Ahora sólo queda representar el gráfico mediante ggplot2 donde los paneles de facet_grid serán los años en eje X y los meses en eje Y:

```r
# Realizamos el calendario
calendario1<- ggplot(df, aes(semanames, dia, fill = IBEX.Adjusted)) +
  geom_tile(colour = "white") + facet_grid(año~mes) +
  scale_fill_gradient(low = "red", high = "darkgreen", na.value = "black") +
  labs(title="Cierre histórico del IBEX", x ="Semana del mes", y = "")
calendario1
```


[![](/images/2020/01/Mapa_calor_calendario.png)](/images/2020/01/Mapa_calor_calendario.png)

Un gráfico que me gusta bastante y una original forma de representar series temporales muy largas, no he usado paletas de colores pero imagino que los resultados mejorarán, podéis aportar esas mejoras en los comentarios.

## Calendario con openair y calendarPlot

Si deseamos representar un calendario de un año concreto tenemos la función calendarPlot de openair (que me ha costado instalar en Ubuntu) que no puede ser más sencilla:

```r
library(openair)
calendarPlot(df, pollutant = "IBEX.Adjusted", year = 2019, cols = "Greens")
```


[![](/images/2020/01/Grafico_calendario_anual.png)](/images/2020/01/Grafico_calendario_anual.png)

Este último calendario no lo he usado pero la sintaxis es muy sencilla y el resultado queda bastante bien. Ahora vosotros mismos podéis juzgar si hay o no hay rally de fin de año.