---
author: rvaquerizo
categories:
  - business intelligence
  - formación
  - r
date: '2011-03-20'
lastmod: '2025-07-13'
related:
  - truco-r-paletas-de-colores-en-r.md
  - graficos-de-barras-y-linas-en-dos-ejes-con-r.md
  - trucos-r-el-paquete-classint-para-clasificar-variables-continuas.md
  - graficos-dinamicos-en-r-con-la-funcion-text.md
  - graficos-de-burbuja-con-r.md
tags:
  - lines
  - points
  - polygon
  - rcolorbrewer
  - velocimetro
title: Trucos R. Gráficos de velocímetro con R
url: /blog/trucos-r-graficos-de-velocimetro-con-r/
---

Hoy toca homenaje a dos lectores del blog. Es la primera versión de un gráfico en forma de velocímetro con R. Cuando disponga de más tiempo, modificaré la versión para darle mayor vistosidad. Como es habitual, el truco nos servirá para trabajar con un interesante paquete de R como `RColorBrewer`. [Un paquete que me descubrió un lector](https://analisisydecision.es/truco-r-paletas-de-colores-en-r/). El resultado final no es muy espectacular (de momento):

![velocimetro_r.png](/images/2011/03/velocimetro_r.png)

Veamos el código R que representa el semicírculo y posteriormente lo analizaremos. Me gustaría que también lo ejecutaseis vosotros para comentarme posibles incidencias. Se genera el gráfico como `.png` en `C:\temp`:

```r
# Datos a graficar
x <- seq(-1, 1, by = 0.001)
y <- sqrt(1 - x**2)

# Cargamos la librería
library("RColorBrewer")

# Guardamos el resultado como PNG
png(file = "C:\\temp\\velocimetro_R.png", width = 600, height = 450)

# Pintamos un gráfico base vacío
plot(0, 0, ann = FALSE, type = "n", xlim = c(-1, 1), ylim = c(0, 1), axes = FALSE)

# Creamos el arco con una escala de colores de rojo a verde
# brewer.pal(9, "RdYlGn") nos da los colores base
# colorRampPalette crea la transición suave
lines(x, y, type = "h", lwd = 12, 
      col = colorRampPalette(brewer.pal(9, "RdYlGn"))(length(x)))

# Superponemos un semicírculo blanco para crear el efecto "rosquilla"
lines(x, sqrt(0.5 - x**2), type = "h", lwd = 12, col = "white")
```

La librería `RColorBrewer` nos permite emplear distintas paletas de colores que podemos ver con la función `display.brewer.all()`. En este caso, empleamos los nueve colores de rojo a verde con `RdYlGn`. Con `lines` y `type="h"` creamos barras verticales que siguen la forma circular. Para que nos quede una rosquilla, superponemos una línea de barras verticales en blanco. Evidentemente se puede mejorar.

Ahora tenemos que pintar la aguja. De momento grafico lo más sencillo: porcentajes que vayan de 0 a 100:

```r
porcentaje <- 75 # Ejemplo: 75%
posicion <- round((porcentaje * length(x)) / 100)

# Coordenadas de la aguja
dx <- c(0, x[posicion])
dy <- c(0.03, y[posicion])

# Dibujamos la aguja y el punto central
lines(dx, dy, lwd = 10, col = "gainsboro")
points(0, 0.03, lwd = 10, col = "gainsboro", pch = 19)

dev.off()
```

La aguja parte del punto (0, 0.03) y va hasta una posición proporcional en el vector que representa el semicírculo. En este caso, el 75% será una posición avanzada en el vector. No puede ser más sencillo. Como último paso, pinto un punto central por estética. 

Como ya os comenté, ésta es una versión beta del gráfico. Será interesante poner escalas, números, una aguja más real y representar muchos gráficos de forma ordenada. También estoy abierto a otras sugerencias; de hecho, este gráfico es una idea que me dieron dos lectores. Saludos.