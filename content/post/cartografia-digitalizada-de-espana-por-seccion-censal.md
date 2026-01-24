---
author: rvaquerizo
categories:
  - formación
  - mapas
  - r
date: '2016-06-15'
lastmod: '2025-07-13'
related:
  - libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
  - mapas-municipales-de-argentina-con-r.md
  - mapas-municipales-de-espana-con-excel-y-qgis.md
  - mapa-de-espana-por-provincias-en-html.md
  - mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
tags:
  - mapas
  - qgis
title: Cartografía digitalizada de España por sección censal
url: /blog/cartografia-digitalizada-de-espana-por-seccion-censal/
---

Por si no lo sabéis [tenemos disponible en la web del INE](http://www.ine.es/censos2011_datos/cen11_datos_resultados_seccen.htm) un mapa de España por sección censal que podéis descargaros y realizar mapas con R de una forma que es más que conocida para los lectores del blog:

````r
```r
#mapas con secciones censales
library(maptools)
ub_shp = "/Users/raulvaquerizo/Desktop/R/mapas/cartografia_censo2011_nacional/SECC_CPV_E_20111101_01_R_INE.shp"
seccion_censal = readShapeSpatial(ub_shp)
barcelona = seccion_censal[seccion_censal$NMUN=="Barcelona",]
plot(barcelona)
````

![Barcelona_mapa_seccion_censal](/images/2016/06/Barcelona_mapa_seccion_censal.png)

A ver si me animo y preparo una BBDD para que podáis acceder desde QGIS a una serie de mapas como este, además de los mapas por código postal. Aunque necesitaría un poco de ayuda técnica (ahí lo dejo). Saludos.
