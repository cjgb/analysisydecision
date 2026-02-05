---
author: rvaquerizo
categories:
  - consultoría
  - formación
  - opinión
  - r
date: '2019-08-26'
lastmod: '2025-07-13'
related:
  - stadistical-data-warehouse-del-european-central-bank-con-r-y-los-depositos-a-perdidas.md
  - leer-y-representar-datos-de-google-trends-con-r.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - analisis-de-textos-con-r.md
  - beatifulsoup-web-scraping-con-python-o-como-las-redes-sociales-estan-cambiando-mi-forma-de-escribir.md
tags:
  - gganimate
  - ggplot2
  - xml
title: Los principales problemas de los españoles. Animaciones con R y gganimate
url: /blog/los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate/
---

![Problemas_españoles.gif](/images/2019/08/Problemas_espa%C3%B1oles.gif)

La realización de gráficos animados con R, `gganimate` y `ggplot2` es algo que quiero empezar a trabajar en mis visualizaciones de datos; una buena forma de llamar la atención. Para ilustrar el ejemplo, he recogido los datos que publica mensualmente el `CIS` con las tres principales preocupaciones de los españoles, que podéis encontrar en [este enlace](http://www.cis.es/cis/export/sites/default/-Archivos/Indicadores/documentos_html/TresProblemas.html). Por cierto, este enlace tiene toda la pinta de ser una salida en SAS; no me parece muy apropiado, pero no diré nada porque imagino que serán lectores del blog. 

El caso es que la primera parte de nuestro trabajo será el «scrapeado» de la web:

```r
library(XML)
library(dplyr)
library(lubridate)

# Lectura de los datos del CIS
url <- "http://www.cis.es/cis/export/sites/default/-Archivos/Indicadores/documentos_html/TresProblemas.html"
doc <- htmlParse(url, encoding = "UTF-8")
tableNodes <- getNodeSet(doc, "//table")

# Leemos la tabla (la segunda)
problemas_raw <- readHTMLTable(tableNodes[[2]], skip.rows = 1, stringsAsFactors = FALSE)
problemas_raw <- problemas_raw %>% filter(!is.na(V1) & V1 != "")

# Transformamos los puntos en 0 (parece que estuviera hecho con SAS)
haz.cero.na <- function(x) {
  x <- gsub(",", ".", x)
  res <- ifelse(x == "." | x == "", 0, as.numeric(x))
  return(res)
}

# Limpiamos el data frame
problemas <- problemas_raw
problemas[, -1] <- lapply(problemas[, -1], haz.cero.na)

# El primer elemento de la tabla contiene los nombres (meses)
nombres_meses <- readHTMLTable(tableNodes[[2]])[1, ]
nombres_meses[1] <- "Problema"
colnames(problemas) <- as.character(unlist(nombres_meses))

# Eliminamos el registro con el número de encuestas (N)
problemas <- problemas %>% filter(Problema != "(N)")
```

Hacemos `htmlParse()` de la web y nos quedamos con las tablas. Como los valores perdidos aparecen como un punto `.`, es necesario transformarlos a `0`. Para los nombres de las columnas seleccionamos el primer registro de la tabla que contiene las fechas.

Tenemos un *data frame* con muchas columnas; ahora es necesario reestructurarlo para quedarnos con los 10 principales problemas mes a mes:

```r
# Transformamos a formato largo (tidy)
library(tidyr)
resultado <- problemas %>%
  pivot_longer(cols = -Problema, names_to = "mes_raw", values_to = "porcentaje") %>%
  group_by(mes_raw) %>%
  arrange(desc(porcentaje)) %>%
  mutate(rank = row_number()) %>%
  filter(rank <= 10) %>%
  ungroup()

# Transformamos el texto del mes a fecha
resultado$mes <- parse_date_time(resultado$mes_raw, orders = "my", locale = "Spanish")
```

Ya estamos en disposición de realizar la animación con `ggplot2` y `gganimate`:

```r
library(ggplot2)
library(gganimate)

# Creamos el gráfico estático base
estatico <- ggplot(resultado, aes(x = -rank, group = Problema, y = porcentaje, fill = Problema)) +
  geom_bar(stat = 'identity') +
  geom_text(aes(y = 0, label = paste(Problema, " ")), vjust = 0.2, hjust = 1, size = 4) +
  coord_flip(clip = "off", expand = TRUE) +
  scale_y_continuous(limits = c(0, 100)) +
  theme_minimal() +
  theme(legend.position = "none",
        plot.margin = margin(1, 1, 1, 9, "cm"),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

# Especificamos la transición y el título dinámico
animacion <- estatico + 
  transition_manual(mes) + 
  labs(title = "Principales problemas de los españoles: {month(current_frame, label=TRUE)} {year(current_frame)}")

# Renderizamos la animación
animate(animacion, fps = 2, width = 800, height = 600, renderer = gifski_renderer())
```

Para realizar animaciones con `gganimate`, lo más importante es el gráfico estático. En este caso se representa un *ranking* ordenado. Con `coord_flip()` hacemos que sea horizontal y fijamos la escala del eje $Y$. La velocidad se regula con el parámetro `fps`. 

Todo este código estará en el `GitHub` de la web ([https://github.com/analisisydecision](https://github.com/analisisydecision)). Saludos.