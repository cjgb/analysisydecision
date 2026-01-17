---
author: rvaquerizo
categories:
- Formación
- Modelos
- SAS
- WPS
date: '2013-07-26T04:01:28-05:00'
lastmod: '2025-07-13T15:54:19.240224'
related:
- manual-curso-introduccion-de-r-capitulo-10-funciones-graficas-en-regresion-lineal.md
- primeros-pasos-con-regresion-no-lineal-nls-con-r.md
- parametro-asociado-a-una-poisson-con-sas.md
- en-la-regresion-logistica-el-sobremuestreo-es-lo-mismo-que-asignar-pesos-a-las-observaciones.md
- manual-curso-introduccion-de-r-capitulo-9-introduccion-a-la-regresion-lineal-con-r.md
slug: atentos-a-los-intervalos-de-confianza
tags: []
title: Atentos a los intervalos de confianza
url: /blog/atentos-a-los-intervalos-de-confianza/
---

[![](/images/2013/07/cali.png)](/images/2013/07/cali.png)

Un [intervalo de confianza ](http://es.wikipedia.org/wiki/Intervalo_de_confianza)es la zona en la que me fío de lo que estimo. Cuanto más amplia es esa zona menos me fío de lo que estimo y cuanto más estrecha más me fío de lo que estimo. Lo que pasa es que un intervalo de confianza por definición empieza con la famosa expresión “ _dada una población de media nu y desviación típica sigma…_ ”

**¡¡¡FU FU FU FU FU FU!!!**

Cuando una definición empieza así levantad las orejas como el can que tenéis al comienzo de estas líneas, una brava infante de marina que, tras 11 años cuidando de mi y de mi familia está pasando horas bajas. Y debéis estar atentos porque estáis trabajando con una media y cuando los datos se parezcan más a la media más me fío de lo que estimo. Sin embargo no por estar más cerca de la media mi estimación tiene que ser mejor. Hacemos unos datos aleatorios con SAS:

```r
data uno;
do x = 1 to 100;
tam = int(110 - rangam(3,x))/30;
do j = 1 to tam;
y = ranuni(8);
dist = sqrt((y-x/100)**2);
if dist
```


[![](/images/2013/07/intervalo_confianza_sas_1.png)](/images/2013/07/intervalo_confianza_sas_1.png)

Tenemos una nube de puntos a la que deseamos ajustar un modelo de regresión lineal y obtener un intervalo de confianza:

```r
proc reg data=uno;
model y = x/spec;
plot y*x/conf;
run;quit;
```


Podemos observar que el intervalo se estrecha en la zona central de nuestra recta de regresión, es decir, es más estrecho en el punto (media_y,media_x) por donde pasan todas las rectas de regresión, sin embargo casi todos los puntos están fuera de ese intervalo en esa zona y a la izquierda, donde el intervalo es ligeramente más ancho, casi todos los puntos caen dentro. No es un modelo que presenta homocedasticidad algo que comprobamos con la opción spec. Es evidente que los datos tienen poco de aleatorios, están forzados para que salga lo que tiene que salir, pero se trata de alertaros sobre medias y desviaciones típicas. Y pediros, también, que veáis **gráficos de residuos** cuando modelicéis:

```r
proc reg data=uno;
model y = x;
plot y*x/conf;
plot residual.*x;
run;quit;
```


[![](/images/2013/07/intervalo_confianza_sas_2.png)](/images/2013/07/intervalo_confianza_sas_2.png)

A la vista de este gráfico podríamos apreciar **heterocedasticidad** , pero no es muy clara, pero si que es evidente que mi modelo funciona mucho mejor para valores pequeños de X, donde los intervalos de confianza eran más anchos, donde menos me fío de lo que estimo. Saludos.