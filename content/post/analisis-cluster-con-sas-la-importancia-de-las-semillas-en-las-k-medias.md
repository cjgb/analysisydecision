---
author: rvaquerizo
categories:
- Consultoría
- Data Mining
- Formación
- Monográficos
- SAS
- Trucos
- WPS
date: '2013-04-15T10:00:29-05:00'
lastmod: '2025-07-13T15:53:55.986896'
related:
- knn-con-sas-mejorando-k-means.md
- un-peligro-del-analisis-cluster.md
- cluster-svm.md
- macros-sas-tramificar-en-funcion-de-una-variable-respuesta.md
- manual-curso-introduccion-de-r-capitulo-17-analisis-cluster-con-r-y-iii.md
slug: analisis-cluster-con-sas-la-importancia-de-las-semillas-en-las-k-medias
tags:
- k-medias
- proc fastclus
- seed
title: Analisis cluster con SAS. La importancia de las semillas en las k-medias
url: /blog/analisis-cluster-con-sas-la-importancia-de-las-semillas-en-las-k-medias/
---

[![](/images/2013/04/gplot-cluster-1-300x225.gif)](/images/2013/04/gplot-cluster-1.gif)

El PROC FASTCLUS en SAS nos permite realizar análisis de agrupamiento dirigido mediante el algoritmo de las k-medias. Este algoritmo tiene algunos problemas pero nos puede servir para agrupar de forma multivariante observaciones. Es rápido, sencillo de explicar y con algunas lagunas no funciona mal. Como aproximación a nuestras segmentaciones puede ser muy práctico. Hoy se va a utilizar para identificar a los clientes más complicados de segmentar, a aquellas observaciones que quedan en las zonas grises. (http://www.datanalytics.com/blog/2011/08/03/clustering-iii-sobresimplificacion/)
Estas zonas grises en muchos casos son más importantes que la segmentación en sí. Si estamos con un problema de taxonomía (clasificar especies) puede ser menos importante, pero si clasificamos inversiones, clientes,… ¿qué pasa con aquellos que no sabemos ubicar? Escribimos segmentar en un buscador y tenemos esta imagen:

![](https://www.webmarketingemprendedores.com/wp-content/uploads/2012/06/segmentar-el-mercado.jpg)

¡Qué sencillo es segmentar! Cada muñeco queda en su pelota, pero una segmentación se parece más al gráfico (feo) sobre el plano y con dos variables que tenemos más arriba construido con el siguiente código SAS:

```r
data pelota;
do i = 1 to 1000;
*GRUPO 1;
a=0; b=5; x = a+(b-a)*ranuni(34);
a=0; b=5; y = a+(b-a)*ranuni(14);
grupo=1;
distancia = sqrt(((x-2.5)**2)+((y-2.5)**2));
if distancia < 2.5 then output;
end;
run;

data pelota1;
set pelota;
grupo=1;
run;

data pelota2;
set pelota;
x = x+4.5;
grupo=2;
run;

data pelota3;
set pelota;
x = x+2.5;
y = y+3.5;
grupo=3;
run;

data datos;
set pelota1 pelota2 pelota3;
run;

proc gplot data=datos;
	plot y * x = grupo;
run;quit;
```


Incluso lo más habitual es tener situaciones más complicadas, aquí está forzado a tres bolas bastante claras. ¿Qué nos sucede si hacemos un análisis cluster empleando el algoritmo de las k medias sobre estos datos tan peculiares?

```r
proc fastclus data=datos maxclusters=3 out=datos2;
var x y;
quit;

proc gplot data=datos2;
	plot y * x = cluster;
run;quit;
```


[![](/images/2013/04/gplot-cluster-2-300x225.gif)](/images/2013/04/gplot-cluster-2.gif)

Parece que no ha funcionado muy bien en determinados grupos, con grupos aparentemente muy claros. Hay observaciones que quedan esas zonas grises y que al algoritmo le cuesta clasificar. Si pudiéramos tener el mejor escenario posible pondríamos las medias de los grupos que deseamos como semillas para el algoritmo de las k-medias:

```r
proc summary data=datos nway;
class grupo;
output out=medias (keep= x y) mean(x)= mean(y)=;
quit;

proc fastclus data=datos maxclusters=3 out=datos3 seed=medias;
var x y;
quit;

proc gplot data=datos3;
	plot y * x = cluster;
run;quit;
```


[![](/images/2013/04/gplot-cluster-3-300x225.gif)](/images/2013/04/gplot-cluster-3.gif)

Observamos que la clasificación es prácticamente perfecta, puede ser que esas observaciones que quedan entre grupos se clasifiquen de forma incorrecta, pero en general la clasificación es correcta. Mediante las semillas podremos dar al algoritmo las características que deseamos para los cluster. Pero tiene una doble lectura, también podemos asignar las observaciones al grupo que deseemos y perder rigurosidad. Imaginemos la siguiente situación:

```r
data semillas;
input x y;
datalines;
6 2
5 5
2 6
;run;

proc fastclus data=datos maxclusters=3 out=datos4 seed=semillas;
var x y;
quit;

title "Distorsionamos el análisis";
proc gplot data=datos4;
	plot y * x = cluster;
run;quit;
```


[![](/images/2013/04/gplot-cluster-4-300x225.gif)](/images/2013/04/gplot-cluster-4.gif)

Pero a veces perder rigurosidad es interesante para nuestra investigación. Sabemos que existen 3 grupos pero necesitamos identificar las zonas grises, hagamos algo tan absurdo como identificar nuestros perfiles tipo y el perfil medio. Asignemos esas semillas y veamos que hace el análisis cluster:

```r
proc summary data=datos nway;
class grupo;
output out=medias (keep= x y) mean(x)= mean(y)=;
quit;

proc summary data=datos nway;
output out=medias2 (keep= x y) mean(x)= mean(y)=;
quit;

data medias;
set medias medias2;

proc fastclus data=datos maxclusters=4 out=datos5 seed=medias;
var x y;
quit;

title "Identificando zonas grises";
proc gplot data=datos5;
	plot y * x = cluster;
run;quit;
```


[![](/images/2013/04/gplot-cluster-5-300x225.gif)](/images/2013/04/gplot-cluster-5.gif)

Vaya que resultado más interesante nos ha ofrecido el algoritmo en esta ocasión. Resulta que el cluster 4 marca todas aquellas observaciones que son más complejas de identificar. Lo que parece una laguna del análisis cluster puede ser muy útil a la hora de identificar que registros habríamos de mover hacia un lado u otro. Pongámonos en el ejemplo típico de marketing, unos clientes tienen un perfil claro, para aquellos que no tienen un perfil establecido definamos a donde queremos conducirlos y diseñemos una acción que nos permita moverlos hacia un lado o hacia otro, así nuestra estrategia será más dirigida y nos ahorraremos costes.

Así pues, con esta sencilla herramienta podríamos establecer grupos perfectos, distorsionar nuestros grupos a nuestra voluntad e incluso identificar aquellos registros más complicados de clasificar. Es muy útil, espero que por lo menos despierte vuestra curiosidad. Saludos.