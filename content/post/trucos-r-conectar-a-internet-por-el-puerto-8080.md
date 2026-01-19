---
author: rvaquerizo
categories:
  - r
  - trucos
date: '2010-06-22'
lastmod: '2025-07-13'
related:
  - comunicar-sas-con-r-creando-ejecutables-windows.md
  - intro-rcommander-1-que-es-rcommander.md
  - trial-version-del-bridge-to-r.md
  - ejecutar-un-codigo-al-iniciar-la-sesion-de-r.md
  - conectar-r-a-una-base-de-datos.md
tags:
  - sin etiqueta
title: Trucos R. Conectar a internet por el puerto 8080
url: /blog/trucos-r-conectar-a-internet-por-el-puerto-8080/
---

Con R hay veces que no podemos acceder a internet desde nuestro trabajo. Esto es porque el puerto 80 suele estar cerrado por motivos de seguridad. Sin embargo el puerto 8080 es más habitual dejarlo abierto. Para conectar R con internet y facilitar la descarga de paquetes, la conexión con Yahoo Finance, Bloomberg,… podemos hacer lo siguiente. Buscar el Rgui.exe en nuestro equipo y a la hora de ejecutarlo poner la opción **–internet2**. Con ello hacemos que R se conecte a internet con el puerto 8080. Por ejemplo en windows sería:

«C:\\Archivos de programa\\R\\R-2.10.1\\bin\\Rgui.exe» –internet2

Este sencillo truco nos está facilitando mucho la instalación de paquetes de R. Y a mi me está permitiendo seguir algunas acciones del Mercado Continuo con _quantmod_.
