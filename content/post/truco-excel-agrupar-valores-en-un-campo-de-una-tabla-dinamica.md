---
author: rvaquerizo
categories:
- excel
- formación
- trucos
date: '2013-11-05'
lastmod: '2025-07-13'
related:
- truco-excel-repetir-un-campo-a-partir-de-otro-que-define-el-numero-de-repeticiones.md
- trucos-excel-multiples-campos-calculados-en-una-tabla-dinamica.md
- macros-sas-agrupando-variables-categoricas.md
- trucos-sas-operaciones-con-tablas-de-dimensiones-con-sas.md
- truco-excel-dividir-una-variable-cuantitativa-en-tramos.md
tags:
- tabla dinamica
title: Truco Excel. Agrupar valores en un campo de una tabla dinámica
url: /blog/truco-excel-agrupar-valores-en-un-campo-de-una-tabla-dinamica/
---
Si necesitamos agrupar un campo de una tabla dinámica tenemos dos opciones. Por un lado agrupar manualmente o bien crear intervalos de determinado tamaño. Para agrupar datos manualmente seleccionamos los elementos que deseamos agrupar en la tabla dinámica y pulsamos botón derecho agrupar:

![](/images/2013/11/agrupar_excel_tabla_dinamica_1.png)

Inmediatamente se nos crea un nuevo campo en la tabla dinámica que por sufijo tendrá un 2 y aparece un nuevo grupo que por defecto se llamará Grupo 1. Podemos cambiar el nombre, en este caso agrupamos trimestres o cuatrimestres:

![](/images/2013/11/agrupar_excel_tabla_dinamica_2.png)

Es un campo más de nuestra tabla dinámica y podemos utilizarlo a nuestro antojo. Si por el contrario deseamos agrupar una variable numérica en tramos de un deteminado tamaño no seleccionamos campos pero con botón derecho seleccionamos agrupar y obtendremos el siguiente cuadro de diálogo:

![](/images/2013/11/agrupar_excel_tabla_dinamica_3.png)

En este caso empezamos en el valor mímimo y vamos al máximo en tramos de 5 en 5 obtendremos los siguiente:

![](/images/2013/11/agrupar_excel_tabla_dinamica_4.png)

No se genera un nuevo campo en nuestra tabla dinámica. Se agrupa sobre el mismo así que si deseamos desagrupar sólo tendremos que dar botón derecho y desagrupar para que nuestros datos sean los mismos de antes. Espero que sea de utilidad. Saludos.