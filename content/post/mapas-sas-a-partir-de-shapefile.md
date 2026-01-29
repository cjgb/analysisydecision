---
author: rvaquerizo
categories:
  - business intelligence
  - formación
  - mapas
  - sas
date: '2015-10-29'
lastmod: '2025-07-13'
related:
  - como-obtener-los-centroides-de-municipios-con-sas-mapas-con-sgplot.md
  - mapas-estaticos-de-peru-con-r-y-python-a-nivel-de-distrito.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
  - mapas-municipales-de-espana-con-excel-y-qgis.md
  - mapa-estatico-de-espana-con-python.md
tags:
  - proc gmap
  - proc mapimport
  - mapas
  - sas procs
title: Mapas SAS a partir de shapefile
url: /blog/mapas-sas-a-partir-de-shapefile/
---

![Mapa shp SAS](/images/2015/10/Mapa-shp-SAS-300x232.png "Mapa shp SAS")

Los mapas como este no los hago habitualmente con `SAS` pero que puede interesaros saber como se pueden hacer. Para la realización de mapas a partir de `shapefiles` suelo usar `R`, los que seáis habituales del blog sabéis que hay entradas al respecto. Sin embargo, recientemente, he conocido `QGIS` que interactúa a la perfección con Excel. El ejemplo de hoy es para aquellos que no conocéis `QGIS` o `R` y estáis más habituados a trabajar con `SAS`. Se trata de importar un `shapefile` con `SAS` poder hacer un sencillo tratamiento de datos y posteriormente realizar un mapa muy simple con `SAS`. Para ilustrar el ejemplo vamos a realizar un mapa por municipios de una provincia española con `SAS` y para ello necesitamos un fichero `*.shp` que os vais a descargar de [http://www.gadm.org/country](http://www.gadm.org/country) seleccionáis los mapas de España y descargáis el `ZIP` que contiene los archivos. El primer paso es crear un conjunto de datos `SAS` a partir del `shapefile`:

```sas
`proc mapimport` `datafile`="/directorio/mapa_sas/ESP_adm4.shp"
`out = work.espania`;
`run`;
```

Se emplea el `proc mapimport` que genera un conjunto de datos `SAS` compuesto por las coordenadas, identificadores y nombres de los municipios. Hacemos un tratamiento de datos muy sencillo:

```sas
`data cadiz`;
`set espania`;
`if name_2 = "Cádiz"`;
`run`;

`proc sort data=cadiz out=municipios nodupkey`;
`by id_4`;
`run`;

`data municipios`;
`set municipios`;
`aleatorio = ranpoi(3,4)`;
`output`;
`end`;
`run`;
```

Seleccionamos la provincia de `Cádiz`, sobre sus municipios calculamos una varible aleatoria (muy fácil todo) que será la que representemos en `SAS` con el `proc gmap`:

```sas
`proc gmap data=municipios map=cadiz;`
`id id_4`;
`choro aleatorio/discrete`;
`run`;`quit`;
```

Ya sabéis hacerlo con `SAS`, pero os recomiendo que vayáis instalando `QGIS`. Saludos.
