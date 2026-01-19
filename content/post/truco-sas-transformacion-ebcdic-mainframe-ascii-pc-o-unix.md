---
author: rvaquerizo
categories:
- formación
- sas
date: '2009-07-15'
lastmod: '2025-07-13'
related:
- truco-sas-macro-buscar-y-reemplazar-en-texto.md
- truco-sas-leer-datos-de-excel-con-sas-con-dde.md
- trucos-sas-mas-usos-de-infile-y-pipe-directorios-en-tablas-sas.md
- importar-a-sas-desde-otras-aplicaciones.md
- curso-de-lenguaje-sas-con-wps-lectura-de-ficheros-de-texto.md
tags:
- sin etiqueta
title: Truco SAS. Transformación EBCDIC (Mainframe)
url: /blog/truco-sas-transformacion-ebcdic-mainframe-ascii-pc-o-unix/
---
Hay ocasiones en las que tenemos que leer directamente de entornos Mainframe ficheros DB2, conocemos la estructura de esos ficheros y necesitamos leerlos vía FTP. Para ello tenemos que tener en cuenta la transformación EBCDIC (Extended Binary Coded Decimal Interchange Code ) a ASCII (American Standard Code for Information Interchange), esta transformación requiere las siguientes equivalencias entre formatos:

  * Decimales empaquetados: PD5. -> S370FPD5.
  * Enteros binarios: IB5. -> S370FIB5.
  * Caracter: 5\. ->EBCDIC5.
  * Numérico con 0: Z5. -> S370FZDU5.

De modo que para leer el fichero del Mainframe haremos:

```r
filename test1 ftp "'ACA.ACANAME.FECHA'" HOST='MVS' USER='SASXXX' PAS='XXX'

s370v RCMD='site rdw' lrecl=xx;

data one;

infile test1;

input @1 name ebcdic20.

  @21 addrebcdic20.

  @41 city ebcdic10.

  @51 stebcdic2.

  @54 zip s370PD5.

  @60 comments :$ebcdic200.;

run;
```

Necesitaremos saber la longitud del registro y por supuesto conocer la estructura del fichero que vamos a leer, con esto hacemos la transformación para mover información entre plataformas. Por otro lado tenemos el filename FTP. Le pasamos el nombre del fichero a leer, el host donde se encuentra alocado ese fichero con la opción RCMD=’site rdw’ indicamos que tenemos el descriptor de registro, el [RDW ](http://publib.boulder.ibm.com/infocenter/zvm/v5r4/index.jsp?topic=/com.ibm.zvm.v54.dmsa5/dup0009.htm)(Record Descriptor Word) con S370v indicamos que el formato es EBCDIC y en lrecl debemos poner la longitud de registro. En este punto desconozco como hacer funcionar la opción EOR (end of record) para encontrar el final del registro.`Espero que este "extraño" truco os sea de utilidad. Hace años si alguien hubiera colgado algo así en la red a mi me hubiera ahorrado mucho trabajo y por eso me he decidido a ponerlo. Un saludo y nos vemos después de las merecidas vacaciones que me voy a tomar el próximo mes. Por supuesto, si alguien tiene dudas o un trabajo que me permita jugar más tiempo con mis hijos [rvaquerizo@analisisydecision.es](mailto:rvaquerizo@analisisydecision.es)`