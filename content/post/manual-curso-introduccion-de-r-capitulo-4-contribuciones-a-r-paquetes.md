---
author: rvaquerizo
categories:
  - formación
  - r
date: '2008-02-28'
lastmod: '2025-07-13'
related:
  - manual-curso-introduccion-de-r-capitulo-5-lectura-avanzada-de-datos.md
  - manual-curso-introducion-de-r-capitulo-1-que-es-r.md
  - montemos-un-sistema-de-informacion-en-nuestro-equipo-iii.md
  - intro-rcommander-1-que-es-rcommander.md
  - manual-curso-introduccion-de-r-capitulo-15-analisis-cluster-con-r-i.md
tags:
  - formación
  - r
title: 'Manual. Curso introducción de R. Capítulo 4: Contribuciones a R (paquetes)'
url: /blog/manual-curso-introduccion-de-r-capitulo-4-contribuciones-a-r-paquetes/
---

En esta nueva entrega del manual introducctorio a la programación en `R` comenzaremos a familiarizarnos con las contribuciones que se realizan en el mundo a esta herramienta. La intención es cargar un `paquete` que contenga una funcionalidad en `R` que nos permita leer orígenes de datos `ODBC` para que, en sucesivas entregas, podamos leer datos de `Access`, Excel,…

Los paquetes de `R` son contribuciones de programadores de todo el mundo para la creación de funcionalidades de `R` que contienen funciones que permiten que día a día `R` mejore y adquiera un mayor potencial. Estos paquetes se encuentran en el `Comprehensive R Archive Network` `CRAN` que es una red de `ftp` y servidores donde nos podemos descargar `R` o nos podemos descargar las contribuciones de los programadores de `R` de todo el mundo. En este caso para España tenemos la red [CRAN espejo España](http://cran.es.r-project.org/) En ella tenemos todos los paquetes disponibles por orden alfabético.

Para conocer que paquetes tenemos intalados podemos ir a la barra de herramientas de `R` y pulsar en el botón _Paquetes_. Si pulsamos _Cargar paquete_ veremos los paquetes que tenemos instalados, los que lleva el módulo base por defecto. Para instalar nuevos paquetes podemos emplear las herramientas que tiene para ello `R` o bien podemos descargar los paquetes del `CRAN` e instalarlos en nuestro entorno de trabajo.

En nuestro ejemplo pretendemos obtener una funcionalidad que nos permita leer orígenes de datos `ODBC`. El primer paso es ir al espejo o elemento de la red donde descargar esta funcionalidad: [CRAN espejo España](http://cran.es.r-project.org/) Una vez en esta web basta con buscar `ODBC` y encontramos el paquete [RODBC](http://cran.es.r-project.org/web/packages/RODBC/index.html) Abrimos el link y encontramos una completa información con todas las descargas posibles, la licencia e incluso un completo [manual en pdf](http://cran.es.r-project.org/web/packages/RODBC/RODBC.pdf). En este caso nos descargamos la versión para `windows`. Yo recomiendo descargar el archivo en un directorio de `R`.

Descargado el fichero necesitamos instalar el paquete. Para ello empleamos _Paquetes_ -> _Instalar paquete a partir de ficheros `zip` locales_ le especificamos la ubicación del fichero y ya disponemos de un nuevo conjunto de funciones de `R` que nos permitirán leer otros orígenes de datos. Para cargarlo debemos hacer _Paquetes_ -> _Cargar paquete_ y seleccionar `RODBC`. También podemos hacerlo con código empleando la función `library(<paquete>)`.

Si deseamos leer tablas `SAS`, `SPSS`, `dBase`,… disponemos del paquete [foreign](http://cran.es.r-project.org/web/packages/foreign/index.html) que recomendamos instalar.
