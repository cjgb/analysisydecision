---
author: rvaquerizo
categories:
  - formación
  - opinión
  - r
date: '2018-12-09'
lastmod: '2025-07-13'
related:
  - mapa-de-rstats-animado-con-el-porcentaje-de-vacunacion-en-espana.md
  - monografico-arboles-de-clasificacion-con-rpart.md
  - los-pilares-de-mi-simulacion-de-la-extension-del-covid19.md
  - informes-con-r-en-html-comienzo-con-r2html-i.md
  - animacion-de-un-mapa-con-python-porcentaje-de-vacunas-administradas.md
tags:
  - plotrix
  - pyramid.plot
title: Porque no vamos a cobrar pensiones. Animación con R y pirámides de población
url: /blog/porque-no-vamos-a-cobrar-pensiones-animacion-con-r-y-piramides-de-poblacion/
---

Estoy creando material para un módulo de un máster que voy a impartir y escribiendo sobre seguros de ahorro he llegado a crear esta animación:

![Pirámide de población de España animada](/images/2018/12/piramide-poblacion-Espa%C3%B1a-animada.gif)

Se trata de una animación con las pirámides de población de España desde 1975 hasta 2018 de 5 en 5 años. El sistema de pensiones español se basa en 5 principios:
1\. principio de proporcionalidad
2\. principio de universalidad
3\. principio de gestión pública
4\. principio de suficiencia
5\. principio de reparto

La animación va directa contra el principio de reparto. **En el sistema español nadie ha cotizado para garantizarse su pensión** , los actuales trabajadores pagan las prestaciones de aquellos trabajadores jubilados. Si tras leer estas dos frases y mirar la animación sigues recelando de la migración de personas a España espero que tengas un buen plan de ahorro privado.

Esta animación está hecha con R, los datos están [descargados del INE](https://www.ine.es/jaxiT3/Tabla.htm?t=10256) pero están ligeramente cocinados (no al estilo Tezanos). En <https://github.com/analisisydecision/wordpress> tenéis este Excel con el formato adecuado, el código empleado para realizar la animación está en [https://github.com/analisisydecision/wordpress/blob/master/Piramide_poblacional.R](https://github.com/analisisydecision/wordpress/blob/master/Piramide_poblacional.R) Es un buen ejemplo de uso de `plotrix` y `pyramid.plot` espero que el código no tenga algún gazapo…
