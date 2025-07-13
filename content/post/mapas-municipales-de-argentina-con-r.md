---
author: rvaquerizo
categories:
- Formación
- Mapas
- R
date: '2016-09-05T03:00:16-05:00'
lastmod: '2025-07-13T16:02:08.588280'
related:
- mapa-de-argentina-con-r.md
- mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- mapas-con-spatial-data-de-r.md
- mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
slug: mapas-municipales-de-argentina-con-r
tags:
- RColorBrewer
- sp
- spatial data
title: Mapas municipales de Argentina con R
url: /mapas-municipales-de-argentina-con-r/
---

[![Municipios Buenos Aires](/images/2016/09/Municipios-Buenos-Aires.png)](/images/2016/09/Municipios-Buenos-Aires.png)

En respuesta a un lector del blog he elaborado de forma rápida una nueva entrada que nos permite realizar mapas por municipalidades para Argentina, ya hay entradas similares pero está bien que este mapa tenga su propia entrada para facilitar las búsquedas. El ejemplo es rápido y es probable que el código tenga algún fallo o error, si es así lo comentáis y lo solvento. Como es habitual nos dirigimos a la web del proyecto _Global Administrative Areas_ (<http://www.gadm.org/country>) y nos descargamos el mapa de Argentina por municipios que es el nivel 2, una vez descargado pocas líneas de R:  
[sourcecode language=»r»]library(sp)  
library(RColorBrewer)

ub_argentina="C:\\\mapas\\\ARG_adm2.rds"

argentina = readRDS(ub_argentina)  
b.aires = argentina[argentinaNAME_1=="Buenos Aires",]

aleatorio = rpois(length(unique(b.airesNAME_2)),3)  
b.aires@data=data.frame(aleatorio)  
spplot(b.aires,col.regions=brewer.pal(5, "Blues"))  
[/sourcecode]  
Leemos el mapa entero y hacemos un subconjunto de datos sólo con los municipios de Buenos Aires, pintamos unos datos aleatorios con la función spplot y con la librería RColorBrewer podemos dar un formato más elegante a nuestro mapa. Saludos.