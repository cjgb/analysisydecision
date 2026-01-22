---
author: rvaquerizo
categories:
  - excel
  - formación
  - javascript
date: '2020-04-16'
lastmod: '2025-07-13'
related:
  - como-hacer-un-mapa-de-espana-por-codigos-postales-con-qgis.md
  - cartografia-digitalizada-de-espana-por-seccion-censal.md
  - trucos-excel-mapa-de-espana-por-provincias.md
  - archivos-shape-y-geojason-para-crear-un-mapa-de-espana-por-codigos-postales.md
  - el-brexit-con-rstats-o-como-mover-spatial-data-con-r.md
tags:
  - excel
  - formación
  - javascript
title: Creando un mapa en Excel con archivos SVG
url: /blog/creando-un-mapa-en-excel-con-archivos-svg/
---

Voy a traeros algo que me ha llamado mucho la atención. Una solución en Excel para pintar un mapa de España con la posibilidad de resaltar Comunidades Autónomas, Provincias o incluso un nivel inferior, con el archivo del que partimos, Secciones Censales. Una solución realmente buena que además es open-source por lo que no tenemos ningún problema para emplearla o modificarla, de verdad que creo que es una de las soluciones más interesantes que me he encontrado en Excel en muchos años. La solución la encontraréis en [https://github.com/datavizforall/create-your-own-choropleth-map-in-excel](https://github.com/datavizforall/create-your-own-choropleth-map-in-excel) en el artículo [Create your own choropleth map in Excel](https://datavizforall.org/createyourownmap/)

Los mapas coropléticos son mapas temáticos en los que las unidades de la superficie se sombrean con distintos colores o tramas, según el valor de la variable que representan. La forma más sencilla de representar datos geográficos dentro de Excel es usar los mapas 3D pero de verdad, no os dejéis engañar por el nombre, no tiene mucho de cartografía y si de representación de datos con coordenadas geográficas.

En la siguiente imagen podéis ver lo que podemos hacer con la solución de la que os estoy hablando:

![excel-mapa-svg.png](/images/2020/04/excel-mapa-svg.png)

El secreto para poder trabajar con mapas en Excel es que Excel es compatible con `SVG` (`Scalable Vector Graphics`) un formato de gráficos vectoriales bidimensionales. Esto nos permite un control total sobre el color, la trama, los textos, etc. Una vez tenemos el mapa en formato `SVG` tan solo necesitamos `VBA` para acceder a él y manipularlo.

El proyecto del que os he hablado utiliza los archivos `SVG` de los siguientes repositorios:

- [https://github.com/datavizforall/topjson-maps](https://github.com/datavizforall/topjson-maps)
- [https://github.com/datavizforall/topojson-choropleth-maps](https://github.com/datavizforall/topojson-choropleth-maps)

Y tiene un código `VBA` muy sencillo para poder manipular los archivos `SVG`. Con ello podemos hacer el mapa de la imagen superior. Podemos colorear o no y todo ello con la velocidad del `VBA`.
