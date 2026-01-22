---
author: rvaquerizo
categories:
  - formación
  - r
date: '2019-02-13'
lastmod: '2025-07-13'
related:
  - graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
  - grafico-de-barras-y-lineas-con-python.md
  - capitulo-5-representacion-basica-con-ggplot.md
  - descubriendo-ggplot2-421.md
  - un-acercamiento-a-graph-primeros-graficos-con-sas.md
tags:
  - ggplot2
title: Gráfico con eje secundario en ggplot2
url: /blog/grafico-con-eje-secundario-en-ggplot2/
---

![](/images/2019/02/ggplot2_eje_secundario.png)

Los gráficos con eje secundario o con dos ejes son un tema que ya he puesto en el blog en varias ocasiones, [hay un ejemplo con R que tenía sus problemas](https://analisisydecision.es/graficos-de-barras-y-lineas-en-dos-ejes-con-r/) y [hay un ejemplo con Python y matplotlib](https://analisisydecision.es/grafico-de-barras-y-lineas-con-python/) que particularmente me gusta por elegancia y sencillez. En esta entrada vamos a repetir el ejercicio y vamos a realizar un gráfico de columnas y líneas con 2 ejes, primario y secundario pero con `ggplot2`. Este tipo de gráficos son muy utilizados por los `actuarios` para representar `frecuencias` o `siniestralidades` y `exposición`. Para ilustrar el ejercicio vamos a emplear los mismos datos que usamos en el ejemplo con `matplotlib` pero vemos paso a paso como realizaríamos el gráfico:

```r
library(ggplot2)
url='http://www.businessandeconomics.mq.edu.au/our_departments/Applied_Finance_and_Actuarial_Studies/acst_docs/glms_for_insurance_data/data/claimslong.csv'
df <- read.csv(url)

resumen <- df %>% group_by(period) %>%
  summarise(pct_exposicion = n(),
            frecuencia = sum(claim)/n())

g2 <- ggplot(resumen,aes(x = period)) +
  geom_col(aes(y = pct_exposicion), fill="yellow",alpha=0.7) +
  geom_line(aes(y=frecuencia, group=), group = 1,color="red") +
  geom_text(aes(y = frecuencia, label = paste(round(frecuencia*100),'%')),
            vjust = 1.4, color = "red", size = 2)

g2
```

Así el gráfico no puede representar las líneas porque hay una clara diferencia de escala, eso lo solventamos con `scale_y_continuous` y `sec.axis` quedando el código:

```r
g2 <- ggplot(resumen,aes(x = period)) +
  geom_col(aes(y = pct_exposicion), fill="yellow",alpha=0.7) +
  geom_line(aes(y=frecuencia, group=), group = 1,color="red") +
  geom_text(aes(y = frecuencia, label = paste(round(frecuencia*100),'%')),
            vjust = 1.4, color = "red", size = 2) +
  scale_y_continuous(sec.axis = sec_axis(~., name = "Frecuencia [%]"))

g2
```

Estamos en la misma situación porque es necesario ajustar la escala para que ambos ejes cuadren, hay que buscar una relación entre un dato que ronda los 40000 y otro que ronda los 0.15 para ajustarse habría que multiplicar por 250000 aproximadamente, en este caso multiplicamos por 500000 y así la línea de frecuencia queda por encima de las barras de exposición:

```r
g2 <- ggplot(resumen,aes(x = period)) +
  geom_col(aes(y = pct_exposicion), fill="yellow",alpha=0.7) +
  geom_line(aes(y=frecuencia * 500000 , group=), group = 1,color="red") +
  geom_text(aes(y = frecuencia * 500000, label = paste(round(frecuencia*100),'%')),
            vjust = 1.4, color = "red", size = 2) +
  scale_y_continuous(sec.axis = sec_axis(~.* 500000, name = "Frecuencia [%]"))

g2
```

No es muy elegante pero los resultados son espectaculares, la propia definición de `ggplot2`.
