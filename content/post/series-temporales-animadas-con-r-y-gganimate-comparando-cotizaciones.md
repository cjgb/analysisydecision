---
author: rvaquerizo
categories:
  - formación
date: '2021-02-01'
lastmod: '2025-07-13'
related:
  - random-walk-se-escribe-con-r.md
  - graficos-de-calendarios-con-series-temporales.md
  - mi-breve-seguimiento-del-coronavirus-con-r.md
  - stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
  - grafico-con-eje-secundario-en-ggplot2.md
tags:
  - formación
title: Series temporales animadas con R y `gganimate`, comparando cotizaciones
url: /blog/series-temporales-animadas-con-r-y-gganimate-comparando-cotizaciones/
---

La comparación de series es otro de los usos que le estoy dando a las animaciones, en este caso quiero comparar la cotización de `Tesla` frente a la cotización del `Bitcoin` e intentar establecer paralelismo (o no). Obtenemos los datos vía `quantmod` y comenzamos a traficar:

```r
library(quantmod)
library(`tidyverse`)
library(gganimate)
library(`lubridate`)

cartera = c("BTC-USD", "TSLA")
getSymbols(cartera, src="yahoo", from="2019-12-31")
chartSeries(`BTC-USD`)
tail(`BTC-USD`)
btc =  data.frame(date=index(`BTC-USD`), coredata(`BTC-USD`))
tesla =  data.frame(date=index(`TSLA`), coredata(`TSLA`))
```

Ya tenemos dos `data frames` con la cotización de `Tesla` y la cotización del `Bitcoin` desde el 31/12/2019 hasta la fecha. Ahora vamos a unir los 2 objetos en uno para facilitar los gráficos.

```r
df <- btc %>% select(date, BTC.USD.Adjusted) %>% left_join(select(tesla, date, TSLA.Adjusted))

while (sum(is.na(df$TSLA.Adjusted))){
df <- df %>% mutate(TSLA.Adjusted=ifelse(is.na(TSLA.Adjusted), lag(TSLA.Adjusted), TSLA.Adjusted)) }
```

Como `Tesla` no cotiza en feriados y fines de semana se hace una chapuza, si es vacío se asigna la última cotización disponible, eso facilita la realización del gráfico.

### Gráfico de puntos

El tema es graficar series temporales pero si deseamos establecer relaciones entre ambas cotizaciones un gráfico de puntos puede ayudarnos, aunque perdamos la dimensión temporal.

```r
ub <- "/Users/raulvaquerizo/Desktop/R/animaciones/"
#GRáfico de puntos
p <- ggplot(df, aes(x = TSLA.Adjusted, y=BTC.USD.Adjusted, alpha=0.6, group=1)) + `geom_point`(show.legend = FALSE) +
  `labs`(x="Cotización ajustada de Tesla", "Cotización ajustada de BTC")

animacion1 <- p + `transition_time`(date) +
  `labs`(title = "Fecha: {frame_time}") + `shadow_mark`alpha = 0.2)

`anim_save`
```

En este caso hacemos primero el gráfico y posteriormente creamos la animación, con shadow_mark vamos dejando rastro de los puntos que pintamos en el gráfico y el resultado es interesante.

![](/images/2021/01/animacion1.gif)

Si se aprecia un comportamiento parecido, cuando sube una cotización sube otra, pero de este modo perdemos la dimensión temporal

### Serie temporal

Si traficamos la cotización del `Bitcoin` y la cotización de `Tesla` necesitaríamos incluir dos ejes, el Bitcoin está en 5 cifras y Tesla en 3. Podemos sugerir muchas transformaciones, pero en ocasiones lo más sencillo es lo mejor, dividimos por la media.

```r
p <- ggplot(df) +
  `geom_line`(aes(x=date, y=BTC.USD.Adjusted/mean(dfBTC.USD.Adjusted), color = "BTC")) +  `geom_line`(aes(x=date, y=TSLA.Adjusted/mean(dfTSLA.Adjusted), color="Tesla")) +
  `labs`(x = "Día de cotización", y = "Cotización ajustada") +
  `transition_reveal`(date)

animacion2 <- `animate`(p, end_pause = 25, fps=5)
anim_save(paste0(ub,"animacion2.gif"), animacion2)
```

El resultado es muy interesante, cada cual que saque sus conclusiones.

![](/images/2021/01/animacion2.gif)
