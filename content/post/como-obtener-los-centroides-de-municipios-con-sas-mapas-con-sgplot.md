---
author: rvaquerizo
categories:
- Consultoría
- Formación
- Mapas
- Monográficos
- SAS
date: '2016-11-09T15:03:33-05:00'
lastmod: '2025-07-13T15:55:04.717411'
related:
- mapas-sas-a-partir-de-shapefile.md
- adyacencia-de-poligonos-con-el-paquete-spdep-de-r.md
- representar-poligonos-de-voronoi-dentro-de-un-poligono.md
- incluir-subplot-en-mapa-con-ggplot.md
- identificar-los-municipios-costeros-y-limitrofes-de-espana-con-r.md
slug: como-obtener-los-centroides-de-municipios-con-sas-mapas-con-sgplot
tags:
- MAPA SAS
- proc sgplot
- shapefile
title: Como obtener los centroides de municipios con SAS. Mapas con SGPLOT
url: /blog/como-obtener-los-centroides-de-municipios-con-sas-mapas-con-sgplot/
---

[![mapa_municipios_sas2](/images/2016/11/mapa_municipios_SAS2.png)](/images/2016/11/mapa_municipios_SAS2.png)

Un amigo y lector del blog me ha pedido un mapa de códigos postales donde poder identificar los centroides para andar calculando distancias a otros puntos. Yo ~~no~~ tengo un mapa de España por códigos postales para poder usar con fines comerciales, [pero si cuento en el blog como poder obtenerlo bajo ciertas condiciones](https://analisisydecision.es/como-hacer-un-mapa-de-espana-por-codigos-postales-con-qgis/). Lo que si puedo contar a Juan es como hacer un mapa por municipios con SAS, [aunque ya he hablado de ello](https://analisisydecision.es/mapas-sas-a-partir-de-shapefile/) hay ciertos aspectos que pueden ser interesantes. y todo empieza donde siempre <http://www.gadm.org/country> la web donde tenemos los mapas «libres» por países, seleccionáis Spain y el formato shapefile una vez descargados los mapas en vuestros equipos empezamos con el trabajo en SAS:

[source languaje=»SAS»]
proc mapimport datafile="\directorio\mapa\ESP_adm_shp.shp"
out = work.espania;
run;
proc contents;quit;
[/source]

[![mapa_municipios_sas1](/images/2016/11/mapa_municipios_SAS1.png)](/images/2016/11/mapa_municipios_SAS1.png)

El procedimiento MAPIMPORT ha creado un conjunto de datos SAS donde tenemos caracterizados todos los polígonos que componen el shapefile. Entonces si tenemos que calcular el centroide de un municipio con SAS sugiero realizar un PROC SQL de la siguiente forma

:

[source languaje=»SAS»]
proc sql;
create table centroides as select
id_4,
avg(x) as centroide_x,
avg(y) as centroide_y
from espania
group by 1;
quit;
[/source]

¡A qué molo! El centroide de cada municipio será la media de las coordenadas que lo definen y ahora viene el motivo por el cual he creado una entrada en el blog en vez de llamar por teléfono a Juanito que se ha ido muy lejos a trabajar y no me invita. Vamos a realizar el mapa de la provincia de Barcelona con SAS con el procedimiento SGPLOT que tiene una serie de matices que me hace sugerir que empleéis R para la realización de este tipo de mapas:

[source languaje=»SAS»]

*Creacion de un mapa de Barcelona;
data barna;
set espania;
if name_2 eq "Barcelona";
orden = _n_;
run;

proc sql;
create table barna as select distinct
a.*, b.*
from barna a left join centroides b
on a.id_4 eq b.id_4
order by orden;
quit;

proc sgplot data=barna ;
polygon x=x y=y ID=id_4 / fill outline;
xaxis display=none;
yaxis display=none;
scatter x=centroide_x y=centroide_y ;
quit;

[/source]

Matices y rarezas que tiene este código SAS. Necesita el orden del shapefile no puedo explicar porque, lo investigaré, pero los primeros mapas no me salieron e intuí que por ahí iban los problemas, además el left join ha necesitado un distinct algo que no entiendo muy bien ya que se puede realizar el mapa con los mismos datos sin el left join y éste no genera duplicados, esto si le he investigado y el resultado ha sido PROBLEMA 1 – RAUL 0 volveré con ello. Por otro lado tenemos el PROC SGPLOT que emplea POLYGON para la representación de los shapefile y como deseamos que nos pinte un punto para identificar los centroides usamos la sentencia SCATTER. Bueno, espero que a Juan y a otros os sirva esta entrada, imagino que sí porque ahora será capaz de representar en mapas la distancia de los centroides de un municipio a un punto determinado o incluso la adyacencia entre municipios. Saludos.