---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2012-11-20'
lastmod: '2025-07-13'
related:
- truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
- truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda.md
- truco-excel-agrupar-valores-en-un-campo-de-una-tabla-dinamica.md
- desref-para-trasponer-en-excel-varias-columnas.md
- truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
tags:
- contar
- jerarquia
- redondear.mas
title: Truco Excel. Dividir una variable cuantitativa en tramos
url: /blog/truco-excel-dividir-una-variable-cuantitativa-en-tramos/
---
Un truco Excel que implica la utilización de la función **JERARQUIA** para la creación de un ranking y que la complementamos con la tramificación de ese ranking, de este modo creamos tramos de una variable numérica con Excel sin necesidad de ordenación previa. La situación sería:

[![](/images/2012/11/tramos-variable-excel-1.png)](/images/2012/11/tramos-variable-excel-1.png)

Tenemos un campo cuantitativo que deseamos tramificar. El primer paso es la fórmula JERARQUIA:

=JERARQUIA(A1;A1:A30;1)

Creamos un valor numérico que va desde el 1 hasta el 30 en función de la posición que ocupa, el último elemento de la función nos indica si es descendente (0) o si es ascendente (1). Ahora tenemos que dividir esos 30 valores en 4 grupos (por ejemplo) para ello hacemos una fórmula ya conocida para los lectores de esta bitácora:

=REDONDEAR.MAS((B1/CONTAR(B1:B30))*4;0)

Dividimos la posición en el ranking por el número total de elementos (el total lo hacemos con CONTAR) y lo multiplicamos por el número de grupos. Si hacemos un REDONDEAR.MAS irá redondeado al mayor entero y tendremos los 4 grupos deseados. Ahora podemos unir las dos fórmulas y nos queda:

=REDONDEAR.MAS((JERARQUIA(A1;A1:A30;1)/CONTAR(B1:B30))*4;0)

¡Toma! Una de esas fórmulas que nos encontramos a veces en hojas realizadas por terceros y nos terminamos acordando de la familia de dichos terceros. Espero que os sea útil este truco, saludos.