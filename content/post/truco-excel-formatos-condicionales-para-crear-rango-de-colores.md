---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2015-01-15T09:34:28-05:00'
lastmod: '2025-07-13T16:07:11.743221'
related:
- truco-excel-identificar-el-color-de-una-celda.md
- truco-excel-funcion-para-identificar-el-color-de-una-celda.md
- truco-excel-grafico-de-puntos-con-colores.md
- truco-excel-graficos-de-dispersion-que-identifican-los-puntos.md
- trucos-excel-mapa-de-espana-por-provincias.md
slug: truco-excel-formatos-condicionales-para-crear-rango-de-colores
tags: []
title: Truco Excel. Formatos condicionales para crear rango de colores
url: /blog/truco-excel-formatos-condicionales-para-crear-rango-de-colores/
---

Un truco de Excel poco ortodoxo. Aprovechar los colores que nos ofrece un formato condicional sin necesidad de emplear el formato condicional para crear un rango de colores. Parece un trabalenguas pero puede ser muy útil cuando trabajamos con Visual Basic. En mi caso particular es muy útil disponer de estas paletas de colores para hacer mapas mucho más vistosos. El truco es muy sencillo empezamos por escribir números del 1 hasta el número de colores que deseamos y elegimos el formato condicional a aplicar:

[![](/images/2015/01/formatos_condicionales_excel1-286x300.png)](/images/2015/01/formatos_condicionales_excel1.png)

Para el ejemplo ponemos 20 números y elegimos el formato condicional donde el verde significa mayor y el rojo significa menor. Cualquier intento de copiar formatos o de obtener el color de la celda con Visual Basic se complica bastante. Y aquí viene el truco “poco brillante pero práctico”. Lo que hacemos es copiar los datos con el formato de color y pegarlo en Word:

[![](/images/2015/01/formatos_condicionales_excel2-186x300.png)](/images/2015/01/formatos_condicionales_excel2.png)

Desde Word ya podemos pegarlo en Excel y no tendremos formatos condicionales que nos impidan identificar el color de la celda. En el blog [ya hablamos de ello en una ocasión](https://analisisydecision.es/truco-excel-identificar-el-color-de-una-celda/) y aplicando esa sencilla macro obtenemos:

[![](/images/2015/01/formatos_condicionales_excel3-300x265.png)](/images/2015/01/formatos_condicionales_excel3.png)

Una forma poco elegante pero sencilla de obtener rangos de colores en Excel. Yo hago virguerías con este truco. Saludos.