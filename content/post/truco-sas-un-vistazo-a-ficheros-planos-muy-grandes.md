---
author: rvaquerizo
categories:
- SAS
- Trucos
date: '2012-08-20T04:09:56-05:00'
slug: truco-sas-un-vistazo-a-ficheros-planos-muy-grandes
tags:
- PROC FSLIST
title: Truco SAS. Un vistazo a ficheros planos muy grandes
url: /truco-sas-un-vistazo-a-ficheros-planos-muy-grandes/
---

Alguna vez no habéis podido abrir un fichero de texto muy grande para comprobar si tiene cabeceras o conocer el separador de campos. Es habitual emplear para esto el gran UltraEdit. Pero podemos emplear el PROC FSLIST de SAS para poder hacer esta tarea y se nos abrirá de inmediato una vista del fichero en una ventana de nuestra sesión SAS. La sintaxis muy sencilla:

```r
proc fslist fileref="Z:\temp\archivo_enorme.txt";

quit;
```

Este sencillo código nos abrirá las primeras líneas del archivo en un instante y así podremos comprobar si tiene cabeceras o el separador que utiliza. Esto nos facilitaría la importación del fichero a tabla SAS. Saludos.