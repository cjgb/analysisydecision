---
author: rvaquerizo
categories:
- sas
- trucos
- wps
date: '2013-01-17'
lastmod: '2025-07-13'
related:
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
- importar-a-sas-desde-otras-aplicaciones.md
- truco-sas-limpiar-un-fichero-de-texto-con-sas.md
- truco-sas-macro-buscar-y-reemplazar-en-texto.md
- curso-de-lenguaje-sas-con-wps-que-hace-el-paso-data.md
tags:
- infile
- proc import
title: Ayudadme. Importar a SAS texto con comillas
url: /blog/ayudadme-importar-a-sas-texto-con-comillas/
---
Hoy sois vosotros los que tenéis que ayudar al dinosaurio. Ya no estoy para estas cosas. Tengo un problema. Fichero de texto separado por ; típico csv de toda la vida. Este fichero de texto contiene diversos campos que a mis efectos son de texto. Si abrimos el fichero con una hoja de cálculo tendríamos:

[![](/images/2013/01/importar_sas_csv.png)](/images/2013/01/importar_sas_csv.png)

Pues bien, a la hora de importar unos datos con esa estructura desde SAS no soy capaz de que Dato2 siga conservando las comillas. Con IMPORT tampoco me funciona. El código sería algo parecido a esto:

```r
data WORK.CODIGO                                 ;
infile 'C:\TEMP\prueba_SAS.csv' delimiter = ';'  MISSOVER DSD
 lrecl=32767 firstobs=2 ;
   informat DATO1 20. ;
   informat DATO220. ;
input
            DATO1 DATO2;
run;
```


Es un tema que he resuelto pero desde los datos de origen. Pero tengo una duda, ¿qué debo poner en el INFILE para evitar este problema? Que nadie me responda “quitar DSD en el INFILE” que no sirve, tengo campos en blanco. O a lo mejor quitar el DSD en combinación con otra instrucción. El caso es que me atasqué y tiré por el camino más sencillo. A ver si me ayudáis, gracias.