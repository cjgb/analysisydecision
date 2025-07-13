---
author: rvaquerizo
categories:
- Formación
- R
date: '2010-10-02T14:02:35-05:00'
slug: 'descubriendo-ggplot2'
tags:
- geom_boxplot
- geom_histogram
- geom_line
- geom_points
- geom_text
- ggplot2
title: Descubriendo ggplot2
url: /descubriendo-ggplot2/
---

Bye bye plot, bye bye points, bye bye abline,…[![Imagen de previsualización de YouTube](https://img.youtube.com/vi/bNcl0L7eJUY/0.jpg)](http://www.youtube.com/watch?v=bNcl0L7eJUY)Como la canción Bye bye life. He escrito en el Tinn-R install.packages(“ggplot2”) y estoy como un niño con zapatos nuevos. Así estoy desde que he comenzado a trabajar con el paquete ggplot2 de R. No es que no lo conociera, es que me defiendo demasiado bien con mis plot y mis points. Había visto algún gráfico espectacular pero el código asustaba. Sin embargo este paquete es tema de conversación todas las semanas con algún usuario de R. Entonces me siento delante de R y tras escribir library(ggplot2)…
`x <- abs(rnorm(20,10,2))y <- abs(rnorm(20,5,1))grupo <- rpois(20,2)datos <- data.frame(cbind(grupo,x,y))#Gráfico de dispersióng <- ggplot(datos,aes(x,y))g + geom_point()#Identificamos los puntosg + geom_point(aes(colour = grupo))`
¿Qué os parece? Anda que no es fácil trabajar con ggplot2. Además tiene su [propia web de ayuda](http://had.co.nz/ggplot2/) con una gran cantidad de ejemplos ymuy documentada por lo que no es necesario un manual. Con un acercamiento y algunos ejemplos me parece suficiente.Particularmente me encantan los boxplot y además podemos añadir puntos:

```r
g2 <- ggplot(datos,aes(factor(grupo),x))

g2 + geom_boxplot()g2 + geom_boxplot() + geom_jitter()
```

Los histogramas no me gustan, pero siempre son imprescindibles y nos permiten entender el “subcódigo” de ggplot2:

```r
g3 <- ggplot(datos,aes(x))g3 + geom_histogram(binwidth=1)

g3 + geom_histogram(aes(y=..density..),binwidth=1,fill="white", colour="grey") + geom_density()
```

Y cuando queremos hacer gráficos por grupos ¡no es necesario trabajar con par!
```r
g3.1 <- g3 + geom_histogram(aes(y=..density..),binwidth=1,fill="white", colour="grey") + geom_density()

g3.1 + facet_wrap(~grupo)
```

¿Qué os parece facet_wrap? Fácil, muy fácil. El código es muy sencillo, lástima de no tener un código semafórico tipo Tinn-R, seguro que existe algo para el U-Edit pero este último es de pago. En el momento de escribir estas líneas ando entretenido con el geom_text:

```r
g4 <- ggplot(datos,aes(x,y,label=grupo))

g4 + geom_point() + geom_text()
```

Más puntos a favor del ggplot2. En todo caso os sugiero que os deis una vuelta por la web y busquéis ejemplos de uso. En mi caso, a partir de hoy, me comprometo a emplear este paquete para los gráficos más habituales de mis ejemplos.