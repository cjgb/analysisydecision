---
author: rvaquerizo
categories:
- Business Intelligence
- Consultoría
- Formación
- SAS
date: '2011-04-23T16:24:31-05:00'
slug: los-10-errores-y-warnings-mas-habituales-en-sas
tags:
- DATA
- format
title: Los 10 errores y warnings más habituales en SAS
url: /los-10-errores-y-warnings-mas-habituales-en-sas/
---

En función de los contactos con SAS support han elaborado un ranking de errores y warnings reportados a SAS con respecto al paso DATA.[ En este enlace](http://blogs.sas.com/supportnews/index.php?/archives/151-The-top-10-errors,-notes-and-warnings-that-prompt-DATA-step-programmers-to-call-SAS-Technical-Support.html) tenéis el ranking, a los comentarios de Kim Wilson podéis añadir los míos. Veamos uno por uno esos errores:

  1. **ERROR: AN INTERNAL ERROR HAS OCCURRED WHILE READING A COMPRESSED FILE. PLEASE CALL YOUR SAS SITE REPRESENTATIVE AND REPORT THE FOLLOWING…**  
Tenéis que reparar el dataset como indica Kim, pero mucho ojo con mover datasets entre servidores o con trabajar con distintas versiones de SAS.
  2. **ERROR: ARRAY SUBSCRIPT OUT OF RANGE AT LINE N AND COLUMN N**  
Nos hemos ido de rango en el array sucede cuando recorremos los arrays con un bucle DO y el índice del bucle es mayor que el tamaño del array. Para evitarnos líos podemos hacer ARRAY AR(*) ; DO i = 1 TO DIM(AR); Que no se lleve nadie las manos a la cabeza.
  3. **ERROR: THE FORMAT $NAME WAS NOT FOUND OR COULD NOT BE LOADED**  
Llamamos a un formato que no existe, muy habitual en input o put.
  4. **NOTE: THE MEANING OF AN IDENTIFIER AFTER A QUOTED STRING MAY CHANGE IN A FUTURE SAS RELEASE. INSERTING WHITE SPACE BETWEEN A QUOTED STRING AND THE SUCCEEDING IDENTIFIER IS RECOMMENDED.**  
Esto no pasa…
  5. **NOTE: INVALID ARGUMENT TO FUNCTION INPUT AT LINE N COLUMN N**  
En ocasiones el formato que ponemos en input es incorrecto y se produce este error, habitual cuando trabajamos con fechas
  6. **NOTE: MERGE STATEMENT HAS MORE THAN ONE DATA SET WITH REPEATS OF BY VALUES**  
Cuando hacemos un merge si uno de los conjuntos de datos tiene observaciones duplicadas por la variable que ponemos en BY obtenemos este WARNING, cuando cruzamos tablas SAS hemos de tener mucho cuidado con las observaciones duplicadas.
  7. **NOTE: SAS WENT TO A NEW LINE WHEN INPUT STATEMENT REACHED PAST THE END OF A LINE**  
No es muy habitual este error. Tenemos que realizar lo que nos dice Kim. La opción FLOWOVER no la he empleado nunca,[ en este link](http://support.sas.com/documentation/cdl/en/basess/58133/HTML/default/a002645812.htm) tenéis ejemplos de esta problemática.
  8. **NOTE: INVALID DATA FOR VARIABLE-NAME AT LINE N**  
Si definimos una variable de un tipo no podemos emplear datos de otro tipo, es decir, si la variable es numérica no la igualéis a un caracter y viceversa. Tenedlo en cuenta.
  9. **WARNING: THE QUOTED STRING CURRENTLY BEING PROCESSED HAS BECOME MORE THAN 262 CHARACTERS LONG. YOU MAY HAVE UNBALANCED QUOTATION MARKS.**  
Otro problema poco habitual, seguid haciendo caso a Kim.
  10. **WARNING: MULTIPLE LENGTHS WERE SPECIFIED FOR THE VARAIBLE VARIABLE-NAME BY INPUT DATA SET(S). THIS MAY CAUSE TRUNCATION OF DATA.**  
Este warning es muy típico cuando realizamos merge con variables alfanuméricas. Imaginemos que un dataset tiene la variable póliza definida como 10\. y otro tiene la variable póliza definida como12\. si realizamos un merge por esa variable obtendremos este WARNING.

Estos son los errores que más aparecen en SAS SUPPORT. En mi opinión hay algunos que no son habituales pero hay algunos que son dudas recurrentes que me llegan. Al final lo que siempre plantea problemas son los formatos y las fechas en SAS, el 80% de las dudas que me llegan van por ahí. Espero complementar el mensaje de SAS.