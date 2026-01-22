---
author: rvaquerizo
categories:
  - consultoría
  - excel
  - formación
  - trucos
date: '2021-02-04'
lastmod: '2025-07-13'
related:
  - truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
  - trucos-excel-repetir-filas-con-desref.md
  - trucos-excel-repetir-filas-o-columnas-con-la-funcion-desref.md
  - truco-excel-producto-cartesiano-de-dos-campos.md
  - truco-excel-transponer-una-fila-en-varias-columnas-con-desref.md
tags:
  - consultoría
  - excel
  - formación
  - trucos
title: Truco Excel. Repetir celdas en función de los valores de otra celda
url: /blog/truco-excel-repetir-celdas-en-funcion-de-los-valores-de-otra-celda/
---

En alguna ocasión me habéis planteado como repetir celdas en `Excel` en función del valor de una celda, es decir, repetir una celda tantas veces como nos indica otra celda. Disponía de una versión con fórmulas más complejas que programar el proceso en `visual basic`, si alguien está interesado cuelgo un ejemplo en `Excel` sin describir el funcionamiento porque es muy complejo, quizá en el futuro retome esas fórmulas e intente simplificar el proceso. Hoy os traigo esta tarea de repetir celdas en `Excel` en base a otra celda pero insertando y usando fórmulas sencillas. Para el ejemplo partiríamos de esta situación:

![Repetir Columna Excel](/images/2021/02/repetir_columna_excel.png)

Hay que repetir `V1` tantas veces como nos indica `V2`. El primer paso sería añadir una columna a la izquierda y crear una suma acumulada de este modo:

![Repetir Columna Excel 2](/images/2021/02/repetir_columna_excel2.png)

En el ejemplo deberíamos tener 16 registros, el resultado de la suma acumulada de todas las repeticiones, luego necesitamos 16 celdas numeradas donde pondremos los 16 registros, para ilustrar:

![Repetir Columna Excel 3](/images/2021/02/repetir_columna_excel3.png)

Ahora aplicamos `BUSCARV` en los 16 registros pero ponemos la coincidencia aproximada a `1`, a `VERDADERO` y de ese modo `BUSCARV` no solo encontrará los valores exactos también encontrará los valores superiores y nos ofrecerá la celda que necesitamos:

![Repetir Columna Excel 4](/images/2021/02/repetir_columna_excel4.png)

El resultado final realiza la tarea requerida:

![Repetir Columna Excel 5](/images/2021/02/repetir_columna_excel5.png)

No es porque lo haya hecho yo, pero no puede ser más sencillo y estar más claramente ilustrado, en cualquier caso si tenéis dudas escribid un comentario y en cuanto sea posible lo contesto, pero vamos…
Saludos.
