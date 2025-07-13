---
author: rvaquerizo
categories:
- Excel
- Formación
- Trucos
date: '2011-04-30T16:13:20-05:00'
slug: trucos-excel-transponer-con-la-funcion-desref
tags:
- ''
- DESREF
- funciones excel
- trasponer
title: Trucos Excel. Transponer con la función DESREF
url: /trucos-excel-transponer-con-la-funcion-desref/
---

[Este blog ya contó como trasponer filas a columnas con la función INDIRECTO](https://analisisydecision.es/trucos-excel-trasponer-con-la-funcion-indirecto/). Recientemente tuve que explicar ese proceso a una persona y parece que le costó, sin embargo entendió a la perfección el uso de la función **DESREF**([a la que ya hicimos mención en una entrada reciente](https://analisisydecision.es/trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref/)) y por ello me he animado a crear esta entrada. [En este enlace](/images/2011/04/transponer-con-desref.xlsx "transponer-con-desref.xlsx") podéis descargar un **excel 2007** que contiene el siguiente ejemplo:

![transponer-con-desref.png](/images/2011/04/transponer-con-desref.png)

Con DESREF el primer parámetro que pasamos es una celda de referencia y a partir de ella nos movemos por filas (segundo parámetro) y columnas (tercer parámetro). En el ejemplo fijamos la celda B5 y nos movemos filas de uno en uno permaneciendo en la misma columna. La fórmula que yo he empleado para hacer esto es: =DESREF(B5;COLUMNA(E2)-COLUMNA(E2);0). Fijo B5; columna en la cual estoy menos la columna donde empiezo a trasponer, así creamos un autonumérico desde el 0; un 0 ya que no me muevo de columna.

Esta fórmula parece entenderse mejor que la utilizada con INDIRECTO. En cualquier caso disponéis de otro ejemplo que puede ayudaros en vuestro trabajo diario. Saludos.