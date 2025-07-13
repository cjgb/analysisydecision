---
author: rvaquerizo
categories:
- R
- Trucos
date: '2010-06-22T03:28:50-05:00'
slug: trucos-r-conectar-a-internet-por-el-puerto-8080
tags: []
title: Trucos R. Conectar a internet por el puerto 8080
url: /trucos-r-conectar-a-internet-por-el-puerto-8080/
---

Con R hay veces que no podemos acceder a internet desde nuestro trabajo. Esto es porque el puerto 80 suele estar cerrado por motivos de seguridad. Sin embargo el puerto 8080 es más habitual dejarlo abierto. Para conectar R con internet y facilitar la descarga de paquetes, la conexión con Yahoo Finance, Bloomberg,… podemos hacer lo siguiente. Buscar el Rgui.exe en nuestro equipo y a la hora de ejecutarlo poner la opción **–internet2**. Con ello hacemos que R se conecte a internet con el puerto 8080. Por ejemplo en windows sería:

«C:\Archivos de programa\R\R-2.10.1\bin\Rgui.exe» –internet2

Este sencillo truco nos está facilitando mucho la instalación de paquetes de R. Y a mi me está permitiendo seguir algunas acciones del Mercado Continuo con _quantmod_.