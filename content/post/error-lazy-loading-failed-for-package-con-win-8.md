---
author: rvaquerizo
categories:
- R
date: '2014-12-06T13:49:46-05:00'
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