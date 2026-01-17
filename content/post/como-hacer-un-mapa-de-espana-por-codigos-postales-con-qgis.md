---
author: rvaquerizo
categories:
- Business Intelligence
- Consultoría
- Formación
- Mapas
- Monográficos
date: '2016-02-12T16:35:11-05:00'
lastmod: '2025-07-13T15:54:59.284343'
related:
- archivos-shape-y-geojason-para-crear-un-mapa-de-espana-por-codigos-postales.md
- mapas-municipales-de-espana-con-excel-y-qgis.md
- mapa-de-codigos-postales-con-r-aunque-el-mapa-es-lo-de-menos.md
- cartografia-digitalizada-de-espana-por-seccion-censal.md
- libreria-mapspain-en-rstats-mapas-estaticos-de-espana.md
slug: como-hacer-un-mapa-de-espana-por-codigos-postales-con-qgis
tags:
- codigos postales
- QGIS
title: Como hacer un mapa de España por códigos postales con QGIS
url: /blog/como-hacer-un-mapa-de-espana-por-codigos-postales-con-qgis/
---

## Editado 2022:

Francisco Goerlich ha elaborado una versión que de nuevo puede obtener los datos de Cartociudad. Volveremos sobre el tema y dejaremos una capa que pueda ser reutilizable.

https://www.uv.es/goerlich/Ivie/CodPost

## Editado 2019:

