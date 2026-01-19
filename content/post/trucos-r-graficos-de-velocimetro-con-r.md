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
- graficos-de-barras-y-lineas-en-dos-ejes-con-r.md
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
Hoy toca homenaje a 2 lectores del blog. Es la primera versión de un gráfico en forma de velocímetro con R. Cuando disponga de más tiempo modificaré la versión para darle mayor vistosidad. Como es habitual el truco nos servirá para trabajar con un interesante paquete de R como _RColorBrewer_. [Un paquete que me descubrió un lector](https://analisisydecision.es/truco-r-paletas-de-colores-en-r/). El resultado final no es muy espectacular (de momento):

![velocimetro_r.png](/images/2011/03/velocimetro_r.png)

De momento la versión más sencilla. Veamos el código R que representa el semicírculo y posteriormente lo analizaremos. Me gustaría que también lo ejecutéis vosotros para comentarme posibles incidencias. Se genera el gráfico como PNG en C:\temp:

```r
#Datos a graficar

x=seq(-1,1,by=0.001)

y=sqrt(1-x**2)

#Cargamos la librería

library("RColorBrewer")

win.graph()

#Guardamos el resultado como PNG

png(file="C:\\temp\\velocimetro_R.png",width=600, height=450)
```

```r
#Pintamos un gráfico sin nada

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",

,xlim=c(-1,1),ylim=c(0,1),axes=FALSE)

#Creamos un diagrama de barras con una escala de colores que

#empieza en el rojo y finaliza en el verde. Hemos de especificar

#el número de grupos, en este caso la longitud del vector que

#estamos representando

lines(x,y,type="h",lwd=12,

col=colorRampPalette(brewer.pal(9,"RdYlGn"))(length(x)))

#Un semicírculo para crear una rosquilla

lines(x,sqrt(0.5-x**2),type="h",lwd=12,col="white")
```

La librería _RColorBrewer_ nos permite emplear distintas paletas de colores que podemos ver con la función **_display.brewer.all()_** en este caso se empleamos los 9 colores de rojo a verde con _RdYlGn_ al lado tenemos que poner un número que nos permite crear la escala de colores. Con _lines_ y _type=»h»_ creamos barras verticales con la forma circular. Para que nos quede una rosquilla no se me ha ocurrido nada mejor que superponer una línea de barras verticales en blanco. Evidentemente se puede mejorar.

Ahora tenemos que pintar la línea. De momento grafico lo más sencillo, porcentajes que vayan de 0 a 100:

```r
porcentaje=1

posicion=round((porcentaje*length(x))/100)-10

posicion

dx=c(0,x[posicion])

dy=c(0.03,y[posicion])

lines(dx,dy,lwd=10,col="gainsboro")

points(0,.03,lwd=10,col="gainsboro")

dev.off()
```

La línea parte del punto (0,0.03) y va hasta una posición entre el 0 y la longitud del vector que representa el semicírculo. En este caso el 1% será la posición 200 del semicírculo. No puede ser más sencillo. Como último paso pinto un punto con función estética. Como ya os comenté esta es una versión beta del gráfico. Será interesante poner escalas, números, una aguja y representar muchos gráficos de forma ordenada. También estoy abierto a otras sugerencias, de hecho este gráfico es una ídea que me dieron dos lectores.