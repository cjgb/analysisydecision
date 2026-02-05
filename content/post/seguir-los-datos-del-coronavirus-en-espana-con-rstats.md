---
author: rvaquerizo
categories:
  - formación
date: '2020-03-10'
lastmod: '2025-07-13'
noindex: true
related:
  - estimacion-de-la-evolucion-de-casos-del-coronavirus-en-espana.md
  - mi-breve-seguimiento-del-coronavirus-con-r.md
  - evolucion-del-numero-de-casos-de-coronavirus.md
  - mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
  - mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
tags:
  - formación
title: Seguir los datos del coronavirus en España con Rstats
url: /blog/seguir-los-datos-del-coronavirus-en-espana-con-rstats/
---

No he podido evitarlo: os traigo unas líneas de código en R para seguir la evolución del coronavirus en España (podéis filtrar cualquier país). Me hubiera gustado hacer un *scraping* de la página [Worldometers](https://www.worldometers.info/coronavirus/), sin embargo me ha parecido más sencillo leer directamente los datos del repositorio de la Universidad Johns Hopkins ([https://github.com/CSSEGISandData/COVID-19](https://github.com/CSSEGISandData/COVID-19)), cuya actualización es diaria. También existe ya un paquete en R denominado `coronavirus`, pero su funcionamiento a veces es irregular. 

Por mi parte, os ofrezco el siguiente *script* para seguir su evolución:

```r
library(tidyverse)
library(lubridate)

# Lectura directa desde el repositorio de la Universidad Johns Hopkins
url_datos <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
datos <- read.csv(url_datos, check.names = FALSE)

# Filtramos por España
espania <- datos %>% 
  filter(`Country/Region` == "Spain") %>% 
  select(-`Province/State`, -`Country/Region`, -Lat, -Long)

# Transponemos para tener formato de serie temporal
espania_long <- data.frame(
  fecha = mdy(colnames(espania)),
  casos = as.numeric(t(espania))
)

# Graficamos con ggplot2
ggplot(espania_long, aes(x = fecha, y = casos)) +
  geom_line(color = "red", size = 1) +
  labs(title = "Evolución de casos confirmados de COVID-19 en España",
       x = "Fecha",
       y = "Número de casos") +
  theme_minimal()
```

Tendría que mejorar los ejes y el aspecto, pero no es eso lo más importante. Estaba escribiendo sobre distribuciones `tweedie`, ahora me siento tentado para escribir sobre modelos exponenciales y, si hacéis ésto mismo para los datos de Italia de hace unos días, la verdad es que el gráfico es calcado. Saludos.
