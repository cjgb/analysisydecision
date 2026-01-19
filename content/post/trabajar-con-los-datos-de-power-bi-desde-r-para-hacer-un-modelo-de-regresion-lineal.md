---
author: rvaquerizo
categories:
  - business intelligence
  - consultoría
  - power bi
  - r
date: '2021-10-04'
lastmod: '2025-07-13'
related:
  - arboles-de-decision-con-sas-base-con-r-por-supuesto.md
  - manual-curso-introduccion-de-r-capitulo-18-modelos-de-regresion-de-poisson.md
  - evita-problemas-con-excel-desde-r-de-tocar-el-dato-a-un-proceso.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
  - sobremuestreo-y-pesos-a-las-observaciones-ahora-con-r.md
tags:
  - sin etiqueta
title: Trabajar con los datos de Power BI desde R para hacer un modelo de regresión lineal
url: /blog/trabajar-con-los-datos-de-power-bi-desde-r-para-hacer-un-modelo-de-regresion-lineal/
---

Vídeo dedicado al uso de la librería de R pbix. Responde a una duda planteada por un lector que deseaba realizar un modelo de regresión lineal con Power BI. Imagino que se podrá programar en DAX, pero es mejor llevar los datos, las tablas necesarias, de Power BI a un software específico para poder realizar el modelo como es Python o R en este caso.

Desde Power BI podemos realizar scripts de R pero recomiendo este primer paso para crear y validar el modelo, posteriormente podemos poner el programa de R con nuestra regresión lineal directamente en Power BI. El código empleado es:

```r
library(pbixr)

# Puerto
pbi_abiertos = f_get_connections()

pbi_abiertospbix <- gsub(" - Power BI Desktop", "", pbi_abiertospbix_name)
puerto_empleado <- as.numeric(pbi_abiertosports)

conexion <- paste0("Provider=MSOLAP.8;Data Source=localhost:", puerto_empleado, ";MDX Compatibility=1")

consulta = "select * from `SYSTEM.TMSCHEMA_TABLES"
tablas <- f_query_datamodel(consulta, conexion)

consulta2 <- "evaluate cars"
cars <- f_query_datamodel(consulta2, conexion)

consulta = "select * from `SYSTEM.TMSCHEMA_COLUMNS"
columnas <- f_query_datamodel(consulta, conexion)

nombres <- columnas %>% filter(TableID==641&IsHidden == 'False') %>% select(ExplicitName) %>%
  t() %>% as.vector()

names(cars) = nombres

carsmpg = as.numeric(sub(',','.', carsmpg))

lm(carsmpg ~ cars$hp)
##############################
```
