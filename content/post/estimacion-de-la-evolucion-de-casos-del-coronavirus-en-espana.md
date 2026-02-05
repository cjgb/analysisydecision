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

[Ayer escribí sobre la obtención de los datos del coronavirus](https://analisisydecision.es/seguir-los-datos-del-coronavirus-en-espana-con-rstats/) con R y después me disponía a escribir sobre modelos de regresión no lineal, hacer una estimación del coronavirus en España… Pero estuve hablando con una amiga residente en Italia y allí el número de casos está dos semanas por delante de España; bueno, dos semanas exactamente no, 10 días:

```r
library(lubridate)
library(ggplot2)
library(dplyr)
library(reshape2)

datos <- read.csv2("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv",
                   sep = ',')

fechas <- seq(as.Date("2020/01/22"), as.Date(today() - 1), "days")
fechas_chr <- substr(as.character.Date(fechas), 6, 10)
# Se asume que el csv tiene el formato adecuado para asignar estos nombres
# En este caso, simplificamos la lógica de nombres para el ejemplo
names(datos) <- c("Provincia", "Pais", "Latitud", "Longitud", fechas_chr)

esp_ita <- data.frame(fecha = fechas_chr)
esp_ita$Espania <- as.numeric(t(datos %>% filter(Pais == "Spain") %>% select(all_of(fechas_chr))))
esp_ita$Italia <- as.numeric(t(datos %>% filter(Pais == "Italy") %>% select(all_of(fechas_chr))))

p <- ggplot(esp_ita, aes(x = fecha)) +
  geom_line(aes(y = Espania, group = 1, color = "España")) +
  geom_line(aes(y = Italia, group = 1, color = "Italia")) +
  scale_color_manual(values = c("España" = "red", "Italia" = "blue")) +
  xlab("") + ylab("") +
  theme(axis.text.x = element_text(angle = 90))
p
```

![Gráfico de la evolución de casos de coronavirus](/images/2020/03/coronavirus2.png)

A la vista de las dos evoluciones, hace pensar que el número de casos en España siga la misma evolución que sigue en Italia; por eso, en este caso, en vez de manejar fechas vamos a manejar días de evolución y al dato de España vamos a quitarle 10 días:

```r
Italia_df <- data.frame(Italia = as.numeric(t(datos %>% filter(Pais == "Italy") %>% select(all_of(fechas_chr)))))
Italia_df <- Italia_df %>% mutate(dia = row_number())

Espania_df <- data.frame(Espania = as.numeric(t(datos %>% filter(Pais == "Spain") %>% select(all_of(fechas_chr)))))
# Desplazamos 10 días
Espania_df <- Espania_df %>% 
  filter(row_number() >= 10) %>% 
  mutate(dia = row_number())

esp_ita_v2 <- Italia_df %>% left_join(Espania_df, by = "dia")

p2 <- ggplot(esp_ita_v2, aes(x = dia)) +
  geom_line(aes(y = Espania, color = "España")) +
  geom_line(aes(y = Italia, color = "Italia")) +
  scale_color_manual(values = c("España" = "red", "Italia" = "blue")) +
  xlab("Día de evolución") + ylab("Casos confirmados")
p2
```

![Gráfico de la evolución de casos de coronavirus con 10 días de decalaje](/images/2020/03/coronavirus3.png)

Mi estimación para los próximos 10 días sobre la evolución del coronavirus en España está clara; ahora sólo queda que no salga el ejército a la calle como en Milán.