---
author: rvaquerizo
categories:
- Business Intelligence
- Formación
- Mapas
date: '2016-12-22T08:57:14-05:00'
lastmod: '2025-07-13T16:03:09.227430'
related:
- mover-parte-de-un-shapefile-con-r-mapa-de-la-tasa-de-casos-de-coronavirus-por-habitante-en-espana.md
- mapas-municipales-de-espana-con-excel-y-qgis.md
- mapas-sas-a-partir-de-shapefile.md
- animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
- creando-un-mapa-en-excel-con-archivos-svg.md
slug: mover-elementos-de-un-mapa-con-qgis-ejemplo-mover-canarias
tags:
- QGIS
title: Mover elementos de un mapa con QGIS. Ejemplo mover Canarias
url: /blog/mover-elementos-de-un-mapa-con-qgis-ejemplo-mover-canarias/
---

Para modificar shapefile estaba acostumbrado a usar R, sin embargo, poco a poco estoy usando más QGIS para este tipo de tareas. Lo primero que tengo que comentaros es que no sé QGIS, no tengo ni idea, lo uso sólo para visualizar mapas porque es más cómodo que R pero poco a poco me estoy acostumbrando a usarlo. Hoy quería mostraros como he realizado una tarea muy habitual cuando hacemos mapas de España, mover las Islas Canarias para que queden más cerca de la Península. El proceso lo he presentado para torpes con QGIS (como yo mismo). Lo primero es abrir el shapefile con QGIS y nos encontraremos con algo parecido a esto:

[![mover_qgis](/images/2016/12/mover_QGIS.png)](/images/2016/12/mover_QGIS.png)

Es un mapa comarcar de España, a la hora de presentar el este mapala posición de las Islas Canarias puede ser un poco incómoda por ello hemos decidido acercarlas a la península y para ello el primer paso es pulsar un botón con forma de lápiz de nuestra barra de herramientas que nos permite editar las formas:

[![mover_qgis_2](/images/2016/12/mover_QGIS_2.png)](/images/2016/12/mover_QGIS_2.png)

Al pulsarlo se marcan todos los polígonos que componen nuestro shapefile:

[![mover_qgis_3](/images/2016/12/mover_QGIS_3.png)](/images/2016/12/mover_QGIS_3.png)

En este punto tenemos que seleccionar las Canarias y cambiarlas de ubicación para que estén más cerca de la península, para ello empleamos el botón de selección y podemos hacer un rectángulo, a mano alzada o una selección circular, lo que nos sea más cómodo:[![mover_qgis_4](/images/2016/12/mover_QGIS_4.png)](/images/2016/12/mover_QGIS_4.png)

Ahora ya estamos en disposición de mover los elementos seleccionados y para ello tenemos que pulsar otro botón de la barra de herramientas que nos permite mover objetos espaciales:[![mover_qgis_5](/images/2016/12/mover_QGIS_5.png)](/images/2016/12/mover_QGIS_5.png)

Ahora ya podemos poner nuestro objeto seleccionado donde mejor nos parezca directamente con el ratón:[![mover_qgis_6](/images/2016/12/mover_QGIS_6.png)](/images/2016/12/mover_QGIS_6.png)

Una vez realizada esta tarea recomiendo dejar de seleccionar elementos del mapa y guardar los cambios realizados. A partir de este momento dispondremos del mapa con las Islas donde hayamos seleccionado y podremos usar el shapefile resultante con otras herramientas:

[![mover_qgis_7](/images/2016/12/mover_QGIS_7.png)](/images/2016/12/mover_QGIS_7.png)

Ahora sólo me quedaría ser capaz de poner un cuadro a las Islas, pero eso ya se me escapa porque mis conocimientos de QGIS son muy limitados pero es una herramienta libre que debemos tener instalada en nuestro equipo. Espero que se haya entendido esta «guía para burros» que he elaborado, en cualquier caso si hay algún punto, algún problema o se puede hacer de otra forma más eficiente lo podéis comentar en la entrada y lo modifico.