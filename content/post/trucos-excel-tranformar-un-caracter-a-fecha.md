---
author: rvaquerizo
categories:
  - excel
  - formación
  - trucos
date: '2011-03-13'
lastmod: '2025-07-13'
related:
  - truco-excel-pasar-de-numero-con-formato-aaaammdd-a-fecha-con-formulas.md
  - trucos-sas-pasar-fecha-a-caracter-en-sas.md
  - trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
  - macros-sas-transformar-un-numerico-a-fecha.md
  - trucos-r-establecer-la-configuracion-local-de-una-fecha.md
tags:
  - funciones texto
  - fechas
  - excel
title: Trucos Excel. Tranformar un caracter a fecha
url: /blog/trucos-excel-tranformar-un-caracter-a-fecha/
---

Si tenemos en Excel celdas con valores en la forma:

- _viernes 1 de enero de 2010_
- _sábado 2 de enero de 2010_
- _domingo 3 de enero de 2010_
- \_…
  \_

y deseamos transformarlo en fecha podemos hacer lo siguiente:

```
**=TEXTO(IZQUIERDA(EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30);2) &EXTRAE(EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30);6;4)&DERECHA(EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30);4 );»dd/mm/aaaa»)*1**
```

¡Toma función! Vamos a contar paso por paso como funciona:

1. necesitamos _1 de enero de 2010_ de _viernes 1 de enero de 2010_ , supongamos que está en la celda A2. Eso lo conseguimos encontrando el primer espacio en blanco con la función ENCONTRAR(» «;A2;1) en este caso el 6, luego debemos empezar por el siguiente, por eso debemos sumar 1. Con EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30) nos quedamos con _1 de enero de 2010_
1. ese texto tiene que pasar a otro texto con el formato dd/mm/aaa. El día lo cogemos con IZQUIERDA(EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30);2) el mes es más complejo porque queda entremedias EXTRAE(EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30);6;4) y el año se hace de forma análoga al día DERECHA(EXTRAE(A2;ENCONTRAR(» «;A2;1)+1;30);4 ) y hemos creado el texto _1 ener2010_
1. por último empleamos la función TEXTO para transformar esa cadena de caracteres a otra cadena de caracteres con el formato deseado dd/mm/aaaa y todo ello lo multiplicamos por 1 para crear el número 40179 al que podemos dar el formato de fecha que queramos y con el que podemos realizar operaciones

Espero que esta fórmula os sirva y os ayude en vuestro trabajo con Excel cuando tengáis que cambiar textos a fechas (o al contrario). También podemos emplear la función FECHANUMERO pero esa me la guardo para otro día.
