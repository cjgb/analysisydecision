---
author: rvaquerizo
categories:
- business intelligence
- formación
- mapas
- r
date: '2020-12-10'
lastmod: '2025-07-13'
related:
- mapa-del-covid-19-por-comunidades-autonomas-con-r-mas-rstats.md
- incluir-subplot-en-mapa-con-ggplot.md
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- mapa-estatico-de-espana-con-python.md
tags:
- mapas
- r
title: Librería mapSpain en RStats. Mapas estáticos de España
url: /blog/libreria-mapspain-en-rstats-mapas-estaticos-de-espana/
---
[![](/images/2020/12/mapspain1.png)](/images/2020/12/mapspain1.png)

Más mapas estáticos de España con R esta vez con la [librería mapSpain de Diego Hernangomez](http://CCAA.sf <- esp_get_ccaa\(\) table\(CCAA.sf$iso2.ccaa.code\)) que simplifica mucho la realización de esta tarea. el primer ejemplo es un mapa del exceso de mortalidad por comunidad Autónoma para el año 2020 [reaprovechando un código del blog](https://analisisydecision.es/no-estamos-igual-que-en-la-primera-ola-de-covid/):

```r
library(mapSpain)
library(sf)
library(tidyverse)
library(lubridate)
library(stringr)

df <- read.csv("https://momo.isciii.es/public/momo/data")

df <- df %>% dplyr::filter(ambito =='ccaa' & nombre_sexo=='todos' & cod_gedad=='all') %>%
  mutate(fecha_defuncion=as.Date(fecha_defuncion, '%Y-%m-%d')) %>%
  filter(year(fecha_defuncion)>=2020)

df <- df %>% mutate(ola = case_when(
  fecha_defuncion <= as.Date("2020-03-07") ~ 'Anteriores',
  fecha_defuncion <= as.Date("2020-05-07") ~ 'Primera ola',
  fecha_defuncion <= as.Date("2020-08-01") ~ 'Verano',
  TRUE ~ 'Segunda ola'),
  exceso = round(defunciones_observadas/defunciones_esperadas-1,4)*100,
  iso2.ccaa.code = paste0("ES-",cod_ambito,sep=""))

agr <- df %>% dplyr::filter(ola=='Primera ola') %>% group_by(iso2.ccaa.code) %>%
  summarise(exceso=round(sum(defunciones_observadas)/sum(defunciones_esperadas)-1,4)*100)
```


Como vemos en el código se ha preparado una variable `iso2.ccaa.code` para el cruce con el objeto espacial que vamos a obtener con mapSpain. Ahora para realizar el mapa sólo necesitamos unas líneas de código para realizar el mapa con el que empezamos la entrada:

```r
#Mapa estático
CCAA.sf <- esp_get_ccaa()
table(CCAA.sf$iso2.ccaa.code)

CCAA.sf <- left_join(CCAA.sf, agr)

ggplot() + geom_sf(data=CCAA.sf, aes(fill=exceso)) + scale_fill_continuous(low="white",high="red")
```


Para incluir el cuadro de Canarias tenemos la función esp_get_can_box(), solo tenemos que hacer:

```r
ggplot() + geom_sf(data=CCAA.sf, aes(fill=exceso)) + scale_fill_continuous(low="white",high="red") +
  geom_sf(data = esp_get_can_box(), colour = "grey50")
```


[![](/images/2020/12/mapspain3.png)](/images/2020/12/mapspain3.png)

En cuanto escribimos en la ayuda esp_ podemos ver todas las funciones que tiene el paquete y me gustaría destacar `esp_get_munic` para obtener mapas por municipios. Se ilustra con un ejemplo para representar el número de empresas de la comunidad de Madrid, para ello es necesario [descargar la tabla del INE 4721](https://ine.es/jaxiT3/Datos.htm?t=4721). La descarga de tablas del INE se puede automatizar como indica [Daniel Redondo en su github](https://github.com/danielredondo/INE_R). En este caso se ha obviado esa automatización y se ha descargado el csv «que tiene sus cositas»:

```r
empresas <- read.csv2('c:\\temp\\4721bsc.csv', encoding='latin 1')

empresas <- empresas %>% dplyr::filter(Municipios != '28 Madrid' & Periodo==2019) %>%
  mutate(LAU_CODE = substr(Municipios,1,5), n_empresas = as.numeric(gsub("[.]","",Total))) %>%
  dplyr::select(LAU_CODE, n_empresas)

empresasn_empresas <- ifelse(empresasLAU_CODE=='28079', 0, empresas$n_empresas)

Madrid.sf <- esp_get_munic(region="Madrid")
Madrid.sf <- Madrid.sf %>% left_join(empresas)

ggplot() + geom_sf(data=Madrid.sf, aes(fill=n_empresas)) + scale_fill_continuous(low="white",high="green")
```


Descargado el csv filtramos sólo Madrid para el último periodo disponible. El campo de cruce en este caso será `LAU_CODE`, pasamos de carácter a numérico mediante gsub donde es importante usar los corchetes para que funcione correctamente. La función esp_get_munic nos permite obtener el mapa municipal para la region Madrid, de este modo ya tenemos el objeto espacial que nos permite crear el mapa. Como se ha indicado se cruza por LAU_CODE que es el mismo código del INE y esto mola mucho mucho, bueno, con la peculiaridad que las tablas del INE tienen código de municipio – código de comunidad. Pero nada complicado el cruce. Con el objeto espacial ya podemos hacer el mapa con geom_sf de ggplot y nos queda:

[![](/images/2020/12/mapspain2.png)](/images/2020/12/mapspain2.png)

Se aprecia el cinturón Sur, Corredor del Henares y Alcobendas como los municipios con más empresas de la Comunidad de Madrid. Bajo mi punto de vista los mapas municipales más sencillos no pueden ser. Espero que uséis esta librería.