---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2014-02-25'
lastmod: '2025-07-13'
related:
- trucos-excel-tranformar-un-caracter-a-fecha.md
- macros-sas-transformar-un-numerico-a-fecha.md
- truco-python-restar-meses-con-formato-yyyymm.md
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
tags:
- entero
- fecha
- residuo
title: Truco Excel. Pasar de número con formato AAAAMMDD a fecha con fórmulas
url: /blog/truco-excel-pasar-de-numero-con-formato-aaaammdd-a-fecha-con-formulas/
---
![](/images/2014/02/transformar_fecha_excel.png)

Tenía que transformar un número en formato AAAAMMDD a una fecha en Excel. Tenía que concatenar varias funciones y he pensado que a lo mejor a alguno de los lectores del blog podría interesarle. Se trata de utilizar la función de Excel FECHA con RESIDUO y ENTERO pero con cierto talento. Partimos del una fecha 20140225 y realizamos la siguiente sucesión de fórmulas:

  * Año: ENTERO(C6/10000)
  * Mes: RESIDUO(ENTERO(C6/100);100)
  * Día: RESIDUO(C6;100)
  * Todo junto en una fórmula: FECHA(ENTERO(C6/10000);RESIDUO(ENTERO(C6/100);100);RESIDUO(C6;100))

Ahí tenéis un truco interesante por si os encontráis en la misma situación que yo. Saludos.