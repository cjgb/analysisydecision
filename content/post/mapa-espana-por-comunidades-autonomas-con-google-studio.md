---
author: rvaquerizo
categories:
- Business Intelligence
- Formación
- Mapas
- Trucos
date: '2020-09-24T04:39:21-05:00'
lastmod: '2025-07-13T16:01:53.577376'
related:
- mapas-municipales-de-espana-con-excel-y-qgis.md
- trucos-excel-mapa-de-espana-por-comunidades-autonomas.md
- mapa-estatico-de-espana-con-python.md
- mapas-de-municipales-de-espana-en-r-con-la-ayuda-de-excel.md
- mapas-estaticos-municipales-para-estados-de-mexico-con-r-y-con-excel.md
slug: mapa-espana-por-comunidades-autonomas-con-google-studio
tags:
- Data Studio
- Google Sheets
title: Mapa España por Comunidades Autónomas con Google Studio
url: /blog/mapa-espana-por-comunidades-autonomas-con-google-studio/
---

Continúo evaluando métodos para crear mapas con software que no sea de pago e intentando que la dificultad sea mínima. En este caso quería mostraros y poner a vuestra disposición un mapa de España por Comunidades Autónomas, además os dejo acceso libre a los datos que usa el mapa para que vosotros mismos podáis realizar el trabajo. Voy a pasaros 2 enlaces uno con los datos donde tenemos datos de pruebas PCR por 100.000 habitantes a nivel de Comunidad Autónoma (por representar algo) es ahí donde incluís los datos que deseáis representar gráficamente. Y el otro enlace es el dashboard simple hecho con Data Studio que véis al inicio de la entrada que contiene un mapa con el formato que en este momento necesito. Este trabajo es meramente experimental porque pongo a disposición de todos tanto mapa como Hoja de Google, veremos lo que tarda en dejar de funcionar.

El mapa se ha llevado a cabo según las instrucciones de este video:

Si necesitáis realizar el mismo proceso para México ahí lo tenéis muy bien explicado, en mi caso voy a pasar los link para generar el mapa y vosotros mismos cambiando los datos de la google sheet deberíais poder materializar el gráfico. Para no dejar abiertos al público vuestros mapas os pediría copiar o duplicar tanto la Google Sheet

como el dashboard de Data Studio:

[![](/images/2020/09/Data-Studio-duplicar-informe.png)](/images/2020/09/Data-Studio-duplicar-informe.png)

Por favor, haced esta tarea, aunque los primeros meses iré revisando las modificaciones y si alguien lo ha cambiado volveré a poner la primera versión.

En el siguiente link tenéis la hoja de Google que no puede ser más simple:

[Link a Google Sheets con ejemplo de dato por Comunidad Autónoma](https://docs.google.com/spreadsheets/d/1DYlWv7XdaDLzv5n5vqyNG2AARfeM_I-m-84ldaCi5HU/edit?usp=sharing)

Ahí sólo tenéis esto:

[![](/images/2020/09/Google-sheet-mapa-comunidades.png)](/images/2020/09/Google-sheet-mapa-comunidades.png)

Tenéis que modificar la columna dato. Una vez la hayáis modificado os váis al Data Studio que tenéis en el siguiente link:

[Link a Data Studio Comunidades Autónomas](https://datastudio.google.com/reporting/2bdd8cb6-5cda-4b53-b146-edb86808c5d6)

Ya hemos actualizado los datos por Comunidad Autónoma solo tenemos que actualizar el Data Studio:

[![](/images/2020/09/Actualizar-Data-Studio.png)](/images/2020/09/Actualizar-Data-Studio.png)

Ahora ya tenemos nuestro mapa actualizado con los datos Google Sheet. Podemos editar este mapa y dar el formato deseado. Y aquí insisto en que dupliquéis la hoja y cambiéis el origen de datos con vuestra propia Google Sheet, como no confío mucho en vosotros velaré porque nadie «rompa» el mapa durante un tiempo. No soy capaz de hacer este proceso como una aplicación donde subís vuestros datos y se obtiene el mapa, a ver si me oyen en Google y me ayudan porque me está costando.

Si funciona subiré más mapas con Data Studio. Saludos.