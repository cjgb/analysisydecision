---
author: rvaquerizo
categories:
  - business intelligence
  - consultoría
  - formación
  - monográficos
date: '2011-09-12'
lastmod: '2025-07-13'
related:
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-ii.md
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-iii.md
  - las-cuentas-claras.md
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-i.md
  - trucos-sas-trasponer-con-sql-para-torpes.md
tags:
  - business intelligence
  - consultoría
  - formación
  - monográficos
title: Univariantes de campos de nuestra BBDD con kettle
url: /blog/univariantes-de-campos-de-nuestra-bbdd-con-kettle/
---

El `kettle` no sólo puede servirnos para subir y bajar tablas a nuestra `BBDD`. También puede ayudarnos a describir las tablas de nuestras `BBDD` de una forma muy sencilla. El paso `Univariate Statistics` será nuestro aliado para esta sencilla tarea.

![Transformación Kettle](/images/2011/09/transfomacion_kettle.png)

Lo primero que tenemos que hacer es crear una conexión a nuestra `BBDD`. [Hace tiempo ya hablamos de esta labor con Postgres](https://analisisydecision.es/montemos-un-sistema-de-informacion-en-nuestro-equipo-ii/). Una vez creada la conexión comprobamos su correcto funcionamiento y el primer paso será una `Entrada Tabla` donde seleccionaremos la tabla que deseamos describir:

![Entrada Tabla Kettle](/images/2011/09/entrada_tabla_kettle.png)

El botón `Obtener consulta SQL` nos permite navegar de forma sencilla por los distintos esquemas de la `BBDD`, seleccionamos la tabla y podemos ver la consulta a realizar, por supuesto podemos manipular el código `SQL` a nuestro antojo. Como siguiente elemento vamos a utilizar `Sample Rows` de la carpeta `Statistics` para seleccionar sólo una muestra y que nuestro proceso sea menos pesado. El siguiente paso es el `Univariate Statistic` donde seleccionaremos los campos que deseamos sumarizar y el análisis deseado:

![Univariate Statistic Kettle](/images/2011/09/univariate_statistic_kettle.png)

En este caso seleccionamos 3 campos para los que obtenemos la frecuencia, la media y la desviación típica. Por último la salida de este análisis la vamos a llevar a Excel, para ello tenemos el paso `Salida Excel`. Un paso muy sencillo donde tenemos una gran cantidad de posibilidades:

![Salida Excel Kettle](/images/2011/09/salida_excel_kettle.png)

Muy fácil. A qué esperas para tener el `kettle` en tu equipo.
