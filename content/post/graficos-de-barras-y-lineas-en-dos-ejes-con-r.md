---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - r
date: '2011-09-26'
lastmod: '2025-07-13'
related:
  - grafico-con-eje-secundario-en-ggplot2.md
  - capitulo-5-representacion-basica-con-ggplot.md
  - introduccion-a-la-estadistica-para-cientificos-de-datos-capitulo-7-descripcion-grafica-de-variables.md
  - informes-con-r-en-html-comienzo-con-r2html-i.md
  - trucos-r-graficos-de-velocimetro-con-r.md
tags:
  - axis
  - barplot
  - gráficos
  - plot
  - points
  - recode
  - text
title: Gráficos de barras y íneas en dos ejes con R
url: /blog/graficos-de-barras-y-lineas-en-dos-ejes-con-r/
---

![grafico_actuarial_r.png](/images/2011/09/grafico_actuarial_r.png)

[Aunque no es `recomendable crear gráficos` con `2 ejes`](http://www.perceptualedge.com/articles/visual_business_intelligence/dual-scaled_axes.pdf) hoy quería `mostraros` un `gráfico` muy `común` realizado con `R`. Se trata del **`gráfico` de `barras` y `líneas` para un `factor`**. Las `barras` serán un `valor` de `exposición` del `factor` y las `líneas` pueden ser una `frecuencia siniestral` y estarán en un `eje secundario`. Con esto crearemos nuestro `gráfico` de `barras` y `líneas` en `dos ejes`. Simulamos los `datos` para `crear` el `gráfico` con `R`:

```r
#Numeros aleatorios de con una distribución gamma

potencia = ceiling(rgamma(1000, shape = 10, rate = 0.08))

hist(potencia)
```

Generamos `números aleatorio` con una `distribución gamma` con la `función rgamma` que `asemejan` a la `potencia` de los `vehículos` en `caballos` que se `venden actualmente` en el `mercado español`. Ahora tenemos que `codificar` esta `potencia` en un `factor`, para ello tenemos la `función recode` de la `librería car`:

```r
library(car)

agr <- recode(potencia,recode="

lo:90='1 Menos de 90 cv';

90:120='2 91 - 120 cv';

120:150='3 121 - 150 cv';

150:200='4 151 - 200 cv';

else='5 Mas de 200 cv'")
```

`Particularmente`, la `función recode` me `parece` la `mejor forma` de `crear tramos` en `variables numéricas` con `R`. Ahora `simulamos` unos `datos` de `exposición` también `basándonos` en una `distribución gamma`:

```r
exposicion = rnorm(1000,1,0.3)

exposicion = ifelse(exposicion>1,1,exposicion)

exposicion = ifelse(exposicion<0,abs(exposicion),exposicion)
```

Con `ifelse` modificamos aquellos `valores` que pueden `resultar imposibles` como una `exposición superior` a `1` o `inferior` a `0`. Por último creamos una `variable dicotómica` que toma `valor 1` si se ha `producido` un `siniestro`:

```r
siniestro = runif(10000)

siniestro = ifelse(siniestro>=0.8,1,0)

table(siniestro)

summary(siniestro)
```

Ahora tenemos que unir todos nuestros `objetos` para crear un `data.frame final`:

```r
frec = data.frame(agr)

frec = cbind(frec,exposicion,siniestro)

summary(frec)
```

La `forma` tan `peculiar` de `crear` el `data.frame` no se debe a `malas costumbres`, no entiendo que hace `R` si `intentas` `crear` en un `sólo paso` el `data.frame` , todos sus `elementos` los `identifica` como `factores`, así pues es `mejor` `hacerlo` por `pasos`. Si alguien me puede explicar por qué sucede esto… `Calculamos` la `frecuencia` sobre el `objeto final` con `sqldf` (como no). **¡Qué grande `sqldf`!**

```r
library(sqldf)

res = sqldf("select agr,

sum(exposicion) as exposicion,

sum(siniestro) as siniestro,

sum(siniestro)/sum(exposicion) as frecuencia

from frec

group by agr;")
```

Ya estamos en `disposición` de `crear` el `gráfico` y tiene sus `peculiaridades`, primero el `código` y después los `comentarios`:

```r
#Gráfica de barras

barplot(res$exposicion,names.arg=res$agr,

ylim=c(0,5000),xlab="Potencia del vehículo")

#Creamos un nuevo gráfico

par(new=TRUE)

#No pintamos nada, pero el eje x será el factor

plot(res$agr,rep(0,nrow(res)),axes=FALSE,ann=FALSE,

type="n",ylim=c(0.1,0.3),ylab="",xlab="")

#Mostramos el eje secundario

axis(4)

#Pintamos la línea que queda centrada

points(res$frecuencia,type="l")

#Unos puntos para que quede mejor

points(res$frecuencia)

#Ponemos las etiquetas en %

text(res$frecuencia,labels=paste(round(res$frecuencia,4)*100,'%'),pos=3)
```

Este es el `código` más `interesante` que os `presento` hoy. Con `barplot` creamos el `gráfico` de `barras` para la `exposición`, como `etiquetas` del `eje` ponemos los `valores` del `factor`, un `gráfico sencillo` pero me gustaría `destacar` que en este `tipo` de `gráficos` la `escala` es muy `importante`, el `parámetro ylim` tiene que estar bien `definido` para que los `gráficos` se vean `mejor`. El `siguiente paso` es el más `interesante`, creamos un `nuevo gráfico` pero no `pintamos nada`. Sin `embargo` es el `paso` más `importante` porque se pinta fuera del `gráfico` pero nos `garantizamos` que los `elementos` que `añadimos` al `gráfico` quedan `centrados` con los `valores` del `factor`, así nuestro `gráfico` será más `vistoso`. Después mostramos el `eje secundario` con `axis(4)`. Ya `pintamos` la `línea` que queda `perfectamente centrada` y añadimos algunos `elementos`, `puntos` y `etiquetas` que dan más `vistosidad` a nuestro `gráfico`.

Creo que esta entrada es muy interesante para algunos compañeros muy habituados a este `tipo` de `gráficos` pero me gustaría `advertiros` sobre el `problema` de las `escalas` en los `ejes`. Saludos.
