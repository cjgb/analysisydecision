---
author: rvaquerizo
categories:
- Formación
date: '2012-10-31T10:02:42-05:00'
slug: trucos-excel-pasar-de-caracter-a-numerico-con-formulas
tags: []
title: Trucos Excel. Pasar de caracter a numérico con fórmulas
url: /trucos-excel-pasar-de-caracter-a-numerico-con-formulas/
---

Nos pasan un fichero de texto y tenemos números con separación decimal americana y Excel, ¡horror! [En este blog se pasaron soluciones a este problema](https://analisisydecision.es/trucos-excel-y-sas-complemento-para-cambiar-la-configuracion-regional/) pero hoy vamos a emplear una solución muy sencilla mediante fórmulas. Nada complicado, se trata de enlazar las funciones SUSTITUIR y VALOR:

=VALOR(SUSTITUIR(A1;».»;»,»))

Así de sencillo. Espero que os sea de utilidad. Saludos.