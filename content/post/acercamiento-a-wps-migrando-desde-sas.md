---
author: rvaquerizo
categories:
- Business Intelligence
- Formación
- SAS
date: '2010-01-17T13:25:37-05:00'
lastmod: '2025-07-13T15:53:37.410659'
related:
- sigo-migrando-de-sas-a-wps.md
- wps-en-el-mercado-espanol.md
- en-breve-revision-de-wps-clonico-de-sas.md
- curso-de-lenguaje-sas-con-wps-introduccion-2.md
- curso-de-lenguaje-sas-con-wps-introduccion.md
slug: acercamiento-a-wps-migrando-desde-sas
tags:
- migración
- SAS
- WPS
title: Acercamiento a WPS. Migrando desde SAS
url: /blog/acercamiento-a-wps-migrando-desde-sas/
---

Poco a poco comienzo a trabajar con el clónico de SAS WPS. Estoy trabajando con la versión 2.3.5. De momento las impresiones no pueden ser mejores. El interfaz me recuerda a Enterprise Guide, trabajamos con proyectos que pueden estar compuestos de scripts (códigos de SAS) o ficheros. En cuanto al interfaz tenemos un navegador de proyectos para explorar los elementos que añadimos. Acompaña a este explorador una ventana de propiedades del proyecto. En la parte central podemos ver los scripts o los ficheros que añadimos. Me ha gustado el poder linkar los ficheros añadidos al proyecto a la aplicación del sistema asociada al fichero, me explico, si añades una hoja de cálculo ésta se abre en el proyecto de WPS con el programa asociado a ella. Otra de las ventanas está organizada en pestañas, una de ellas dispone del log y los resultados, otra un «server explorer» similar al explorador de SAS Base y una pestaña de progreso. Por último disponemos de otro navegador de procedimientos, resultados o log de ejecuciones al que particularmente no le encuentro mucho interés.

Al lío, en mi trabajo diario me pondría a picar código SAS y echo en falta algunas funciones (perfectamente prescindibles). El PROC SQL funciona a la perfección. Ya sabéis que sin el PROC SQL no somos nadie con SAS (sobre todo yo). Al final programas como lo haces habitualmente en Enterprise Guide, me costaría muy poco migrar mis proyectos de Guide o mi codigos de SAS a WPS. Al no disponer de SAS no puedo comparar en tiempos las ejecuciones. Lo primero que se me ocurre es generar una «tablita» con 20 millones de registros en una libreria de mi PC. Las tablas se guardan con extension WPD no sé si son «tablas propietarias» o se pueden utilizar con otras herramientas, si me entero ya os diré. De momento no tenemos problemas con tablas de 800 MB. En una hora curioseando lo que más me gusta es el interfaz y la posibilidad de abrir archivos hojas de calculo desde el proyecto de WPS. De este modo me cuesta bien poco mantener una tabla de dimensiones. A la hora de importar ficheros de otro tipo veo que la gente de World Programing Software no me dejan evaluar el equivalente al modulo ACCESS TO PC FILES de SAS. No es mayor problema porque desde el mismo proyecto preparo el fichero para realizar la importación pero echo de menos un asistente. Con SAS desarrollé una metodología para importar ficheros de texto que me ha dado muy buenos resultados. Para la importación de archivos recomendaría tener UltraEdit y generar los _input_ manualmente.

A simple vista me costaría muy poco migrar mis procesos de SAS a WPS y ahorraría a mi organización bastante dinero. Los códigos que se denominan scripts se almacenan con extension .sas y _%include_ funciona a la perfección (menos problemas para una hipotética migración) También hay que destacar que no hemos probado el acceso a datos en Oracle ni las posibilidades estadisticas de este clónico. Pero en este primer acercamiento me ha dejado buen sabor de boca aunque de momento solo me estoy familiarizando con la herramienta. No esperaba que WPS fuera maravilloso pero me está costando muy poco sacarle partido.

Pocos euros de gasto en formación. Pocos euros de gasto en la herramienta. Pocos recursos en la migración (creo). En el primer año saldría rentable el cambio de herramienta. A no ser de tuvieramos un entorno SAS con gestor de campañas (si funciona) o una dependencia del Enterprise Guide o Miner; también es posible que no nos fiáramos del futuro de WPS pero siempre podríamos volver a SAS. Me parece que se puede acabar un monopolio. Seguiré informando.