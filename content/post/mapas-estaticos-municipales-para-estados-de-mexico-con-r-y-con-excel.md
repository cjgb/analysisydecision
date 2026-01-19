---
author: rvaquerizo
categories:
- excel
- formación
- r
- trucos
date: '2015-03-20'
lastmod: '2025-07-13'
related:
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- mapas-con-spatial-data-de-r.md
- mapas-municipales-de-espana-con-excel-y-qgis.md
- mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
- mapa-estatico-de-espana-con-python.md
tags:
- mapas
- mexico
title: Mapas estáticos municipales para estados de México. Con R y con Excel
url: /blog/mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel/
---
![mexico_municipios_R_excel](/images/2015/03/mexico_municipios_R_excel-300x267.png)

Podemos pintar mapas municipales de México con la ayuda de R y Excel. Esta entrada está [en la línea de otra anterior para hacer esta misma tarea con mapas de España](https://analisisydecision.es/mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel/). Disponemos de los datos en Excel y tenemos intalado R y la librería sp. El objeto R con los mapas de México lo podemos encontrar en <http://www.gadm.org/country> seleccionamos Mexico y R Spatial Poligons Data Frame y debemos descargarnos el objeto de nivel 2. Comenzamos el trabajo con R:

```r
library(sp)
library(RColorBrewer)

ub_mexico="C:\\TEMP\\00 raul\\MAPA\\MEX_adm2.RData"

#Creamos los objetos de R
load(ub_mexico)
mexico=gadm

unique(mexico@data$NAME_1)
```


Esos son los Estados mexicanos que tenemos en el mapa. Para ilustrar el ejemplo vamos a pintar el número de habitantes del estado de México. Por ello creamos un objeto sólo con el estado de México:

```r
mexico = mexico[mexico$NAME_1=="México",]
```


Ahora es necesario que nos llevemos a Excel el nombre de los municipios para cruzar los datos:

```r
writeClipboard(unique(mexico@data$NAME_2))
#Rellenamos los datos con http://qacontent.edomex.gob.mx/coespo/numeralia/poblaciontotal/municipios_j_s/index.htm
```


De la web indicada sacamos el número de habitantes y en Excel realizamos el cruce de datos.[Os adjunto en la entrada el Excel empleado.](/images/2015/03/mexico.xlsx) Hemos rellenado los datos, en ocasiones es necesario darle una vuelta al nombre de algunos municipios pero se tarda poco en el caso del estado de México. Pegas los nombres de los municipios y buscas en tus datos. Una vez hayas completado el cruce copiando los datos en Excel te lo puedes llevar a R y ejecutando el siguiente código tenemos:

```r
datos = read.delim("clipboard")

#Ya estamos en disposición de pintar el mapa
mexico=mexico[1]
mexico@data <- datos
spplot(mexico,col.regions=brewer.pal(5, "Blues"))
```


Que nos pinta el mapa con el que se inicia esta entrada. Muy casero, manual, pero una vez hayáis hecho uno el resto de mapas estáticos es inmediato y los resultados pueden quedar muy bien. Seguro que es útil para los lectores de México. Saludos.

[
](/images/2015/03/mexico_municipios_R_excel.png)