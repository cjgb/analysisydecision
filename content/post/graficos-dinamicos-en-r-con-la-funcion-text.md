---
author: rvaquerizo
categories:
- Formación
- R
- Trucos
date: '2010-07-22T06:50:29-05:00'
lastmod: '2025-07-13T15:58:20.353554'
related:
- trucos-r-graficos-de-velocimetro-con-r.md
- truco-r-paletas-de-colores-en-r.md
- un-acercamiento-a-graph-proc-ganno.md
- graficos-de-burbuja-con-r.md
- analisisydecision-es-os-desea-felices-fiestas.md
slug: graficos-dinamicos-en-r-con-la-funcion-text
tags:
- text
title: Gráficos dinámicos en R con la función text
url: /blog/graficos-dinamicos-en-r-con-la-funcion-text/
---

En graphics tenemos la función **text** y hoy nos vamos a divertir con esta función. Simplemente lo que hace es poner un texto en un gráfico. Lo más sencillo:

```r
#Gráfico sin nada

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",axes=FALSE)

#Ponemos un texto en el centro

text(10,10,"Ejemplo de uso de text")
```

En un gráfico sin nada escribimos, sólo indicamos la posición y el texto a escribir. Vamos añadiendo opciones:

```r
#Gráfico sin nada

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",axes=FALSE)

#Ponemos un texto en el centro

text(10,10,"Ejemplo de uso de text",srt=45,col=1,cex=3,

vfont=c("sans serif", "plain"))
```

Ahora modificamos la inclinación del texto con **SRT** , el color, el tamaño y con **vfont** la fuente. Podemos jugar con los colores del texto realizando un bucle for:

```r
#Realizamos un bucle

for (i in 1:20){

#Gráfico sin nada

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",axes=FALSE)

#Ponemos un texto en el centro

text(10,10,"Ejemplo de uso de text",srt=0,col=i,cex=2)

Sys.sleep(0.1)}
```

Y si recorremos un texto letra a letra entonces podemos hacer:

```r
texto="Letra por letra";

for (i in 1:nchar(texto)){

letra=substr(texto,i,i)

frase=substr(texto,1,i)

#Gráfico sin nada

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",axes=FALSE)

text(11,11,letra,srt=0,col=i,cex=5)

text(10,8,frase,srt=0,cex=2)

Sys.sleep(0.1)}
```

Estamos creando algo muy parecido a una animación… Continuamos:

```r
for (i in 1:20){

#Gráfico sin nada

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",axes=FALSE)

#Ponemos un texto en el centro

text(10,10.5,"Algo parecido",srt=0,col=i,cex=3*i/20)

text(10,9.5,"a una animación",srt=0,col=i,cex=3*i/20)

Sys.sleep(0.01)}
```

Otra vuelta de tuerca al tema:

```r
#Realizamos un bucle

for (i in 1:360) {

plot(rep(10,10),rep(10,10),ann=FALSE,type="n",axes=FALSE)

text(10,10.5,"Algo parecido",srt=-i,col=rainbow(360)[i],cex=3*i/360)

text(10,9.5,"a una animación",srt=i,col=rainbow(360)[i],cex=3*i/360)

Sys.sleep(0.01)}
```

Códigos divertidos y sin mucha complicación. En breve espero poder hacer verdaderos gráficos dinámicos e interactivos en R. Saludos.