---
author: rvaquerizo
categories:
- Formación
date: '2017-03-04T14:32:37-05:00'
slug: actualizar-rstats-en-4-lineas
tags: []
title: Actualizar nuestra versión de R en 4 líneas
url: /actualizar-rstats-en-4-lineas/
---

Con este código actualizamos R en nuestro MAC OSx en 4 líneas:

[sourcecode language=»r»]  
require(devtools)  
install_github(‘andreacirilloac/updateR’)  
library(updateR)  
updateR(admin_password = "XXXxxx111")  
[/sourcecode]

Sólo tenemos que poner la clave de nuestro usuario administrador.