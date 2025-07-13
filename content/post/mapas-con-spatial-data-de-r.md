---
author: rvaquerizo
categories:
- Formación
- Monográficos
- R
date: '2010-10-09T11:50:32-05:00'
lastmod: '2025-07-13T16:02:01.820361'
related:
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
- mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
- mapa-de-argentina-con-r.md
- mapa-estatico-de-espana-con-python.md
slug: mapas-con-spatial-data-de-r
tags:
- ''
- mapas
- sp
- spatial data
title: Mapas con spatial data de R
url: /mapas-con-spatial-data-de-r/
---

[](/images/2010/10/colombia13.jpg "colombia13.jpg")

![colombia13.jpg](/images/2010/10/colombia13.thumbnail.jpg)[![espania1.jpg](/images/2010/10/espania1.thumbnail.jpg)](/images/2010/10/espania1.jpg "espania1.jpg")[![mexico1.jpg](/images/2010/10/mexico1.thumbnail.jpg)](/images/2010/10/mexico1.jpg "mexico1.jpg")

Vamos a hacer mapas de México, España y Colombia con R. Y lo primero que tenemos que hacer es disponer de un objeto de R con los datos del mapa. Estos datos los vamos a obtener de [http://www.gadm.org/country ](http://www.gadm.org/country)Seleccionamos el país y el formato que deseamos descargar. Para ilustrar nuestros ejemplos vamos a descargarnos los mapas de España, México y Colombia en formato R data. Vemos que tenemos distintas divisiones en función del nivel al que deseemos llegar. En este caso seleccionamos nivel 2 para España y nivel 1 para Colombia y México. Los hemos descargado a nuestro equipo, mejor descargarlo que no acceder a la web, y comprobamos que tengan extensión Rdata los archivos. Una vez tengamos los archivos con su formato, su extensión y demás ya podemos trabajar con ellos y vamos a trabajar con el paquete sp _spatial data_ :

```r
#install.packages("sp")

library(sp)

ub_colombia="C:\\temp\\00 Raul\\04_software\\mapas\\COL_adm1.Rdata"

ub_mexico="C:\\temp\\00 Raul\\04_software\\mapas\\MEX_adm1.RData"

ub_espania="C:\\temp\\00 Raul\\04_software\\mapas\\ESP_adm2.RData"

#Creamos los objetos de R

load(ub_colombia)

colombia=gadm

load(ub_mexico)

mexico=gadm

load(ub_espania)

espania=gadm
```

Evidentemente modificad la ubicación de los archivos. Cada uno de nuestros objetos tiene una serie de información y una serie de polígonos que nos permiten representar los mapas. El STR es imprescindible, sobre todo tenemos que tener presente la cabecera:

```r
str(espania)

Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots

  ..@ data :'data.frame': 51 obs. of 18 variables:

  .. ..ID_0 : int [1:51] 70 70 70 70 70 70 70 70 70 70 ...

  .. .. ISO : Factor w/ 1 level "ESP": 1 1 1 1 1 1 1 1 1 1 ...

  .. ..NAME_0 : Factor w/ 1 level "Spain": 1 1 1 1 1 1 1 1 1 1 ...

  .. .. ID_1 : int [1:51] 935 935 935 935 935 935 935 935 936 936 ...

  .. ..NAME_1 : Factor w/ 18 levels "Andalucía","Aragón",..: 1 1 1 1 1 1 1 1 2 2 ...

  .. .. ID_2 : int [1:51] 13596 13597 13598 13599 13600 13601 13602 13603 13604 13605 ...

  .. ..NAME_2 : Factor w/ 51 levels "A Coruña","Álava",..: 5 13 18 21 24 26 33 42 25 45 ...

  .. .. VARNAME_2 : Factor w/ 5 levels "Alacant","Araba",..: NA NA NA NA NA NA NA NA NA NA ...

  .. ..NL_NAME_2 : Factor w/ 0 levels: NA NA NA NA NA NA NA NA NA NA ...

  .. .. HASC_2 : Factor w/ 51 levels "ES.AN.AM","ES.AN.CD",..: 1 2 3 4 5 6 7 8 9 10 ...

  .. ..CC_2 : Factor w/ 51 levels "01","02","03",..: 4 11 14 18 21 23 29 40 22 43 ...

  .. .. TYPE_2 : Factor w/ 2 levels "Ciudad Autónoma",..: 2 2 2 2 2 2 2 2 2 2 ...

  .. ..ENGTYPE_2 : Factor w/ 2 levels "Autonomous City",..: 2 2 2 2 2 2 2 2 2 2 ...

  .. .. VALIDFR_2 : Factor w/ 1 level "Unknown": 1 1 1 1 1 1 1 1 1 1 ...

  .. ..VALIDTO_2 : Factor w/ 1 level "Present": 1 1 1 1 1 1 1 1 1 1 ...

  .. .. REMARKS_2 : Factor w/ 0 levels: NA NA NA NA NA NA NA NA NA NA ...

  .. ..Shape_Leng: num [1:51] 6.51 8.05 8.05 7.29 10.21 ...

  .. .. Shape_Area: num [1:51] 0.891 0.748 1.412 1.286 1.029 ...
```

Las variables @data son las que nos permiten representar o colorear indicadores en los mapas. Empecemos a representar gráficamente estos objetos. La función del paquete sp que vamos a emplear es spplot:

```r
jpeg('C:\\temp\\00 Raul\\04_software\\mapas\\colombia1.jpg',

quality = 100, bg = "white", res = 100, width=450, height=600)

spplot(colombia); dev.off()

jpeg('C:\\temp\\00 Raul\\04_software\\mapas\\mexico1.jpg',

quality = 100, bg = "white", res = 100, width=450, height=600)

spplot(mexico); dev.off()

jpeg('C:\\temp\\00 Raul\\04_software\\mapas\\espania1.jpg',

quality = 100, bg = "white", res = 100, width=450, height=600)

spplot(espania); dev.off()
```

Cada uno de los Rdata descargados nos ofrece varios mapas, podemos elegir cual es el que más se adecúa al análisis que vamos a realizar:

```r
spplot(espania[1])

 spplot(mexico[1])

 spplot(colombia[1])
```

A modo de ilustración vamos a representar el PIB per capita de las provincias españolas. Ahora voy a trabajar con España porque conozco muy bien su división territorial, pero el ejemplo lo podréis extrapolar a México y Colombia. Voy a representar el PIB per cápita por provincia. Los datos que he sacado del INE los meto manualmente y en orden por provincia:

```r
#PIB per cápita por provincia en orden

valores=c(32.942,16.268,18.442,20.267,19.401,

15.538,23.854,26.671,25.735,16.173,17.934,23.005,

17.299,15.837,20.318,17.656,25.660,16.580,17.436,

30.734,18.293,22.885,14.870,20.517,26.084,24.032,

18.264,29.227,17.189,18.662,28.104,16.729,21.106,

22.986,20.727,19.480,18.965,18.960,22.634,23.021,

18.062,21.443,25.119,24.226,16.994,20.721,24.382,

28.653,18.684,24.785,19.808);
```

Tengo un vector con los valores que deseo representar en el mapa. Ahora sólo tenemos que preparar un objeto y en @data añadirle los valores a representar:

```r
#Seleccionamos un objeto de mapa

mapa = espania[11]

#str(mapa)

#Añadimos los valores que deseamos representar

mapa@data=data.frame(valores)

spplot(mapa,c("valores"))
```

No es muy complicada su representación. Pero me gustaría señalar que el objeto de R que me he descargado tiene 51 divisiones territoriales cuando España tiene 52. No me he planteado la búsqueda de la incongruencia pero parece que el problema viene por las Islas Canarias. En este monográfico sólo me quiero aproximar a la sintaxis ya haremos representaciones “más serias”. Pero podemos analizar donde está el problema con la siguiente sintaxis:

```r
plot(mapa)

text(getSpPPolygonsLabptSlots(mapa),

labels=as.character(mapa$valores), cex=0.3)
```

Efectivamente sólo ha representado un valor para Canarias. Tenemos que tener mucho cuidado con el uso de este objeto. Además la representación no es muy buena ya que sería más elegante recuadrar las islas y disponer de un mapa con una escala mayor.  
En fin, empezamos a aproximarnos al uso de objetos spatial data para la representación de mapas con R. Poco a poco iré introduciendo estas representaciones en los distintos mapas que realizamos. Por cierto, si alguien quiere seguir la labor y crear ejemplos de uso para Colombia y México que me lo comunique y creamos un link. Saludos.