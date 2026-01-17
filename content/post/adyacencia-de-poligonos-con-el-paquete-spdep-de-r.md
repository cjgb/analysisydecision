---
author: rvaquerizo
categories:
- Formación
- Mapas
- Monográficos
- R
- Seguros
date: '2016-05-29T13:42:45-05:00'
lastmod: '2025-07-13T15:53:41.700577'
related:
- como-obtener-los-centroides-de-municipios-con-sas-mapas-con-sgplot.md
- identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- representar-poligonos-de-voronoi-dentro-de-un-poligono.md
- libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
slug: adyacencia-de-poligonos-con-el-paquete-spdep-de-r
tags:
- geolocalizacion
- Mapa
- spdep
- zonificacion
title: Adyacencia de polígonos con el paquete spdep de R
url: /blog/adyacencia-de-poligonos-con-el-paquete-spdep-de-r/
---

Cuando trabajamos con **zonificación** o **geolocalización** la adyacencia entre los elementos del estudio es relevante. En este caso quería trabajar con la adyacencia entre los polígonos que componen un archivo de datos espaciales shapefile y para entender mejor como podemos obtener la adyancecia entre polígonos creo que lo mejor es hacer un ejemplo con un mapa, en este caso un mapa de municipios de Barcelona. El primer paso es disponer del objeto con los datos espaciales, [de esto ya he escrito mucho en el blog](https://analisisydecision.es/mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel/) y por eso no me detengo mucho:

```r
ub="./Desktop/R/mapas/ESP_adm4.rds"

#Creamos los objetos de R
espania = readRDS(ub)
barcelona = espania[espania$NAME_2=="Barcelona",]
plot(barcelona)
#Marcamos el centro de cada poligono
points(coordinates(barcelona))
```


[![adyacencia poligonos con R 1](/images/2016/05/adyacencia-poligonos-con-R-1.png)](/images/2016/05/adyacencia-poligonos-con-R-1.png)

Leemos el objeto con los datos municipales de España y hacemos un subset para quedarnos sólo con Barcelona y realizamos un mapa municipal de la provincia de Barcelona sencillamente usando plot. Podemos identificar todos los centroides de los polígonos que componen este objeto con la función coordinates, ahora lo que necesitamos identificar es la adyacencia entre estos puntos, la adyacencia entre los municipos de Barcelona. En mi caso localicé el paquete spdep de R, muy adecuado para trabajar con ponderaciones.

Os pongo paso por paso el código de R y luego comento como voy buscando REFERENCIAS para crear las adyacencias:

```r
#install.packages("spdep")
library(spdep)
centros = coordinates(barcelona)
mas_proxima = knn2nb(knearneigh(centros))
```


El primer paso es buscar el centroide más cercano para cada uno de los elementos con los que trabajo y a partir de ese momento necesito buscar una referencia para establecer la adyacencia. En un primer paso fijo esa referencia en el percentil 99 y puedo graficarla:

```r
referencia = quantile(unlist(nbdists(mas_proxima, centros)),.99)
proximos = dnearneigh(centros, 0, referencia)
plot(barcelona)
plot(proximos, centros, add=TRUE,col="red")
```


[![adyacencia polígonos con R 2](/images/2016/05/adyacencia-polígonos-con-R-21.png)](/images/2016/05/adyacencia-polígonos-con-R-21.png)

Calculamos el percentil 99 del conjunto de todas las distancias entre próximos, algún polígono quedará necesariamente sin unir la función **dnearneigh** va a crear una lista que, polígono a polígono, recoge los polígonos cuya distancia euclídea está dentro de los límites de referencia. Barcelona capital sólo se une a los municipios del sur porque los del norte están fuera de la distancia euclídea de referencia. A modo ilustrativo la lista para los datos municipales de Barcelona con los que estamos trabajando sería:

```r
> str(proximos)
List of 313
 : int 190 : int 0
 : int [1:11] 7 9 10 21 22 31 34 35 81 102 ... : int [1:14] 8 15 18 21 22 31 32 34 86 89 ...
 $ : int [1:6] 6 11 13 24 26 28
-------
  [list output truncated]
 - attr(*, "class")= chr "nb"
 - attr(*, "nbtype")= chr "distance"
 - attr(*, "distances")= num [1:2] 0 0.0698
 - attr(*, "region.id")= chr [1:313] "1" "2" "3" "4" ...
 - attr(*, "call")= language dnearneigh(x = centros, d1 = 0, d2 = referencia)
 - attr(*, "dnn")= Named num [1:2] 0 0.0698
  ..- attr(*, "names")= chr [1:2] "" "99%"
 - attr(*, "bounds")= chr [1:2] "GT" "LE"
 - attr(*, "sym")= logi TRUE
```


El objeto barcelona se compone de 313 polígonos (municipios) y para cada uno de los correspondientes polígonos los adyacentes están en la lista. Si queremos que todos los municipios tengan su adyacente la distancia referencia habría de ser la máxima posible:

```r
referencia = max(unlist(nbdists(mas_proxima, centros)))
proximos = dnearneigh(centros, 0, referencia)
plot(barcelona)
plot(proximos, centros, add=TRUE,col="red")
```


[![adyacencia polígonos con R 3](/images/2016/05/adyacencia-polígonos-con-R-3.png)](/images/2016/05/adyacencia-polígonos-con-R-3.png)

Interesantes posibilidades las que nos ofrece spdep para la realización de estos análisis, en este caso estamos en el mínimo nivel, la adyacencia por distancias euclídeas. También podemos hacer adyacencias en función de los k vecinos:

```r
proximos_k3 = knn2nb(knearneigh(centros, k=4, longlat=TRUE))
plot(barcelona)
plot(proximos_k3, centros, add=TRUE,col="red")
```


[![adyacencia polígonos con R 4](/images/2016/05/adyacencia-polígonos-con-R-4.png)](/images/2016/05/adyacencia-polígonos-con-R-4.png)

Creamos adyacencias para los k=4 elementos mas cercanos polígono a polígono con la función **knearneigh** aunque en este caso el objeto que genera es necesario transformarlo en lista con **knn2nb**. Más posibilidades para spdep, en cualquier caso a ver si encuentro ejemplos ilustrativos y pasamos de la adyacencia a la ponderación que es donde de verdad me gusta como funciona este paquete. Espero que os sea útil. Saludos.