---
author: rvaquerizo
categories:
- Formación
- SAS
- Trucos
- WPS
date: '2012-01-10T11:05:34-05:00'
slug: trucos-sas-eliminacion-de-espacios-en-blanco
tags:
- ''
- COMPBL
- compress
- funciones de texto
- left
- rxchange
- rxparse
- trimn
title: Trucos SAS. Eliminación de espacios en blanco
url: /trucos-sas-eliminacion-de-espacios-en-blanco/
---

Truco SAS práctico para aquellos que os estáis iniciando en el uso de las **funciones de texto con SAS**. Se trata de **eliminar aquellos espacios en blanco que no son necesarios en una variable**. Quería plantearos las posibles soluciones que se me han ido ocurriendo. Algunas de ellas no son eficientes pero es necesario que dispongáis de todas. En la línea habitual planteo un ejemplo para que lo ejecutéis y así podáis analizar los resultados:

```r
data ejemplo;

palabra=" EJEMPLO DE ELIMINACIÓN DE BLANCOS CON SAS ";

uso_compress=compress(palabra);

uso_trimn=trimn(palabra);

uso_trimn_left=trimn(left(palabra));

uso_compbl=compbl(palabra);

length uso_rxchange $50.;

rx=rxparse("' ' to ' '"); drop rx;

call rxchange (rx,length(palabra),palabra,uso_rxchange);

run;
```

La variable palabra tiene tanto espacios por la derecha como por la izquierda y entre las palabras que no son necesarios. La función COMPRESS elimina todos los espacios en blanco. Con TRIMN y LEFT eliminamos los espacios en blanco al inicio y al final de palabra pero mantenemos los espacios en blanco entre palabras.  
COMPBL (compress blank) parece más adecuada para eliminar los espacios en blanco sobrantes entre las palabras. La función de reconocimiento de patrones RXCHANGE (que necesita el patrón previamente con RXPARSE) sustituye dos espacios por uno sólo, el resultado no parece muy satisfactorio; esto mismo podríamos hacerlo con la función TRANWRD. A ver si algún lector encuentra un patrón adecuado para  
estas funciones. 

**¿La combinación óptima de funciones?**

```r
data ejemplo;

palabra=" EJEMPLO DE ELIMINACIÓN DE BLANCOS CON SAS ";

optimo=trimn(left(compbl(palabra)));

run;
```

Combinación de 3 funciones de texto que nos permite eliminar espacios en blanco. A continuación lo ponemos como una macro que realiza una función:

```r
%macro noblanco(pal);

trimn(left(compbl(&pal.)))

%mend;

*;

data ejemplo;

palabra=" EJEMPLO DE ELIMINACIÓN DE BLANCOS CON SAS ";

optimo=%noblanco(palabra);

run;
```

Espero que sea de vuestra utilidad. Un saludo.