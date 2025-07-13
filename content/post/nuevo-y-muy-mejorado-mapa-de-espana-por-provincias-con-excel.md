---
author: rvaquerizo
categories:
- Consultoría
- Excel
- Formación
- Mapas
date: '2016-06-08T10:22:02-05:00'
lastmod: '2025-07-13T16:03:55.687033'
related:
- trucos-excel-mapa-de-espana-por-provincias.md
- nuevo-mapa-por-provincias-en-excel-de-espana-actualiza-los-colores-en-rgb.md
- mapa-excel-de-europa.md
- trucos-excel-mapa-de-espana-por-provincias-mejorado.md
- mapas-municipales-de-espana-con-excel-y-qgis.md
slug: nuevo-y-muy-mejorado-mapa-de-espana-por-provincias-con-excel
tags:
- mapa Excel
title: Nuevo y muy mejorado mapa de España por provincias con Excel
url: /nuevo-y-muy-mejorado-mapa-de-espana-por-provincias-con-excel/
---

![Nuevo_mapa_españa1](/images/2016/06/Nuevo_mapa_españa1.png)

Hacía tiempo que no publicaba un mapa de España de Excel, aquí tenéis una nueva versión que mejora mucho a las anteriores. La primera mejora y la que más destaca es que nos permite incluir datos, además ponemos los nombres de las provincias para todos aquellos que dominen poco la geografía española. Podemos pintar hasta 4 datos distintos que se pueden seleccionar en el desplegable que tenéis arriba. Ahora los colores van en dos escalas que podéis seleccionar vosotros:[  
](/images/2016/06/Nuevo_mapa_españa1.png)

[![Nuevo_mapa_españa_excel2](/images/2016/06/Nuevo_mapa_españa_excel2.png)](/images/2016/06/Nuevo_mapa_españa_excel2.png)

A la hora de meter los datos a nivel provincial es necesario ir a la hoja _datos_mapa_ en ella tenéis los 4 datos que podéis pintar, estos datos irán en un ranking que a la postre asigna colores a los _shapes_ que componen el conjunto de imágenes que hace el mapa de Excel:

![Nuevo_mapa_españa_excel3](/images/2016/06/Nuevo_mapa_españa_excel3.png) **Tenéis como ejemplo datos aleatorios** , el _Dato 1_ es un número entre 1 y 50 y te pintaría en el mapa números enteros entre 1 y 50 donde el más próximo a 1 toma un color rojo y el más lejano toma un valor verde. Si queréis cambiar el rango de colores sólo tenéis que cambiar el ranking de menor a mayor, creo que es sencillo y no os enfadéis conmigo si opino que es sencillo. Para ilustrar como funciona observad el dato 2 y el 3, cambia la escala de colores en función de la ordenación. Para modificar los formatos que pinta el mapa es necesario que juguéis con las columnas ocultas de la hoja _mapa_ , tenéis algún ejemplo de uso de la función TEXTO. [  
](/images/2016/06/Nuevo_mapa_españa_excel3.png)

Algún usuario al que le he pasado el mapa no ha tenido muchos problemas, así que debe ser sencillo de usar, espero que sea de utilidad.

[Descargar mapa de España por provincias en Excel de www.analisisydecision.es](/images/2016/06/Mapa_provincial.xlsm)