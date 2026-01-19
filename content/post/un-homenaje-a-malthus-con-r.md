---
author: rvaquerizo
categories:
- formación
- monográficos
- r
date: '2010-06-13'
lastmod: '2025-07-13'
related:
- los-pilares-de-mi-simulacion-de-la-extension-del-covid19.md
- etiquetas-en-scatter-plot-muertes-covid-por-millon-de-habitantes-vs-gasto-en-salud.md
- manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-ii.md
- informes-con-r-en-html-comienzo-con-r2html-i.md
- monografico-regresion-logistica-con-r.md
tags:
- gsub
- plotrix
- pyramid.plot
- r
- xml
title: Un homenaje a Malthus con R
url: /blog/un-homenaje-a-malthus-con-r/
---
Hoy quería yo revindicar la figura de un tipo bastante maltratado: [Thomas Malthus](http://es.wikipedia.org/wiki/Thomas_Malthus). Maltratado porque era un poco reaccionario y facha, y parece que eso es suficiente para que se olviden de uno, aunque fuera el tipo que más ha aportado a la [demografía](http://es.wikipedia.org/wiki/Demograf%C3%ADa).Y el homenaje tenía que hacérselo con el paquete de R que más utilizo últimamente, el XML y algunos sencillos gráficos creados con R-commander. Malthus lo que venía a decir es que somos muchos, demasiados y encima la cosa tenía muy mala pinta. Parece que tiene razón, pero vamos a verlo gráficamente. Comenzamos:

```r
library(XML)

pag="http://en.wikipedia.org/wiki/World_population"

total_tablas=readHTMLTable(pag)

str(total_tablas)
```

Nos interesa saber la población estimada y tenemos 17 elementos. Nos vamos a quedar con las estimaciones desde el siglo XVIII en adelante. Tenemos el problema con los formatos de los números:

```r
poblacion=data.frame(total_tablas`Estimated world population at various dates (in millions) [citation needed]`)

#NOS QUEDAMOS CON LOS REGISTROS QUE NOS INTERESAN

poblacion=poblacion[c(16:nrow(poblacion)-1),]

#FUNCION PARA TRANSFORMAR CARACTER A NUMERO

cambio=function(x){

x=(gsub("([[:punct:]])","",x))

x=(gsub("([[:alpha:]])","",x))

#AJUSTE A MEDIDA, POR NO COMPLICAR LA FUNCION

x=as.numeric(gsub(" 1 ","",x))}

#PODEMOS USAR SAPPLY:

poblacionYear=cambio(poblacionYear)

poblacionWorld=cambio(poblacionWorld)

poblacionAfrica=cambio(poblacionAfrica)

poblacionAsia=cambio(poblacionAsia)

poblacionEurope=cambio(poblacionEurope)

poblacionLatin.America.Note.1.=cambio(poblacionLatin.America.Note.1.)

poblacionNorthern.America.Note.1.=cambio(poblacionNorthern.America.Note.1.)

poblacionOceania=cambio(poblacion$Oceania)
```

Analicemos si Malthus tenía motivos para ser tan cenizo:

```r
plot(poblacionYear,poblacionWorld,type="l",col="red",

lwd=3, main="Evolución de la población desde el siglo XVIII")

#Malthus murió en el 1834. Nada más comenzar a liarla la reina Victoria

#Pintamos una línea vertical

lines(rep(1834,10),seq(1,7000,by=700),lty="dashed")
```

![pob1.png](/images/2010/06/pob1.png)

Hay que decir que Malthus era clérigo, por eso tenía tanto tiempo para dedicar al pensamiento, eso facilita su genialidad. No es quitarle méritos pero el resto de la población inglesa (y sobre todo de las colonias inglesas) bastante tenían con poder acceder a la comida. Si realizamos este gráfico con la ayuda del R-Commander para cada contiente nos encontramos lo siguiente:

```r
.mar <- par(mar=c(5.1,4.1,10.5,2.1))

matplot(poblacion$Year,

poblacion[, c("Africa","Asia","Europe","Latin.America.Note.1.","Northern.America.Note.1.","Oceania","World")],

type="l", lty=1, lwd=2, ylab="Población en millones de habitantes")

.xpd <- par(xpd=TRUE)

legend(1739.68, 11673.1615019011,

legend=c("Africa","Asia","Europe","Latin.America","Northern.America","Oceania","World"),

col=c(1,2,3,4,5,6,1),   lty=1,lwd=2)

par(mar=.mar)

par(xpd=.xpd)
```

![pob2.png](/images/2010/06/pob2.png)

Yo empleo mucho el R-Commander para realizar gráficos «rápidos», es una forma de conseguir código que luego podemos modificar de un modo muy sencillo. En este caso he empleado el menos sofisticado posible, un gráfico lineal. A la vista de los datos es evidente que el crecimiento exponencial de la población comenzó a primeros del siglo XX en Asia. África comienza a despuntar, pero la esperanza de vida allí es mucho menor:

![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Life_Expectancy_2009_Estimates_CIA_World_Factbook.svg/800px-Life_Expectancy_2009_Estimates_CIA_World_Factbook.svg.png)

Si analizamos las pirámides de población las africanas dan mucho que pensar. Si Malthus está un poco olvidado el continente africano… Para analizar pirámides de población tenemos el módulo **epicalc** y la función **pyramid**. Así si deseamos hacer la pirámide de población de Mali con R podemos hacer lo siguiente:

```r
mali=readHTMLTable("http://data.un.org/Data.aspx?q=age+sex+mali&d=GenderStat&f=inID%3a6%3bcrID%3a48")

mali=mali[[2]] #Nos quedamos con el segundo elemento

#VECTOR DE ETIQUETAS

etiquetas=gsub("Male ","",maliSubgroup)

etiquetas=gsub("Female ","",etiquetas)

etiquetas=gsub(" yr","",etiquetas)

etiquetas=unique(etiquetas)

#DATOS PARA HOMBRES

xx.data=as.vector(subset(mali,substr(maliSubgroup,1,1)=="M")Value)

xx.data=as.numeric(xx.data)

xx.data=(xx.data/sum(xx.data))*100

#DATOS PARA MUJERES

xy.data=as.vector(subset(mali,substr(maliSubgroup,1,1)=="F")$Value)

xy.data=as.numeric(xy.data)

xy.data=(xy.data/sum(xy.data))*100

library(plotrix)

pyramid.plot(xy.data,xx.data,labels=etiquetas, gap=5,show.values=TRUE)
```

![pob3.png](/images/2010/06/pob3.png)

Con este gráfico lo primero que tenemos que decir es que la B[BDD de las Naciones Unidas](http://data.un.org/) está un poco hecha polvo, además los colores que selecciona R por defecto son muy feos. Los rangos se solapan y no parece que actualicen mucho sus estimaciones estos de la ONU. De todos modos nos quedamos con el % de personas mayores de 65, preocupante. En fin, R ha sido buena escusa para recordar a un gran pensador bajo mi punto de vista muy olvidado. Saludos.