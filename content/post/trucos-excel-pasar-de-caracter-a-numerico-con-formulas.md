---
author: rvaquerizo
categories:
  - formación
date: '2012-10-31'
lastmod: '2025-07-13'
related:
  - trucos-excel-modificar-la-configuracion-regional-con-visual-basic.md
  - macros-sas-pasar-de-texto-a-numerico.md
  - transformar-variables-en-sas-caracter-a-numerico.md
  - trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional.md
  - trucos-excel-tranformar-un-caracter-a-fecha.md
tags:
  - sin etiqueta
title: Trucos Excel. Pasar de caracter a numérico con fórmulas
url: /blog/trucos-excel-pasar-de-caracter-a-numerico-con-formulas/
---

Nos pasan un fichero de texto y tenemos números con separación decimal americana y Excel, ¡horror! [En este blog se pasaron soluciones a este problema](https://analisisydecision.es/trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional/) pero hoy vamos a emplear una solución muy sencilla mediante fórmulas. Nada complicado, se trata de enlazar las funciones SUSTITUIR y VALOR:

=VALOR(SUSTITUIR(A1;».»;»,»))

Así de sencillo. Espero que os sea de utilidad. Saludos.