Como podéis leer más abajo Correos ha impedido al proyecto Cartociudad incluir los mapas de España por Código Postal, ahora es necesario comprarlos. Sin embargo, hay versiones antiguas como las que se descargó en su día [Íñigo Flores](https://github.com/inigoflores/ds-codigos-postales). Con estas descargas yo he elaborado un mapa de España por códigos postales:

[Descargar el shapefile con el mapa de España por códigos postales para QGIS.](/images/2019/09/España.zip)

Una vez os hayáis descargado el mapa sólo tenéis que abrir la capa vectorial correspondiente (el shp) con QGIS:

[![](/images/2016/02/mapa_españa_codigos_postales_QGIS.png)](/images/2016/02/mapa_españa_codigos_postales_QGIS.png)

Los cruces los realizáis en QGIS a través del campo COD_POSTAL. También podéis hacer filtros para realizar mapas de provincias o ciudades.

## Versión antigua:

Tenía pendiente hablar de **QGIS** y de la creación de un **mapa de España por códigos postales gratuito y libre**. Pero no sé como enfocar esta entrada porque el mapa, siendo gratuito y de difusión libre, no se puede usar con fines comerciales y me temo que un gran número de lectores del blog tienen tales fines. Así que he pensado en hablaros de [CartoCiudad](http://www.cartociudad.es/portal/) y de los mapas que contiene este interesante proyecto. En CartoCiudad colaboran algunos ministerios y entidades estatales, entre ellas **Correos** y podéis descargar provincia a provincia los archivos que componen el proyecto. Emplear los mapas de CartoCiudad implica aceptar las siguientes condiciones:

> 1\. La licencia de uso solicitada ampara exclusivamente **el uso no comercial de la información geográfica** , entendiendo como tal el uso que no conlleva aprovechamiento económico directo, indirecto o diferido. Cualquier uso distinto al descrito, incluida la publicación, requerirá la suscripción de una autorización o contrato específico con el Centro Nacional de Información Geográfica (CNIG), devengando, en su caso, la contraprestación económica correspondiente. En caso de duda deberá establecerse contacto con el CNIG (consulta@cnig.es).
>
> 2.**El usuario titular de la licencia se compromete a citar al Instituto Geográfico Nacional (IGN) mediante la fórmula:** «© Instituto Geográfico Nacional de España» como origen y propietario de la información geográfica suministrada ante cualquier exhibición o difusión de ella, o de parte de ella o de cualquier producto que, aún siendo de forma parcial, la incorpore o derive de ella.
>
> – Si se tratara de Ortofoto o MDT5 (PNOA®), la mención se sustituirá por: «PNOA cedido por © Instituto Geográfico Nacional de España».
>  – Tratándose de datos LiDAR, la mención se sustituirá por: «LiDAR-PNOA cedido por © Instituto Geográfico Nacional de España».
>  – En caso de datos SIOSE®, la mención se sustituirá por: «SIOSE cedido por © Instituto Geográfico Nacional de España».
>  – Tratándose de CartoCiudad®, la mención se sustituirá por: «CartoCiudad cedido por © Instituto Geográfico Nacional de España».
>
> 3\. En caso de CartoCiudad®, los nuevos productos o servicios que puedan generarse basados en CartoCiudad®, no incluirán ninguna referencia a la información catastral, ni suplantarán explícitamente o mediante productos o servicios que puedan dar lugar a confusión a los ofrecidos por la Dirección General del Catastro, del Ministerio de Economía y Hacienda, o a los ofrecidos por la Sociedad Estatal Correos y Telégrafos S.A., a quienes corresponde en exclusiva la competencia para la difusión de la información catastral y postal respectivamente, así como el ejercicio de los derechos de propiedad intelectual inherentes a la información y a las bases de datos catastrales y postales.
>
> 4\. La cesión de la información digital licenciada, de otra que la incorpore o de cualquier producto derivado de ella, a otra persona física o jurídica, requerirá la concesión por el CNIG de nueva licencia al nuevo usuario, o que el cedente comunique expresamente por escrito al nuevo usuario las condiciones originales de licenciamiento establecidas por el CNIG, y que el nuevo usuario acepte expresamente dichas condiciones. Esta comunicación puede llevarse a término mediante el documento estándar descargable desde www.ign.es, o bien a través de un documento definido por el cedente y aprobado previamente por el CNIG.
>
> 5\. Esta licencia de uso no comercial, no supone la concesión de ningún tipo de exclusividad, aval o patrocinio, ni responsabilidad alguna del IGN sobre el uso derivado de los datos geográficos.

Si os habéis leído la licencia de uso entendréis porque tengo algunas dudas sobre la conveniencia de escribir esta entrada. Así que se me ha ocurrido que, os voy a decir como podéis hacer el mapa de códigos postales, os voy a advertir que el mapa que hagáis no puede tener fines comerciales y que si queréis un mapa comercial hay empresas que os pueden vender estos mapas. Yo en mi puesto de trabajo tengo uno de estos mapas comerciales y no ha sido necesario hacer todo lo que a continuación os voy a relatar.

**Ya tengo la conciencia tranquila** , ahora preparaos para descargar los archivos *.zip de las 52 provincias españolas. Archivo a archivo os los descargáis y los descomprimís en una ubicación de vuestro equipo.

Si no disponéis de QGIS debéis ir a <http://www.qgis.org/es/site/> y descargar esta aplicación que os permitirá abrir los archivos shape con cada una de las 52 provincias españolas que están en las 52 carpetas que os habéis creado tras descargarros los 52 zip. La tarea, aunque aburrida, no es para tanto, incluso se puede plantear un  _scraping_ por lo que animo a que lo haga algún lector y lo cuelgue en el blog. Cuando ya tenemos las 52 carpetas Si por ejemplo abrimos los archivos codigo_postal.shp de las carpetas Madrid y Guadalajara tendremos:

[![madrid_guadalajara_codigo_postal](/images/2016/02/madrid_guadalajara_codigo_postal-300x179.png)](/images/2016/02/madrid_guadalajara_codigo_postal.png)Si abrís los 52 archivos podéis imaginaros que tendréis un mapa de España por códigos postales que no podéis usar con fines comerciales. Si queréis crear un shape que contenga la unión de los 52 codigo_postal.shp podéis trabajar con datos vectoriales a través del menú Vectorial –> Herramientas de gestión de datos. Pero imaginemos que seguimos con QGIS y guardamos el proyecto, nuestro mapa tiene buena pinta. Ahora cómo asignamos valores a los códigos postales, bastante sencillo. Podéis buscar en la web información acerca de QGIS pero de forma rápida os diré como me ha enseñado mi compañero Luisete a trabajar con QGIS. Lo que hago es añadir los shape y archivos de datos a nivel de código postal ya sea en csv o en Excel y se crean nuevas capas:

[![Captura de pantalla 2016-02-09 a las 21.44.21](/images/2016/02/Captura-de-pantalla-2016-02-09-a-las-21.44.21-254x300.png)](/images/2016/02/Captura-de-pantalla-2016-02-09-a-las-21.44.21.png)También podéis abrir archivo vectorial y os pregunta la ubicación de los datos. Pero en el ejemplo vemos que navegamos por el equipo y tenemos todas las carpetas con los mapas de CartoCiudad que añadimos a las capas y añadir datos de distintos orígenes, para ilustrar el ejemplo añadimos un csv que se llama guadalajara. En este punto es importante señalar que **QGIS trabaja con formato decimal americano** y es sensible a las comas para separar decimales. Desconozco si esto se puede modificar, para mi no es problema porque trabajo con ese formato. Ahora tenemos que unir nuestros datos, unir el csv a nivel de código postal con el archivo shape por código postal, evidentemente .el shape de CartoCiudad tiene un campo código postal y el archivo csv que deseo unir también. Las uniones se llevan a cabo con el botón derecho Propiedades->Uniones añadir y allí las definimos:

[![Captura de pantalla 2016-02-12 a las 22.03.54](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.03.54-300x201.png)](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.03.54.png)Unión por el campo código postal y añadimos el campo Datos de nuestro csv, ahora estamos en disposición de pintar ese campo datos en nuestro mapa y para asignar colores en nuestro mapa hemos de ir de nuevo a las Propiedades de la capa después en Estilo:

[![Captura de pantalla 2016-02-12 a las 22.12.23](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.12.23-300x201.png)](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.12.23.png)Vamos a categorizar la variable que puede ser continua (elegimo Graduado) o categórica (elegimos Categorizado) allí seleccionamos la columna que desamos pintar con colores pulsamos Clasificar y podríamos obtener algo parecido a esto:

[![Captura de pantalla 2016-02-12 a las 22.14.58](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.14.58-300x166.png)](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.14.58.png)

Representamos un caso extremo en el que tenemos múltiples categorías para que veáis como se realiza el proceso. Con variables continuas QGIS dispone de diversas formas de crear las clases o sugiero que lo investigueís y por supuesto tienes la posibilidad de jugar con las distintas paletas de colores:

[![Captura de pantalla 2016-02-12 a las 22.20.09](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.20.09-300x171.png)](/images/2016/02/Captura-de-pantalla-2016-02-12-a-las-22.20.09.png)Ya sabéis como hacer un mapa de España por código postal de forma gratuita y sin fines comerciales, espero que aquellos que hacéis mapas con herramientas que no están preparadas para ello empecéis a trabajar con QGIS que es mucho más flexible y espectacular que otras aplicaciones (incluido R) a la hora de crear mapas. Saludos.