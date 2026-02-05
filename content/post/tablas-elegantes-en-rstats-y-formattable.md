---
author: rvaquerizo
categories:
  - business intelligence
  - formación
  - r
date: '2020-10-20'
lastmod: '2025-07-13'
related:
  - mi-breve-seguimiento-del-coronavirus-con-r.md
  - evolucion-del-numero-de-casos-de-coronavirus.md
  - informes-con-r-en-html-comienzo-con-r2html-i.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - trucos-simples-para-rstats.md
tags:
  - business intelligence
  - formación
  - r
title: 'Tablas elegantes en #rstats y formattable'
url: /blog/tablas-elegantes-en-rstats-y-formattable/
---

Las salidas de la consola de R para muchos de nosotros son más que suficientes. Además, en mi caso particular, prefiero poner las cosas más elegantes en otras herramientas como `Excel`, `Qlik Sense` o `Tableau`. Pero me he dado cuenta de que hay una librería que sí uso cuando directamente copio y pego salidas de R en correos, presentaciones o si empleo `markdown` (rara vez); esta librería es `formattable`. Es posible que haya mejores librerías, pero ésta es la que yo uso desde hace un par de años.

Vamos a ilustrar algunos ejemplos de uso con un código ya conocido: extraemos la información de casos de COVID de `Datadista` y vamos a poner una tabla con la evolución de casos, UCI, altas y fallecimientos para el mes de octubre de 2020:

```r
library(tidyverse)
library(formattable)
library(lubridate)

# Importación de datos
data <- read.csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/nacional_covid19.csv",
                 check.names = FALSE)

colnames(data)[1] <- 'fecha'

# Preparación de datos
data$Fecha <- as.Date(data$fecha, "%Y-%m-%d")
data$`Casos nuevos` <- c(NA, diff(data$casos_pcr))
data$`Altas nuevas` <- c(NA, diff(data$altas))
data$`Fallecimientos nuevos` <- c(NA, diff(data$fallecimientos))
data$`UCI nuevas` <- c(NA, diff(data$ingresos_uci))

data_filtered <- data %>% 
  filter(month(Fecha) == 10 & `Casos nuevos` > 0) %>%
  select(Fecha, `Casos nuevos`, `Altas nuevas`, `Fallecimientos nuevos`, `UCI nuevas`)

# Formato básico
formattable(data_filtered)
```

Y si queremos el `HTML`:

```r
format_table(data_filtered)
```

Copiando y pegando podemos incrustar en `HTML`.

El elemento que más uso cuando hago este tipo de tablas es la inclusión de una **barra de color**. Esto se hace incluyendo una lista con las características columna a columna; en este caso, la columna `Altas nuevas` sólo tiene valores perdidos, también la podemos eliminar del reporte:

```r
formattable(data_filtered, digits = 2, align = c("r"),
            list(`Casos nuevos` = color_bar('red'),
                 `Altas nuevas` = FALSE,
                 `Fallecimientos nuevos` = color_bar('red'),
                 `UCI nuevas` = color_bar('red')))
```

Algo que queda muy elegante son las celdas con flechas y colores en el caso de mejorar o empeorar los datos. En ese caso, recomiendo crear un **formato personalizado**; imaginemos que calculamos el número de casos de COVID por día y si supone un incremento o un decremento:

```r
data$`Incremento de casos` <- c(NA, diff(data$`Casos nuevos`))
data_filtered_inc <- data %>% 
  filter(month(Fecha) == 10 & `Casos nuevos` > 0) %>%
  select(Fecha, `Casos nuevos`, `Incremento de casos`)

reduccion_formato <- formatter("span",
  style = x ~ style(font.weight = "bold",
                    color = ifelse(x < 0, 'green', ifelse(x > 0, 'red', "black"))),
  x ~ icontext(ifelse(x < 0, "arrow-down", "arrow-up"), x))

formattable(data_filtered_inc, align = c("r"),
            list(`Casos nuevos` = color_bar('red'),
                 `Incremento de casos` = reduccion_formato))
```

Para el ejemplo solo sacamos casos diarios e incrementos; en el caso que se produzca una reducción pondremos una flecha hacia abajo y el color verde como algo positivo. Si se produce un incremento de casos, pondremos una flecha roja hacia arriba.

Estaréis pensando: vaya "castaña" de datos que ha seleccionado para ilustrar los ejemplos; no tienen sentido los fines de semana, no son diarios… En este caso sólo se está ilustrando un ejemplo de uso; imaginad que hay que pilotar una pandemia con esta información. Saludos.