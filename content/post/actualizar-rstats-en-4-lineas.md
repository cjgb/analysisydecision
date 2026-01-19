---
author: rvaquerizo
categories:
  - formación
date: '2017-03-04'
lastmod: '2025-07-13'
related:
  - ejecutar-un-codigo-al-iniciar-la-sesion-de-r.md
  - migrando-de-sas-a-r.md
  - twitter-con-r-el-hashtag-rstats.md
  - r-portable-para-windows.md
  - nueva-edicion-del-curso-basico-de-r.md
tags:
  - r
title: Actualizar nuestra versión de R en 4 líneas
url: /blog/actualizar-rstats-en-4-lineas/
---

Con este código actualizamos R en nuestro MAC OSx en 4 líneas:

[sourcecode language=»r»]
require(devtools)
install_github(‘andreacirilloac/updateR’)
library(updateR)
updateR(admin_password = "XXXxxx111")
[/sourcecode]

Sólo tenemos que poner la clave de nuestro usuario administrador.
