---
author: rvaquerizo
categories:
- R
date: '2014-12-06T13:49:46-05:00'
lastmod: '2025-07-13T15:57:30.157539'
related:
- r-python-reticulate.md
- tres-fracasos-y-medio-con-r.md
- paquete-opendataes-en-ropenspain-para-acceder-a-los-datos-de-datos-gob-es-con-r.md
- manual-curso-introduccion-de-r-capitulo-4-contribuciones-a-r-paquetes.md
- r-portable-para-windows.md
slug: error-lazy-loading-failed-for-package-con-win-8
tags:
- Github
title: 'ERROR: lazy loading failed for package con WIN 8'
url: /error-lazy-loading-failed-for-package-con-win-8/
---

Cuando instalamos paquetes de R desde github con devtools puede aparecernos ERROR: lazy loading failed for package típico de un código:

require(devtools)  
install_github(‘paquete@menda’)

El RStudio bajo Win 8 R comienza a descargarse en el temporal una serie de zip que nos permiten crear el paquete y en un punto pone ** preparing package for lazy loading e inmediatamente el ERROR. Ejecutamos install.packages(‘base64enc’) y ya no tendremos ese error. No todos los procesos de instalación desde github nos indican que ese es el problema. Saludos.