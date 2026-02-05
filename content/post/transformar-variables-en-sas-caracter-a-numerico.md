---
author: rvaquerizo
categories:
  - formación
  - monográficos
  - sas
date: '2008-12-03'
lastmod: '2025-07-13'
related:
  - macros-sas-pasar-de-texto-a-numerico.md
  - trucos-sas-pasar-de-caracter-a-numerico-y-viceversa.md
  - truco-sas-macro-buscar-y-reemplazar-en-texto.md
  - trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
  - importar-a-sas-desde-otras-aplicaciones.md
tags:
  - formación
  - monográficos
  - sas
title: Transformar variables en SAS. Carácter a numérico
url: /blog/transformar-variables-en-sas-caracter-a-numerico/
---

Muchas visitas a este sitio son búsquedas de Google que plantean la problemática que surge al transformar variables carácter a numéricas y viceversa con SAS. Las palabras habituales son "transformar texto a número SAS", "cómo paso de variable string a numérica en SAS", "pasar de carácter a fecha en SAS", "SAS transformar fecha numérica en texto"… son todas búsquedas que han generado mucho tiempo de estancia en el sitio, a pesar de que no existía un mensaje específico. En el siguiente monográfico vamos a tratar estas conversiones. De esta forma, se crearán una serie de dos *posts* que pueden ser un interesante material de consulta para profesionales y estudiantes que trabajen con SAS.

En esta primera entrega vamos a transformar variables de texto en variables numéricas. Como es habitual, trabajaremos con ejemplos que podéis ejecutar en vuestras sesiones de SAS para comprobar el funcionamiento. Veamos qué posibles casuísticas podemos encontrar:

```sas
data uno;
    * VARIABLE DE TEXTO SIN SEPARADOR DE MILES CON FORMATO AMERICANO;
    x = "4567.89";
    
    * VARIABLE DE TEXTO CON SEPARADOR DE MILES CON FORMATO AMERICANO;
    y = "4,567.89";
    
    * VARIABLE DE TEXTO SIN SEPARADOR DE MILES CON FORMATO EUROPEO;
    z = "4567,89";
    
    * VARIABLE DE TEXTO CON SEPARADOR DE MILES CON FORMATO EUROPEO;
    k = "4.567,89";
    
    output;
run;
```

Éstas son las casuísticas más habituales: formato europeo o americano, con o sin separador de miles. Suele ser muy común importar una tabla de `Access` vía fichero de texto y necesitar transformar formatos europeos en formatos americanos que puede leer mejor SAS.

La función estrella para esta transformación será `INPUT(variable o constante carácter, formato de entrada)`. Esta función aplica un formato de entrada a una variable o constante carácter. Es muy importante que el formato de entrada exista en SAS. Hay formatos en SAS que pueden ser de salida pero no de entrada. En ocasiones no será necesario emplear la función `INPUT`; bastará con multiplicar por 1 para transformar en numérico. Así, por ejemplo, si deseamos transformar las variables anteriores:

```sas
data uno_transformado;
    set uno;
    
    x2 = x * 1;
    y2 = input(y, comma16.5);
    z2 = tranwrd(z, ",", ".") * 1;
    k2 = input(k, commax16.5);
run;
```

Cuando tenemos números tipo `EEEE.DD`, basta con multiplicar por 1 para transformar en numérico. Cuando tenemos formatos con separadores de miles, tenemos que emplear los formatos de entrada `COMMAw.d` (americano) o `COMMAXw.d` (europeo). Un caso especial es el número `EEEE,DD` (sin separador de miles pero con coma decimal); este caso requiere transformar con la función `TRANWRD(variable, "texto a reemplazar", "texto que reemplaza")`. Reemplazamos "," por "." y solo necesitamos multiplicar por 1.

En la siguiente entrega veremos cómo transformar variables numéricas a texto. Por supuesto, si tenéis dudas, sugerencias o un trabajo muy bien retribuido… `rvaquerizo@analisisydecision.es`. Saludos.