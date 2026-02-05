---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2020-04-20'
lastmod: '2025-07-13'
related:
  - evolucion-del-numero-de-casos-de-coronavirus.md
  - incluir-subplot-en-mapa-con-ggplot.md
  - estimacion-de-la-evolucion-de-casos-del-coronavirus-en-espana.md
  - seguir-los-datos-del-coronavirus-en-espana-con-rstats.md
  - mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
tags:
  - coronavirus
  - covid
title: Mi breve seguimiento del coronavirus con R
url: /blog/mi-breve-seguimiento-del-coronavirus-con-r/
---

Este código es la unión de muchos de los *scripts* de días anteriores; es un buen ejemplo de uso de la librería `gridExtra` para poner múltiples gráficos en una sola salida:

```r
library(tidyverse)
library(reshape2)
library(gridExtra)
library(lubridate)

# Carga de datos de fallecidos
df_raw <- read.csv("https://raw.githubusercontent.com/datadista/datasets/master/COVID%2019/ccaa_covid19_fallecidos.csv",
                   check.names = FALSE, encoding = 'UTF-8')

# Reestructuración de datos
df_long <- melt(df_raw, id.vars = "CCAA", variable.name = "fecha", value.name = "fallecidos")
df_long$fecha <- as.Date(as.character(df_long$fecha), format = "%Y-%m-%d")

# Identificamos las regiones con más fallecidos
ranking <- df_long %>% 
  group_by(CCAA) %>% 
  summarise(total = max(fallecidos, na.rm = TRUE)) %>% 
  arrange(desc(total)) %>%
  mutate(CCAA2 = ifelse(row_number() >= 10, 'Resto', as.character(CCAA)))

df_long <- left_join(df_long, ranking[, c("CCAA", "CCAA2")], by = "CCAA")

# Agregamos por la nueva clasificación
df_agrupado <- df_long %>% 
  group_by(CCAA2, fecha) %>% 
  summarise(fallecidos = sum(fallecidos)) %>% 
  ungroup()

# Cálculo del dato diario (lag manual con left_join)
df_anterior <- df_agrupado %>% 
  mutate(fecha = fecha + 1, fallecidos_anterior = fallecidos) %>% 
  select(-fallecidos)

df_final <- left_join(df_agrupado, df_anterior, by = c("CCAA2", "fecha")) %>% 
  mutate(fallecidos_dia = fallecidos - fallecidos_anterior)

# Función para generar los gráficos
grafica_ccaa <- function(comunidad) {
  df_pinta <- filter(df_final, CCAA2 == comunidad & !is.na(fallecidos_dia))
  ggplot(df_pinta, aes(x = fecha, y = fallecidos_dia)) +
    geom_line(alpha = 0.5, color = 'red') +
    geom_smooth(method = "loess", formula = y ~ x) +
    labs(title = comunidad, x = "", y = "Fallecidos/día") +
    theme_minimal()
}

# Generamos los objetos gráficos
g1 <- grafica_ccaa('Madrid')
g2 <- grafica_ccaa('Cataluña')
g3 <- grafica_ccaa('Castilla-La Mancha')
g4 <- grafica_ccaa('Castilla y León')
g5 <- grafica_ccaa('País Vasco')
g6 <- grafica_ccaa('C. Valenciana')
g7 <- grafica_ccaa('Andalucía')
g8 <- grafica_ccaa('Aragón')
g9 <- grafica_ccaa('Resto')
g10 <- grafica_ccaa('Total') # Suponiendo que 'Total' esté calculado

# Composición final
grid.arrange(g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, nrow = 5, ncol = 2)
```

![coronavirus16.png](/images/2020/04/coronavirus16.png)

Del mismo modo podemos analizar el número de **casos confirmados**:

![coronavirus17.png](/images/2020/04/coronavirus17.png)

En este caso es un buen ejemplo de uso de `melt()` para transponer columnas a filas. Al hacer ésto, el `lag` lo realizamos mediante un `left_join()` sumando un día a la fecha, y así podemos calcular la diferencia diaria con el acumulado. Esperemos que este tipo de análisis se estén llevando a cabo en los sitios donde se toman decisiones. Saludos.