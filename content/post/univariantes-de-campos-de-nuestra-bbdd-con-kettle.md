---
author: rvaquerizo
categories:
- Business Intelligence
- Consultoría
- Formación
- Monográficos
date: '2011-09-12T03:11:00-05:00'
lastmod: '2025-07-13T16:11:01.367205'
related:
- montemos-un-sistema-de-informacion-en-nuestro-equipo-ii.md
- montemos-un-sistema-de-informacion-en-nuestro-equipo-iii.md
- las-cuentas-claras.md
- montemos-un-sistema-de-informacion-en-nuestro-equipo-i.md
- trucos-sas-trasponer-con-sql-para-torpes.md
slug: univariantes-de-campos-de-nuestra-bbdd-con-kettle
tags: []
title: Univariantes de campos de nuestra BBDD con kettle
url: /blog/univariantes-de-campos-de-nuestra-bbdd-con-kettle/
---

El kettle no sólo puede servirnos para subir y bajar tablas a nuestra BBDD. También puede ayudarnos a describir las tablas de nuestras BBDD de una forma muy sencilla. El paso _Univariate Statistics_ será nuestro aliado para esta sencilla tarea.

![transfomacion_kettle.png](/images/2011/09/transfomacion_kettle.png)

Lo primero que tenemos que hacer es crear una conexión a nuestra BBDD. [Hace tiempo ya hablamos de esta labor con Postgres](https://analisisydecision.es/montemos-un-sistema-de-informacion-en-nuestro-equipo-ii/). Una vez creada la conexión comprobamos su correcto funcionamiento y el primer paso será una _Entrada Tabla_ donde seleccionaremos la tabla que deseamos describir:

![entrada_tabla_kettle.png](/images/2011/09/entrada_tabla_kettle.png)

El botón _Obtener consulta SQL_ nos permite navegar de forma sencilla por los distintos esquemas de la BBDD, seleccionamos la tabla y podemos ver la consulta a realizar, por supuesto podemos manipular el código SQL a nuestro antojo. Como siguiente elemento vamos a utilizar _Sample Rows_ de la carpeta _Statistics_ para seleccionar sólo una muestra y que nuestro proceso sea menos pesado. El siguiente paso es el _Univariate Statistic_ donde seleccionaremos los campos que deseamos sumarizar y el análisis deseado:

![univariate_statistic_kettle.png](/images/2011/09/univariate_statistic_kettle.png)

En este caso seleccionamos 3 campos para los que obtenemos la frecuencia, la media y la desviación típica. Por último la salida de este análisis la vamos a llevar a Excel, para ello tenemos el paso _Salida Excel_. Un paso muy sencillo donde tenemos una gran cantidad de posibilidades:

![salida_excel_kettle.png](/images/2011/09/salida_excel_kettle.png)

Muy fácil. A qué esperas para tener el kettle en tu equipo.