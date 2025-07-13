---
author: rvaquerizo
categories:
- Formación
- Monográficos
- WPS
date: '2011-01-14T14:12:31-05:00'
lastmod: '2025-07-13T15:55:49.612146'
related:
- curso-de-lenguaje-sas-con-wps-variables.md
- trabajo-con-fechas-sas-formatos-de-fecha-sas-mas-utilizados.md
- trucos-sas-pasar-fecha-a-caracter-en-sas.md
- trabajo-con-fechas-sas-introduccion.md
- curso-de-lenguaje-sas-con-wps-funciones-fecha.md
slug: curso-de-lenguaje-sas-con-wps-introduccion-a-los-formatos-de-variables
tags:
- format
- informat
title: Curso de lenguaje SAS con WPS. Introducción a los formatos de variables
url: /curso-de-lenguaje-sas-con-wps-introduccion-a-los-formatos-de-variables/
---

Volvemos con el curso de lenguaje SAS con WPS. Estaba parado debido a un problema con las licencias de WPS desde junio de 2010 pero le retomamos con uno de los capítulos más interesantes: **formatos de variables en SAS**. Si tuvieramos que definirlos Son imprescindibles tanto para leer como para escribir variables. Y esa es la característica que los divide, existen formatos de entrada INFORMAT y formatos de salida FORMAT. Se dividen por categorías, entre las que destacan los formatos numéricos, formatos carácter y formatos de fecha. La sintaxis es sencilla (IN)FORMAT   
-variable–formato- 

Los formatos más importantes por tipo son:

Formatos numéricos:

• BESTw. SAS mejor formato  
• BINARYw. Binario  
• COMMAw.d Separación de miles y decimales en formato americano  
• COMMAXw.d Separación de miles y decimales en formato europeo  
• NUMx.d Separación de decimales en formato europeo  
• FRACTw. Número fraccionario  
• HEXw. Hexadecimal  
• ROMANw. Romano  
• w.d Habitual

• Zw.d Números empezados por 0 (08034)

En el caso de las variables numéricas el formato de lectura tiene importancia a la hora de la importación de ficheros de texto y el formato de escritura es importante en exportaciones y realización de informes. 

Formatos fecha:

• DATE. Día siglas de mes en inglés Año (01JAN2001)  
• DATETIME. Como date pero con HH:MM:SS (01JAN2001:12:00:00)  
• DDMMYY. DD/MM/YY  
En el caso de las fechas es fundamental conocer bien bien el funcionamiento de los formatos tanto de lectura, para la importación de ficheros de texto; como de escritura, para la realización de cálculos y reportes.

Formatos carácter:  
• CHARw.  
•w.

Como podemos ver para los formatos carácter son formatos estándar. Cuando trabajemos con variables carácter la información que requerirá más atención será su longitud.