---
author: rvaquerizo
categories:
  - opinión
  - r
date: '2020-03-11'
lastmod: '2025-07-13'
related:
  - seguir-los-datos-del-coronavirus-en-espana-con-rstats.md
  - mi-breve-seguimiento-del-coronavirus-con-r.md
  - evolucion-del-numero-de-casos-de-coronavirus.md
  - los-pilares-de-mi-simulacion-de-la-extension-del-covid19.md
  - no-estamos-igual-que-en-la-primera-ola-de-covid.md
tags:
  - opinión
  - r
title: Estimación de la evolución de casos del coronavirus en España
url: /blog/estimacion-de-la-evolucion-de-casos-del-coronavirus-en-espana/
---

[Ayer escribrí sobre la obtención de los datos del coronavirus](https://analisisydecision.es/seguir-los-datos-del-coronavirus-en-espana-con-rstats/) con R y después me disponía ha escribir sobre modelos de regresión no lineal, hacer una estimación del coronavirus en España,… Pero estuve hablando con una amiga residente en Italia y allí el número de casos está dos semanas por delante de España, bueno, dos semanas exactamente no, 10 días:

```r
library(lubridate)
library(ggplot2)
library(dplyr)
library(reshape2)
datos <- read.csv2("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv",
                   sep=',')

fechas <- seq(as.Date("2020/01/22"), as.Date(today()-1), "days")
fechas <- substr(as.character.Date(fechas),6,10)
names(datos) <- c("Provincia", "Pais","Latitud", "Longitud", fechas)

esp_ita <- data.frame(fecha=fechas)
esp_ita <- cbind.data.frame(esp_ita, Espania = t(datos %>% filter(Pais=="Spain") %>% select(fechas)))
esp_ita <- cbind.data.frame(esp_ita, Italia = t(datos %>% filter(Pais=="Italy") %>% select(fechas)))

p <- ggplot(esp_ita, aes(x=fecha)) +
  geom_line(aes(y=Espania, group = 1, color="España")) +
  geom_line(aes(y=Italia, group = 1, color="Italia")) +
  scale_color_manual(values = c("España" = "red", "Italia" = "blue")) +
  xlab("") + ylab("")
p
```

[![](/images/2020/03/coronavirus2.png)](/images/2020/03/coronavirus2.png)

A la vista de las dos evoluciones hace pensar que el número de casos en España siga la misma evolución que sigue en Italia, por eso en este caso en vez de manejar fechas vamos a manejar días de evolución y al dato de España vamos a quitarle 10 días:

```r
esp_ita <- data.frame(fecha=fechas)
esp_ita <- esp_ita %>% mutate(dia=row_number())
Italia <- data.frame(Italia=t(datos %>% filter(Pais=="Italy") %>% select(fechas)))
Italia <- Italia %>% mutate(dia = row_number())

Espania <- data.frame(Espania=t(datos %>% filter(Pais=="Spain") %>% select(fechas)))
Espania <- Espania %>% filter(row_number() >= 10) %>% mutate(dia=row_number())

esp_ita <- esp_ita %>% left_join(Espania) %>% left_join(Italia)

p <- ggplot(esp_ita, aes(x=fecha)) +
  geom_line(aes(y=Espania, group = 1, color="España")) +
  geom_line(aes(y=Italia, group = 1, color="Italia")) +
  scale_color_manual(values = c("España" = "red", "Italia" = "blue")) +
  xlab("") + ylab("")
p
```

[![](/images/2020/03/coronavirus3.png)](/images/2020/03/coronavirus3.png)

Mi estimación para los próximos 10 días sobre la evolución del coronavirus en España está clara, ahora solo queda que no salga el ejército a la calle como en Milán.
