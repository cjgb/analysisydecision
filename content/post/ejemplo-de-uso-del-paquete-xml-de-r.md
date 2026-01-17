---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-06-08T17:32:21-05:00'
lastmod: '2025-07-13T15:56:38.571526'
related:
- resultados-de-la-liga-con-rstats-estudiando-graficamente-rachas.md
- alineaciones-de-equipos-de-futbol-con-worldfootballr-de-rstats.md
- truco-r-insertar-imagen-en-un-grafico.md
- trucos-r-leer-archivos-xml-con-r.md
- los-principales-problemas-de-los-espanoles-animaciones-con-r-y-gganimate.md
slug: ejemplo-de-uso-del-paquete-xml-de-r
tags:
- plotrix
- XML
title: Ejemplo de uso del paquete XML de R
url: /blog/ejemplo-de-uso-del-paquete-xml-de-r/
---

Quería poneros unos apuntes sobre el paquete XML de R. El caso es que entre todos los fregados en los que ando metidos he retomado el tema de leer páginas web con R. Y con esto he llegado a la sentencia _install.packages(«XML»)_ y con la fiebre mundialista estoy en lo siguiente:

```r
pag="http://es.wikipedia.org/wiki/Anexo:Finales_de_la_Copa_Mundial_de_F%C3%BAtbol"

pagina=data.frame(readHTMLTable(pag))

ganador=data.frame(substr(paginaNULL.Ganador,3,length(paginaNULL.Ganador)))

names(ganador)=primero

segundo=data.frame(substr(paginaNULL.Segundo.puesto,3,length(paginaNULL.Segundo.puesto)))

names(segundo)="segundo"
```

Muy sencillo, leemos la wikipedia y nos creamos un objeto con las finales de todos los mundiales. Me voy a centrar en los finalistas. Parece que tengo algún problema con las tildes y con nulos. Grafiquemos un poco:

```r
ganador=subset(ganador,nchar(as.character(primero))>0)

segundo=subset(segundo,nchar(as.character(segundo))>0)

library(plyr)

tabla=ddply(ganador,"primero",summarise,veces=length(primero))

library(plotrix)

pie3D(tablaveces,labels=tablaprimero,main="Campeones históricos")
```

Vemos que al final esto siempre lo ganan los mismos. Nos facilita una predicción.Veamos los finalistas:

```r
finalistas=data.frame(rbind(as.matrix(ganador,dimnames=list("finalista")),

as.matrix(segundo,dimnames=list("finalista"))))

pie3D(tablaveces,labels=tablaprimero,main="Finalistas")
```

Un poco vago con el nombre de las variables. A la vista de los datos la final será Brasil – Argentina. Lo que no tengo tan claro es cúal ganará… Seguiremos trabajando con XML y con plotrix.