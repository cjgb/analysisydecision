---
author: rvaquerizo
categories:
  - business intelligence
  - excel
  - formación
  - monográficos
  - r
  - trucos
date: '2015-02-20'
lastmod: '2025-07-13'
related:
  - mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
  - mapas-municipales-de-espana-con-excel-y-qgis.md
  - identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
  - mapa-estatico-de-espana-con-python.md
  - mapas-con-spatial-data-de-r.md
tags:
  - mapas
  - spatial data
  - españa
title: Mapas municipales de España en R, con la ayuda de Excel
url: /blog/mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel/
---

![municipios extremadura R 1](/images/2015/02/municipios-extremadura-R-1-293x300.png)

[El escribir sobre el `BDT` de Madrid ](https://analisisydecision.es/mapas-de-la-provincia-de-madrid-con-bdt/)me ha hecho [recordar mi trabajo con `statial data` de `R`](https://analisisydecision.es/mapas-con-spatial-data-de-r/). Los mapas de `statial data` los podemos obtener de forma gratuita de <http://www.gadm.org/country> y en este caso vamos a descargarnos para España un `SpatialPolygonsDataFrame` específico para `R` de `nivel 4` que está a `nivel` municipal (repito `nivel` todas las veces necesarias), el archivo que os debéis descargar se llamará `ESP_adm4.RData`. Si buscáis un poco en google encontraréis documentación acerca de este tipo de archivos de `R` y veréis que se pueden hacer maravillas. En este caso quiero hacer un ejemplo lo más sencillo posible, muy artesanal y casero. Con un poco de imaginación podréis complicarlo o incluso hacer una herramienta en `Excel` que hiciera mapas con `R`.

Descargado el archivo vamos a comenzar nuestro trabajo con `R`. Sólo será necesaria la `librería sp` y `RColorBrewer` para que el mapa obtenido sea más vistoso:

```r
#install.packages("sp")
library(sp)

ub_espania="C:\\TEMP\\00 raul\\ESP_adm4.RData"
#Creamos los objetos de R
load(ub_espania)
espania=gadm
```

Con 5 líneas de código ya disponemos del objeto con los mapas municipales de España. Para ilustrar el ejemplo deseamos realizar un mapa de población por municipios de Extremadura. Los datos que vamos a utilizar nos los podemos descargar [del anuario económico de «la Caixa»](http://www.anuarioeco.lacaixa.comunicacions.com/java/X?cgi=caixa.anuari99.util.ChangeLanguage&lang=esp) que no tiene todos los municipios, sólo aquellos con más de 1000 habitantes. Podéis emplear datos del `INE`. Esta es la parte más artesanal, en mi caso dispongo de los datos en `Excel` y es necesario añadir los datos del anuario económico. ¿Qué es lo que se me ha ocurrido hacer? Con código `R` lo entenderéis mejor:

```r
unique(espania@data NAME_1)
extremadura = espania[espaniaNAME_1=="Extremadura",]
extremadura_pueblos <- unique(extremadura@data$NAME_4)
write.table(pueblos, "c:/temp/borra.txt", sep="\t")
#En este punto trabajamos con Excel
```

Primero vemos cual es el nombre que le asigna a Extremadura (`nivel 1`), con ello creamos un objeto sólo con `datos` de Extremadura. Después otro objeto con el nombre de los municipios (`nivel 4`), podéis imaginar que el `nivel 2` es la provincia y el `nivel 3` es… ¡no sé que es el `nivel 3`! No lo entiendo. Imagino que será necesario para otros países. Por cierto, para los lectores de América del Sur, esto es perfectamente válido. No hago un ejemplo porque desconozco la división territorial. Si alguien me ayuda puedo ilustrarlo. Los pueblos los llevamos a `Excel` y allí realizamos el cruce de `datos`. Esto es demasiado casero, no queda muy profesional. Si trabajáis con los `ID` de los objetos `spatial data` conseguiréis mejorar este paso. En mi caso particular tengo archivos de `Excel` que directamente rellenan la información en `R` y mi objetivo final es que sea `Excel` el que maneje `R`, no que todo quede en `R`. A partir de tener los `datos cocinados` todo es más fácil:

```r
#Es necesario que leas con cabeceras
datos = read.delim("clipboard")
mapa = extremadura[11]
mapa@data=data.frame(datos)

library(RColorBrewer)

spplot(mapa,col.regions=brewer.pal(9, "Blues"))
```

Leemos de `Excel`, con una cabecera, esto es importante, creamos el objeto con la información necesaria del objeto `S4 extremadura` para pintar el mapa a excepción de los `datos` que necesita representar que esos serán los que vienen precisamente de `Excel`. Por último sólo pintamos el mapa y le añadimos más vistosidad con una paleta de colores de `RColorBrewer`, la `Blues`, que particularmente me gusta mucho.

Todo el proceso puede parecer un poco lioso, pero sentaros y, con unos `datos` en `Excel` por municipios, empezad a seguir los pasos que indico, en 30 minutos podéis hacer maravillas. Y me reitero. POR FAVOR, PARA AQUELLOS LECTORES DE MEXICO, COLOMBIA, CHILE,… AYUDADME Y REALIZAMOS EL EJEMPLO.

En mi caso particular esto va a derivar en un complemento de `Excel` que espero presentar en el [grupo de usuarios de `R` de Madrid](http://madrid.r-es.org/). Grupo en el que somos uno menos y por esto quería dedicarle esta entrada a Gregorio que allá donde esté seguro que sigue compartiendo sus conocimientos.
