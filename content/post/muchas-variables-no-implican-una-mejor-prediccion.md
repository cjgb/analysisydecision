---
author: rvaquerizo
categories:
  - data mining
  - modelos
  - r
date: '2011-01-30'
lastmod: '2025-07-13'
related:
  - el-problema-de-la-multicolinealidad-intuirlo-y-detectarlo.md
  - entrenamiento-validacion-y-test.md
  - monografico-regresion-logistica-con-r.md
  - obteniendo-los-parametros-de-mi-modelo-gam.md
  - manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
tags:
  - azar
  - importancia variables
title: Muchas variables no implican una mejor predicción
url: /blog/muchas-variables-no-implican-una-mejor-prediccion/
---

![](https://2.bp.blogspot.com/_zFAmaVE4u-U/Sj61p51qOUI/AAAAAAAAANA/ogdK03jx7o4/s320/127brosavientos.jpg)

Me sigo durmiendo con el genio [Juan Antonio Cebrián](http://es.wikipedia.org/wiki/Juan_Antonio_Cebri%C3%A1n) y sus pasajes de la historia, monográficos zona cero o tertulias 4 C. Sus programas de radio me acompañan desde hace muchos años. Estudiando, vigilando instalaciones del ejercito o en el turno de noche de una [fábrica ](http://portal.danosa.com/danosa/CMSServlet?node=F111M&lng=1&site=1&dbg=1)Cebrián y su gente ha estado conmigo. En alguna ocasión hablaron del [código secreto de la Bíblia](http://es.wikipedia.org/wiki/El_c%C3%B3digo_secreto_de_la_Biblia), un código existente en la Torá (Pentateuco) que se resume en «todo está escrito».Y es que una gran cantidad de información puede provocar relaciones al azar (o al azahar como le gusta decir a un buen amigo). Y esto puede pasarnos en nuestros modelos matemáticos. Ejecutemos el siguiente código en R:

```r
#DF de partida

df=data.frame(rnorm(1000,100,10))

names(df)=c("dependiente")

#Bucle para añadir 300 variables

for (i in 1:300){

x=data.frame(rnorm(1000,sample(1:100,1),sample(1:50,1)))

nombre=paste("x",i,sep="")

names(x)=nombre

df=cbind(df,x)

remove(x)}

#1.000 observaciones y 300 variables

head(df)
```

Tenemos un _data frame_ con datos aleatorios, 1.000 observaciones y 300 variables. ¿Pueden existir relaciones aleatorias entre una variable dependiente y estas 300 variables aleatorias? Realicemos un modelo de regresión a ver que pasa:

```r
modelo=lm(dependiente~. ,data=df)

summary(modelo)
```

No sé lo que os habrá salido a vosotros, pero he encontrado 5 variables donde rechazamos la hipótesis nula que establece que no hay relación lineal. Es decir, 5 variables aleatorias tienen una relación lineal con otra variable aleatoria. ¿Cómo es posible? El azar ha intervenido en nuestro modelo debido al gran número de variables que forman parte de él. Mirad con recelo a aquellos que os dicen «el modelo acierta» y no os justifican los motivos de tal acierto.
