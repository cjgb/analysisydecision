---
author: rvaquerizo
categories:
- Excel
- Formación
- Monográficos
- Trucos
date: '2010-09-30T09:38:33-05:00'
lastmod: '2025-07-13T15:55:25.147710'
related:
- trucos-excel-mapa-de-espana-por-comunidades-autonomas.md
- trucos-excel-mapa-de-espana-por-provincias.md
- mapas-municipales-de-espana-con-excel-y-qgis.md
- mapa-excel-de-europa.md
- trucos-excel-mapa-de-colombia-por-departamentos.md
slug: creando-un-mapa-en-excel-con-archivos-svg
tags:
- ''
- mapas españa
- svg
title: Creando un mapa en Excel con archivos SVG
url: /blog/creando-un-mapa-en-excel-con-archivos-svg/
---

Aunque me lo agradezcan poco el [mapa por comunidades de Excel](https://analisisydecision.es/trucos-excel-mapa-de-espana-por-comunidades-autonomas/) está teniendo un gran éxito. Mientras preparo un mapa por provincias en Excel he elaborado el siguiente tutorial para crear mapas en Excel a partir de archivos SVG. El punto de partida, disponer de [Inkscape ](http://inkscape.org/?lang=es)software libre para la elaboración de dibujos y Excel. Podemos buscar mapas en la wikipedia, en este caso [mapa por provincias de España](http://es.wikipedia.org/wiki/Archivo:Provincias_de_Espa%C3%B1a.svg). Se trata de utilizar ese archivo svg y crear un Excel con objetos de ms-office que provienen del archivo svg que hemos abierto con el Inkscape. Juntamos las piezas del puzle y ya podemos trabajar con el mapa.

El paso 0 es abrir Excel y el svg con el Inkscape. En el Inkscape seleccionamos la provincia a copiar:

![paso-1.PNG](/images/2010/09/paso-1.PNG)

Vemos que al seleccionar la provincia ésta se recuadra y aparecen una serie de flechas. Tras copiar nos dirigimos a Excel y pegamos tal cual:

![paso-2.PNG](/images/2010/09/paso-2.PNG)

Hemos pegado una imagen. Y aquí viene uno de los **puntos más importantes** , si deseamos modificar la imagen se modificará el recuadro completo, nosotros queremos modificar sólo el dibujo de la provincia y esto se consigue convirtiendo la imagen a objeto de ms-office y esto lo hacemos **desagrupando** :

![paso-3.PNG](/images/2010/09/paso-3.PNG)

Este es el punto clave. Excel nos hará la siguiente cuestión:

![paso-4.PNG](/images/2010/09/paso-4.PNG)

Decimos que si y ya tenemos un objeto de ms-office. Ahora seleccionamos sólo el dibujo de la provincia y no el «marco»:

![paso-5.PNG](/images/2010/09/paso-5.PNG)

Eliminamos el marco y tenemos un objeto de Office que es el contorno de la provincia al que recomiendo llamar igual que la provincia. Tenemos un _shape_ con el nombre de la provincia:

![paso-6.PNG](/images/2010/09/paso-6.PNG)

Ahora podemos modificar el formato de este objeto, por ejemplo el color:

![paso-7.PNG](/images/2010/09/paso-7.PNG)

Estos mismos pasos los hacemos sobre el total de provincias y vamos confeccionando el puzle. Es una tarea lenta pero sólo es necesario realizarla una vez:

![paso-8.PNG](/images/2010/09/paso-8.PNG)

Bueno, creo que con estas líneas queda claro como crear mapas con Excel. No es tarea sencilla y muy aburrida pero podemos crear todo tipo de mapas con Excel y un poco de paciencia. Espero que todos aquellos que no entendíais lo que hacía en el mapa por comunidades ahora tengáis un breve manual de creación de mapas a partir de svg. Saludos.